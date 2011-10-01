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

with MCU.GPIO.Port_E;
with MCU.SSI.SSI1;
with L3G4200D.Driver;
with System_Initialization;
pragma Elaborate_All (System_Initialization);

package body Gyroscope is
   package GPIO_Port renames MCU.GPIO.Port_E;

   SPC_Pin : constant MCU.GPIO.Pin_Number := 0;
   CS_Pin  : constant MCU.GPIO.Pin_Number := 1;
   SDO_Pin : constant MCU.GPIO.Pin_Number := 2;
   SDI_Pin : constant MCU.GPIO.Pin_Number := 3;

   procedure Set_CS (State : MCU.GPIO.Pin_State) is
      CS_Mask : constant MCU.GPIO.Data_Mask := (CS_Pin => MCU.GPIO.Unmasked, others => MCU.GPIO.Masked);
   begin
      GPIO_Port.Set_Pins (States => (CS_Pin => State, others => MCU.GPIO.Low), Mask => CS_Mask);
   end Set_CS;

   package Driver is new L3G4200D.Driver (MCU.SSI.SSI1, Set_CS);

   procedure Check_Who_Am_I (Is_Ok : out Boolean) is
   begin
      Driver.Check_Who_Am_I (Is_Ok);
   end Check_Who_Am_I;

   procedure Read_Sensor_Data (X_Rate, Y_Rate, Z_Rate : out Raw_Angular_Rate) is
   begin
      Driver.Wait_For_New_Reading;
      Driver.Read_Sensor_Data (X_Rate, Y_Rate, Z_Rate);
   end Read_Sensor_Data;

   procedure Init_GPIO is
      use MCU.GPIO;

      Direction_Register : Direction_Register_Record;
      Alternate_Function_Select_Register : Alternate_Function_Select_Register_Record;
      Digital_Enable_Register : Digital_Enable_Register_Record;
      Pull_Up_Select_Register : Pull_Up_Select_Register_Record;
   begin
      Direction_Register := GPIO_Port.Direction_Register;
      Direction_Register.Directions (SPC_Pin) := Output;
      Direction_Register.Directions (CS_Pin) := Output;
      Direction_Register.Directions (SDI_Pin) := Output;
      Direction_Register.Directions (SDO_Pin) := Input;
      GPIO_Port.Direction_Register := Direction_Register;

      Alternate_Function_Select_Register := GPIO_Port.Alternate_Function_Select_Register;
      Alternate_Function_Select_Register.Functions (SPC_Pin) := Alternate_Function;
      Alternate_Function_Select_Register.Functions (CS_Pin) := GPIO_Mode;
      Alternate_Function_Select_Register.Functions (SDI_Pin) := Alternate_Function;
      Alternate_Function_Select_Register.Functions (SDO_Pin) := Alternate_Function;
      GPIO_Port.Alternate_Function_Select_Register := Alternate_Function_Select_Register;

      Pull_Up_Select_Register := GPIO_Port.Pull_Up_Select_Register;
      Pull_Up_Select_Register.Selections (SDO_Pin) := Enable_Pull_Up;
      -- FIXME others default (Disable_Pull_Up)
      GPIO_Port.Pull_Up_Select_Register := Pull_Up_Select_Register;

      Set_CS (MCU.GPIO.High); -- FIXME maybe move to driver?

      Digital_Enable_Register := GPIO_Port.Digital_Enable_Register;
      Digital_Enable_Register.Digital_Functions (SPC_Pin) := Enable_Digital_Function;
      Digital_Enable_Register.Digital_Functions (CS_Pin) := Enable_Digital_Function;
      Digital_Enable_Register.Digital_Functions (SDO_Pin) := Enable_Digital_Function;
      Digital_Enable_Register.Digital_Functions (SDI_Pin) := Enable_Digital_Function;
      GPIO_Port.Digital_Enable_Register := Digital_Enable_Register;
   end Init_GPIO;

begin
   Driver.Initialize_SSI;
   Init_GPIO;
   Driver.Initialize;
end Gyroscope;
