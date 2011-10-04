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

-- This package contains various utilities for LM3S3749 MCU.

pragma Restrictions (No_Elaboration_Code);

package MCU.Utils is
   pragma Preelaborate;

   procedure Nop;
   pragma Inline_Always (Nop);

   procedure Wait_For_Interrupt;
   pragma Inline_Always (Wait_For_Interrupt);

   procedure Wait_For_Event;
   pragma Inline_Always (Wait_For_Event);

   procedure Mask_Interrupts;
   pragma Inline_Always (Mask_Interrupts);

   procedure Unmask_Interrupts;
   pragma Inline_Always (Unmask_Interrupts);
end MCU.Utils;
