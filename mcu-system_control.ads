pragma Restrictions (No_Elaboration_Code);
with System.Storage_Elements;

package MCU.System_Control is
   pragma Preelaborate;

   --------------------
   -- Base addresses --
   --------------------
   Register_File_Base_Address : constant System.Storage_Elements.Integer_Address := 16#400F_E000#;

   ----------------------
   -- Register offsets --
   ----------------------
   Brown_Out_Reset_Control_Register_Offset           : constant := 16#030#;
   LDO_Power_Control_Register_Offset                 : constant := 16#034#;
   Software_Reset_Control_Register_0_Offset          : constant := 16#040#;
   Software_Reset_Control_Register_1_Offset          : constant := 16#044#;
   Software_Reset_Control_Register_2_Offset          : constant := 16#048#;
   Raw_Interrupt_Status_Register_Offset              : constant := 16#050#;
   Interrupt_Mask_Control_Register_Offset            : constant := 16#054#;
   Masked_Interrupt_Status_And_Clear_Register_Offset : constant := 16#058#;
   Reset_Cause_Register_Offset                       : constant := 16#05C#;
   Run_Mode_Clock_Configuration_Register_Offset      : constant := 16#060#;
   XTAL_To_PLL_Translation_Register_Offset           : constant := 16#064#;
   GPIO_High_Performance_Bus_Control_Register_Offset : constant := 16#06C#;
   Run_Mode_Clock_Configuration_Register_2_Offset    : constant := 16#070#;
   Main_Oscillator_Control_Register_Offset           : constant := 16#07C#;
   Run_Mode_Clock_Gating_Control_Register_0_Offset   : constant := 16#100#;
   Run_Mode_Clock_Gating_Control_Register_1_Offset   : constant := 16#104#;
   Run_Mode_Clock_Gating_Control_Register_2_Offset   : constant := 16#108#;
   Sleep_Mode_Clock_Gating_Control_Register_0_Offset : constant := 16#110#;
   Sleep_Mode_Clock_Gating_Control_Register_1_Offset : constant := 16#114#;
   Sleep_Mode_Clock_Gating_Control_Register_2_Offset : constant := 16#118#;
   Deep_Sleep_Mode_Clock_Gating_Control_Register_0_Offset : constant := 16#120#;
   Deep_Sleep_Mode_Clock_Gating_Control_Register_1_Offset : constant := 16#124#;
   Deep_Sleep_Mode_Clock_Gating_Control_Register_2_Offset : constant := 16#128#;
   Deep_Sleep_Clock_Configuration_Register_Offset    : constant := 16#144#;

   ----------------------
   -- Type definitions --
   ----------------------
   type Brown_Out_Action is (Interrupt, Reset);
   for Brown_Out_Action use (Interrupt => 0, Reset => 1);

   type LDO_Voltage_Adjustment is mod 2**5;
   LDO_Voltage_250 : constant LDO_Voltage_Adjustment := 16#00#;
   LDO_Voltage_245 : constant LDO_Voltage_Adjustment := 16#01#;
   LDO_Voltage_240 : constant LDO_Voltage_Adjustment := 16#02#;
   LDO_Voltage_235 : constant LDO_Voltage_Adjustment := 16#03#;
   LDO_Voltage_230 : constant LDO_Voltage_Adjustment := 16#04#;
   LDO_Voltage_225 : constant LDO_Voltage_Adjustment := 16#05#;

   LDO_Voltage_275 : constant LDO_Voltage_Adjustment := 16#1B#;
   LDO_Voltage_270 : constant LDO_Voltage_Adjustment := 16#1C#;
   LDO_Voltage_265 : constant LDO_Voltage_Adjustment := 16#1D#;
   LDO_Voltage_260 : constant LDO_Voltage_Adjustment := 16#1E#;
   LDO_Voltage_255 : constant LDO_Voltage_Adjustment := 16#1F#;

   type Interrupt_Status is (Not_Active, Active);
   for Interrupt_Status use (Not_Active => 0, Active => 1); -- FIXME move to common package

   type Oscillator is (Main_Oscillator, Internal_Oscillator, Internal_Oscilator_Div_4, Internal_30_kHZ_Oscillator);
   for Oscillator use
      (Main_Oscillator => 0,
       Internal_Oscillator => 1,
       Internal_Oscilator_Div_4 => 2,
       Internal_30_kHZ_Oscillator => 3);

   type Crystal_Frequency is range 0 .. 2**5 - 1;
   Crystal_Frequency_10_MHz : constant Crystal_Frequency := 16#10#;
   -- TODO other frequencies

   type PWM_Divisor is (Div_2, Div_4, Div_8, Div_16, Div_32, Div_64, Div_64_1, Div_64_2);
   for PWM_Divisor use
      (Div_2 => 0,
       Div_4 => 1,
       Div_8 => 2,
       Div_16 => 3,
       Div_32 => 4,
       Div_64 => 5,
       Div_64_1 => 6,
       Div_64_2 => 7);

   type Bypass is new Boolean; -- TODO FIXME XXX

   type Clock_Divisor is range 1 .. 16;
   pragma Warnings (Off, Clock_Divisor);
   for Clock_Divisor'Size use 4; -- should be biased
   pragma Warnings (On, Clock_Divisor);

   type GPIO_Bus_Kind is (APB, AHB);
   for GPIO_Bus_Kind use (APB => 0, AHB => 1);

   type GPIO_Bus_Kinds is array (GPIO_Port) of GPIO_Bus_Kind;
   for GPIO_Bus_Kinds'Component_Size use 1;

   type Clock_Gating is (Clock_Disabled, Clock_Enabled);
   for Clock_Gating use (Clock_Disabled => 0, Clock_Enabled => 1);

   type UART_Clock_Gating is array (UART_Port) of Clock_Gating;
   for UART_Clock_Gating'Component_Size use 1;

   type SSI_Clock_Gating is array (SSI_Port) of Clock_Gating;
   for SSI_Clock_Gating'Component_Size use 1;

   type Timers_Clock_Gating is array (Timer) of Clock_Gating;
   for Timers_Clock_Gating'Component_Size use 1;

   type Comparators_Clock_Gating is array (Comparator) of Clock_Gating;
   for Comparators_Clock_Gating'Component_Size use 1;

   type GPIO_Clock_Gating is array (GPIO_Port) of Clock_Gating;
   for GPIO_Clock_Gating'Component_Size use 1;

   -----------------------------
   -- Types for reserved bits --
   -----------------------------
   type Reserved_1 is mod 2**1;
   type Reserved_2 is mod 2**2;
   type Reserved_3 is mod 2**3;
   type Reserved_4 is mod 2**4;
   type Reserved_5 is mod 2**5;
   type Reserved_11 is mod 2**11;
   type Reserved_15 is mod 2**15;
   type Reserved_23 is mod 2**23;
   type Reserved_24 is mod 2**24;
   type Reserved_26 is mod 2**26;
   type Reserved_30 is mod 2**30;

   --------------------------------------
   -- Brown out reset control register --
   --------------------------------------
   type Brown_Out_Reset_Control_Register_Record is
      record
         Reserved : Reserved_1;
         Action : Brown_Out_Action;
         Reserved1 : Reserved_30;
      end record;

   for Brown_Out_Reset_Control_Register_Record use
      record
         Reserved at 0 range 0 .. 0;
         Action at 0 range 1 .. 1;
         Reserved1 at 0 range 2 .. 31;
      end record;

   for Brown_Out_Reset_Control_Register_Record'Size use 32;
   for Brown_Out_Reset_Control_Register_Record'Alignment use 4;
   for Brown_Out_Reset_Control_Register_Record'Bit_Order use System.Low_Order_First;

   --------------------------------
   -- LDO power control register --
   --------------------------------
   type LDO_Power_Control_Register_Record is
      record
         Voltage_Adjustment : LDO_Voltage_Adjustment;
         Reserved : Reserved_26;
      end record;

   for LDO_Power_Control_Register_Record use
      record
         Voltage_Adjustment at 0 range 0 .. 5;
         Reserved at 0 range 6 .. 31;
      end record;

   for LDO_Power_Control_Register_Record'Size use 32;
   for LDO_Power_Control_Register_Record'Alignment use 4;
   for LDO_Power_Control_Register_Record'Bit_Order use System.Low_Order_First;

   -----------------------------------
   -- Raw interrupt status register --
   -----------------------------------
   type Raw_Interrupt_Status_Register_Record is
      record
         Reserved : Reserved_1;
         Brown_Out_Reset : Interrupt_Status;
         Reserved1 : Reserved_4;
         PLL_Lock : Interrupt_Status;
         USB_PLL_Lock : Interrupt_Status;
         Main_Oscillator_Power_Up : Interrupt_Status;
         Reserved2 : Reserved_23;
      end record;

   for Raw_Interrupt_Status_Register_Record use
      record
         Reserved at 0 range 0 .. 0;
         Brown_Out_Reset at 0 range 1 .. 1;
         Reserved1 at 0 range 2 .. 5;
         PLL_Lock at 0 range 6 .. 6;
         USB_PLL_Lock at 0 range 7 .. 7;
         Main_Oscillator_Power_Up at 0 range 8 .. 8;
         Reserved2 at 0 range 9 .. 31;
      end record;

   for Raw_Interrupt_Status_Register_Record'Size use 32;
   for Raw_Interrupt_Status_Register_Record'Alignment use 4;
   for Raw_Interrupt_Status_Register_Record'Bit_Order use System.Low_Order_First;

   --------------------------
   -- Reset cause register --
   --------------------------
   type Reset_Cause_Register_Record is
      record
         External_Reset : Boolean;
         Power_On_Reset : Boolean;
         Brown_Out_Reset : Boolean;
         Watchdog_Timer_Reset : Boolean;
         Software_Reset : Boolean;
         Reserved : Reserved_11;
         Main_Oscillator_Failure_Reset : Boolean;
         Reserved1 : Reserved_15;
      end record;

   for Reset_Cause_Register_Record use
      record
         External_Reset at 0 range 0 .. 0;
         Power_On_Reset at 0 range 1 .. 1;
         Brown_Out_Reset at 0 range 2 .. 2;
         Watchdog_Timer_Reset at 0 range 3 .. 3;
         Software_Reset at 0 range 4 .. 4;
         Reserved at 0 range 5 .. 15;
         Main_Oscillator_Failure_Reset at 0 range 16 .. 16;
         Reserved1 at 0 range 17 .. 31;
      end record;

   for Reset_Cause_Register_Record'Size use 32;
   for Reset_Cause_Register_Record'Alignment use 4;
   for Reset_Cause_Register_Record'Bit_Order use System.Low_Order_First;

   -------------------------------------------
   -- Run-mode clock configuration register --
   -------------------------------------------
   type Run_Mode_Clock_Configuration_Register_Record is
      record
         Main_Oscillator_Disable : Boolean;
         Internal_Oscillator_Disable : Boolean;
         Reserved : Reserved_2;
         Oscillator_Source : Oscillator;
         Crystal_Value : Crystal_Frequency;
         PLL_Bypass : Bypass;
         Reserved1 : Reserved_1;
         PLL_Power_Down : Boolean; -- FIXME XXX TODO
         Reserved2 : Reserved_3;
         PWM_Clock_Divisor : PWM_Divisor;
         Enable_PWM_Clock_Divisor : Boolean;
         Reserved3 : Reserved_1;
         Enable_System_Clock_Divider : Boolean;
         System_Clock_Divisor : Clock_Divisor;
         Auto_Clock_Gating : Boolean;
         Reserved4 : Reserved_4;
      end record;

   for Run_Mode_Clock_Configuration_Register_Record use
      record
         Main_Oscillator_Disable at 0 range 0 .. 0;
         Internal_Oscillator_Disable at 0 range 1 .. 1;
         Reserved at 0 range 2 .. 3;
         Oscillator_Source at 0 range 4 .. 5;
         Crystal_Value at 0 range 6 .. 10;
         PLL_Bypass at 0 range 11 .. 11;
         Reserved1 at 0 range 12 .. 12;
         PLL_Power_Down at 0 range 13 .. 13;
         Reserved2 at 0 range 14 .. 16;
         PWM_Clock_Divisor at 0 range 17 .. 19;
         Enable_PWM_Clock_Divisor at 0 range 20 .. 20;
         Reserved3 at 0 range 21 .. 21;
         Enable_System_Clock_Divider at 0 range 22 .. 22;
         System_Clock_Divisor at 0 range 23 .. 26;
         Auto_Clock_Gating at 0 range 27 .. 27;
         Reserved4 at 0 range 28 .. 31;
      end record;

   for Run_Mode_Clock_Configuration_Register_Record'Size use 32;
   for Run_Mode_Clock_Configuration_Register_Record'Alignment use 4;
   for Run_Mode_Clock_Configuration_Register_Record'Bit_Order use System.Low_Order_First;

   -------------------------------
   -- Crystal to PLL transition --
   -------------------------------
   -- TODO

   ---------------------------------------
   -- GPIO high-performance bus control --
   ---------------------------------------
   type GPIO_High_Performance_Bus_Control_Register_Record is
      record
         Controls : GPIO_Bus_Kinds;
         Reserved : Reserved_24;
      end record;

   for GPIO_High_Performance_Bus_Control_Register_Record use
      record
         Controls at 0 range 0 .. 7;
         Reserved at 0 range 8 .. 31;
      end record;

   for GPIO_High_Performance_Bus_Control_Register_Record'Size use 32;
   for GPIO_High_Performance_Bus_Control_Register_Record'Alignment use 4;
   for GPIO_High_Performance_Bus_Control_Register_Record'Bit_Order use System.Low_Order_First;

   -------------------------------------
   -- Run-mode clock configuratiuon 2 --
   -------------------------------------
   -- TODO

   -----------------------------
   -- Main osicllator control --
   -----------------------------
   -- TODO

   ------------------------------------
   -- Deep sleep clock configuration --
   ------------------------------------
   -- TODO

   -------------------------------------
   -- Clock gating control register 0 --
   -------------------------------------
   -- TODO + deep sleep

   -------------------------------------
   -- Clock gating control register 1 --
   -------------------------------------
   type Clock_Gating_Control_Register_1_Record is
      record
         UART : UART_Clock_Gating;
         Reserved : Reserved_1;
         SSI : SSI_Clock_Gating;
         Reserved1 : Reserved_2;
         QEI0 : Clock_Gating;
         Reserved2 : Reserved_3;
         I2C0 : Clock_Gating;
         Reserved3 : Reserved_1;
         I2C1 : Clock_Gating;
         Reserved4 : Reserved_1;
         Timers : Timers_Clock_Gating;
         Reserved5 : Reserved_4;
         Comparators : Comparators_Clock_Gating;
         Reserved6 : Reserved_5;
      end record;

   for Clock_Gating_Control_Register_1_Record use
      record
         UART at 0 range 0 .. 2;
         Reserved at 0 range 3 .. 3;
         SSI at 0 range 4 .. 5;
         Reserved1 at 0 range 6 .. 7;
         QEI0 at 0 range 8 .. 8;
         Reserved2 at 0 range 9 .. 11;
         I2C0 at 0 range 12 .. 12;
         Reserved3 at 0 range 13 .. 13;
         I2C1 at 0 range 14 .. 14;
         Reserved4 at 0 range 15 .. 15;
         Timers at 0 range 16 .. 19;
         Reserved5 at 0 range 20 .. 23;
         Comparators at 0 range 24 .. 25;
         Reserved6 at 0 range 26 .. 31;
      end record;

   for Clock_Gating_Control_Register_1_Record'Size use 32;
   for Clock_Gating_Control_Register_1_Record'Alignment use 4;
   for Clock_Gating_Control_Register_1_Record'Bit_Order use System.Low_Order_First;

   -------------------------------------
   -- Clock gating control register 2 --
   -------------------------------------
   type Clock_Gating_Control_Register_2_Record is
      record
         GPIO : GPIO_Clock_Gating;
         Reserved : Reserved_5;
         UDMA : Clock_Gating;
         Reserved1 : Reserved_2;
         USB0 : Clock_Gating;
         Reserved2 : Reserved_15;
      end record;

   for Clock_Gating_Control_Register_2_Record use
      record
         GPIO at 0 range 0 .. 7;
         Reserved at 0 range 8 .. 12;
         UDMA at 0 range 13 .. 13;
         Reserved1 at 0 range 14 .. 15;
         USB0 at 0 range 16 .. 16;
         Reserved2 at 0 range 17 .. 31;
      end record;

   for Clock_Gating_Control_Register_2_Record'Size use 32;
   for Clock_Gating_Control_Register_2_Record'Alignment use 4;
   for Clock_Gating_Control_Register_2_Record'Bit_Order use System.Low_Order_First;
end MCU.System_Control;
