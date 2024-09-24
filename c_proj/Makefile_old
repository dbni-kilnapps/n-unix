# makefile for nesdoug example code, for Linux
# this version won't move the final files to BUILD folder
# also won't rebuild on changes to neslib/nesdoug/famitone files

CC65 = ../cc65/bin/cc65
CA65 = ../cc65/bin/ca65
LD65 = ../cc65/bin/ld65
NAME = hello
CFG = nrom_32k_vert.cfg
CHR = Alpha.chr

BUILD_DIR = build
SRC_DIR = src

.PHONY: default clean

default: $(BUILD_DIR) $(BUILD_DIR)/$(NAME).nes

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(BUILD_DIR)/debug


#target: dependencies

$(BUILD_DIR)/$(NAME).nes: $(BUILD_DIR)/$(NAME).o crt0.o $(CFG)
	$(LD65) -C $(CFG) -o $@ crt0.o $< nes.lib -Ln $(BUILD_DIR)/debug/labels.txt --dbgfile $(BUILD_DIR)/debug/dbg.txt
	@echo $(NAME).nes created

crt0.o: crt0.s $(CHR)
	$(CA65) crt0.s

$(BUILD_DIR)/$(NAME).o: $(BUILD_DIR)/$(NAME).s 
	$(CA65) $< -g

$(BUILD_DIR)/$(NAME).s: $(SRC_DIR)/$(NAME).c
	$(CC65) -Oirs $^ -o $@ --add-source -v

clean:
	@rm -f $(BUILD_DIR)/*.*
	@rm -f $(BUILD_DIR)/debug/*.*
