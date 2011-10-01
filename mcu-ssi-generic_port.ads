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

-- This is a generic package that contains definitions of variables for
-- an SSI port.

pragma Restrictions (No_Elaboration_Code);
with System.Storage_Elements;

generic
   Base_Address : System.Storage_Elements.Integer_Address;
   Port_ID : SSI_Port;
package MCU.SSI.Generic_Port is
   pragma Preelaborate;

   use type System.Storage_Elements.Integer_Address;

   ID : constant SSI_Port := Port_ID;

   Control_Register_0 : Control_Register_0_Record;
   for Control_Register_0'Address use System'To_Address (Base_Address + Control_Register_0_Offset);
   pragma Atomic (Control_Register_0);
   pragma Import (Ada, Control_Register_0);

   Control_Register_1 : Control_Register_1_Record;
   for Control_Register_1'Address use System'To_Address (Base_Address + Control_Register_1_Offset);
   pragma Atomic (Control_Register_1);
   pragma Import (Ada, Control_Register_1);

   Data_Register : Data_Register_Record;
   for Data_Register'Address use System'To_Address (Base_Address + Data_Register_Offset);
   pragma Atomic (Data_Register);
   pragma Import (Ada, Data_Register);

   Status_Register : constant Status_Register_Record;
   for Status_Register'Address use System'To_Address (Base_Address + Status_Register_Offset);
   pragma Atomic (Status_Register);
   pragma Import (Ada, Status_Register);

   Clock_Prescale_Register : Clock_Prescale_Register_Record;
   for Clock_Prescale_Register'Address use System'To_Address (Base_Address + Clock_Prescale_Register_Offset);
   pragma Atomic (Clock_Prescale_Register);
   pragma Import (Ada, Clock_Prescale_Register);
end MCU.SSI.Generic_Port;
