with MCU.GPIO.Port_D;
with MCU.System_Control.Registers;
with MCU.Utils;
with DCC;

procedure LED_Demo is
   Green_LED : constant MCU.GPIO.Pin_Number := 6;
   Red_LED : constant MCU.GPIO.Pin_Number := 7;

   type LED_Status is (Off, On);

   procedure Set_LEDs (Green, Red : LED_Status) is
      LEDs_Mask : constant MCU.GPIO.Data_Mask :=
         (Green_LED | Red_LED => MCU.GPIO.Unmasked,
          others => MCU.GPIO.Masked);

      Green_Pin, Red_Pin : MCU.GPIO.Pin_State;

      function LED_To_Pin (LED : LED_Status) return MCU.GPIO.Pin_State is
         Value : MCU.GPIO.Pin_State;
      begin
         case LED is
            when Off => Value := MCU.GPIO.High;
            when On => Value := MCU.GPIO.Low;
         end case;

         return Value;
      end LED_To_Pin;
   begin
      Green_Pin := LED_To_Pin (Green);
      Red_Pin := LED_To_Pin (Red);
      MCU.GPIO.Port_D.Set_Pins (States => (Green_LED => Green_Pin, Red_LED => Red_Pin, others => MCU.GPIO.Low), Mask => LEDs_Mask);
   end Set_LEDs;

   procedure Init_GPIO is
      use MCU.GPIO;
      use MCU.System_Control;
      use MCU.GPIO.Port_D;
   begin
      MCU.System_Control.Registers.Run_Mode_Clock_Gating_Control_Register_2 :=
         MCU.System_Control.Clock_Gating_Control_Register_2_Record'
            (GPIO => (MCU.GPIO.Port_D.ID => Clock_Enabled, others => Clock_Disabled),
             UDMA | USB0 => Clock_Disabled,
             others => <>);

      MCU.System_Control.Registers.GPIO_High_Performance_Bus_Control_Register :=
         MCU.System_Control.GPIO_High_Performance_Bus_Control_Register_Record'
            (Controls => (others => AHB),
             others => <>);

      MCU.Utils.Nop;
      MCU.Utils.Nop;
      MCU.Utils.Nop;

      Direction_Register :=
         Direction_Register_Record'
            (Directions => (Green_LED | Red_LED => Output, others => Input),
             others => <>);

      Drive_Select_8mA_Register :=
         Drive_Select_Register_Record'
            (Drive_Selects => (Green_LED | Red_LED => Select_Drive, others => No_Change),
             others => <>);

      Set_LEDs (Off, On);

      Open_Drain_Select_Register :=
         Open_Drain_Select_Register_Record'
            (Selections => (Green_LED | Red_LED => Enable_Open_Drain, others => Disable_Open_Drain),
             others => <>);

      Slew_Rate_Control_Register :=
         Slew_Rate_Control_Register_Record'
            (Controls => (Green_LED | Red_LED => Enable_Slew_Rate_Control, others => Disable_Slew_Rate_Control),
             others => <>);

      Digital_Enable_Register :=
         Digital_Enable_Register_Record'
            (Digital_Functions =>
               (Green_LED | Red_LED => Enable_Digital_Function,
                others => Disable_Digital_Function),
             others => <>);
   end Init_GPIO;

   procedure Switch_To_PLL is
      use MCU.System_Control;

      Clock_Config : Run_Mode_Clock_Configuration_Register_Record;
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
      while Registers.Raw_Interrupt_Status_Register.PLL_Lock = Not_Active loop
         null;
      end loop;

      -- TODO Clear the interrupt

      -- Run off the PLL
      Clock_Config := Registers.Run_Mode_Clock_Configuration_Register;
      Clock_Config.PLL_Bypass := False;
      Registers.Run_Mode_Clock_Configuration_Register := Clock_Config;
   end Switch_To_PLL;

   type Phase is (Phase1, Phase2);
   Current_Phase : Phase;

   Delay_Value : constant := 1000000;
begin
   Switch_To_PLL;

   Init_GPIO;
   Current_Phase := Phase1;

   DCC.Put_Line ("Hallo!");

   loop
      case Current_Phase is
         when Phase1 =>
            Set_LEDs (Off, On);
            Current_Phase := Phase2;
         when Phase2 =>
            Set_LEDs (On, Off);
            Current_Phase := Phase1;
      end case;

      for I in 1 .. Delay_Value loop
         MCU.Utils.Nop;
      end loop;
   end loop;
end LED_Demo;
