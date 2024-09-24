CC65 = ../cc65/bin/cc65
CA65 = ../cc65/bin/ca65
LD65 = ../cc65/bin/ld65
# NAME = hello
CFG = nrom_32k_vert.cfg
CHR = basic.chr

BUILD_DIR = build
# SRC_DIR = src


.PHONY: default clean

default: clean $(BUILD_DIR) $(BUILD_DIR)/test.nes

clean:
	@rm -rf $(BUILD_DIR)/*.nes

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(BUILD_DIR)/debug

$(BUILD_DIR)/test.nes:
	$(CA65) LIB/fambasiclib.s -g
	$(LD65) -o $@ -C $(CFG) LIB/fambasiclib.o