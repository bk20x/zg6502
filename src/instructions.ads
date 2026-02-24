with Bytes;
package Instructions is
  use Bytes;
  type Addressing_Mode is (
      Implied,      
      Absolute,     
      Absolute_X,   
      Absolute_Y,   
      Immediate,    
      Indirect,     
      Indirect_X,   
      Indirect_Y,   
      Zero_Page,    
      Zero_Page_X,  
      Zero_Page_Y,  
      Accumulator,  
      Relative     
  );
  type Cpu_Flags is (
    Negative,
    Overflow,
    B0,
    B1,
    Decimal,
    Interrupt_Disable,
    Zero,
    Carry
  );
  for Cpu_Flags use (
    Negative => 16#01#,
    Overflow => 16#02#,
    B0       => 16#04#,
    B1       => 16#08#,
    Decimal  => 16#10#,
    Interrupt_Disable => 16#20#,
    Zero              => 16#40#,
    Carry             => 16#80#
  ); 
  function Cpu_Flag(Flag: Cpu_Flags) return Integer;
  type Mnemonics is (
      ADC, AND_Op, ASL, BCC, BCS, BEQ, BIT, BMI, BNE, BPL, 
      BRK, BVC, BVS, CLC, CLD, CLI, CLV, CMP, CPX, CPY, 
      DEC, DEX, DEY, EOR, INC, INX, INY, JMP, JSR, LDA, 
      LDX, LDY, LSR, NOP, ORA, PHA, PHP, PLA, PLP, ROL, 
      ROR, RTI, RTS, SBC, SEC, SED, SEI, STA, STX, STY, 
      TAX, TAY, TSX, TXA, TXS, TYA,
      --- directives
      DB, DW, DCB, DS, ORG, EQU
  );
  function Is_Directive(Mnemonic: Mnemonics) return Boolean;
  function Mnemonic_Of_String(Instruction_Name : String) return Mnemonics;
  type Instruction is record
      Op_Code  : Byte;
      Mode     : Addressing_Mode;
      Size     : Positive;      
      Cycles   : Positive;
  end record;
  type Instruction_List is array (Positive range <>) of Instruction;
  type Instruction_List_Access is access constant Instruction_List;
  type Mnemonic_Map is array (Mnemonics) of Instruction_List_Access;
 
  LDA_Instructions : aliased constant Instruction_List := (
      (Op_Code => 16#A9#, Mode => Immediate,   Size => 2, Cycles => 2),
      (Op_Code => 16#A5#, Mode => Zero_Page,   Size => 2, Cycles => 3),
      (Op_Code => 16#B5#, Mode => Zero_Page_X, Size => 2, Cycles => 4),
      (Op_Code => 16#AD#, Mode => Absolute,    Size => 3, Cycles => 4),
      (Op_Code => 16#BD#, Mode => Absolute_X,  Size => 3, Cycles => 4),
      (Op_Code => 16#B9#, Mode => Absolute_Y,  Size => 3, Cycles => 4),
      (Op_Code => 16#A1#, Mode => Indirect_X,  Size => 2, Cycles => 6),
      (Op_Code => 16#B1#, Mode => Indirect_Y,  Size => 2, Cycles => 5)
  );
  Opcode_Table : constant Mnemonic_Map := (
      LDA    => LDA_Instructions'Access,
      others => null
  );
  function Lookup_Instruction(
      Name: Mnemonics;
      Mode: Addressing_Mode
  ) return Instruction;


end Instructions; 
