import cpu, apu, ppu, mapper, cartridge, controller;

/**
**/
class Console {

  this(const string path) {
      this.cpu = new CPU();
      this.apu = new APU();
      this.ppu = new PPU();
      this.cartridge = new Cartridge();
      this.controller1 = new Controller();
      this.controller2 = new Controller();
      this.mapper = new Mapper();
  }

  void reset() {
      this.cpu.reset();
  }

  ubyte getRam(ushort address)
  {
      return this.ram[address];
  }

  Controller getController1()
  {
    return this.controller1;
  }

  Controller getController2()
  {
    return this.controller2;
  }

  CPU getCPU()
  {
    return this.cpu;
  }

  APU getAPU()
  {
    return this.apu;
  }

  PPU getPPU()
  {
      return this.ppu;
  }

  Mapper getMapper()
  {
    return this.mapper;
  }

  private:
    CPU         cpu;
    APU         apu;
    PPU         ppu;
    Cartridge   cartridge;
    Controller  controller1;
    Controller  controller2;
    Mapper      mapper;
    byte[2048]  ram;
}
