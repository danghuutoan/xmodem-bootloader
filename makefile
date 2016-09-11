TOOLCHAIN = arm-none-eabi-

CC = $(TOOLCHAIN)gcc
AS = $(TOOLCHAIN)as
CP = $(TOOLCHAIN)objcopy
LD = $(TOOLCHAIN)ld
DUMP = $(TOOLCHAIN)objdump

all: startup.o startup.elf startup.bin
startup.o: startup.s
	$(AS) -g -mcpu=cortex-m4 -mthumb startup.s -o startup.o
startup.elf: startup.o
	$(LD) -Ttext 0x8000000 startup.o -o startup.elf
startup.bin: startup.elf
	$(CP) -Obinary startup.elf startup.bin
clean:
	rm -f *.bin *.elf *.o *.list
flash:
	# st-flash write startup.bin 0x8000000
	openocd -s /usr/share/openocd/scripts/ \
	-f /usr/share/openocd/scripts/interface/stlink-v2-1.cfg \
	-f /usr/share/openocd/scripts/target/stm32f4x.cfg \
	-c init -c targets -c "halt" \
    -c "flash write_image erase startup.elf" \
    -c "verify_image startup.elf" \
    -c "reset run" -c shutdown

deassembly:
	$(DUMP) -S startup.elf > deassembly.list
