pragma Restrictions (No_Elaboration_Code);
with System.Storage_Elements;

package MCU.GPIO is
   pragma Pure;

   --------------------
   -- Base Addresses --
   --------------------
   Port_A_Base : constant System.Address := System'To_Address (16#4005_8000#);
   Port_B_Base : constant System.Address := System'To_Address (16#4005_9000#);
   Port_C_Base : constant System.Address := System'To_Address (16#4005_A000#);
   Port_D_Base : constant System.Address := System'To_Address (16#4005_B000#);
   Port_E_Base : constant System.Address := System'To_Address (16#4005_C000#);
   Port_F_Base : constant System.Address := System'To_Address (16#4005_D000#);
   Port_G_Base : constant System.Address := System'To_Address (16#4005_E000#);
   Port_H_Base : constant System.Address := System'To_Address (16#4005_F000#);

   ----------------------
   -- Register Offsets --
   ----------------------
   Data_Register_Offset                      : constant System.Storage_Elements.Storage_Offset := 16#000#;
   Direction_Register_Offset                 : constant System.Storage_Elements.Storage_Offset := 16#400#;
   Interrupt_Sense_Register_Offset           : constant System.Storage_Elements.Storage_Offset := 16#404#;
   Interrupt_Both_Edges_Register_Offset      : constant System.Storage_Elements.Storage_Offset := 16#408#;
   Interrupt_Event_Register_Offset           : constant System.Storage_Elements.Storage_Offset := 16#40C#;
   Interrupt_Mask_Register_Offset            : constant System.Storage_Elements.Storage_Offset := 16#410#;
   Raw_Interrupt_Status_Register_Offset      : constant System.Storage_Elements.Storage_Offset := 16#414#;
   Masked_Interrupt_Status_Register_Offset   : constant System.Storage_Elements.Storage_Offset := 16#418#;
   Interrupt_Clear_Register_Offset           : constant System.Storage_Elements.Storage_Offset := 16#41C#;
   Alternate_Function_Select_Register_Offset : constant System.Storage_Elements.Storage_Offset := 16#420#;
   Drive_Select_2mA_Register_Offset          : constant System.Storage_Elements.Storage_Offset := 16#500#;
   Drive_Select_4mA_Register_Offset          : constant System.Storage_Elements.Storage_Offset := 16#504#;
   Drive_Select_8mA_Register_Offset          : constant System.Storage_Elements.Storage_Offset := 16#508#;
   Open_Drain_Select_Register_Offset         : constant System.Storage_Elements.Storage_Offset := 16#50C#;
   Pull_Up_Select_Register_Offset            : constant System.Storage_Elements.Storage_Offset := 16#510#;
   Pull_Down_Select_Register_Offset          : constant System.Storage_Elements.Storage_Offset := 16#514#;
   Slew_Rate_Control_Register_Offset         : constant System.Storage_Elements.Storage_Offset := 16#518#;
   Digital_Enable_Register_Offset            : constant System.Storage_Elements.Storage_Offset := 16#51C#;
   Lock_Register_Offset                      : constant System.Storage_Elements.Storage_Offset := 16#520#;
   Commit_Register_Offset                    : constant System.Storage_Elements.Storage_Offset := 16#524#;
   Analog_Mode_Select_Register_Offset        : constant System.Storage_Elements.Storage_Offset := 16#528#;

   ----------------------
   -- Type Definitions --
   ----------------------
   type Pin_Number is range 0 .. 7;

   type Pin_State is (Low, High);
   for Pin_State use (Low => 0, High => 1);
   type Pin_States is array (Pin_Number) of Pin_State;
   for Pin_States'Component_Size use 1;

   type Pin_Direction is (Input, Output);
   for Pin_Direction use (Input => 0, Output => 1);
   type Pin_Directions is array (Pin_Number) of Pin_Direction;
   for Pin_Directions'Component_Size use 1;

   type Pin_Interrupt_Sense is (Edge_Sensitive, Level_Sensitive);
   for Pin_Interrupt_Sense use (Edge_Sensitive => 0, Level_Sensitive => 1);
   type Pin_Interrupt_Senses is array (Pin_Number) of Pin_Interrupt_Sense;
   for Pin_Interrupt_Senses'Component_Size use 1;

   type Pin_Both_Edges_Sense is (Not_Both_Edges, Both_Edges);
   for Pin_Both_Edges_Sense use (Not_Both_Edges => 0, Both_Edges => 1);
   type Pin_Both_Edges_Senses is array (Pin_Number) of Pin_Both_Edges_Sense;
   for Pin_Both_Edges_Senses'Component_Size use 1;

   type Pin_Interrupt_Event is (Falling_Edge, Rising_Edge);
   for Pin_Interrupt_Event use (Falling_Edge => 0, Rising_Edge => 1);
   type Pin_Interrupt_Events is array (Pin_Number) of Pin_Interrupt_Event;
   for Pin_Interrupt_Events'Component_Size use 1;

   type Pin_Interrupt_Mask is (Masked, Not_Masked);
   for Pin_Interrupt_Mask use (Masked => 0, Not_Masked => 1);
   type Pin_Interrupt_Masks is array (Pin_Number) of Pin_Interrupt_Mask;
   for Pin_Interrupt_Masks'Component_Size use 1;

   type Pin_Interrupt_Status is (Not_Active, Active);
   for Pin_Interrupt_Status use (Not_Active => 0, Active => 1);
   type Pin_Interrupt_Statuses is array (Pin_Number) of Pin_Interrupt_Status;
   for Pin_Interrupt_Statuses'Component_Size use 1;

   type Pin_Interrupt_Clear is (No_Change, Clear);
   for Pin_Interrupt_Clear use (No_Change => 0, Clear => 1);
   type Pin_Interrupt_Clears is array (Pin_Number) of Pin_Interrupt_Clear;
   for Pin_Interrupt_Clears'Component_Size use 1;

   type Pin_Function is (GPIO_Mode, Alternate_Function);
   for Pin_Function use (GPIO_Mode => 0, Alternate_Function => 1);
   type Pin_Functions is array (Pin_Number) of Pin_Function;
   for Pin_Functions'Component_Size use 1;

   type Pin_Drive_Select is (No_Change, Select_Drive);
   for Pin_Drive_Select use (No_Change => 0, Select_Drive => 1);
   type Pin_Drive_Selects is array (Pin_Number) of Pin_Drive_Select;
   for Pin_Drive_Selects'Component_Size use 1;

   type Pin_Open_Drain_Selection is (Disable_Open_Drain, Enable_Open_Drain);
   for Pin_Open_Drain_Selection use (Disable_Open_Drain => 0, Enable_Open_Drain => 1);
   type Pin_Open_Drain_Selections is array (Pin_Number) of Pin_Open_Drain_Selection;
   for Pin_Open_Drain_Selections'Component_Size use 1;

   type Pin_Pull_Up_Selection is (Disable_Pull_Up, Enable_Pull_Up);
   for Pin_Pull_Up_Selection use (Disable_Pull_Up => 0, Enable_Pull_Up => 1);
   type Pin_Pull_Up_Selections is array (Pin_Number) of Pin_Pull_Up_Selection;
   for Pin_Pull_Up_Selections'Component_Size use 1;

   type Pin_Pull_Down_Selection is (Disable_Pull_Down, Enable_Pull_Down);
   for Pin_Pull_Down_Selection use (Disable_Pull_Down => 0, Enable_Pull_Down => 1);
   type Pin_Pull_Down_Selections is array (Pin_Number) of Pin_Pull_Down_Selection;
   for Pin_Pull_Down_Selections'Component_Size use 1;

   type Pin_Slew_Rate_Control is (Disable_Slew_Rate_Control, Enable_Slew_Rate_Control);
   for Pin_Slew_Rate_Control use (Disable_Slew_Rate_Control => 0, Enable_Slew_Rate_Control => 1);
   type Pin_Slew_Rate_Controls is array (Pin_Number) of Pin_Slew_Rate_Control;
   for Pin_Slew_Rate_Controls'Component_Size use 1;

   type Pin_Digital_Function is (Disable_Digital_Function, Enable_Digital_Function);
   for Pin_Digital_Function use (Disable_Digital_Function => 0, Enable_Digital_Function => 1);
   type Pin_Digital_Functions is array (Pin_Number) of Pin_Digital_Function;
   for Pin_Digital_Functions'Component_Size use 1;

   type Pin_Commit is (Dont_Commit, Commit);
   for Pin_Commit use (Dont_Commit => 0, Commit => 1);
   type Pin_Commits is array (Pin_Number) of Pin_Commit;
   for Pin_Commits'Component_Size use 1;

   type Pin_Analog_Mode is (Analog_Function_Disabled, Analog_Function_Enabled);
   for Pin_Analog_Mode use (Analog_Function_Disabled => 0, Analog_Function_Enabled => 1);
   type Pin_Analog_Modes is array (Pin_Number) of Pin_Analog_Mode; -- FIXME should be subset?
   for Pin_Analog_Modes'Component_Size use 1;

   -----------------------------
   -- Types for reserved bits --
   -----------------------------
   type Reserved_24 is mod 2**24;

   -------------------
   -- Data register --
   -------------------
   type Data_Register_Record is
      record
         Data : Pin_States;
         Reserved : Reserved_24 := 0;
      end record;

   for Data_Register_Record use
      record
         Data at 0 range 0 .. 7;
         Reserved at 0 range 8 .. 31;
      end record;

   for Data_Register_Record'Size use 32;
   for Data_Register_Record'Bit_Order use System.Low_Order_First;

   ------------------------
   -- Direction register --
   ------------------------
   type Direction_Register_Record is
      record
         Directions : Pin_Directions;
         Reserved : Reserved_24 := 0;
      end record;

   for Direction_Register_Record use
      record
         Directions at 0 range 0 .. 7;
         Reserved at 0 range 8 .. 31;
      end record;

   for Direction_Register_Record'Size use 32;
   for Direction_Register_Record'Bit_Order use System.Low_Order_First;

   ------------------------------
   -- Interrupt sense register --
   ------------------------------
   type Interrupt_Sense_Register_Record is
      record
         Interrupt_Senses : Pin_Interrupt_Senses;
         Reserved : Reserved_24 := 0;
      end record;

   for Interrupt_Sense_Register_Record use
      record
         Interrupt_Senses at 0 range 0 .. 7;
         Reserved at 0 range 8 .. 31;
      end record;

   for Interrupt_Sense_Register_Record'Size use 32;
   for Interrupt_Sense_Register_Record'Bit_Order use System.Low_Order_First;

   -----------------------------------
   -- Interrupt both edges register --
   -----------------------------------
   type Interrupt_Both_Edges_Register_Record is
      record
         Both_Edges : Pin_Both_Edges_Senses;
         Reserved : Reserved_24 := 0;
      end record;

   for Interrupt_Both_Edges_Register_Record use
      record
         Both_Edges at 0 range 0 .. 7;
         Reserved at 0 range 8 .. 31;
      end record;

   for Interrupt_Both_Edges_Register_Record'Size use 32;
   for Interrupt_Both_Edges_Register_Record'Bit_Order use System.Low_Order_First;

   ------------------------------
   -- Interrupt event register --
   ------------------------------
   type Interrupt_Event_Register_Record is
      record
         Events : Pin_Interrupt_Events;
         Reserved : Reserved_24 := 0;
      end record;

   for Interrupt_Event_Register_Record use
      record
         Events at 0 range 0 .. 7;
         Reserved at 0 range 8 .. 31;
      end record;

   for Interrupt_Event_Register_Record'Size use 32;
   for Interrupt_Event_Register_Record'Bit_Order use System.Low_Order_First;

   -----------------------------
   -- Interrupt mask register --
   -----------------------------
   type Interrupt_Mask_Register_Record is
      record
         Masks : Pin_Interrupt_Masks;
         Reserved : Reserved_24 := 0;
      end record;

   for Interrupt_Mask_Register_Record use
      record
         Masks at 0 range 0 .. 7;
         Reserved at 0 range 8 .. 31;
      end record;

   for Interrupt_Mask_Register_Record'Size use 32;
   for Interrupt_Mask_Register_Record'Bit_Order use System.Low_Order_First;

   --------------------------------
   -- Interrupt status registers --
   --                            --
   -- (both raw and masked)      --
   --------------------------------
   type Interrupt_Status_Record is
      record
         Interrupt_Statuses : Pin_Interrupt_Statuses;
         Reserved : Reserved_24 := 0;
      end record;

   for Interrupt_Status_Record use
      record
         Interrupt_Statuses at 0 range 0 .. 7;
         Reserved at 0 range 8 .. 31;
      end record;

   for Interrupt_Status_Record'Size use 32;
   for Interrupt_Status_Record'Bit_Order use System.Low_Order_First;

   ------------------------------
   -- Interrupt clear register --
   ------------------------------
   type Interrupt_Clear_Register_Record is
      record
         Interrupt_Clears : Pin_Interrupt_Clears;
         Reserved : Reserved_24 := 0;
      end record;

   for Interrupt_Clear_Register_Record use
      record
         Interrupt_Clears  at 0 range 0 .. 7;
         Reserved at 0 range 8 .. 31;
      end record;

   for Interrupt_Clear_Register_Record'Size use 32;
   for Interrupt_Clear_Register_Record'Bit_Order use System.Low_Order_First;

   ----------------------------------------
   -- Alternate function select register --
   ----------------------------------------
   type Alternate_Function_Select_Register_Record is
      record
         Functions : Pin_Functions;
         Reserved : Reserved_24 := 0;
      end record;

   for Alternate_Function_Select_Register_Record use
      record
         Functions at 0 range 0 .. 7;
         Reserved at 0 range 8 .. 31;
      end record;

   for Alternate_Function_Select_Register_Record'Size use 32;
   for Alternate_Function_Select_Register_Record'Bit_Order use System.Low_Order_First;

   -----------------------------------
   -- Drive select registers        --
   -- (2, 4, and 8 mA drive select) --
   -----------------------------------
   type Drive_Select_Register_Record is
      record
         Drive_Selects : Pin_Drive_Selects;
         Reserved : Reserved_24 := 0;
      end record;

   for Drive_Select_Register_Record use
      record
         Drive_Selects at 0 range 0 .. 7;
         Reserved at 0 range 8 .. 31;
      end record;

   for Drive_Select_Register_Record'Size use 32;
   for Drive_Select_Register_Record'Bit_Order use System.Low_Order_First;

   --------------------------------
   -- Open drain select register --
   --------------------------------
   type Open_Drain_Select_Register_Record is
      record
         Selections : Pin_Open_Drain_Selections;
         Reserved : Reserved_24 := 0;
      end record;

   for Open_Drain_Select_Register_Record use
      record
         Selections at 0 range 0 .. 7;
         Reserved at 0 range 8 .. 31;
      end record;

   for Open_Drain_Select_Register_Record'Size use 32;
   for Open_Drain_Select_Register_Record'Bit_Order use System.Low_Order_First;

   -----------------------------
   -- Pull-up select register --
   -----------------------------
   type Pull_Up_Select_Register_Record is
      record
         Selections : Pin_Pull_Up_Selections;
         Reserved : Reserved_24 := 0;
      end record;

   for Pull_Up_Select_Register_Record use
      record
         Selections at 0 range 0 .. 7;
         Reserved at 0 range 8 .. 31;
      end record;

   for Pull_Up_Select_Register_Record'Size use 32;
   for Pull_Up_Select_Register_Record'Bit_Order use System.Low_Order_First;

   -------------------------------
   -- Pull-down select register --
   -------------------------------
   type Pull_Down_Select_Register_Record is
      record
         Selections : Pin_Pull_Down_Selections;
         Reserved : Reserved_24 := 0;
      end record;

   for Pull_Down_Select_Register_Record use
      record
         Selections at 0 range 0 .. 7;
         Reserved at 0 range 8 .. 31;
      end record;

   for Pull_Down_Select_Register_Record'Size use 32;
   for Pull_Down_Select_Register_Record'Bit_Order use System.Low_Order_First;

   --------------------------------
   -- Slew rate control register --
   --------------------------------
   type Slew_Rate_Control_Register_Record is
      record
         Controls : Pin_Slew_Rate_Controls;
         Reserved : Reserved_24 := 0;
      end record;

   for Slew_Rate_Control_Register_Record use
      record
         Controls at 0 range 0 .. 7;
         Reserved at 0 range 8 .. 31;
      end record;

   for Slew_Rate_Control_Register_Record'Size use 32;
   for Slew_Rate_Control_Register_Record'Bit_Order use System.Low_Order_First;

   -----------------------------
   -- Digital enable register --
   -----------------------------
   type Digital_Enable_Register_Record is
      record
         Digital_Functions : Pin_Digital_Functions;
         Reserved : Reserved_24 := 0;
      end record;

   for Digital_Enable_Register_Record use
      record
         Digital_Functions at 0 range 0 .. 7;
         Reserved at 0 range 8 .. 31;
      end record;

   for Digital_Enable_Register_Record'Size use 32;
   for Digital_Enable_Register_Record'Bit_Order use System.Low_Order_First;

   -------------------
   -- Lock register --
   -------------------
   type Lock_Value is mod 2**32;
   for Lock_Value'Size use 32;
   Port_Unlocked : constant Lock_Value := 0;
   Port_Locked   : constant Lock_Value := 1;
   Unlock_Code   : constant Lock_Value := 16#4C4F_434B#;

   ---------------------
   -- Commit register --
   ---------------------
   type Commit_Register_Record is
      record
         Commit_Bits : Pin_Commits;
         Reserved : Reserved_24 := 0;
      end record;

   for Commit_Register_Record use
      record
         Commit_Bits at 0 range 0 .. 7;
         Reserved at 0 range 8 .. 31;
      end record;

   for Commit_Register_Record'Size use 32;
   for Commit_Register_Record'Bit_Order use System.Low_Order_First;

   ---------------------------------
   -- Analog mode select register --
   ---------------------------------
   type Analog_Mode_Select_Register_Record is
      record
         Analog_Modes : Pin_Analog_Modes;
         Reserved : Reserved_24 := 0;
      end record;

   for Analog_Mode_Select_Register_Record use
      record
         Analog_Modes at 0 range 0 .. 7;
         Reserved at 0 range 8 .. 31;
      end record;

   for Analog_Mode_Select_Register_Record'Size use 32;
   for Analog_Mode_Select_Register_Record'Bit_Order use System.Low_Order_First;
end MCU.GPIO;
