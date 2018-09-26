/*
 * EGG OpenSource EBike firmware
 *
 * Copyright (C) Casainho, 2015, 2106, 2017.
 *
 * Released under the GPL License, Version 3
 */

#ifndef _UART_H
#define _UART_H

void uart_put_buffered(uint8_t c); 
uint8_t uart_get_possible();
uint8_t uart_get_buffered(void);

void uart_init (void);
void putbyte(uint8_t c);
char getchar1(void);

#endif /* _UART_H */
