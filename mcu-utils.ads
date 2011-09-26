pragma Restrictions (No_Elaboration_Code);

package MCU.Utils is
   pragma Preelaborate;

   procedure Nop;
   pragma Inline_Always (Nop);
end MCU.Utils;
