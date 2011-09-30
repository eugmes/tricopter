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
