with System;
with Interfaces;
with Ada.Unchecked_Conversion;
use type Interfaces.Unsigned_32;

package body DCC is
   type Byte is mod 256;

   type Reserved_7 is mod 2**7;
   type Reserved_16 is mod 2**16;

   type Debug_Register_Record is
      record
         Busy : Boolean;
         Reserved : Reserved_7 := 0;
         Target_Write_Buffer : Byte;
         Reserved1 : Reserved_16 := 0;
      end record;

   for Debug_Register_Record use
      record
         Busy at 0 range 0 .. 0;
         Reserved at 0 range 1 .. 7;
         Target_Write_Buffer at 0 range 8 .. 15;
         Reserved1 at 0 range 16 .. 31;
      end record;

   for Debug_Register_Record'Size use 32;
   for Debug_Register_Record'Alignment use 4;
   for Debug_Register_Record'Bit_Order use System.Low_Order_First;

   Debug_Register : Debug_Register_Record;
   for Debug_Register'Address use System'To_Address (16#E000_EDF8#);
   pragma Atomic (Debug_Register);
   pragma Import (Ada, Debug_Register);

   procedure Send_Word (Item : Interfaces.Unsigned_32) is
      use Interfaces;

      W : Interfaces.Unsigned_32;
      B : Byte;
      Debug : Debug_Register_Record;
   begin
      W := Item;

      for I in 1 .. 4 loop
         loop
            Debug := Debug_Register;
            exit when not Debug.Busy;
         end loop;
         B := Byte (W and 16#ff#);
         Debug_Register := (Busy => True, Target_Write_Buffer => B, others => <>);
         W := Shift_Right (W, 8);
      end loop;
   end Send_Word;

   Request_Type_Character : constant := 2;
   Request_Type_String : constant := 1;

   procedure Put (Item : Character) is
      use Interfaces;
   begin
      Send_Word (Shift_Left (Unsigned_32 (Character'Pos (Item)), 16) or Request_Type_Character);
   end Put;

   procedure Put (Item : String) is
      use Interfaces;
      I : Integer;

      type Buf_String is new String (1 .. 4);
      function Buf_To_Word is new Ada.Unchecked_Conversion (Buf_String, Unsigned_32);
      Buf : Buf_String;
      Done : Boolean := False;
   begin
      Send_Word (Shift_Left (Unsigned_32 (Item'Length), 16) or Request_Type_String);

      I := Item'First;
      while not Done loop
         for J in 1 .. 4 loop
            if not Done then
               Buf (J) := Item (I);
               if I = Item'Last then
                  Done := True;
               else
                  I := I + 1;
               end if;
            else
               Buf (J) := Character'Val (0);
            end if;
         end loop;

         Send_Word (Buf_To_Word (Buf));
      end loop;
   end Put;
end DCC;
