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

-- Test program that uses system tick module to blink LEDs.

with Real_Time;
with Indicators;
use type Real_Time.Time;

procedure SysTick_Test is
   type Clock_Phase is (Phase_1, Phase_2);

   Current_Phase : Clock_Phase := Phase_1;
   Wakeup_Time : Real_Time.Time := Real_Time.Clock;
begin
   Indicators.Set_States (Red => Indicators.Off, Green => Indicators.Off);

   loop
      Wakeup_Time := Wakeup_Time + 100;
      Real_Time.Sleep_Until (Wakeup_Time);

      case Current_Phase is
         when Phase_1 =>
            Current_Phase := Phase_2;
            Indicators.Set_States (Red => Indicators.On, Green => Indicators.Off);
         when Phase_2 =>
            Current_Phase := Phase_1;
            Indicators.Set_States (Red => Indicators.Off, Green => Indicators.On);
      end case;
   end loop;
end SysTick_Test;

pragma No_Return(SysTick_Test);
