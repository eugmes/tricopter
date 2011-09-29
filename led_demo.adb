with MCU.GPIO.Port_D;
with MCU.GPIO.Port_E;
with MCU.System_Control.Registers;
with MCU.SSI.SSI1;
with Debug_IO;
with Ada.Characters.Latin_1;
with L3G4200D.Driver;

use type L3G4200D.Raw_Angular_Rate;

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

      Bus_Control : GPIO_High_Performance_Bus_Control_Register_Record;
      Clock_Register_1 : Clock_Gating_Control_Register_1_Record;
      Clock_Register_2 : Clock_Gating_Control_Register_2_Record;
   begin
      Bus_Control := Registers.GPIO_High_Performance_Bus_Control_Register;
      Bus_Control.Controls := (others => AHB);
      Registers.GPIO_High_Performance_Bus_Control_Register := Bus_Control;

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

      Direction_Register : Direction_Register_Record;
      Alternate_Function_Select_Register : Alternate_Function_Select_Register_Record;
      Drive_Select_Register : Drive_Select_Register_Record;
      Open_Drain_Select_Register : Open_Drain_Select_Register_Record;
      Slew_Rate_Control_Register : Slew_Rate_Control_Register_Record;
      Digital_Enable_Register : Digital_Enable_Register_Record;
      Pull_Up_Select_Register : Pull_Up_Select_Register_Record;
   begin
      ------------
      -- Port D --
      ------------
      Direction_Register := Port_D.Direction_Register;
      Direction_Register.Directions (Green_LED) := Output;
      Direction_Register.Directions (Red_LED) := Output;
      Port_D.Direction_Register := Direction_Register;

      Alternate_Function_Select_Register := Port_D.Alternate_Function_Select_Register;
      Alternate_Function_Select_Register.Functions (Green_LED) := GPIO_Mode;
      Alternate_Function_Select_Register.Functions (Red_LED) := GPIO_Mode;
      Port_D.Alternate_Function_Select_Register := Alternate_Function_Select_Register;

      Drive_Select_Register := Port_D.Drive_Select_8mA_Register;
      Drive_Select_Register.Drive_Selects (Green_LED) := Select_Drive;
      Drive_Select_Register.Drive_Selects (Red_LED) := Select_Drive;
      Port_D.Drive_Select_8mA_Register := Drive_Select_Register;

      Set_LEDs (Green => Off, Red => Off);

      Open_Drain_Select_Register := Port_D.Open_Drain_Select_Register;
      Open_Drain_Select_Register.Selections (Green_LED) := Enable_Open_Drain;
      Open_Drain_Select_Register.Selections (Red_LED) := Enable_Open_Drain;
      Port_D.Open_Drain_Select_Register := Open_Drain_Select_Register;

      Slew_Rate_Control_Register := Port_D.Slew_Rate_Control_Register;
      Slew_Rate_Control_Register.Controls (Green_LED) := Enable_Slew_Rate_Control;
      Slew_Rate_Control_Register.Controls (Red_LED) := Enable_Slew_Rate_Control;
      Port_D.Slew_Rate_Control_Register := Slew_Rate_Control_Register;

      Digital_Enable_Register := Port_D.Digital_Enable_Register;
      Digital_Enable_Register.Digital_Functions (Green_LED) := Enable_Digital_Function;
      Digital_Enable_Register.Digital_Functions (Red_LED) := Enable_Digital_Function;
      Port_D.Digital_Enable_Register := Digital_Enable_Register;

      ------------
      -- Port E --
      ------------
      Direction_Register := Port_E.Direction_Register;
      Direction_Register.Directions (Gyro_SPC) := Output;
      Direction_Register.Directions (Gyro_CS) := Output;
      Direction_Register.Directions (Gyro_SDI) := Output;
      Direction_Register.Directions (Gyro_SDO) := Input;
      Port_E.Direction_Register := Direction_Register;

      Alternate_Function_Select_Register := Port_E.Alternate_Function_Select_Register;
      Alternate_Function_Select_Register.Functions (Gyro_SPC) := Alternate_Function;
      Alternate_Function_Select_Register.Functions (Gyro_CS) := GPIO_Mode;
      Alternate_Function_Select_Register.Functions (Gyro_SDI) := Alternate_Function;
      Alternate_Function_Select_Register.Functions (Gyro_SDO) := Alternate_Function;
      Port_E.Alternate_Function_Select_Register := Alternate_Function_Select_Register;

      Pull_Up_Select_Register := Port_E.Pull_Up_Select_Register;
      Pull_Up_Select_Register.Selections (Gyro_SDO) := Enable_Pull_Up;
      -- FIXME others default (Disable_Pull_Up)
      Port_E.Pull_Up_Select_Register := Pull_Up_Select_Register;

      Set_Gyro_CS (MCU.GPIO.High);

      Digital_Enable_Register := Port_E.Digital_Enable_Register;
      Digital_Enable_Register.Digital_Functions (Gyro_SPC) := Enable_Digital_Function;
      Digital_Enable_Register.Digital_Functions (Gyro_CS) := Enable_Digital_Function;
      Digital_Enable_Register.Digital_Functions (Gyro_SDO) := Enable_Digital_Function;
      Digital_Enable_Register.Digital_Functions (Gyro_SDI) := Enable_Digital_Function;
      Port_E.Digital_Enable_Register := Digital_Enable_Register;
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

   X_Rate, Y_Rate, Z_Rate : L3G4200D.Raw_Angular_Rate;
   Threshold : constant L3G4200D.Raw_Angular_Rate := 300;
begin
   Init_System_Control;
   Switch_To_PLL;

   Gyro_Driver.Initialize;
   Init_GPIO;
   Gyro_Driver.Initialize_Gyroscope;

   Test_Gyroscope;

   loop
      Gyro_Driver.Wait_For_New_Reading;
      Gyro_Driver.Read_Sensor_Data (X_Rate, Y_Rate, Z_Rate);

      if Z_Rate > Threshold then
         Set_LEDs (Green => Off, Red => On);
      elsif Z_Rate < -Threshold then
         Set_LEDs (Green => On, Red => Off);
      else
         Set_LEDs (Green => Off, Red => Off);
      end if;
   end loop;
end LED_Demo;
