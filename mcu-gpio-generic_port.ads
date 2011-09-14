with System.Storage_Elements;

generic
   Base_Address : System.Address;
package MCU.GPIO.Generic_Port is
   pragma Pure;

   use type System.Address;
   use type System.Storage_Elements.Storage_Offset;

   -- XXX FIXME TODO this register is masked
   Data_Register : Data_Register_Record;
   for Data_Register'Address use Base_Address + Data_Register_Offset;
   pragma Volatile (Data_Register);
   pragma Import (Ada, Data_Register);

   Direction_Register : Direction_Register_Record;
   for Direction_Register'Address use Base_Address + Direction_Register_Offset;
   pragma Volatile (Direction_Register);
   pragma Import (Ada, Direction_Register);

   Interrupt_Sense_Register : Interrupt_Sense_Register_Record;
   for Interrupt_Sense_Register'Address use Base_Address + Interrupt_Sense_Register_Offset;
   pragma Volatile (Interrupt_Sense_Register);
   pragma Import (Ada, Interrupt_Sense_Register);

   Interrupt_Both_Edges_Register : Interrupt_Both_Edges_Register_Record;
   for Interrupt_Both_Edges_Register'Address use Base_Address + Interrupt_Both_Edges_Register_Offset;
   pragma Volatile (Interrupt_Both_Edges_Register);
   pragma Import (Ada, Interrupt_Both_Edges_Register);

   Interrupt_Event_Register : Interrupt_Event_Register_Record;
   for Interrupt_Event_Register'Address use Base_Address + Interrupt_Event_Register_Offset;
   pragma Volatile (Interrupt_Event_Register);
   pragma Import (Ada, Interrupt_Event_Register);

   Interrupt_Mask_Register : Interrupt_Mask_Register_Record;
   for Interrupt_Mask_Register'Address use Base_Address + Interrupt_Mask_Register_Offset;
   pragma Volatile (Interrupt_Mask_Register);
   pragma Import (Ada, Interrupt_Mask_Register);

   Raw_Interrupt_Status_Register : Interrupt_Status_Record;
   for Raw_Interrupt_Status_Register'Address use Base_Address + Raw_Interrupt_Status_Register_Offset;
   pragma Volatile (Raw_Interrupt_Status_Register);
   pragma Import (Ada, Raw_Interrupt_Status_Register);

   Masked_Interrupt_Status_Register : Interrupt_Status_Record;
   for Masked_Interrupt_Status_Register'Address use Base_Address + Masked_Interrupt_Status_Register_Offset;
   pragma Volatile (Masked_Interrupt_Status_Register);
   pragma Import (Ada, Masked_Interrupt_Status_Register);

   Interrupt_Clear_Register : Interrupt_Clear_Register_Record;
   for Interrupt_Clear_Register'Address use Base_Address + Interrupt_Clear_Register_Offset;
   pragma Volatile (Interrupt_Clear_Register);
   pragma Import (Ada, Interrupt_Clear_Register);

   Alternate_Function_Select_Register : Alternate_Function_Select_Register_Record;
   for Alternate_Function_Select_Register'Address use Base_Address + Alternate_Function_Select_Register_Offset;
   pragma Volatile (Alternate_Function_Select_Register);
   pragma Import (Ada, Alternate_Function_Select_Register);

   Drive_Select_2mA_Register : Drive_Select_Register_Record;
   for Drive_Select_2mA_Register'Address use Base_Address + Drive_Select_2mA_Register_Offset;
   pragma Volatile (Drive_Select_2mA_Register);
   pragma Import (Ada, Drive_Select_2mA_Register);

   Drive_Select_4mA_Register : Drive_Select_Register_Record;
   for Drive_Select_4mA_Register'Address use Base_Address + Drive_Select_4mA_Register_Offset;
   pragma Volatile (Drive_Select_4mA_Register);
   pragma Import (Ada, Drive_Select_4mA_Register);

   Drive_Select_8mA_Register : Drive_Select_Register_Record;
   for Drive_Select_8mA_Register'Address use Base_Address + Drive_Select_8mA_Register_Offset;
   pragma Volatile (Drive_Select_8mA_Register);
   pragma Import (Ada, Drive_Select_8mA_Register);

   Open_Drain_Select_Register : Open_Drain_Select_Register_Record;
   for Open_Drain_Select_Register'Address use Base_Address + Open_Drain_Select_Register_Offset;
   pragma Volatile (Open_Drain_Select_Register);
   pragma Import (Ada, Open_Drain_Select_Register);

   Pull_Up_Select_Register : Pull_Up_Select_Register_Record;
   for Pull_Up_Select_Register'Address use Base_Address + Pull_Up_Select_Register_Offset;
   pragma Volatile (Pull_Up_Select_Register);
   pragma Import (Ada, Pull_Up_Select_Register);

   Pull_Down_Select_Register : Pull_Down_Select_Register_Record;
   for Pull_Down_Select_Register'Address use Base_Address + Pull_Down_Select_Register_Offset;
   pragma Volatile (Pull_Down_Select_Register);
   pragma Import (Ada, Pull_Down_Select_Register);

   Slew_Rate_Control_Register : Slew_Rate_Control_Register_Record;
   for Slew_Rate_Control_Register'Address use Base_Address + Slew_Rate_Control_Register_Offset;
   pragma Volatile (Slew_Rate_Control_Register);
   pragma Import (Ada, Slew_Rate_Control_Register);

   Digital_Enable_Register : Digital_Enable_Register_Record;
   for Digital_Enable_Register'Address use Base_Address + Digital_Enable_Register_Offset;
   pragma Volatile (Digital_Enable_Register);
   pragma Import (Ada, Digital_Enable_Register);

   Lock_Register : Lock_Value;
   for Lock_Register'Address use Base_Address + Lock_Register_Offset;
   pragma Volatile (Lock_Register);
   pragma Import (Ada, Lock_Register);

   Commit_Register : Commit_Register_Record;
   for Commit_Register'Address use Base_Address + Commit_Register_Offset;
   pragma Volatile (Commit_Register);
   pragma Import (Ada, Commit_Register);

   Analog_Mode_Select_Register : Analog_Mode_Select_Register_Record;
   for Analog_Mode_Select_Register'Address use Base_Address + Analog_Mode_Select_Register_Offset;
   pragma Volatile (Analog_Mode_Select_Register);
   pragma Import (Ada, Analog_Mode_Select_Register);
end MCU.GPIO.Generic_Port;
