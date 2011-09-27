package MCU is
   pragma Pure;

   type UART_Port is (UART0, UART1, UART2);
   type SSI_Port is (SSI0, SSI1);
   type Timer is (Timer0, Timer1, Timer2, Timer3);
   type Comparator is (Comparator0, Comrarator1);
   type GPIO_Port is (Port_A, Port_B, Port_C, Port_D, Port_E, Port_F, Port_G, Port_H);
end MCU;
