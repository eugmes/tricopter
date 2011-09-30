with L3G4200D;

package Gyroscope is
   subtype Raw_Angular_Rate is L3G4200D.Raw_Angular_Rate;

   procedure Check_Who_Am_I (Is_Ok : out Boolean);

   procedure Read_Sensor_Data (X_Rate, Y_Rate, Z_Rate : out Raw_Angular_Rate);
end Gyroscope;
