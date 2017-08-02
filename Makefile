#Makefile for STM8 Examples with SDCC compiler
#Author:	Saeid Yazdani
#Website:	WWW.EMBEDONIX.COM
#Copyright 2016
#LICENSE:	GNU-LGPL

#Compiler
CC = /home/cas/software/stm8-binutils/bin/sdcc
OBJCOPY = stm8-objcopy
SIZE = stm8-size

#Platform
PLATFORM = stm8

#Product name
PNAME = main

#Directory for helpers
IDIR = StdPeriphLib/inc
SDIR = StdPeriphLib/src

# In case you ever want a different name for the main source file
MAINSRC = $(PNAME).c

ELF_SECTIONS_TO_REMOVE = -R DATA -R INITIALIZED -R SSEG -R .debug_line -R .debug_loc -R .debug_abbrev -R .debug_info -R .debug_pubnames -R .debug_frame

# These are the sources that must be compiled to .rel files:
EXTRASRCS = \
	$(SDIR)/stm8s_itc.c \
	$(SDIR)/stm8s_clk.c \
	$(SDIR)/stm8s_gpio.c \
	$(SDIR)/stm8s_exti.c \
	$(SDIR)/stm8s_uart2.c \
	$(SDIR)/stm8s_tim1.c \
	$(SDIR)/stm8s_tim2.c \
	$(SDIR)/stm8s_adc1.c \
	gpio.c \
	utils.c \
	cruise_control.c \
	uart.c \
	adc.c \
	brake.c \
	timers.c \
	pwm.c \
	motor.c \

# The list of .rel files can be derived from the list of their source files
RELS = $(EXTRASRCS:.c=.rel)

INCLUDES = -I$(IDIR) -I. 
#CFLAGS   = -m$(PLATFORM) -I/usr/local/share/sdcc/include -I/usr/local/share/sdcc/lib/ --std-c99 --nolospre --opt-code-size
CFLAGS   = -m$(PLATFORM) -I/usr/local/share/sdcc/include -I/usr/local/share/sdcc/lib/ --std-c99 --nolospre
ELF_FLAGS = --out-fmt-elf --debug
LIBS     = -l$(PLATFORM)

# This just provides the conventional target name "all"; it is optional
# Note: I assume you set PNAME via some means not exhibited in your original file
all: $(PNAME)

# How to build the overall program
$(PNAME): $(MAINSRC) $(RELS)
	$(CC) $(INCLUDES) $(CFLAGS) -Wl-r $(ELF_FLAGS) $(LIBS) $(MAINSRC) $(RELS)
	$(SIZE) $(PNAME).elf
	$(OBJCOPY) -O binary $(ELF_SECTIONS_TO_REMOVE) $(PNAME).elf $(PNAME).bin

# How to build any .rel file from its corresponding .c file
# GNU would have you use a pattern rule for this, but that's GNU-specific
%.rel: %.c
	$(CC) -c $(INCLUDES) $(CFLAGS) $(ELF_FLAGS) $(LIBS) -o$< $<

# Suffixes appearing in suffix rules we care about.
# Necessary because .rel is not one of the standard suffixes.
.SUFFIXES: .c .rel

hex:
	$(OBJCOPY) -O ihex $(ELF_SECTIONS_TO_REMOVE) $(PNAME).elf $(PNAME).ihx

flash:
	stm8flash -cstlinkv2 -pstm8s105?6 -w$(PNAME).ihx

clean:
	@echo "Cleaning files..."
	@rm -rf $(SDIR)/*.asm
	@rm -rf $(SDIR)/*.rel
	@rm -rf $(SDIR)/*.lk
	@rm -rf $(SDIR)/*.lst
	@rm -rf $(SDIR)/*.rst
	@rm -rf $(SDIR)/*.sym
	@rm -rf $(SDIR)/*.cdb
	@rm -rf $(SDIR)/*.map
	@rm -rf $(SDIR)/*.elf
	@rm -rf $(SDIR)/*.bin
	@rm -rf *.asm
	@rm -rf *.rel
	@rm -rf *.lk
	@rm -rf *.lst
	@rm -rf *.rst
	@rm -rf *.sym
	@rm -rf *.cdb
	@rm -rf *.map
	@rm -rf *.elf
	@rm -rf main.bin
	@rm -rf *.ihx
	@echo "Done."
