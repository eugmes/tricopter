with MCU.System_Control.Registers;
with MCU.GPIO.Port_D;
with MCU.GPIO.Port_E;
with MCU.SSI.SSI1;

package body System_Initialization is

   procedure Enable_GPIO_AHB is
      use MCU.System_Control;

      Bus_Control : GPIO_High_Performance_Bus_Control_Register_Record;
   begin
      Bus_Control := Registers.GPIO_High_Performance_Bus_Control_Register;
      Bus_Control.Controls := (others => AHB);
      Registers.GPIO_High_Performance_Bus_Control_Register := Bus_Control;
   end Enable_GPIO_AHB;

   procedure Enable_Clocks is
      use MCU.System_Control;
      use MCU.GPIO;

      Clock_Register_1 : Clock_Gating_Control_Register_1_Record;
      Clock_Register_2 : Clock_Gating_Control_Register_2_Record;
   begin
      Clock_Register_1 := Registers.Run_Mode_Clock_Gating_Control_Register_1;
      Clock_Register_1.SSI (MCU.SSI.SSI1.ID) := Clock_Enabled;
      Registers.Run_Mode_Clock_Gating_Control_Register_1 := Clock_Register_1;

      Clock_Register_2 := Registers.Run_Mode_Clock_Gating_Control_Register_2;
      Clock_Register_2.GPIO (Port_D.ID) := Clock_Enabled;
      Clock_Register_2.GPIO (Port_E.ID) := Clock_Enabled;
      Registers.Run_Mode_Clock_Gating_Control_Register_2 := Clock_Register_2;
   end Enable_Clocks;

   procedure Switch_To_PLL is
      use MCU.System_Control;

      Clock_Config : Run_Mode_Clock_Configuration_Register_Record;
      Interrupt_Status : Raw_Interrupt_Status_Register_Record;
   begin
      Clock_Config := Registers.Run_Mode_Clock_Configuration_Register;

      -- TODO Clear the PLL interrupt, just in case...

      -- Bypass the PLL and system clock divider
      Clock_Config.PLL_Bypass := True;
      Clock_Config.Enable_System_Clock_Divider := False;
      Registers.Run_Mode_Clock_Configuration_Register := Clock_Config;

      -- Select the right crystal value (10 MHz)
      Clock_Config.Crystal_Value := Crystal_Frequency_10_MHz;
      -- Select main oscillator as source
      Clock_Config.Oscillator_Source := Main_Oscillator;
      -- Power-up the PLL
      Clock_Config.PLL_Power_Down := False;
      Registers.Run_Mode_Clock_Configuration_Register := Clock_Config;

      -- Select clock divider for 50 MHz operation
      Clock_Config.System_Clock_Divisor := 4; -- 200 / 50
      Clock_Config.Enable_System_Clock_Divider := True;
      Registers.Run_Mode_Clock_Configuration_Register := Clock_Config;

      -- Wait for PLL sync
      loop
         Interrupt_Status := Registers.Raw_Interrupt_Status_Register;
         exit when Interrupt_Status.PLL_Lock = Active;
      end loop;

      -- TODO Clear the interrupt

      -- Run off the PLL
      Clock_Config := Registers.Run_Mode_Clock_Configuration_Register;
      Clock_Config.PLL_Bypass := False;
      Registers.Run_Mode_Clock_Configuration_Register := Clock_Config;
   end Switch_To_PLL;

begin
   Enable_GPIO_AHB;
   Enable_Clocks;
   Switch_To_PLL;
end System_Initialization;
