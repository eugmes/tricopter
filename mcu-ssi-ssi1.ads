pragma Restrictions (No_Elaboration_Code);
with MCU.SSI.Generic_Port;

package MCU.SSI.SSI1 is new MCU.SSI.Generic_Port (Base_Address => SSI1_Base, Port_ID => SSI1);
pragma Preelaborate (MCU.SSI.SSI1);
