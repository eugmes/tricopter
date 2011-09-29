with Ada.Unchecked_Conversion;

package body MCU.GPIO.Generic_Port is
   type Integer_Mask is mod 2**8;
   for Integer_Mask'Size use 8;

   function Mask_To_Integer is new Ada.Unchecked_Conversion (Data_Mask, Integer_Mask);

   procedure Set_Pins (States : Pin_States; Mask : Data_Mask) is
      Masked_Data_Register : Data_Register_Record;
      for Masked_Data_Register'Address use System'To_Address
         (Base_Address + Data_Register_Offset +
            System.Storage_Elements.Integer_Address (Mask_To_Integer (Mask)) * 4);
      pragma Atomic (Masked_Data_Register);
      pragma Import (Ada, Masked_Data_Register);
   begin
      Masked_Data_Register := (Data => States, Reserved => 0);
   end Set_Pins;

   function Get_Pins (Mask : Data_Mask) return Pin_States is
      Masked_Data_Register : Data_Register_Record;
      for Masked_Data_Register'Address use System'To_Address
         (Base_Address + Data_Register_Offset +
            System.Storage_Elements.Integer_Address (Mask_To_Integer (Mask)) * 4);
      pragma Atomic (Masked_Data_Register);
      pragma Import (Ada, Masked_Data_Register);

      Current_Value : Data_Register_Record;
   begin
      Current_Value := Masked_Data_Register;
      return Current_Value.Data;
   end Get_Pins;

end MCU.GPIO.Generic_Port;
