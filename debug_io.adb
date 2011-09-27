with System.Machine_Code;
with Interfaces;
with Ada.Characters.Latin_1;

package body Debug_IO is
   subtype Word is Interfaces.Unsigned_32;

   SYS_WRITE : constant := 5;

   type Write_Block is
      record
         File_Descriptor : Word;
         Address : System.Address;
         Length : Word;
      end record;

   for Write_Block'Size use 32 * 3;

   procedure Semihosting_SWI (Number : Word; Parameters : System.Address) is
      use System.Machine_Code;
      use Ada.Characters.Latin_1;
   begin
      Asm ("mov r0, %0" & LF & HT &
           "mov r1, %1" & LF & HT &
           "bkpt 0xab",
         Inputs => (Word'Asm_Input ("r", Number),
                    System.Address'Asm_Input ("r", Parameters)),
         Volatile => True,
         Clobber => ("r0, r1, memory"));
   end Semihosting_SWI;
   pragma Inline (Semihosting_SWI);

   procedure Put (Item : String) is
      Params : aliased constant Write_Block :=
         (File_Descriptor => 1,
          Address => Item'Address,
          Length => Item'Length);
   begin
      Semihosting_SWI (SYS_WRITE, Params'Address);
   end Put;

   procedure Put (Item : Character) is
      S : aliased constant String := (1 => Item);
   begin
      Put (S);
   end Put;

   procedure Put_Line (Item : Character) is
   begin
      Put (Item & Ada.Characters.Latin_1.LF);
   end Put_Line;

   procedure Put_Line (Item : String) is
   begin
      Put (Item);
      New_Line;
   end Put_Line;

   procedure New_Line is
   begin
      Put (Ada.Characters.Latin_1.LF);
   end New_Line;
end Debug_IO;
