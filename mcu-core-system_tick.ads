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

-- This package contains constants and type definitions for system timer
-- module.

pragma Restrictions (No_Elaboration_Code);

package MCU.Core.System_Tick is
   pragma Pure;

   ----------------------
   -- Register offsets --
   ----------------------
   Control_And_Status_Register_Offset : constant := 16#010#;
   Reload_Value_Register_Offset       : constant := 16#014#;
   Current_Value_Register_Offset      : constant := 16#018#;

   ----------------------
   -- Type definitions --
   ----------------------
   type Reference_Clock is (External_Clock, System_Clock);
   for Reference_Clock use (External_Clock => 0, System_Clock => 1);

   type Count_Flag_Type is (Not_Counted_Till_0, Counted_Till_0); -- TODO make some better names
   for Count_Flag_Type use (Not_Counted_Till_0 => 0, Counted_Till_0 => 1);

   type Tick_Count is mod 2**24;

   -----------------------------
   -- Types for reserved bits --
   -----------------------------
   type Reserved_8 is mod 2**8;
   type Reserved_13 is mod 2**13;
   type Reserved_15 is mod 2**15;

   ---------------------------------
   -- Control and status register --
   ---------------------------------
   type Control_And_Status_Register_Record is
      record
         Enable : Boolean;
         Interrupt_Enable : Boolean; -- TODO rename
         Clock_Source : Reference_Clock;
         Reserved : Reserved_13;
         Count_Flag : Count_Flag_Type;
         Reserved_1 : Reserved_15;
      end record;

   for Control_And_Status_Register_Record use
      record
         Enable at 0 range 0 .. 0;
         Interrupt_Enable at 0 range 1 .. 1;
         Clock_Source at 0 range 2 .. 2;
         Reserved at 0 range 3 .. 15;
         Count_Flag at 0 range 16 .. 16;
         Reserved_1 at 0 range 17 .. 31;
      end record;

   for Control_And_Status_Register_Record'Size use 32;
   for Control_And_Status_Register_Record'Alignment use 4;
   for Control_And_Status_Register_Record'Bit_Order use System.Low_Order_First;

   ----------------------------------------
   -- Reload and current value registers --
   ----------------------------------------
   type Value_Register_Record is
      record
         Value : Tick_Count;
         Reserved : Reserved_8;
      end record;

   for Value_Register_Record use
      record
         Value at 0 range 0 .. 23;
         Reserved at 0 range 24 .. 31;
      end record;

   for Value_Register_Record'Size use 32;
   for Value_Register_Record'Alignment use 4;
   for Value_Register_Record'Bit_Order use System.Low_Order_First;
end MCU.Core.System_Tick;
