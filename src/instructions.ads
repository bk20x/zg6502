with Bytes;
package Instructions is
  use Bytes;
  type Addressing_Mode is (
      Implied,      -- 1
      Accumulator,  -- 1
      Immediate,    -- 2
      Zero_Page,    -- 2
      Zero_Page_X,  -- 2
      Zero_Page_Y,  -- 2
      Relative,     -- 2
      Indirect_X,   -- 2
      Indirect_Y,   -- 2
      Absolute,     -- 3
      Absolute_X,   -- 3
      Absolute_Y,   -- 3
      Indirect      -- 3
   );

  type Instruction_Size_Map is array (Addressing_Mode) of Positive; --- maybe remove this later and just case...
  Instruction_Sizes : constant Instruction_Size_Map := (
      Implied | Accumulator => 1,
      Immediate  | Zero_Page  | Zero_Page_X | Zero_Page_Y
      | Relative | Indirect_X | Indirect_Y => 2,
      others => 3
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
  function Is_Directive(Mnemonic : Mnemonics) return Boolean;
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
  ADC_Instructions : aliased constant Instruction_List := (
      (Op_Code => 16#69#, Mode => Immediate,   Size => Instruction_Sizes(Immediate),   Cycles => 2),
      (Op_Code => 16#65#, Mode => Zero_Page,   Size => Instruction_Sizes(Zero_Page),   Cycles => 3),
      (Op_Code => 16#75#, Mode => Zero_Page_X, Size => Instruction_Sizes(Zero_Page_X), Cycles => 4),
      (Op_Code => 16#6D#, Mode => Absolute,    Size => Instruction_Sizes(Absolute),    Cycles => 4), 
      (Op_Code => 16#7D#, Mode => Absolute_X,  Size => Instruction_Sizes(Absolute_X),  Cycles => 4),
      (Op_Code => 16#79#, Mode => Absolute_Y,  Size => Instruction_Sizes(Absolute_Y),  Cycles => 4),
      (Op_Code => 16#61#, Mode => Indirect_X,  Size => Instruction_Sizes(Indirect_X),  Cycles => 6),
      (Op_Code => 16#71#, Mode => Indirect_Y,  Size => Instruction_Sizes(Indirect_Y),  Cycles => 5)
  );
  LDA_Instructions : aliased constant Instruction_List := (
      (Op_Code => 16#A9#, Mode => Immediate,   Size => Instruction_Sizes(Immediate),   Cycles => 2),
      (Op_Code => 16#A5#, Mode => Zero_Page,   Size => Instruction_Sizes(Zero_Page),   Cycles => 3),
      (Op_Code => 16#B5#, Mode => Zero_Page_X, Size => Instruction_Sizes(Zero_Page_X), Cycles => 4),
      (Op_Code => 16#AD#, Mode => Absolute,    Size => Instruction_Sizes(Absolute),    Cycles => 4),
      (Op_Code => 16#BD#, Mode => Absolute_X,  Size => Instruction_Sizes(Absolute_X),  Cycles => 4),
      (Op_Code => 16#B9#, Mode => Absolute_Y,  Size => Instruction_Sizes(Absolute_Y),  Cycles => 4),
      (Op_Code => 16#A1#, Mode => Indirect_X,  Size => Instruction_Sizes(Indirect_X),  Cycles => 6),
      (Op_Code => 16#B1#, Mode => Indirect_Y,  Size => Instruction_Sizes(Indirect_Y),  Cycles => 5)
  );
  Opcode_Table : constant Mnemonic_Map := (
      ADC    => ADC_Instructions'Access,
      LDA    => LDA_Instructions'Access,
      others => null
  );
  function Lookup_Instruction(
      Name : Mnemonics;
      Mode : Addressing_Mode
  ) return Instruction;
end Instructions; 
