with MCU.GPIO.Port_D;
with MCU.GPIO.Port_E;
with MCU.System_Control.Registers;
with MCU.Utils;
with MCU.SSI.SSI1;
with Debug_IO;
with Ada.Characters.Latin_1;
with L3G4200D.Driver;
pragma Unreferenced (L3G4200D.Driver);

procedure LED_Demo is
   package L1 renames Ada.Characters.Latin_1;

   Green_LED : constant MCU.GPIO.Pin_Number := 6;
   Red_LED   : constant MCU.GPIO.Pin_Number := 7;

   Gyro_SPC : constant MCU.GPIO.Pin_Number := 0;
   Gyro_CS  : constant MCU.GPIO.Pin_Number := 1;
   Gyro_SDO : constant MCU.GPIO.Pin_Number := 2;
   Gyro_SDI : constant MCU.GPIO.Pin_Number := 3;

   procedure Set_Gyro_CS (State : MCU.GPIO.Pin_State) is
      Gyro_CS_Mask : constant MCU.GPIO.Data_Mask := (Gyro_CS => MCU.GPIO.Unmasked, others => MCU.GPIO.Masked);
   begin
      MCU.GPIO.Port_E.Set_Pins (States => (Gyro_CS => State, others => MCU.GPIO.Low), Mask => Gyro_CS_Mask);
   end Set_Gyro_CS;

   package Gyro_Driver is new L3G4200D.Driver (MCU.SSI.SSI1, Set_Gyro_CS);

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

   procedure Init_System_Control is
      use MCU.GPIO;
      use MCU.System_Control;

      Clock_Register_1 : Clock_Gating_Control_Register_1_Record;
      Clock_Register_2 : Clock_Gating_Control_Register_2_Record;
   begin
      Registers.GPIO_High_Performance_Bus_Control_Register :=
         GPIO_High_Performance_Bus_Control_Register_Record'
            (Controls => (others => AHB),
             others => <>);

      Clock_Register_1 := Registers.Run_Mode_Clock_Gating_Control_Register_1;
      Clock_Register_1.SSI (MCU.SSI.SSI1.ID) := Clock_Enabled;
      Registers.Run_Mode_Clock_Gating_Control_Register_1 := Clock_Register_1;

      Clock_Register_2 := Registers.Run_Mode_Clock_Gating_Control_Register_2;
      Clock_Register_2.GPIO (Port_D.ID) := Clock_Enabled;
      Clock_Register_2.GPIO (Port_E.ID) := Clock_Enabled;
      Registers.Run_Mode_Clock_Gating_Control_Register_2 := Clock_Register_2;
   end Init_System_Control;

   procedure Init_GPIO is
      use MCU.GPIO;
   begin
      ------------
      -- Port D --
      ------------
      Port_D.Direction_Register :=
         Direction_Register_Record'
            (Directions => (Green_LED | Red_LED => Output, others => Input),
             others => <>);

      Port_D.Drive_Select_8mA_Register :=
         Drive_Select_Register_Record'
            (Drive_Selects => (Green_LED | Red_LED => Select_Drive, others => No_Change),
             others => <>);

      Set_LEDs (Green => Off, Red => On);

      Port_D.Open_Drain_Select_Register :=
         Open_Drain_Select_Register_Record'
            (Selections => (Green_LED | Red_LED => Enable_Open_Drain, others => Disable_Open_Drain),
             others => <>);

      Port_D.Slew_Rate_Control_Register :=
         Slew_Rate_Control_Register_Record'
            (Controls => (Green_LED | Red_LED => Enable_Slew_Rate_Control, others => Disable_Slew_Rate_Control),
             others => <>);

      Port_D.Digital_Enable_Register :=
         Digital_Enable_Register_Record'
            (Digital_Functions =>
               (Green_LED | Red_LED => Enable_Digital_Function,
                others => Disable_Digital_Function),
             others => <>);

      ------------
      -- Port E --
      ------------
      Port_E.Direction_Register :=
         Direction_Register_Record'
            (Directions =>
               (Gyro_SPC | Gyro_CS | Gyro_SDI => Output,
                others => Input),
             others => <>);

      Port_E.Alternate_Function_Select_Register :=
         Alternate_Function_Select_Register_Record'
            (Functions => (Gyro_SPC | Gyro_SDO | Gyro_SDI => Alternate_Function, others => GPIO_Mode),
             others => <>);

      Port_E.Pull_Up_Select_Register :=
         Pull_Up_Select_Register_Record'
            (Selections => (Gyro_SDO => Enable_Pull_Up, others => Disable_Pull_Up),
             others => <>);

      Set_Gyro_CS (MCU.GPIO.High);

      Port_E.Digital_Enable_Register :=
         Digital_Enable_Register_Record'
            (Digital_Functions =>
               (Gyro_SPC | Gyro_CS | Gyro_SDO | Gyro_SDI => Enable_Digital_Function,
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

   procedure Test_Gyroscope is
      Gyro_Ok : Boolean;
   begin
      Gyro_Driver.Check_Who_Am_I (Gyro_Ok);

      if Gyro_Ok then
         Debug_IO.Put ("Ok" & L1.LF);
      else
         Debug_IO.Put ("No!" & L1.LF);
      end if;
   end Test_Gyroscope;

   type Phase is (Phase1, Phase2);
   Current_Phase : Phase;

   Delay_Value : constant := 1000000;
begin
   Init_System_Control;
   Switch_To_PLL;

   Gyro_Driver.Initialize;
   Init_GPIO;

   Current_Phase := Phase1;

   loop
      case Current_Phase is
         when Phase1 =>
            Set_LEDs (Green => Off, Red => On);
            Current_Phase := Phase2;
         when Phase2 =>
            Set_LEDs (Green => On, Red => Off);
            Current_Phase := Phase1;
      end case;

      for I in 1 .. Delay_Value loop
         MCU.Utils.Nop;
      end loop;

      Test_Gyroscope;
   end loop;
end LED_Demo;
