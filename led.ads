package LED is
   type State is (Off, On);

   procedure Set_States (Green : State; Red : State);
end LED;
