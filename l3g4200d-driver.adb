with Ada.Unchecked_Conversion;

package body L3G4200D.Driver is
   -- Number of bytes that can be put into FIFO (excluding control byte)
   type Byte_Count is range 0 .. 7;
   subtype Byte_Index is Byte_Count range 1 .. Byte_Count'Last;

   type Byte_Array is array (Byte_Index range <>) of Byte;

   function Control_To_Byte is new Ada.Unchecked_Conversion (Control_Byte, Byte);

   function Control_Register_1_To_Byte is new Ada.Unchecked_Conversion (Control_Register_1_Byte, Byte);
   function Control_Register_2_To_Byte is new Ada.Unchecked_Conversion (Control_Register_2_Byte, Byte);
   function Control_Register_3_To_Byte is new Ada.Unchecked_Conversion (Control_Register_3_Byte, Byte);
   function Control_Register_4_To_Byte is new Ada.Unchecked_Conversion (Control_Register_4_Byte, Byte);
   function Control_Register_5_To_Byte is new Ada.Unchecked_Conversion (Control_Register_5_Byte, Byte);

   function Byte_To_Status_Register is new Ada.Unchecked_Conversion (Byte, Status_Register_Byte);

   procedure Initialize is
      use MCU.SSI;

      Control_0 : Control_Register_0_Record;
      Control_1 : Control_Register_1_Record;
      Clock_Prescale : Clock_Prescale_Register_Record;
   begin
      -- Make sure the SSI is disabled
      Control_1 := SSI_Port.Control_Register_1;
      Control_1.Port_Enable := False;
      SSI_Port.Control_Register_1 := Control_1;

      -- Select master mode
      Control_1.Mode_Select := Normal_Mode;
      Control_1.Master_Slave_Select := Master;
      SSI_Port.Control_Register_1 := Control_1;

      -- Set 1MHz clock, SPI mode, 8-bit data, SPO=1, SPH=1;
      -- Clock rate calculations for 50MHz system clock:
      --   F_SSI = F_Sys / (CPSDVSR * (1 + SCR))
      --   1e6   = 50e6  / (CPSDVSR * (1 + SCR))
      --   CPSDVSR * (1 + SCR) = 50
      --      let CPSDVSR = 2
      --   2       * (1 + SCR) = 50
      --      SCR = 24
      Clock_Prescale := SSI_Port.Clock_Prescale_Register;
      Clock_Prescale.Divisor := 2; -- CPSDVSR
      SSI_Port.Clock_Prescale_Register := Clock_Prescale;

      Control_0 := SSI_Port.Control_Register_0;
      Control_0.Data_Size_Select := 8;
      Control_0.Frame_Format_Select := SPI;
      Control_0.Serial_Clock_Polarity := Steady_High;
      Control_0.Serial_Clock_Phase := Second_Edge_Capture;
      Control_0.Serial_Clock_Rate := 24; -- SCR
      SSI_Port.Control_Register_0 := Control_0;
   end Initialize;

   procedure Push_Byte (Item : Byte) is
      use MCU.SSI;

      Data : Data_Register_Record;
   begin
      Data := Data_Register_Record'(Data => Data_Word (Item), Reserved => 0);
      SSI_Port.Data_Register := Data;
   end Push_Byte;

   procedure Start_Transaction (Direction : IO_Direction; Start_Address : Register_Address) is
      use MCU.SSI;

      Control : constant Control_Byte :=
         (Address => Start_Address, Repeat => Autoincrement, Direction => Direction);

      Control_1 : Control_Register_1_Record;
   begin
      Set_CS (MCU.GPIO.Low);
      Push_Byte (Control_To_Byte (Control));

      -- Enable SSI, it should start transmitting
      Control_1 := SSI_Port.Control_Register_1;
      Control_1.Port_Enable := True;
      SSI_Port.Control_Register_1 := Control_1;
   end Start_Transaction;

   procedure Finish_Transaction is
      use MCU.SSI;

      Status : Status_Register_Record;
      Control_1 : Control_Register_1_Record;
      Dummy_Data : Data_Register_Record;
   begin
      -- Wait till end of transaction
      loop
         Status := SSI_Port.Status_Register;
         exit when not Status.Busy;
      end loop;

      -- Disable SSI
      Control_1 := SSI_Port.Control_Register_1;
      Control_1.Port_Enable := False;
      SSI_Port.Control_Register_1 := Control_1;

      Set_CS (MCU.GPIO.High);

      -- Read dummy data byte
      pragma Warnings (Off, Dummy_Data);
      Dummy_Data := SSI_Port.Data_Register;
   end Finish_Transaction;

   procedure Read_Registers (Start_Address : Register_Address; Result : out Byte_Array) is
      use MCU.SSI;

      Data : Data_Register_Record;
   begin
      Start_Transaction (Read, Start_Address);

      -- Push dummy bytes
      Data := Data_Register_Record'(Data => 0, Reserved => 0);
      for I in Result'Range loop
         SSI_Port.Data_Register := Data;
      end loop;

      Finish_Transaction;

      -- Read out the result
      for I in Result'Range loop
         Data := SSI_Port.Data_Register;
         Result (I) := Byte (Data.Data and 16#FF#);
      end loop;
   end Read_Registers;

   procedure Write_Registers (Start_Address : Register_Address; Item : Byte_Array) is
      use MCU.SSI;

      Dummy_Data : Data_Register_Record;
   begin
      Start_Transaction (Write, Start_Address);

      for I in Item'Range loop
         Push_Byte (Item (I));
      end loop;

      Finish_Transaction;

      -- Read out dummy result
      pragma Warnings (Off, Dummy_Data);
      for I in Item'Range loop
         Dummy_Data := SSI_Port.Data_Register;
      end loop;
   end Write_Registers;

   procedure Check_Who_Am_I (Is_Ok : out Boolean) is
      Result : Byte_Array (1 .. 1);
   begin
      Read_Registers (Who_Am_I_Register, Result);
      Is_Ok := Result (1) = Who_Am_I_ID;
   end Check_Who_Am_I;

   procedure Write_Control_Registers is
      Buffer : Byte_Array (1 .. 5);
      Buffer_1 : Byte_Array (1 .. 1);
   begin
      Buffer (1) := Control_Register_1_To_Byte
         ((X_Enable => True,
           Y_Enable => True,
           Z_Enable => True,
           Normal_Mode_Enable => True,
           Bandwidth_Selector => 0,
           Output_Data_Rate => Rate_100_Hz));

      Buffer (2) := Control_Register_2_To_Byte
         ((Cut_Off_Frequency_Selector => 8,
           High_Pass_Mode_Selector => Normal_Mode_Reset,
           Reserved => 0));

      Buffer (3) := Control_Register_3_To_Byte
         ((Interface_Kind => Push_Pull,
           others => False));

      Buffer (4) := Control_Register_4_To_Byte
         ((SPI_Mode_Selection => SPI_4_Wire,
           Self_Test_Selection => Normal_Mode,
           Reserved => 0,
           Full_Scale_Selection => Range_500_dps, -- TODO change
           Endianness_Selection => Little_Endian,
           Update_Mode_Selection => Continous));

      Buffer (5) := Control_Register_5_To_Byte
         ((Output_Selection => 1,
           INT1_Selection => 0,
           Enable_High_Pass_Filter => True, -- FIXME
           Reserved => 0,
           Enable_FIFO => False,
           Reboot_Memory_Content => False));

      Write_Registers (Control_Register_1, Buffer);

      pragma Warnings (Off, Buffer_1);
      -- Reset the reference
      Read_Registers (Reference_Register, Buffer_1);
   end Write_Control_Registers;

   procedure Initialize_Gyroscope is
   begin
      Write_Control_Registers;
   end Initialize_Gyroscope;

   procedure Wait_For_New_Reading is
      Buffer : Byte_Array (1 .. 1);
      Status_Byte : Status_Register_Byte;
   begin
      loop
         Read_Registers (Status_Register, Buffer);
         Status_Byte := Byte_To_Status_Register (Buffer (1));
         exit when Status_Byte.XYZ_Axis_Data_Available;
      end loop;
   end Wait_For_New_Reading;

   function Make_Rate (Low : Byte; High : Byte) return Raw_Angular_Rate is
      use Interfaces;

      Tmp : Interfaces.Unsigned_16;
      function Convert_To_Rate is new Ada.Unchecked_Conversion (Unsigned_16, Raw_Angular_Rate);
   begin
      Tmp := Unsigned_16 (High) * 256 + Unsigned_16 (Low);
      return Convert_To_Rate (Tmp);
   end Make_Rate;

   procedure Read_Sensor_Data (X_Rate, Y_Rate,Z_Rate : out Raw_Angular_Rate) is
      Buffer : Byte_Array (1 .. 6);
   begin
      Read_Registers (Out_X_Low_Register, Buffer);

      X_Rate := Make_Rate (Buffer (1), Buffer (2));
      Y_Rate := Make_Rate (Buffer (3), Buffer (4));
      Z_Rate := Make_Rate (Buffer (5), Buffer (6));
   end Read_Sensor_Data;
end L3G4200D.Driver;
