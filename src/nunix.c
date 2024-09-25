#include "../lib/fambasiclib.h"
#include "bios.c"

void main(void){
    checkRamRemaining();
    
    while(1){
        read_keyboard_state();
        // asm("inx");
    }

}