TOOLCHAIN = arm-none-eabi-

CC = $(TOOLCHAIN)gcc
AS = $(TOOLCHAIN)as
CP = $(TOOLCHAIN)objcopy
LD = $(TOOLCHAIN)ld
DUMP = $(TOOLCHAIN)objdump

all: main.o startup.o startup.elf startup.bin
main.o:
	$(CC) -g -mcpu=cortex-m4 -mthumb --specs=nosys.specs -lc -Wl,-Map,main.map main.c -o main.o
startup.o: startup.s
	$(AS) -g -mcpu=cortex-m4 -mthumb startup.s -o startup.o
startup.elf: startup.o
	$(LD) -Tstm32f401.ld main.o startup.o -o startup.elf
startup.bin: startup.elf
	$(CP) -O binary startup.elf startup.bin
clean:
	rm -f *.bin *.elf *.o *.list
flash:
	openocd -f /usr/share/openocd/scripts/board/st_nucleo_f4.cfg \
	-c init -c targets -c "halt" \
    -c "flash write_image erase startup.elf" \
    -c "verify_image startup.elf" \
    -c "reset run" -c shutdown

deassembly:
	$(DUMP) -D startup.elf > deassembly.list
