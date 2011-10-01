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

-- This package contains debug output procedures that use OpenOCD's DCC
-- emulation for Cortex-M3.

pragma Restrictions (No_Elaboration_Code);

package DCC is
   pragma Preelaborate;

   procedure Put (Item : Character);

   procedure Put (Item : String);

   procedure Put_Line (Item : String);

   procedure New_Line;
end DCC;
