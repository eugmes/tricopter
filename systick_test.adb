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

with MCU.Core.System_Tick.Registers;
with Indicators;

procedure SysTick_Test is
   use MCU.Core.System_Tick;

   type Clock_Phase is (Phase_1, Phase_2);
   Current_Phase : Clock_Phase := Phase_1;

   Tick_Count : Integer := 0;

   Value_Register_Shadow : Value_Register_Record;
   Control_And_Status_Register_Shadow : Control_And_Status_Register_Record;
begin
   Indicators.Set_States (Red => Indicators.Off, Green => Indicators.Off);

   -- Initialize the system timer with period 100 Hz with system clock 50 MHz
   Value_Register_Shadow := (Value => 50E+4, Reserved => 0);
   Registers.Reload_Value_Register := Value_Register_Shadow;

   Control_And_Status_Register_Shadow := Registers.Control_And_Status_Register;
   Control_And_Status_Register_Shadow.Enable := True;
   Control_And_Status_Register_Shadow.Interrupt_Enable := False;
   Control_And_Status_Register_Shadow.Clock_Source := System_Clock;
   Registers.Control_And_Status_Register := Control_And_Status_Register_Shadow;

   loop
      loop
         Control_And_Status_Register_Shadow := Registers.Control_And_Status_Register;
         exit when Control_And_Status_Register_Shadow.Count_Flag = Counted_Till_0;
      end loop;

      Tick_Count := Tick_Count + 1;

      if Tick_Count = 100 then
         case Current_Phase is
            when Phase_1 =>
               Current_Phase := Phase_2;
               Indicators.Set_States (Red => Indicators.On, Green => Indicators.Off);
            when Phase_2 =>
               Current_Phase := Phase_1;
               Indicators.Set_States (Red => Indicators.Off, Green => Indicators.On);
         end case;

         Tick_Count := 0;
      end if;
   end loop;
end SysTick_Test;

pragma No_Return(SysTick_Test);
