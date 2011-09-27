pragma Restrictions (No_Elaboration_Code);
with MCU.GPIO.Generic_Port;

package MCU.GPIO.Port_E is new MCU.GPIO.Generic_Port (Base_Address => Port_E_Base, Port_ID => Port_E);
pragma Preelaborate (MCU.GPIO.Port_E);
