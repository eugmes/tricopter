pragma Restrictions (No_Elaboration_Code);
with System.Machine_Code;

package body MCU.Utils is
   procedure Nop is
      use System.Machine_Code;
   begin
      Asm ("nop", Volatile => True, Clobber => "memory");
   end Nop;
end MCU.Utils;
