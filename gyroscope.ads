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

-- This package contains high-level routines for the gyroscope sensor.

with L3G4200D;

package Gyroscope is
   pragma Elaborate_Body;

   subtype Raw_Angular_Rate is L3G4200D.Raw_Angular_Rate;

   procedure Check_Who_Am_I (Is_Ok : out Boolean);

   procedure Read_Sensor_Data (X_Rate, Y_Rate, Z_Rate : out Raw_Angular_Rate);
end Gyroscope;
