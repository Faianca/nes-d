import std.conv;
import console;
import memory;

class PPU
{
  this()
  {
      /*ppu := PPU{Memory: NewPPUMemory(console), console: console}
      this.front = image.NewRGBA(image.Rect(0, 0, 256, 240))
      this.back = image.NewRGBA(image.Rect(0, 0, 256, 240))*/
      this.reset();
  }

  void reset()
  {
      this.Cycle = 340;
	    this.ScanLine = 240;
	    this.Frame = 0;
	    this.writeControl(0);
	    this.writeMask(0);
	    this.writeOAMAddress(0);
  }

  void writeControl(byte value)
  {
      this.flagNameTable = (value >> 0) & 3;
      this.flagIncrement = (value >> 2) & 1;
      this.flagSpriteTable = (value >> 3) & 1;
      this.flagBackgroundTable = (value >> 4) & 1;
      this.flagSpriteSize = (value >> 5) & 1;
      this.flagMasterSlave = (value >> 6) & 1;
      this.nmiOutput = ((value>>7) & 1) == 1;
      this.nmiChange();
      // t: ....BA.. ........ = d: ......BA
      this.t = (this.t & 0xF3FF) | ((to!ushort(value) & 0x03) << 10);
  }

  // $2003: OAMADDR
  void writeOAMAddress(byte value)
  {
  	 this.oamAddress = value;
  }

  void nmiChange()
  {
    	bool nmi = this.nmiOutput && this.nmiOccurred;
    	if (nmi && !this.nmiPrevious) {
    		// TODO: this fixes some games but the delay shouldn't have to be so
    		// long, so the timings are off somewhere
    		this.nmiDelay = 15;
    	}
    	this.nmiPrevious = nmi;
  }

  // $2001: PPUMASK
  void writeMask(byte value)
  {
    	this.flagGrayscale = (value >> 0) & 1;
    	this.flagShowLeftBackground = (value >> 1) & 1;
    	this.flagShowLeftSprites = (value >> 2) & 1;
    	this.flagShowBackground = (value >> 3) & 1;
    	this.flagShowSprites = (value >> 4) & 1;
    	this.flagRedTint = (value >> 5) & 1;
    	this.flagGreenTint = (value >> 6) & 1;
    	this.flagBlueTint = (value >> 7) & 1;
  }

  ubyte readRegister(ushort address)
  {
      return 1;
  }

  private:
    Memory memory;      // memory interface
	  Console console;   // reference to parent object

	  int Cycle;         // 0-340
	  int ScanLine;      // 0-261, 0-239=visible, 240=post, 241-260=vblank, 261=pre
	  ulong Frame;       // frame counter

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
