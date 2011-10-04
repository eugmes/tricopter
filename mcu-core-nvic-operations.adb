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

with System.Storage_Elements;
with Interfaces;
with Ada.Unchecked_Conversion;
use type System.Storage_Elements.Integer_Address;
use type Interfaces.Unsigned_8;

package body MCU.Core.NVIC.Operations is
   package SSE renames System.Storage_Elements;

   subtype Byte is Interfaces.Unsigned_8;

   function Priority_To_Byte is new Ada.Unchecked_Conversion (Interrupt_Priority_Byte, Byte);
   function Byte_To_Priority is new Ada.Unchecked_Conversion (Byte, Interrupt_Priority_Byte);

   function Interrupt_Byte_Offset (Item : Interrupt) return SSE.Integer_Address is
   begin
      return SSE.Integer_Address (Item) / 8;
   end Interrupt_Byte_Offset;
   pragma Inline (Interrupt_Byte_Offset);

   function Interrupt_Bit_Mask (Item : Interrupt) return Byte is
   begin
      return Interfaces.Shift_Left (1, Integer (Item) mod 8);
   end Interrupt_Bit_Mask;
   pragma Inline (Interrupt_Bit_Mask);

   procedure Write_Register (Value : Byte; Offset : SSE.Integer_Address) is
      Register : Byte;
      for Register'Address use System'To_Address (Core_Peripherals_Base + Offset);
      pragma Atomic (Register);
      pragma Import (Ada, Register);
   begin
      Register := Value;
   end Write_Register;
   pragma Inline (Write_Register);

   procedure Set_Interrupt_Bit (Item : Interrupt; Block_Offset : SSE.Integer_Address) is
   begin
      Write_Register (Interrupt_Bit_Mask (Item), Block_Offset + Interrupt_Byte_Offset (Item));
   end Set_Interrupt_Bit;
   pragma Inline (Set_Interrupt_Bit);

   function Read_Register (Offset : SSE.Integer_Address) return Byte is
      Register : Byte;
      for Register'Address use System'To_Address (Core_Peripherals_Base + Offset);
      pragma Atomic (Register);
      pragma Import (Ada, Register);
   begin
      return Register;
   end Read_Register;
   pragma Inline (Read_Register);

   function Get_Interrupt_Bit (Item : Interrupt; Block_Offset : SSE.Integer_Address) return Boolean is
      Tmp : Byte;
   begin
      Tmp := Read_Register (Block_Offset + Interrupt_Byte_Offset (Item));
      return (Tmp and Interrupt_Bit_Mask (Item)) = 0;
   end Get_Interrupt_Bit;
   pragma Inline (Get_Interrupt_Bit);

   ----------------------
   -- Enable_Interrupt --
   ----------------------

   procedure Enable_Interrupt (Item : Interrupt) is
   begin
      Set_Interrupt_Bit (Item, Interrupt_Enable_Block_Offset);
   end Enable_Interrupt;

   -----------------------
   -- Disable_Interrupt --
   -----------------------

   procedure Disable_Interrupt (Item : Interrupt) is
   begin
      Set_Interrupt_Bit (Item, Interrupt_Disable_Block_Offset);
   end Disable_Interrupt;

   --------------------
   -- Pend_Interrupt --
   --------------------

   procedure Pend_Interrupt (Item : Interrupt) is
   begin
      Set_Interrupt_Bit (Item, Interrupt_Set_Pending_Block_Offset);
   end Pend_Interrupt;

   ----------------------
   -- Unpend_Interrupt --
   ----------------------

   procedure Unpend_Interrupt (Item : Interrupt) is
   begin
      Set_Interrupt_Bit (Item, Interrupt_Clear_Pending_Block_Offset);
   end Unpend_Interrupt;

   -------------------------
   -- Is_Interrupt_Active --
   -------------------------

   function Is_Interrupt_Active (Item : Interrupt) return Boolean is
   begin
      return Get_Interrupt_Bit (Item, Interrupt_Active_Block_Offset);
   end Is_Interrupt_Active;

   ----------------------------
   -- Set_Interrupt_Priority --
   ----------------------------

   procedure Set_Interrupt_Priority (Item : Interrupt; Priority : Interrupt_Priority) is
      Tmp : Byte;
   begin
      Tmp := Priority_To_Byte ((Reserved => 0, Priority => Priority));
      Write_Register (Tmp, Interrupt_Priority_Block_Offset + SSE.Integer_Address (Item));
   end Set_Interrupt_Priority;

   ----------------------------
   -- Get_Interrupt_Priority --
   ----------------------------

   function Get_Interrupt_Priority (Item : Interrupt) return Interrupt_Priority is
      Tmp : Interrupt_Priority_Byte;
   begin
      Tmp := Byte_To_Priority (Read_Register (Interrupt_Priority_Block_Offset + SSE.Integer_Address (Item)));
      return Tmp.Priority;
   end Get_Interrupt_Priority;

end MCU.Core.NVIC.Operations;
