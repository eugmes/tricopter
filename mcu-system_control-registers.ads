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

-- This package contains definitions of variables for accessing system
-- control block registers.

pragma Restrictions (No_Elaboration_Code);
with System.Storage_Elements;

package MCU.System_Control.Registers is
   pragma Preelaborate;

   use type System.Storage_Elements.Integer_Address;

   Base_Address : constant System.Storage_Elements.Integer_Address := Register_File_Base_Address;

   Brown_Out_Reset_Control_Register : Brown_Out_Reset_Control_Register_Record;
   for Brown_Out_Reset_Control_Register'Address use System'To_Address (Base_Address + Brown_Out_Reset_Control_Register_Offset);
   pragma Atomic (Brown_Out_Reset_Control_Register);
   pragma Import (Ada, Brown_Out_Reset_Control_Register);

   -- TODO

   Raw_Interrupt_Status_Register : constant Raw_Interrupt_Status_Register_Record;
   for Raw_Interrupt_Status_Register'Address use System'To_Address (Base_Address + Raw_Interrupt_Status_Register_Offset);
   pragma Atomic (Raw_Interrupt_Status_Register);
   pragma Import (Ada, Raw_Interrupt_Status_Register);

   -- TODO

   Run_Mode_Clock_Configuration_Register : Run_Mode_Clock_Configuration_Register_Record;
   for Run_Mode_Clock_Configuration_Register'Address use
      System'To_Address (Base_Address + Run_Mode_Clock_Configuration_Register_Offset);
   pragma Atomic (Run_Mode_Clock_Configuration_Register);
   pragma Import (Ada, Run_Mode_Clock_Configuration_Register);

   -- TODO

   GPIO_High_Performance_Bus_Control_Register : GPIO_High_Performance_Bus_Control_Register_Record;
   for GPIO_High_Performance_Bus_Control_Register'Address use
      System'To_Address (Base_Address + GPIO_High_Performance_Bus_Control_Register_Offset);
   pragma Atomic (GPIO_High_Performance_Bus_Control_Register);
   pragma Import (Ada, GPIO_High_Performance_Bus_Control_Register);

   -- TODO
   Run_Mode_Clock_Gating_Control_Register_1 : Clock_Gating_Control_Register_1_Record;
   for Run_Mode_Clock_Gating_Control_Register_1'Address use
      System'To_Address (Base_Address + Run_Mode_Clock_Gating_Control_Register_1_Offset);
   pragma Atomic (Run_Mode_Clock_Gating_Control_Register_1);
   pragma Import (Ada, Run_Mode_Clock_Gating_Control_Register_1);

   Sleep_Mode_Clock_Gating_Control_Register_1 : Clock_Gating_Control_Register_1_Record;
   for Sleep_Mode_Clock_Gating_Control_Register_1'Address use
      System'To_Address (Base_Address + Sleep_Mode_Clock_Gating_Control_Register_1_Offset);
   pragma Atomic (Sleep_Mode_Clock_Gating_Control_Register_1);
   pragma Import (Ada, Sleep_Mode_Clock_Gating_Control_Register_1);

   Deep_Sleep_Mode_Clock_Gating_Control_Register_1 : Clock_Gating_Control_Register_1_Record;
   for Deep_Sleep_Mode_Clock_Gating_Control_Register_1'Address use
      System'To_Address (Base_Address + Deep_Sleep_Mode_Clock_Gating_Control_Register_1_Offset);
   pragma Atomic (Deep_Sleep_Mode_Clock_Gating_Control_Register_1);
   pragma Import (Ada, Deep_Sleep_Mode_Clock_Gating_Control_Register_1);

   Run_Mode_Clock_Gating_Control_Register_2 : Clock_Gating_Control_Register_2_Record;
   for Run_Mode_Clock_Gating_Control_Register_2'Address use
      System'To_Address (Base_Address + Run_Mode_Clock_Gating_Control_Register_2_Offset);
   pragma Atomic (Run_Mode_Clock_Gating_Control_Register_2);
   pragma Import (Ada, Run_Mode_Clock_Gating_Control_Register_2);

   Sleep_Mode_Clock_Gating_Control_Register_2 : Clock_Gating_Control_Register_2_Record;
   for Sleep_Mode_Clock_Gating_Control_Register_2'Address use
      System'To_Address (Base_Address + Sleep_Mode_Clock_Gating_Control_Register_2_Offset);
   pragma Atomic (Sleep_Mode_Clock_Gating_Control_Register_2);
   pragma Import (Ada, Sleep_Mode_Clock_Gating_Control_Register_2);

   Deep_Sleep_Mode_Clock_Gating_Control_Register_2 : Clock_Gating_Control_Register_2_Record;
   for Deep_Sleep_Mode_Clock_Gating_Control_Register_2'Address use
      System'To_Address (Base_Address + Deep_Sleep_Mode_Clock_Gating_Control_Register_2_Offset);
   pragma Atomic (Deep_Sleep_Mode_Clock_Gating_Control_Register_2);
   pragma Import (Ada, Deep_Sleep_Mode_Clock_Gating_Control_Register_2);
end MCU.System_Control.Registers;
