with Controller.GPIO;
with MCU.System_Control;
pragma Unreferenced (Controller.GPIO);
pragma Unreferenced (MCU.System_Control);

procedure Main is
begin
   loop
      null; -- TODO add sleep function
   end loop;
end Main;
pragma No_Return (Main);
