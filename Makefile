CC65 = cc65/bin/cc65
CA65 = cc65/bin/ca65
CL65 = cc65/bin/cl65
LD65 = cc65/bin/ld65
NAME = nunix
CFG = nes_memory.cfg
CHR = chr/basic.chr

BUILD_DIR = build
# SRC_DIR = src


.PHONY: default clean

default: clean $(BUILD_DIR) $(BUILD_DIR)/$(NAME).nes

clean:
	@rm -rf $(BUILD_DIR)/*
	@rm -rf $(BUILD_DIR)/debug/*

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(BUILD_DIR)/debug

# Compile C
$(BUILD_DIR)/$(NAME).s: SRC/$(NAME).c 
	$(CC65) -Oirs $^ -o $@ --add-source 

# Assemble required files
# $(BUILD_DIR)/$(NAME).o: $(BUILD_DIR)/$(NAME).s
# 	$(CA65) $< -g

# $(BUILD_DIR)/entry.o: entry.s $(CHR)
# 	$(CA65) $< -o $@

lib/fambasic_lib.s:
	$(CC65) -Oirs lib/fambasic_lib.c -o $@ --add-source

$(BUILD_DIR)/$(NAME).nes: $(BUILD_DIR)/$(NAME).s entry.s $(CHR) lib/fambasic_lib.s
	$(CL65) $(BUILD_DIR)/$(NAME).s entry.s -o $@ -C $(CFG)