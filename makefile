NA = nasm
NFlags = -f elf32 -i /home/morticia/Projects/OSDev/Learning/1/src/asm/
BOOTFlags = -f bin -i /home/morticia/Projects/OSDev/Learning/1/src/asm/

CC = /usr/bin/i686-elf-gcc
CFlags = -g -m32 -Wall -ffreestanding

LD = ld
LFlags = -m elf_i386 -T link.ld -nostdlib

EM = qemu-system-i386
EFlags = -m 256

ODIR = obj
SDIR = src
ISODIR = iso
OUTDIR = bin

SA_DIR = $(SDIR)/asm
SC_DIR = $(SDIR)/c
BOOT_SRC = $(SA_DIR)/boot

OA_DIR = $(ODIR)/asm
OC_DIR = $(ODIR)/c

boot_target = boot.asm
a_targets = kernel_asm.asm
c_targets = *.c
objects = *.o

abin = kasm.o
cbin = kc.o
boot = boot.bin
elf = kernel.elf
bin = kernel.bin
img = kernel.img
iso = kernel.iso

.PHONY: all build run asm boot c link image dump clean

all: build run

build: boot asm c link image

asm: $(SA_DIR)/$(a_targets)
	$(NA) $(NFlags) $(SA_DIR)/$(a_targets) -o $(OA_DIR)/$(abin)
#	mv -f $(SA_DIR)/$(objects) $(OA_DIR)/

boot: $(BOOT_SRC)/$(boot_target)
	$(NA) $(BOOTFlags) $(BOOT_SRC)/$(boot_target) -o $(OUTDIR)/$(boot)

c: $(SC_DIR)/$(c_targets)
	$(CC) $(CFlags) -c $(SC_DIR)/$(c_targets)
	mv $(objects) $(OC_DIR)

link:
	rm -f $(OUTDIR)/$(elf)
	$(LD) $(LFlags) -o $(OUTDIR)/$(elf) $(OA_DIR)/$(abin) $(OC_DIR)/$(objects)
	objcopy -O binary --set-start 31744 $(OUTDIR)/$(elf) $(OUTDIR)/t_$(bin)
	cat $(OUTDIR)/$(boot) $(OUTDIR)/t_$(bin) > $(OUTDIR)/$(bin)
#	mv -f $(boot) $(bin)

image: $(OUTDIR)/$(bin)
	dd if=/dev/zero of=$(ISODIR)/$(img) bs=1k count=2880
	dd if=$(OUTDIR)/$(bin) of=$(ISODIR)/$(img) seek=0 count=2 conv=notrunc
	genisoimage -quiet -V 'KONOS' -input-charset iso8859-1 -o $(iso) -b $(img) -hide $(img) iso/

run: $(iso)
	$(EM) $(EFlags) -cdrom $(iso)

dump: $(OUTDIR)/$(elf)
	objdump -d $<

clean:
	rm -f $(OA_DIR)/$(objects)
	rm -f $(OC_DIR)/$(objects)
	rm -f $(OUTDIR)/*
	rm -f $(iso)