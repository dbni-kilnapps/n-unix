#define RAM_START ((volatile unsigned char*)0x0000)
#define RAM_END ((volatile unsigned char*)0x07ff)
#define PRG_RAM_START ((volatile unsigned char*)0x6000) // battery backed
#define PRG_RAM_END ((volatile unsigned char*)0x7fff)
#define VERSION 4 // version number

unsigned short checkRamRemaining();
unsigned short checkStorageRemaining();

unsigned short checkRamRemaining(){
    unsigned char value;
    unsigned short i, space;
    
    for(i = 0; i < 0x800; i++){
        value = *(RAM_START + i);
        if(value == 0){
            space++;
        }
    }

    return space;
    
}

unsigned short checkStorageRemaining(){
    unsigned char value;
    unsigned short i, space;
    
    for(i = 0; i < 0x2000; i++){
        value = *(PRG_RAM_START + i);
        if(value == 0){
            space++;
        }
    }

    return space;
    
}