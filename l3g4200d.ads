pragma Restrictions (No_Elaboration_Code);

package L3G4200D is
   pragma Pure;

   type Register_Address is mod 2**6;

   type Byte is mod 2**8;
   for Byte'Size use 8;

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
end L3G4200D;
