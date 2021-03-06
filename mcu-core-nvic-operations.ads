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

-- This package contains various routines for accessing the interrupt
-- controller.

pragma Restrictions (No_Elaboration_Code);

package MCU.Core.NVIC.Operations is
   pragma Preelaborate;

   procedure Enable_Interrupt (Item : Interrupt);

   procedure Disable_Interrupt (Item : Interrupt);

   procedure Pend_Interrupt (Item : Interrupt);

   procedure Unpend_Interrupt (Item : Interrupt);

   function Is_Interrupt_Active (Item : Interrupt) return Boolean;

   procedure Set_Interrupt_Priority (Item : Interrupt; Priority : Interrupt_Priority);

   function Get_Interrupt_Priority (Item : Interrupt) return Interrupt_Priority;

   -- procedure Trigger_Interrupt (Item : Interrupt);

end MCU.Core.NVIC.Operations;
