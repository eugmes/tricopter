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

-- This package contains variables for accessing system clock registers.

with System.Storage_Elements;
use type System.Storage_Elements.Integer_Address;

package MCU.Core.System_Tick.Registers is
   pragma Preelaborate;

   Control_And_Status_Register : Control_And_Status_Register_Record;
   for Control_And_Status_Register'Address use System'To_Address (Core_Peripherals_Base + Control_And_Status_Register_Offset);
   pragma Atomic (Control_And_Status_Register);
   pragma Import (Ada, Control_And_Status_Register);

   Reload_Value_Register : Value_Register_Record;
   for Reload_Value_Register'Address use System'To_Address (Core_Peripherals_Base + Reload_Value_Register_Offset);
   pragma Atomic (Reload_Value_Register);
   pragma Import (Ada, Reload_Value_Register);

   Current_Value_Register : Value_Register_Record;
   for Current_Value_Register'Address use System'To_Address (Core_Peripherals_Base + Current_Value_Register_Offset);
   pragma Atomic (Current_Value_Register);
   pragma Import (Ada, Current_Value_Register);
end MCU.Core.System_Tick.Registers;
