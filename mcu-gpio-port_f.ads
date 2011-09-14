pragma Restrictions (No_Elaboration_Code);
with MCU.GPIO.Generic_Port;

package MCU.GPIO.Port_F is new MCU.GPIO.Generic_Port (Base_Address => Port_F_Base);
pragma Preelaborate (MCU.GPIO.Port_F);
