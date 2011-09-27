pragma Restrictions (No_Elaboration_Code);
with MCU.GPIO.Generic_Port;

package MCU.GPIO.Port_C is new MCU.GPIO.Generic_Port (Base_Address => Port_C_Base, Port_ID => Port_C);
pragma Preelaborate (MCU.GPIO.Port_C);
