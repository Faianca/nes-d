class PPU
{

  ubyte readRegister(ushort address)
  {
      return 1;
  }

  private:
    // storage variables
  	byte[32]   paletteData;
  	byte[2048] nameTableData;
  	byte[256]  oamData;

    // PPU registers
  	ushort v; // current vram address (15 bit)
  	ushort t; // temporary vram address (15 bit)
  	byte x;   // fine x scroll (3 bit)
  	byte w;  // write toggle (1 bit)
  	byte f;  // even/odd frame flag (1 bit)
    byte register;

    // NMI flags
    bool nmiOccurred;
    bool nmiOutput;
    bool nmiPrevious;
    byte nmiDelay;

    // background temporary variables
    byte nameTableByte;
    byte attributeTableByte;
    byte lowTileByte;
    byte highTileByte;
    ushort tileData;

    // sprite temporary variables
    int spriteCount;
    uint[8] spritePatterns;
    byte[8] spritePositions;
    byte[8] spritePriorities;
    byte[8] spriteIndexes;

    // $2000 PPUCTRL
    byte flagNameTable;  // 0: $2000; 1: $2400; 2: $2800; 3: $2C00
    byte flagIncrement;  // 0: add 1; 1: add 32
    byte flagSpriteTable;  // 0: $0000; 1: $1000; ignored in 8x16 mode
    byte flagBackgroundTable;  // 0: $0000; 1: $1000
    byte flagSpriteSize;  // 0: 8x8; 1: 8x16
    byte flagMasterSlave;  // 0: read EXT; 1: write EXT

    // $2001 PPUMASK
    byte flagGrayscale; // 0: color; 1: grayscale
    byte flagShowLeftBackground; // 0: hide; 1: show
    byte flagShowLeftSprites; // 0: hide; 1: show
    byte flagShowBackground; // 0: hide; 1: show
    byte flagShowSprites; // 0: hide; 1: show
    byte flagRedTint; // 0: normal; 1: emphasized
    byte flagGreenTint; // 0: normal; 1: emphasized
    byte flagBlueTint;  // 0: normal; 1: emphasized

    // $2002 PPUSTATUS
    byte flagSpriteZeroHit;
    byte flagSpriteOverflow;

    // $2003 OAMADDR
    byte oamAddress;

    // $2007 PPUDATA
    byte bufferedData;// for buffered reads
}
