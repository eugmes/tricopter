pragma Restrictions (No_Elaboration_Code);

package MCU.Utils is
   procedure Nop;
   pragma Inline_Always (Nop);
end MCU.Utils;
