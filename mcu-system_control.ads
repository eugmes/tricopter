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

   -----------------------------
   -- Types for reserved bits --
   -----------------------------
   type Reserved_1 is mod 2**1;
   type Reserved_4 is mod 2**4;
   type Reserved_23 is mod 2**23;
   type Reserved_26 is mod 2**26;
   type Reserved_30 is mod 2**30;

   --------------------------------------
   -- Brown out reset control register --
   --------------------------------------
   type Brown_Out_Reset_Control_Register_Record is
      record
         Reserved : Reserved_1 := 0;
         Action : Brown_Out_Action;
         Reserved1 : Reserved_30 := 0;
      end record;

   for Brown_Out_Reset_Control_Register_Record use
      record
         Reserved at 0 range 0 .. 0;
         Action at 0 range 1 .. 1;
         Reserved1 at 0 range 2 .. 31;
      end record;

   for Brown_Out_Reset_Control_Register_Record'Size use 32;
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
   for LDO_Power_Control_Register_Record'Bit_Order use System.Low_Order_First;

   -----------------------------------
   -- Raw interrupt status register --
   -----------------------------------
   type Raw_Interrupt_Status_Register_Record is
      record
         Reserved : Reserved_1 := 0;
         Brown_Out_Reset : Interrupt_Status;
         Reserved1 : Reserved_4 := 0;
         PLL_Lock : Interrupt_Status;
         USB_PLL_Lock : Interrupt_Status;
         Main_Oscillator_Power_Up : Interrupt_Status;
         Reserved2 : Reserved_23 := 0;
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
   for Raw_Interrupt_Status_Register_Record'Bit_Order use System.Low_Order_First;
end MCU.System_Control;
