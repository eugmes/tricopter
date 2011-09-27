pragma Restrictions (No_Elaboration_Code);
with MCU.GPIO.Generic_Port;

package MCU.GPIO.Port_H is new MCU.GPIO.Generic_Port (Base_Address => Port_H_Base, Port_ID => Port_H);
pragma Preelaborate (MCU.GPIO.Port_H);
