with MCU.GPIO.Port_A;
with MCU.GPIO.Port_B;
with MCU.GPIO.Port_C;
with MCU.GPIO.Port_D;
with MCU.GPIO.Port_E;
with MCU.GPIO.Port_F;
with MCU.GPIO.Port_G;
with MCU.GPIO.Port_H;

package body Controller.GPIO is
   use MCU.GPIO;
begin
   -- TODO enable module clock

   -- Port A
   --
   -- 0   - U0RX, alternate, input, pull-down
   -- 1   - U0TX, alternate, output
   -- 2-5 - NC
   -- 6   - RX_AUX1, maybe alternate (CCP1), input, pull-down
   -- 7   - RX_AUX3, maybe alternate (CCP3), input, pull-down
   Port_A.Alternate_Function_Select_Register :=
      (Functions =>
         (0 .. 1 => Alternate_Function,
          6 .. 7 => GPIO_Mode, -- TODO change to alternate
          others => GPIO_Mode),
       others => <>);

   Port_A.Direction_Register :=
      (Directions =>
         (0 => Input,
          1 => Output,
          6 .. 7 => Input,
          others => Output),
       others => <>);

   -- no oppen drains

   -- no pull-ups

   Port_A.Pull_Down_Select_Register :=
      (Selections =>
         (0 => Enable_Pull_Down,
          6 .. 7 => Enable_Pull_Down,
          others => Disable_Pull_Down),
       others => <>);

   -- all drives 2 mA
   Port_A.Drive_Select_2mA_Register :=
      (Drive_Selects =>
         (0 .. 1 => Select_Drive,
          6 .. 7 => Select_Drive,
          others => No_Change),
       others => <>);

   -- TODO XXX set default values

   Port_A.Digital_Enable_Register :=
      (Digital_Functions =>
         (0 .. 1 => Enable_Digital_Function,
          6 .. 7 => Enable_Digital_Function,
          others => Disable_Digital_Function), -- TODO maybe enable and set to 0
       others => <>);

   Port_A.Set_Pins (States => (1 => Low, others => <>), Mask => (1 => Unmasked, others => Masked));

   -- Port B
   --
   -- 0   - GROUND - Stellaris LM3S3749 Rev A0 Errata 12.3
   -- 1   - +5V - see above
   -- 2   - I2C0SCL, alternate, open-drain, output
   -- 3   - I2C0SDA, alternate, open-drain, input/output
   -- 4   - GYRO_DRDY, GPIO, input, pull-something, maybe interrupt FIXME
   -- 5   - GYRO_INT, GPIO, input, pull-something, maybe interrupt FIXME
   -- 6-7 - NC

   -- TODO

   -- Port C
   --
   -- 0-3 - JTAG, alternate, preconfigured
   -- 4-7 - NC

   -- TODO

   -- Port D
   --
   -- 0-2 - NC
   -- 3   - RX_PPM, alternate (CCP0), input, pull-down
   -- 4-5 - NC
   -- 6   - LED2, GPIO, output, 8-mA, slew rate control, default high
   -- 7   - LED1, GPIO, output, 8-mA, slew rate control, default high

   -- TODO

   -- Port E
   --
   -- 0   - GYRO_SPC, alternate (SSI1CLK), output
   -- 1   - GYRO_CS, alternate (SSI1FSS), output
   -- 2   - GYRO_SDO, alternate (SSI1RX), input, pull-up
   -- 3   - GYRO_SDI, alternate (SSI1TX), output
   -- 4-6 - ADC3-1, analog, optional
   -- 7   - ADC1, analog, optional

   -- TODO

   -- Port F
   --
   -- 1-3 - PWM[0145], alternate, output, default low
   -- 4   - NC
   -- 5   - RX_AUX2, maybe alternate (CCP2), input, pull-down
   -- 6-7 - NC

   -- TODO

   -- Port G
   --
   -- 0-5 - NC
   -- 6-7 - PWM6-7, alternate, output, default low

   -- TODO

   -- Port H
   --
   -- 0-1 - PWM2-3, alternate, output, default low
   -- 2-3 - NC
   -- 4   - VBUS, GPIO, input, pull-down, maybe interrupt

   -- TODO
end Controller.GPIO;
