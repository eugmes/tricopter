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

with System;
with Interfaces;
with Ada.Characters.Latin_1;
use type Interfaces.Unsigned_32;

package body DCC is
   type Byte is mod 256;

   type Reserved_7 is mod 2**7;

   type Debug_Register_Record is
      record
         Busy : Boolean;
         Reserved : Reserved_7 := 0;
         Target_Write_Buffer : Byte;
      end record;

   for Debug_Register_Record use
      record
         Busy at 0 range 0 .. 0;
         Reserved at 0 range 1 .. 7;
         Target_Write_Buffer at 0 range 8 .. 15;
      end record;

   for Debug_Register_Record'Size use 16;
   for Debug_Register_Record'Alignment use 2;

   Debug_Register : Debug_Register_Record;
   for Debug_Register'Address use System'To_Address (16#E000_EDF8#);
   pragma Atomic (Debug_Register);
   pragma Import (Ada, Debug_Register);

   procedure Send_Command (Item : Interfaces.Unsigned_32) is
      use Interfaces;

      W : Unsigned_32;
      B : Byte;
      Debug : Debug_Register_Record;
   begin
      W := Item;

      for I in 1 .. 4 loop
         loop
            Debug := Debug_Register;
            exit when not Debug.Busy;
         end loop;
         B := Byte (W and 16#ff#);
         Debug_Register := (Busy => True, Target_Write_Buffer => B, Reserved => 0);
         W := Shift_Right (W, 8);
      end loop;
   end Send_Command;

   procedure Put (Item : Character) is
   begin
      Send_Command (Character'Pos (Item));
   end Put;

   procedure Put (Item : String) is
   begin
      for I in Item'Range loop
         Put (Item (I));
      end loop;
   end Put;

   procedure Put_Line (Item : String) is
   begin
      Put (Item);
      New_Line;
   end Put_Line;

   procedure New_Line is
   begin
      Put (Ada.Characters.Latin_1.LF);
   end New_Line;
end DCC;
