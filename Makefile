ASM=nasm

SRC_DIR=source
BUILD_DIR=build

$(BUILD_DIR)/FoxyOS_floppy.img: $(BUILD_DIR)/boot.bin
	cp $(BUILD_DIR)/boot.bin $(BUILD_DIR)/FoxyOS_floppy.img
	truncate -s 1440k $(BUILD_DIR)/FoxyOS_floppy.img
	
$(BUILD_DIR)/boot.bin: $(SRC_DIR)/boot.asm
	mkdir -p $(BUILD_DIR)
	$(ASM) $(SRC_DIR)/boot.asm -f bin -o $(BUILD_DIR)/boot.bin