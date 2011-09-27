pragma Restrictions (No_Elaboration_Code);
with MCU.GPIO.Generic_Port;

package MCU.GPIO.Port_G is new MCU.GPIO.Generic_Port (Base_Address => Port_G_Base, Port_ID => Port_G);
pragma Preelaborate (MCU.GPIO.Port_G);
