ASM=nasm

SRC_DIR=source
BUILD_DIR=build

.PHONY: all floppy_image kernel bootloader clean always

#
# Создание floppy
#
floppy_image: $(BUILD_DIR)/FoxyOS v0.03.img

$(BUILD_DIR)/FoxyOS v0.03.img: bootloader kernel
	dd if=/dev/zero of=$(BUILD_DIR)/FoxyOS_v0.03.img bs=512 count=2880
	mkfs.fat -F 12 -n "FOXYOS" $(BUILD_DIR)/FoxyOS_v0.03.img
	dd if=$(BUILD_DIR)/boot.bin of=$(BUILD_DIR)/FoxyOS_v0.03.img conv=notrunc
	mcopy -i $(BUILD_DIR)/FoxyOS_v0.03.img $(BUILD_DIR)/kernel.bin "::kernel.bin"

#
# Загрузчик
#
bootloader: $(BUILD_DIR)/boot.bin

$(BUILD_DIR)/boot.bin: always
	$(ASM) $(SRC_DIR)/boot.asm -f bin -o $(BUILD_DIR)/boot.bin

#
# Ядро
#
kernel: $(BUILD_DIR)/kernel.bin

$(BUILD_DIR)/kernel.bin: always
	$(ASM) $(SRC_DIR)/kernel/main.asm -f bin -o $(BUILD_DIR)/kernel.bin

#
# Всегда выполняется
#
always:
	mkdir -p $(BUILD_DIR)

#
# Очистка
#
clean:
	rm -rf $(BUILD_DIR)/*