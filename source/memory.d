import console, std.stdio;

interface Memory
{
   byte read(ushort	address);
   void write(ushort address, byte value);
}

class CpuMemory : Memory
{
  private Console console;

  this(Console console) {
    this.console = console;
  }

  byte read(ushort address) {

    	if (address < 0x2000) {
          return this.console.getRam(address%0x0800);
      } else if (address < 0x4000) {
          return this.console.getPPU().readRegister(0x2000 + address%8);
      } else if (address == 0x4014) {
          return this.console.getPPU().readRegister(address);
      } else if (address == 0x4015) {
          return this.console.getAPU().readRegister(0x2000 + address%8);
      } else if (address == 0x4016) {
          return this.console.getController1().read();
      } else if (address == 0x4017) {
          return this.console.getController2().read();
      } else if (address < 0x6000) {
        // TODO: I/O registers
      } else if (address >= 0x6000) {
          return this.console.getMapper().read(address);
      } else {
        writefln("unhandled cpu memory read at address: 0x%04X", address);
      }

    	// case address == 0x4016:
    	// 	return mem.console.Controller1.Read()
    	// case address == 0x4017:
    	// 	return mem.console.Controller2.Read()
    	// case address < 0x6000:
    	// 	// TODO: I/O registers
    	// case address >= 0x6000:
    	// 	return mem.console.Mapper.Read(address)
    	return 0;
  }

  void write(ushort address, byte value) {}
}
