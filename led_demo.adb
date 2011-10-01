with Gyroscope;
with LED;

use type Gyroscope.Raw_Angular_Rate;

procedure LED_Demo is
   X_Rate, Y_Rate, Z_Rate : Gyroscope.Raw_Angular_Rate;
   Threshold : constant Gyroscope.Raw_Angular_Rate := 1000;
begin
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
