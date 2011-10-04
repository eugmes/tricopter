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

pragma Restrictions (No_Elaboration_Code);
with System.Machine_Code;
use System.Machine_Code;

package body MCU.Utils is
   procedure Nop is
   begin
      Asm ("nop", Volatile => True);
   end Nop;

   procedure Wait_For_Interrupt is
   begin
      Asm ("wfi", Volatile => True);
   end Wait_For_Interrupt;

   procedure Wait_For_Event is
   begin
      Asm ("wfe", Volatile => True);
   end Wait_For_Event;

   procedure Mask_Interrupts is
   begin
      Asm ("cpsid i", Volatile => True);
   end Mask_Interrupts;

   procedure Unmask_Interrupts is
   begin
      Asm ("cpsie i", Volatile => True);
   end Unmask_Interrupts;
end MCU.Utils;
