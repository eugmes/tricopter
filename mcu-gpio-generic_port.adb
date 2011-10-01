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

with Ada.Unchecked_Conversion;

package body MCU.GPIO.Generic_Port is
   type Integer_Mask is mod 2**8;
   for Integer_Mask'Size use 8;

   function Mask_To_Integer is new Ada.Unchecked_Conversion (Data_Mask, Integer_Mask);

   procedure Set_Pins (States : Pin_States; Mask : Data_Mask) is
      Masked_Data_Register : Data_Register_Record;
      for Masked_Data_Register'Address use System'To_Address
         (Base_Address + Data_Register_Offset +
            System.Storage_Elements.Integer_Address (Mask_To_Integer (Mask)) * 4);
      pragma Atomic (Masked_Data_Register);
      pragma Import (Ada, Masked_Data_Register);

      Shadow_Data_Register : Data_Register_Record;
   begin
      Shadow_Data_Register := (Data => States, Reserved => 0);
      Masked_Data_Register := Shadow_Data_Register;
   end Set_Pins;

   function Get_Pins (Mask : Data_Mask) return Pin_States is
      Masked_Data_Register : Data_Register_Record;
      for Masked_Data_Register'Address use System'To_Address
         (Base_Address + Data_Register_Offset +
            System.Storage_Elements.Integer_Address (Mask_To_Integer (Mask)) * 4);
      pragma Atomic (Masked_Data_Register);
      pragma Import (Ada, Masked_Data_Register);

      Shadow_Data_Register : Data_Register_Record;
   begin
      Shadow_Data_Register := Masked_Data_Register;
      return Shadow_Data_Register.Data;
   end Get_Pins;

end MCU.GPIO.Generic_Port;
