pragma Restrictions (No_Elaboration_Code);
with MCU.GPIO.Generic_Port;

package MCU.GPIO.Port_A is new MCU.GPIO.Generic_Port (Base_Address => Port_A_Base, Port_ID => Port_A);
pragma Preelaborate (MCU.GPIO.Port_A);
