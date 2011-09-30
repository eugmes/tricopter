package LED is
   pragma Elaborate_Body;

   type State is (Off, On);

   procedure Set_States (Green : State; Red : State);
end LED;
