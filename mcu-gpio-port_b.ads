pragma Restrictions (No_Elaboration_Code);
with MCU.GPIO.Generic_Port;

package MCU.GPIO.Port_B is new MCU.GPIO.Generic_Port (Base_Address => Port_B_Base, Port_ID => Port_B);
pragma Preelaborate (MCU.GPIO.Port_B);
