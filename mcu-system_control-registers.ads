pragma Restrictions (No_Elaboration_Code);
with System.Storage_Elements;

package MCU.System_Control.Registers is
   pragma Preelaborate;

   use type System.Storage_Elements.Integer_Address;

   Base_Address : constant System.Storage_Elements.Integer_Address := Register_File_Base_Address;

   Brown_Out_Reset_Control_Register : Brown_Out_Reset_Control_Register_Record;
   for Brown_Out_Reset_Control_Register'Address use System'To_Address (Base_Address + Brown_Out_Reset_Control_Register_Offset);
   pragma Atomic (Brown_Out_Reset_Control_Register);
   pragma Import (Ada, Brown_Out_Reset_Control_Register);

   -- TODO

   Raw_Interrupt_Status_Register : Raw_Interrupt_Status_Register_Record;
   for Raw_Interrupt_Status_Register'Address use System'To_Address (Base_Address + Raw_Interrupt_Status_Register_Offset);
   pragma Atomic (Raw_Interrupt_Status_Register);
   pragma Import (Ada, Raw_Interrupt_Status_Register);

   -- TODO

   Run_Mode_Clock_Configuration_Register : Run_Mode_Clock_Configuration_Register_Record;
   for Run_Mode_Clock_Configuration_Register'Address use
      System'To_Address (Base_Address + Run_Mode_Clock_Configuration_Register_Offset);
   pragma Atomic (Run_Mode_Clock_Configuration_Register);
   pragma Import (Ada, Run_Mode_Clock_Configuration_Register);

   -- TODO

   GPIO_High_Performance_Bus_Control_Register : GPIO_High_Performance_Bus_Control_Register_Record;
   for GPIO_High_Performance_Bus_Control_Register'Address use
      System'To_Address (Base_Address + GPIO_High_Performance_Bus_Control_Register_Offset);
   pragma Atomic (GPIO_High_Performance_Bus_Control_Register);
   pragma Import (Ada, GPIO_High_Performance_Bus_Control_Register);

   -- TODO

   Run_Mode_Clock_Gating_Control_Register_2 : Clock_Gating_Control_Register_2_Record;
   for Run_Mode_Clock_Gating_Control_Register_2'Address use
      System'To_Address (Base_Address + Run_Mode_Clock_Gating_Control_Register_2_Offset);
   pragma Atomic (Run_Mode_Clock_Gating_Control_Register_2);
   pragma Import (Ada, Run_Mode_Clock_Gating_Control_Register_2);
end MCU.System_Control.Registers;
