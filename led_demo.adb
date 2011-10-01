---------------------------------------------------------------------------
--      Copyright © 2011 Євгеній Мещеряков <eugen@debian.org>            --
--                                                                       --
-- This program is free software: you can redistribute it and/or modify  --
-- it under the terms of the GNU General Public License as published by  --
-- the Free Software Foundation, either version 3 of the License, or     --
-- (at your option) any later version.                                   --
--                                                                       --
-- This program is distributed in the hope that it will be useful,       --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of        --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         --
-- GNU General Public License for more details.                          --
--                                                                       --
-- You should have received a copy of the GNU General Public License     --
-- along with this program.  If not, see <http://www.gnu.org/licenses/>. --
---------------------------------------------------------------------------

-- This is a simple program that turns on LEDs if board turns around Z axis.

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
