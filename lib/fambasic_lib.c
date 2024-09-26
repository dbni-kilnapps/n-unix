#import "fambasic_lib.h"

void put_char(unsigned char x, unsigned char y, unsigned char chr){
    *PPUADDR = 0x20;
    *PPUADDR = 0x00;
    *PPUDATA = chr;
}

void read_keyboard_state(){
    // read the keyboard state
}