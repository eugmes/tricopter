with Debug_IO;
with Ada.Characters.Latin_1;
with Gyroscope;
with LED;

use type Gyroscope.Raw_Angular_Rate;

procedure LED_Demo is
   package L1 renames Ada.Characters.Latin_1;

   procedure Test_Gyroscope is
      Gyro_Ok : Boolean;
   begin
      Gyroscope.Check_Who_Am_I (Gyro_Ok);

      if Gyro_Ok then
         Debug_IO.Put ("Ok" & L1.LF);
      else
         Debug_IO.Put ("No!" & L1.LF);
      end if;
   end Test_Gyroscope;

   X_Rate, Y_Rate, Z_Rate : Gyroscope.Raw_Angular_Rate;
   Threshold : constant Gyroscope.Raw_Angular_Rate := 1000;
begin
   Test_Gyroscope;

   loop
      Gyroscope.Read_Sensor_Data (X_Rate, Y_Rate, Z_Rate);

      if Z_Rate > Threshold then
         LED.Set_States (Green => LED.Off, Red => LED.On);
      elsif Z_Rate < -Threshold then
         LED.Set_States (Green => LED.On, Red => LED.Off);
      else
         LED.Set_States (Green => LED.Off, Red => LED.Off);
      end if;
   end loop;
end LED_Demo;

pragma No_Return (LED_Demo);
