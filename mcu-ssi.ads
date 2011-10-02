---------------------------------------------------------------------------
--      Copyright © 2011 Євгеній Мещеряков <eugen@debian.org>            --
--                                                                       --
-- This program is free software: you can redistribute it and/or modify  --
-- it under the terms of the GNU General Public License as published by  --
-- the Free Software Foundation, either version 3 of the License, or     --
-- (at your option) any later version.                                   --
--                                                                       --
-- This program is distributed in the hope that it will be useful,       --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of        --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         --
-- GNU General Public License for more details.                          --
--                                                                       --
-- You should have received a copy of the GNU General Public License     --
-- along with this program.  If not, see <http://www.gnu.org/licenses/>. --
---------------------------------------------------------------------------

-- This package contains contants and type definitions for LM3S3749 SSI
-- interface.

pragma Restrictions (No_Elaboration_Code);
with System.Storage_Elements;

package MCU.SSI is
   pragma Pure;

   --------------------
   -- Base addresses --
   --------------------
   SSI0_Base : constant System.Storage_Elements.Integer_Address := 16#4000_8000#;
   SSI1_Base : constant System.Storage_Elements.Integer_Address := 16#4000_9000#;

   ----------------------
   -- Register offsets --
   ----------------------
   Control_Register_0_Offset               : constant := 16#000#;
   Control_Register_1_Offset               : constant := 16#004#;
   Data_Register_Offset                    : constant := 16#008#;
   Status_Register_Offset                  : constant := 16#00C#;
   Clock_Prescale_Register_Offset          : constant := 16#010#;
   Interrupt_Mask_Register_Offset          : constant := 16#014#;
   Raw_Interrupt_Status_Register_Offset    : constant := 16#018#;
   Masked_Interrupt_Status_Register_Offset : constant := 16#01C#;
   Interrupt_Clear_Register_Offset         : constant := 16#020#;
   DMA_Control_Register_Offset             : constant := 16#024#;

   ----------------------
   -- Type definitions --
   ----------------------
   type Data_Size is range 1 .. 16;
   pragma Warnings (Off, Data_Size);
   for Data_Size'Size use 4; -- biased ok
   pragma Warnings (On, Data_Size);

   type Frame_Format is (SPI, TI_SSI, MICROWIRE, Reserved);
   for Frame_Format use (SPI => 0, TI_SSI => 1, MICROWIRE => 2, Reserved => 3);

   type Clock_Polarity is (Steady_Low, Steady_High);
   for Clock_Polarity use (Steady_Low => 0, Steady_High => 1);

   type Clock_Phase is (First_Edge_Capture, Second_Edge_Capture);
   for Clock_Phase use (First_Edge_Capture => 0, Second_Edge_Capture => 1);

   type Clock_Rate is mod 2**8;

   type Operating_Mode is (Normal_Mode, Loopback_Mode);
   for Operating_Mode use (Normal_Mode => 0, Loopback_Mode => 1);

   type Master_Or_Slave is (Master, Slave);
   for Master_Or_Slave use (Master => 0, Slave => 1);

   type Data_Word is mod 2**16;

   type Clock_Prescale_Divisor is mod 2**8;
   -- this should be an even value in range 2 .. 254

   -----------------------------
   -- Types for reserved bits --
   -----------------------------
   type Reserved_16 is mod 2**16;
   type Reserved_24 is mod 2**24;
   type Reserved_27 is mod 2**27;
   type Reserved_28 is mod 2**28;

   ------------------------
   -- Control register 0 --
   ------------------------
   type Control_Register_0_Record is
      record
         Data_Size_Select : Data_Size;
         Frame_Format_Select : Frame_Format;
         Serial_Clock_Polarity : Clock_Polarity;
         Serial_Clock_Phase : Clock_Phase;
         Serial_Clock_Rate : Clock_Rate;
         Reserved : Reserved_16;
      end record;

   for Control_Register_0_Record use
      record
         Data_Size_Select at 0 range 0 .. 3;
         Frame_Format_Select at 0 range 4 .. 5;
         Serial_Clock_Polarity at 0 range 6 .. 6;
         Serial_Clock_Phase  at 0 range 7 .. 7;
         Serial_Clock_Rate at 0 range 8 .. 15;
         Reserved at 0 range 16 .. 31;
      end record;

   for Control_Register_0_Record'Size use 32;
   for Control_Register_0_Record'Alignment use 4;

   ------------------------
   -- Control register 1 --
   ------------------------
   type Control_Register_1_Record is
      record
         Mode_Select : Operating_Mode;
         Port_Enable : Boolean;
         Master_Slave_Select : Master_Or_Slave;
         Slave_Mode_Output_Disable : Boolean;
         Reserved : Reserved_28;
      end record;

   for Control_Register_1_Record use
      record
         Mode_Select at 0 range 0 .. 0;
         Port_Enable at 0 range 1 .. 1;
         Master_Slave_Select at 0 range 2 .. 2;
         Slave_Mode_Output_Disable at 0 range 3 .. 3;
         Reserved at 0 range 4 .. 31;
      end record;

   for Control_Register_1_Record'Size use 32;
   for Control_Register_1_Record'Alignment use 4;

   -------------------
   -- Data register --
   -------------------
   type Data_Register_Record is
      record
         Data : Data_Word;
         Reserved : Reserved_16;
      end record;

   for Data_Register_Record use
      record
         Data at 0 range 0 .. 15;
         Reserved at 0 range 16 .. 31;
      end record;

   for Data_Register_Record'Size use 32;
   for Data_Register_Record'Alignment use 4;

   ---------------------
   -- Status register --
   ---------------------
   type Status_Register_Record is
      record
         Transmit_FIFO_Empty : Boolean;
         Transmit_FIFO_Not_Full : Boolean;
         Receive_FIFO_Not_Empty : Boolean;
         Receive_FIFO_Full : Boolean;
         Busy : Boolean;
         Reserved : Reserved_27;
      end record;

   for Status_Register_Record use
      record
         Transmit_FIFO_Empty at 0 range 0 .. 0;
         Transmit_FIFO_Not_Full at 0 range 1 .. 1;
         Receive_FIFO_Not_Empty at 0 range 2 .. 2;
         Receive_FIFO_Full at 0 range 3 .. 3;
         Busy at 0 range 4 .. 4;
         Reserved at 0 range 5 .. 31;
      end record;

   for Status_Register_Record'Size use 32;
   for Status_Register_Record'Alignment use 4;

   -----------------------------
   -- Clock prescale register --
   -----------------------------
   type Clock_Prescale_Register_Record is
      record
         Divisor : Clock_Prescale_Divisor;
         Reserved : Reserved_24;
      end record;

   for Clock_Prescale_Register_Record use
      record
         Divisor at 0 range 0 .. 7;
         Reserved at 0 range 8 .. 31;
      end record;

   for Clock_Prescale_Register_Record'Size use 32;
   for Clock_Prescale_Register_Record'Alignment use 4;

   -- TODO
end MCU.SSI;
