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

-- This package contains constants and type definitions for the interrupt
-- controller module.

pragma Restrictions (No_Elaboration_Code);

package MCU.Core.NVIC is
   pragma Pure;

   ----------------------
   -- Register offsets --
   ----------------------
   Interrupt_Enable_Block_Offset              : constant := 16#100#;
   Interrupt_Disable_Block_Offset             : constant := 16#180#;
   Interrupt_Set_Pending_Block_Offset         : constant := 16#200#;
   Interrupt_Clear_Pending_Block_Offset       : constant := 16#280#;
   Interrupt_Active_Block_Offset              : constant := 16#300#;
   Interrupt_Priority_Block_Offset            : constant := 16#400#;
   Software_Trigger_Interrupt_Register_Offset : constant := 16#F00#;

   -----------
   -- Types --
   -----------
   type Interrupt is range 0 .. 47;
   type Interrupt_Priority is mod 2**3; -- TODO use range?

   -----------------------------
   -- Types for reserved bits --
   -----------------------------
   type Reserved_5 is mod 2**5;

   type Interrupt_Priority_Byte is
      record
         Reserved : Reserved_5;
         Priority : Interrupt_Priority;
      end record;

   for Interrupt_Priority_Byte use
      record
         Reserved at 0 range 0 .. 4;
         Priority at 0 range 5 .. 7;
      end record;

   for Interrupt_Priority_Byte'Size use 8;
   for Interrupt_Priority_Byte'Alignment use 1;
end MCU.Core.NVIC;
