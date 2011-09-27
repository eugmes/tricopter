pragma Restrictions (No_Elaboration_Code);
with MCU.SSI.Generic_Port;

package MCU.SSI.SSI0 is new MCU.SSI.Generic_Port (Base_Address => SSI0_Base, Port_ID => SSI0);
pragma Preelaborate (MCU.SSI.SSI0);
