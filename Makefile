CC := arm-none-eabi-gcc
CFLAGS :=-mcpu=cortex-m3 -mthumb -ffreestanding -nostdlib -Wall -Wextra -g -O0
LDFLAGS := -T linker/link.ld -Wl,-Map=build/firmware.map

# target: dependencies. $@ means the target name
build/firmware.elf: src/boot.c linker/link.ld
	mkdir -p build
	$(CC) $(CFLAGS) $(LDFLAGS) src/boot.c -o $@

# 'make run' builds first, checks if firmware file exists, is updated and then runs it in QEMU. 
run: build/firmware.elf
	qemu-system-arm -M mps2-an385 -nographic -kernel build/firmware.elf


# Deletes only the build directory.
clean:
	rm -rf build

# Debugger; -S tells QEMU to freeze the CPU before the first instruction. -s opens the server on port 1234.
debug: build/firmware.elf
	qemu-system-arm -M mps2-an385 -nographic -kernel build/firmware.elf -S -s

.PHONY: run clean debug