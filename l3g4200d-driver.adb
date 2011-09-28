with Ada.Unchecked_Conversion;

package body L3G4200D.Driver is
   -- Number of bytes that can be put into FIFO (excluding control byte)
   type Byte_Count is range 0 .. 7;
   subtype Byte_Index is Byte_Count range 1 .. Byte_Count'Last;

   type Byte_Array is array (Byte_Index range <>) of Byte;

   function Control_To_Byte is new Ada.Unchecked_Conversion (Control_Byte, Byte);

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
      Data := Data_Register_Record'(Data => Data_Word (Item), others => <>);
      SSI_Port.Data_Register := Data;
   end Push_Byte;

   procedure Start_Transaction (Direction : IO_Direction; Address : Register_Address) is
      use MCU.SSI;

      Control : constant Control_Byte :=
         (Address => Address, Repeat => Autoincrement, Direction => Direction);

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

   procedure Read_Register (Address : Register_Address; Result : out Byte_Array) is
      use MCU.SSI;

      Data : Data_Register_Record;
   begin
      Start_Transaction (Read, Address);

      -- Push dummy bytes
      Data := Data_Register_Record'(Data => 0, others => <>);
      for I in Result'Range loop
         SSI_Port.Data_Register := Data;
      end loop;

      Finish_Transaction;

      -- Read out the result
      for I in Result'Range loop
         Data := SSI_Port.Data_Register;
         Result (I) := Byte (Data.Data and 16#FF#);
      end loop;
   end Read_Register;

   procedure Check_Who_Am_I (Is_Ok : out Boolean) is
      Result : Byte_Array (1 .. 1);
   begin
      Read_Register (Who_Am_I_Register, Result);
      Is_Ok := Result (1) = Who_Am_I_ID;
   end Check_Who_Am_I;
end L3G4200D.Driver;
