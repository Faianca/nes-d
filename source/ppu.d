class PPU
{
  // storage variables
	byte[32]   paletteData;
	byte[2048] nameTableData;
	byte[256]  oamData;

  ubyte readRegister(ushort address)
  {
      return 1;
  }

}
