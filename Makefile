# Makefile for building a simple bootloader
FILES = ./build/kernel.asm.o  ./build/kernel.o  ./build/idt/idt.asm.o  ./build/idt/idt.o  ./build/memory/memory.o   ./build/io/io.asm.o  ./build/memory/heap/heap.o  ./build/memory/heap/kheap.o
INCLUDES=-I./src
FLAGS=-g -ffreestanding -falign-jumps -falign-functions -falign-labels -falign-loops -fstrength-reduce -fomit-frame-pointer -finline-functions -Wno-unused-function -fno-builtin -Werror -Wno-unused-label -Wno-cpp -Wno-unused-parameter -nostdlib -nostartfiles -nodefaultlibs -Wall -Iinc

all:./bin/boot.bin ./bin/kernel.bin 
	rm -fr ./bin/os.bin
	dd if=./bin/boot.bin >> ./bin/os.bin
	dd  if=./bin/kernel.bin >> ./bin/os.bin
	dd if=/dev/zero bs=512 count=1000 >> ./bin/os.bin
	

./bin/kernel.bin:$(FILES)
	i686-elf-ld -g -relocatable $(FILES) -o ./build/kernelfull.o
	i686-elf-gcc $(FLAGS) -T ./src/linker.ld -o $@ -ffreestanding  -nostdlib ./build/kernelfull.o
    

./bin/boot.bin:./src/boot/boot.asm
	nasm -f bin -o ./bin/boot.bin $<

./build/kernel.asm.o:./src/kernel.asm
	nasm -f elf -g $< -o $@


./build/kernel.o: ./src/kernel.c
	i686-elf-gcc  $(INCLUDES) $(FLAGS) -std=gnu99 -c ./src/kernel.c -o ./build/kernel.o


./build/idt/idt.asm.o:./src/idt/idt.asm
	nasm -f elf -g $< -o $@


./build/idt/idt.o: ./src/idt/idt.c
	i686-elf-gcc  $(INCLUDES) -I./src/idt $(FLAGS) -std=gnu99 -c $< -o $@

./build/memory/memory.o: ./src/memory/memory.c
	i686-elf-gcc  $(INCLUDES) -I./src/memory $(FLAGS) -std=gnu99 -c $< -o $@

./build/memory/heap/heap.o: ./src/memory/heap/heap.c
	i686-elf-gcc  $(INCLUDES) -I./src/memory $(FLAGS) -std=gnu99 -c $< -o $@

./build/memory/heap/kheap.o: ./src/memory/heap/kheap.c
	i686-elf-gcc  $(INCLUDES) -I./src/memory $(FLAGS) -std=gnu99 -c $< -o $@



./build/io/io.asm.o:./src/io/io.asm
	nasm -f elf -g $< -o $@

# ./build/io/io.o: ./src/io/io.c
# 	i686-elf-gcc  $(INCLUDES) -I./src/idt $(FLAGS) -std=gnu99 -c $< -o $@


view:./bin/os.bin 
	ndisasm $<

run:./bin/os.bin
	qemu-system-x86_64 -hda $<


clean:
	rm -fr ./bin/boot.bin
	rm -fr ./bin/os.bin
	rm -fr ./build/kernel.asm.o
	rm -fr ./build/kernelfull.o 
	rm -fr ./build/kernel.o
	rm -fr ./bin/kernel.bin
	rm -fr 0
	rm -fr ./build/idt/idt.o
	rm -fr ./build/idt/idt.asm..o
	rm -fr ./build/memory/memory.o