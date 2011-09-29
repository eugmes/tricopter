pragma Restrictions (No_Elaboration_Code);
with Interfaces;

package L3G4200D is
   pragma Pure;

   type Register_Address is mod 2**6;

   type Byte is mod 2**8;
   for Byte'Size use 8;

   type Raw_Angular_Rate is new Interfaces.Integer_16;
   for Raw_Angular_Rate'Size use 16; -- FIXME maybe it is not needed

   ------------------------
   -- Register addresses --
   ------------------------
   Who_Am_I_Register     : constant Register_Address := 16#0F#;
   Control_Register_1    : constant Register_Address := 16#20#;
   Control_Register_2    : constant Register_Address := 16#21#;
   Control_Register_3    : constant Register_Address := 16#22#;
   Control_Register_4    : constant Register_Address := 16#23#;
   Control_Register_5    : constant Register_Address := 16#24#;
   Reference_Register    : constant Register_Address := 16#25#;
   Temperature_Register  : constant Register_Address := 16#26#;
   Status_Register       : constant Register_Address := 16#27#;
   Out_X_Low_Register    : constant Register_Address := 16#27#;
   Out_H_High_Register   : constant Register_Address := 16#27#;
   Out_Y_Low_Register    : constant Register_Address := 16#27#;
   Out_Y_High_Register   : constant Register_Address := 16#27#;
   Out_Z_Low_Register    : constant Register_Address := 16#27#;
   Out_Z_High_Register   : constant Register_Address := 16#27#;
   FIFO_Control_Register : constant Register_Address := 16#27#;
   FIFO_Source_Register  : constant Register_Address := 16#27#;
   Interrupt_1_Configuration_Register    : constant Register_Address := 16#27#;
   Interrupt_1_Source_Register           : constant Register_Address := 16#27#;
   Interrupt_1_Threshold_X_High_Register : constant Register_Address := 16#27#;
   Interrupt_1_Threshold_X_Low_Register  : constant Register_Address := 16#27#;
   Interrupt_1_Threshold_Y_High_Register : constant Register_Address := 16#27#;
   Interrupt_1_Threshold_Y_Low_Register  : constant Register_Address := 16#27#;
   Interrupt_1_Threshold_Z_High_Register : constant Register_Address := 16#27#;
   Interrupt_1_Threshold_Z_Low_Register  : constant Register_Address := 16#27#;
   Interrupt_1_Duration_Register         : constant Register_Address := 16#27#;

   -----------------------------------------
   -- Expected value in Who_Am_I_Register --
   -----------------------------------------
   Who_Am_I_ID : constant Byte := 16#D3#;

   -------------------------------
   -- Types for reserved values --
   -------------------------------
   type Reserved_1 is mod 2**1;
   type Reserved_2 is mod 2**2;

   ----------------------------
   -- Types for address byte --
   ----------------------------
   type Repeat_Type is (No_Increment, Autoincrement);
   for Repeat_Type use (No_Increment => 0, Autoincrement => 1);

   type IO_Direction is (Write, Read);
   for IO_Direction use (Write => 0, Read => 1);

   type Control_Byte is
      record
         Address : Register_Address;
         Repeat : Repeat_Type;
         Direction : IO_Direction;
      end record;

   for Control_Byte use
      record
         Address at 0 range 0 .. 5;
         Repeat at 0 range 6 .. 6;
         Direction at 0 range 7 .. 7;
      end record;

   type Bandwidth is mod 2**2;

   type Data_Rate is (Rate_100_Hz, Rate_200_Hz, Rate_400_Hz, Rate_800_Hz);
   for Data_Rate use (Rate_100_Hz => 0, Rate_200_Hz => 1, Rate_400_Hz => 2, Rate_800_Hz => 3);

   type Cut_Off_Frequency is mod 2**4; -- TODO may require subtype

   type High_Pass_Mode is (Normal_Mode_Reset, Reference, Normal_Mode, Autoreset_On_Interrupt);
   for High_Pass_Mode use (Normal_Mode_Reset => 0, Reference => 1, Normal_Mode => 2, Autoreset_On_Interrupt => 3);

   type Interface_Type is (Push_Pull, Open_Drain);
   for Interface_Type use (Push_Pull => 0, Open_Drain => 1);

   type SPI_Mode is (SPI_4_Wire, SPI_3_Wire);
   for SPI_Mode use (SPI_4_Wire => 0, SPI_3_Wire => 1);

   type Self_Test_Mode is (Normal_Mode, Self_Test_0, Reserved, Self_Test_1);
   for Self_Test_Mode use (Normal_Mode => 0, Self_Test_0 => 1, Reserved => 2, Self_Test_1 => 3);

   type Full_Scale_Mode is (Range_250_dps, Range_500_dps, Range_2000_dps, Range_2000_dps_1);
   for Full_Scale_Mode use (Range_250_dps => 0, Range_500_dps => 1, Range_2000_dps => 2, Range_2000_dps_1 => 3);

   type Endianness is (Little_Endian, Big_Endian);
   for Endianness use (Little_Endian => 0, Big_Endian => 1);

   type Update_Mode is (Continous, Block);
   for Update_Mode use (Continous => 0, Block => 1);

   type Filtering_Mode is mod 2**2; -- TODO

   type FIFO_Threshold is mod 2**5;

   type FIFO_Mode is mod 2**3; -- TODO

   -------------------------
   -- Types for registers --
   -------------------------

   ------------------------
   -- Control register 1 --
   ------------------------
   type Control_Register_1_Byte is
      record
         X_Enable : Boolean;
         Y_Enable : Boolean;
         Z_Enable : Boolean;
         Normal_Mode_Enable : Boolean; -- TODO rename
         Bandwidth_Selector : Bandwidth;
         Output_Data_Rate : Data_Rate;
      end record;

   for Control_Register_1_Byte use
      record
         X_Enable at 0 range 0 .. 0;
         Y_Enable at 0 range 1 .. 1;
         Z_Enable at 0 range 2 .. 2;
         Normal_Mode_Enable at 0 range 3 .. 3;
         Bandwidth_Selector at 0 range 4 .. 5;
         Output_Data_Rate at 0 range 6 .. 7;
      end record;

   for Control_Register_1_Byte'Size use 8;

   ------------------------
   -- Control register 2 --
   ------------------------
   type Control_Register_2_Byte is
      record
         Cut_Off_Frequency_Selector : Cut_Off_Frequency;
         High_Pass_Mode_Selector : High_Pass_Mode;
         Reserved : Reserved_2;
      end record;

   for Control_Register_2_Byte use
      record
         Cut_Off_Frequency_Selector at 0 range 0 .. 3;
         High_Pass_Mode_Selector at 0 range 4 .. 5;
         Reserved at 0 range 6 .. 7;
      end record;

   for Control_Register_2_Byte'Size use 8;

   ------------------------
   -- Control register 3 --
   ------------------------
   type Control_Register_3_Byte is
      record
         FIFO_Empty_On_INT2 : Boolean;
         FIFO_Overrun_On_INT2 : Boolean;
         FIFO_Watermark_On_INT2 : Boolean;
         Data_Ready_On_INT2 : Boolean;
         Interface_Kind : Interface_Type;
         Active_On_INT1 : Boolean;
         Boot_Status_On_INT1 : Boolean;
         Interrupt_Enable_On_INT1 : Boolean;
      end record;

   for Control_Register_3_Byte use
      record
         FIFO_Empty_On_INT2 at 0 range 0 .. 0;
         FIFO_Overrun_On_INT2 at 0 range 1 .. 1;
         FIFO_Watermark_On_INT2 at 0 range 2 .. 2;
         Data_Ready_On_INT2 at 0 range 3 .. 3;
         Interface_Kind at 0 range 4 .. 4;
         Active_On_INT1 at 0 range 5 .. 5;
         Boot_Status_On_INT1 at 0 range 6 .. 6;
         Interrupt_Enable_On_INT1 at 0 range 7 .. 7;
      end record;

   for Control_Register_3_Byte'Size use 8;

   ------------------------
   -- Control register 4 --
   ------------------------
   type Control_Register_4_Byte is
      record
         SPI_Mode_Selection : SPI_Mode;
         Self_Test_Selection : Self_Test_Mode;
         Reserved : Reserved_1;
         Full_Scale_Selection : Full_Scale_Mode;
         Endianness_Selection : Endianness;
         Update_Mode_Selection : Update_Mode;
      end record;

   for Control_Register_4_Byte use
      record
         SPI_Mode_Selection at 0 range 0 .. 0;
         Self_Test_Selection at 0 range 1 .. 2;
         Reserved at 0 range 3 .. 3;
         Full_Scale_Selection at 0 range 4 .. 5;
         Endianness_Selection at 0 range 6 .. 6;
         Update_Mode_Selection at 0 range 7 .. 7;
      end record;

   for Control_Register_4_Byte'Size use 8;

   ------------------------
   -- Control register 5 --
   ------------------------
   type Control_Register_5_Byte is
      record
         Output_Selection : Filtering_Mode;
         INT1_Selection : Filtering_Mode;
         Enable_High_Pass_Filter : Boolean;
         Reserved : Reserved_1;
         Enable_FIFO : Boolean;
         Reboot_Memory_Content : Boolean;
      end record;

   for Control_Register_5_Byte use
      record
         Output_Selection at 0 range 0 .. 1;
         INT1_Selection at 0 range 2 .. 3;
         Enable_High_Pass_Filter at 0 range 4 .. 4;
         Reserved at 0 range 5 .. 5;
         Enable_FIFO at 0 range 6 .. 6;
         Reboot_Memory_Content at 0 range 7 .. 7;
      end record;

   for Control_Register_5_Byte'Size use 8;

   ---------------------
   -- Status register --
   ---------------------
   type Status_Register_Byte is
      record
         X_Axis_Data_Available : Boolean;
         Y_Axis_Data_Available : Boolean;
         Z_Axis_Data_Available : Boolean;
         XYZ_Axis_Data_Available : Boolean;
         X_Axis_Data_Overrun : Boolean;
         Y_Axis_Data_Overrun : Boolean;
         Z_Axis_Data_Overrun : Boolean;
         XYZ_Axis_Data_Overrun : Boolean;
      end record;

   for Status_Register_Byte use
      record
         X_Axis_Data_Available at 0 range 0 .. 0;
         Y_Axis_Data_Available at 0 range 1 .. 1;
         Z_Axis_Data_Available at 0 range 2 .. 2;
         XYZ_Axis_Data_Available at 0 range 3 .. 3;
         X_Axis_Data_Overrun at 0 range 4 .. 4;
         Y_Axis_Data_Overrun at 0 range 5 .. 5;
         Z_Axis_Data_Overrun at 0 range 6 .. 6;
         XYZ_Axis_Data_Overrun at 0 range 7 .. 7;
      end record;

   for Status_Register_Byte'Size use 8;

   ---------------------------
   -- FIFO control register --
   ---------------------------
   type FIFO_Control_Register_Byte is
      record
         Threshold : FIFO_Threshold;
         Mode : FIFO_Mode;
      end record;

   for FIFO_Control_Register_Byte use
      record
         Threshold at 0 range 0 .. 4;
         Mode at 0 range 5 .. 7;
      end record;

   for FIFO_Control_Register_Byte'Size use 8;

   -- TODO
end L3G4200D;
