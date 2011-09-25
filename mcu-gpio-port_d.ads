pragma Restrictions (No_Elaboration_Code);
with MCU.GPIO.Generic_Port;

package MCU.GPIO.Port_D is new MCU.GPIO.Generic_Port (Base_Address => Port_D_Base, Port_ID => Port_D);
pragma Preelaborate (MCU.GPIO.Port_D);
