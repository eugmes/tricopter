pragma Restrictions (No_Elaboration_Code);
with System.Storage_Elements;

generic
   Base_Address : System.Storage_Elements.Integer_Address;
   Port_ID : SSI_Port;
package MCU.SSI.Generic_Port is
   pragma Preelaborate;

   use type System.Storage_Elements.Integer_Address;

   ID : constant SSI_Port := Port_ID;

   Control_Register_0 : Control_Register_0_Record;
   for Control_Register_0'Address use System'To_Address (Base_Address + Control_Register_0_Offset);
   pragma Atomic (Control_Register_0);
   pragma Import (Ada, Control_Register_0);

   Control_Register_1 : Control_Register_1_Record;
   for Control_Register_1'Address use System'To_Address (Base_Address + Control_Register_1_Offset);
   pragma Atomic (Control_Register_1);
   pragma Import (Ada, Control_Register_1);

   Data_Register : Data_Register_Record;
   for Data_Register'Address use System'To_Address (Base_Address + Data_Register_Offset);
   pragma Atomic (Data_Register);
   pragma Import (Ada, Data_Register);

   Status_Register : constant Status_Register_Record;
   for Status_Register'Address use System'To_Address (Base_Address + Status_Register_Offset);
   pragma Atomic (Status_Register);
   pragma Import (Ada, Status_Register);

   Clock_Prescale_Register : Clock_Prescale_Register_Record;
   for Clock_Prescale_Register'Address use System'To_Address (Base_Address + Clock_Prescale_Register_Offset);
   pragma Atomic (Clock_Prescale_Register);
   pragma Import (Ada, Clock_Prescale_Register);
end MCU.SSI.Generic_Port;
