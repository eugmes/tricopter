with MCU.Core.System_Tick.Registers;
with MCU.Utils;

package body Real_Time is

   Current_Time : Time := 0;
   pragma Atomic (Current_Time);

   procedure System_Tick_Interrupt_Handler;
   pragma Export (Ada, System_Tick_Interrupt_Handler, "__gnat_vector_15");

   procedure System_Tick_Interrupt_Handler is
      Time_Shadow : Time;
   begin
      Time_Shadow := Current_Time;
      Time_Shadow := Time_Shadow + 1;
      Current_Time := Time_Shadow;
   end System_Tick_Interrupt_Handler;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
      use MCU.Core.System_Tick;

      Value_Register_Shadow : Value_Register_Record;
      Control_And_Status_Register_Shadow : Control_And_Status_Register_Record;
   begin
      -- Initialize the system timer with period 100 Hz with system clock 50 MHz
      Value_Register_Shadow := (Value => 50E+4, Reserved => 0);
      Registers.Reload_Value_Register := Value_Register_Shadow;

      Control_And_Status_Register_Shadow := Registers.Control_And_Status_Register;
      Control_And_Status_Register_Shadow.Enable := True;
      Control_And_Status_Register_Shadow.Interrupt_Enable := True;
      Control_And_Status_Register_Shadow.Clock_Source := System_Clock;
      Registers.Control_And_Status_Register := Control_And_Status_Register_Shadow;
   end Initialize;

   -----------
   -- Clock --
   -----------

   function Clock return Time is
   begin
      return Current_Time;
   end Clock;

   procedure Sleep_Until (Wakeup_Time : Time) is
      Current_Time_Shadow : Time;
   begin
      loop
         MCU.Utils.Mask_Interrupts;
         Current_Time_Shadow := Current_Time;
         exit when Current_Time_Shadow >= Wakeup_Time;
         MCU.Utils.Wait_For_Interrupt;
         MCU.Utils.Unmask_Interrupts;
      end loop;
      MCU.Utils.Unmask_Interrupts;
   end Sleep_Until;

begin
   Initialize;
end Real_Time;
