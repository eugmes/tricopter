with MCU.GPIO.Port_D;
with MCU.GPIO.Port_E;
with MCU.System_Control.Registers;
with MCU.Utils;
with MCU.SSI.SSI1;
with Debug_IO;

procedure LED_Demo is
   Green_LED : constant MCU.GPIO.Pin_Number := 6;
   Red_LED   : constant MCU.GPIO.Pin_Number := 7;

   Gyro_SPC : constant MCU.GPIO.Pin_Number := 0;
   Gyro_CS  : constant MCU.GPIO.Pin_Number := 1;
   Gyro_SDO : constant MCU.GPIO.Pin_Number := 2;
   Gyro_SDI : constant MCU.GPIO.Pin_Number := 3;

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
            (Functions => (Gyro_SPC | Gyro_CS | Gyro_SDO | Gyro_SDI => Alternate_Function, others => GPIO_Mode),
             others => <>);

      Port_E.Pull_Up_Select_Register :=
         Pull_Up_Select_Register_Record'
            (Selections => (Gyro_SDO => Enable_Pull_Up, others => Disable_Pull_Up),
             others => <>);

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

   procedure Init_SSI is
      use MCU.SSI;

      Control_0 : Control_Register_0_Record;
      Control_1 : Control_Register_1_Record;
      Clock_Prescale : Clock_Prescale_Register_Record;
   begin
      -- Make sure the SSI is disabled
      Control_1 := SSI1.Control_Register_1;
      Control_1.Port_Enable := False;
      SSI1.Control_Register_1 := Control_1;

      -- Select master mode
      Control_1.Mode_Select := Normal_Mode;
      Control_1.Master_Slave_Select := Master;
      SSI1.Control_Register_1 := Control_1;

      -- Set 1MHz clock, SPI mode, 16-bit data, SPO=1, SPH=0;
      -- Clock rate calculations for 50MHz system clock:
      --   F_SSI = F_Sys / (CPSDVSR * (1 + SCR))
      --   1e6   = 50e6  / (CPSDVSR * (1 + SCR))
      --   CPSDVSR * (1 + SCR) = 50
      --      let CPSDVSR = 2
      --   2       * (1 + SCR) = 50
      --      SCR = 24
      Clock_Prescale := SSI1.Clock_Prescale_Register;
      Clock_Prescale.Divisor := 16; -- XXX CPSDVSR
      SSI1.Clock_Prescale_Register := Clock_Prescale;

      Control_0 := SSI1.Control_Register_0;
      Control_0.Data_Size_Select := 16; -- XXX
      Control_0.Frame_Format_Select := SPI;
      Control_0.Serial_Clock_Polarity := Steady_High;
      Control_0.Serial_Clock_Phase := Second_Edge_Capture; -- XXX
      Control_0.Serial_Clock_Rate := 24; -- SCR
      SSI1.Control_Register_0 := Control_0;
   end Init_SSI;

   procedure Test_Gyroscope is
      use MCU.SSI;

      Control_1 : Control_Register_1_Record;
      Data : Data_Register_Record;
   begin
      -- Setup reading from L3G4200D register WHO_AM_I (16#0F#)
      -- FIXME Direct write is buggy?
      Data := Data_Register_Record'(Data => 2#1000_1111_0000_0000#, others => <>);
      SSI1.Data_Register := Data;
      -- SSI1.Data_Register := Data_Register_Record'(Data => 2#1100_1111_0000_0000#, others => <>);

      -- Enable SSI, it should start transmitting
      Control_1 := SSI1.Control_Register_1;
      Control_1.Port_Enable := True;
      SSI1.Control_Register_1 := Control_1;

      -- Wait till end of transaction
      while SSI1.Status_Register.Busy loop
         null;
      end loop;

      -- Disable SSI
      Control_1 := SSI1.Control_Register_1;
      Control_1.Port_Enable := False;
      SSI1.Control_Register_1 := Control_1;

      -- Get back the reply
      Data := SSI1.Data_Register;

      if (Data.Data and 16#00ff#) = 2#1101_0011# then
         Debug_IO.Put_Line ("Ok");
      else
         Debug_IO.Put_Line ("No!");
      end if;
   end Test_Gyroscope;

   type Phase is (Phase1, Phase2);
   Current_Phase : Phase;

   Delay_Value : constant := 1000000;
begin
   Init_System_Control;
   Switch_To_PLL;

   Init_SSI;
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
