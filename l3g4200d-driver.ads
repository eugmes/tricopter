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

-- This is a generic package for an SPI driver for L3G4200D three-axis
-- angular rate sensor.

pragma Restrictions (No_Elaboration_Code);
with MCU.SSI.Generic_Port;
with MCU.GPIO;

generic
   with package SSI_Port is new MCU.SSI.Generic_Port (<>);
   with procedure Set_CS (State : MCU.GPIO.Pin_State);
package L3G4200D.Driver is
   pragma Preelaborate;

   procedure Initialize_SSI;

   procedure Check_Who_Am_I (Is_Ok : out Boolean);

   procedure Initialize;

   procedure Wait_For_New_Reading;

   procedure Read_Sensor_Data (X_Rate, Y_Rate, Z_Rate : out Raw_Angular_Rate);
end L3G4200D.Driver;
