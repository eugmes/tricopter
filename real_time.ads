package Real_Time is
   type Time is mod 2**32;
   for Time'Size use 32;
   for Time'Alignment use 4;

   function Clock return Time;

   procedure Sleep_Until (Wakeup_Time : Time);
end Real_Time;
