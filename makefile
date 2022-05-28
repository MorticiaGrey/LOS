NA = nasm
NFlags = -f elf32

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

OA_DIR = $(ODIR)/asm
OC_DIR = $(ODIR)/c

a_target = boot.asm
c_targets = *.c
objects = *.o

abin = kasm.o
cbin = kc.o
elf = kernel.elf
bin = kernel.bin
img = kernel.img
iso = KonOS.iso

.PHONY: all build run asm c link image dump clean

all: build run

build: asm c link image

asm: $(SA_DIR)/$(a_targets)
	$(NA) $(NFlags) $(SA_DIR)/$(a_target) -o $(OA_DIR)/$(abin)

c: $(SC_DIR)/$(c_targets)
	$(CC) $(CFlags) -c $(SC_DIR)/$(c_targets)
	mv $(objects) $(OC_DIR)

link: $(OA_DIR)/$(abin)
	rm -f $(OUTDIR)/$(elf)
	$(LD) $(LFlags) -o $(OUTDIR)/$(elf) $(OA_DIR)/$(abin) $(OC_DIR)/$(objects)
	objcopy -O binary $(OUTDIR)/$(elf) $(OUTDIR)/$(bin)

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
	rm -f $(OUTDIR)/$(bin)
	rm -f $(ISODIR)/$(img)
	rm -f $(iso)