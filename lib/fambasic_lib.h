#define PPUSTATUS ((volatile unsigned char *)0x2002)
#define PPUCTRL ((volatile unsigned char *)0x2000)
#define PPUDATA ((volatile unsigned char *)0x2007)
#define PPUADDR ((volatile unsigned char *)0x2006)
#define PPUSCROLL ((volatile unsigned char *)0x2005)

void read_keyboard_state();
void put_char(unsigned char x, unsigned char y, unsigned char chr);