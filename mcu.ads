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

-- Root package for LM3S3749 MCU support.

package MCU is
   pragma Pure;

   type UART_Port is (UART0, UART1, UART2);
   type SSI_Port is (SSI0, SSI1);
   type Timer is (Timer0, Timer1, Timer2, Timer3);
   type Comparator is (Comparator0, Comrarator1);
   type GPIO_Port is (Port_A, Port_B, Port_C, Port_D, Port_E, Port_F, Port_G, Port_H);
end MCU;
