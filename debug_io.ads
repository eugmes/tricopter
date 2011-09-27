pragma Restrictions (No_Elaboration_Code);

package Debug_IO is
   pragma Preelaborate;

   procedure Put (Item : Character);

   procedure Put (Item : String);

   procedure Put_Line (Item : Character);

   procedure Put_Line (Item : String);

   procedure New_Line;
end Debug_IO;
