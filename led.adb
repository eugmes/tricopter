with MCU.GPIO.Port_D;
with System_Initialization;
pragma Elaborate_All (System_Initialization);

package body LED is
   package GPIO_Port renames MCU.GPIO.Port_D;

   Green_LED : constant MCU.GPIO.Pin_Number := 6;
   Red_LED   : constant MCU.GPIO.Pin_Number := 7;

   function LED_To_Pin (Item : State) return MCU.GPIO.Pin_State is
   begin
      case Item is
         when Off => return MCU.GPIO.High;
         when On => return MCU.GPIO.Low;
      end case;
   end LED_To_Pin;

   procedure Set_States (Green : State; Red : State) is
      Mask : constant MCU.GPIO.Data_Mask :=
         (Green_LED | Red_LED => MCU.GPIO.Unmasked,
          others => MCU.GPIO.Masked);

      Green_Pin : constant MCU.GPIO.Pin_State := LED_To_Pin (Green);
      Red_Pin   : constant MCU.GPIO.Pin_State := LED_To_Pin (Red);
   begin
      GPIO_Port.Set_Pins
         (States => (Green_LED => Green_Pin, Red_LED => Red_Pin, others => MCU.GPIO.Low),
          Mask => Mask);
   end Set_States;

   procedure Init_GPIO is
      use MCU.GPIO;

      Direction_Register : Direction_Register_Record;
      Alternate_Function_Select_Register : Alternate_Function_Select_Register_Record;
      Drive_Select_Register : Drive_Select_Register_Record;
      Open_Drain_Select_Register : Open_Drain_Select_Register_Record;
      Slew_Rate_Control_Register : Slew_Rate_Control_Register_Record;
      Digital_Enable_Register : Digital_Enable_Register_Record;
   begin
      Direction_Register := GPIO_Port.Direction_Register;
      Direction_Register.Directions (Green_LED) := Output;
      Direction_Register.Directions (Red_LED) := Output;
      GPIO_Port.Direction_Register := Direction_Register;

      Alternate_Function_Select_Register := GPIO_Port.Alternate_Function_Select_Register;
      Alternate_Function_Select_Register.Functions (Green_LED) := GPIO_Mode;
      Alternate_Function_Select_Register.Functions (Red_LED) := GPIO_Mode;
      GPIO_Port.Alternate_Function_Select_Register := Alternate_Function_Select_Register;

      Drive_Select_Register := GPIO_Port.Drive_Select_8mA_Register;
      Drive_Select_Register.Drive_Selects (Green_LED) := Select_Drive;
      Drive_Select_Register.Drive_Selects (Red_LED) := Select_Drive;
      GPIO_Port.Drive_Select_8mA_Register := Drive_Select_Register;

      Set_States (Green => Off, Red => Off);

      Open_Drain_Select_Register := GPIO_Port.Open_Drain_Select_Register;
      Open_Drain_Select_Register.Selections (Green_LED) := Enable_Open_Drain;
      Open_Drain_Select_Register.Selections (Red_LED) := Enable_Open_Drain;
      GPIO_Port.Open_Drain_Select_Register := Open_Drain_Select_Register;

      Slew_Rate_Control_Register := GPIO_Port.Slew_Rate_Control_Register;
      Slew_Rate_Control_Register.Controls (Green_LED) := Enable_Slew_Rate_Control;
      Slew_Rate_Control_Register.Controls (Red_LED) := Enable_Slew_Rate_Control;
      GPIO_Port.Slew_Rate_Control_Register := Slew_Rate_Control_Register;

      Digital_Enable_Register := GPIO_Port.Digital_Enable_Register;
      Digital_Enable_Register.Digital_Functions (Green_LED) := Enable_Digital_Function;
      Digital_Enable_Register.Digital_Functions (Red_LED) := Enable_Digital_Function;
      GPIO_Port.Digital_Enable_Register := Digital_Enable_Register;
   end Init_GPIO;

begin
   Init_GPIO;
end LED;
