with Bytes;
package Instructions is pragma Preelaborate;
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
   Implied_Size     : constant := 1;
   Accumulator_Size : constant := 1;
   Immediate_Size   : constant := 2;
   Zero_Page_Size   : constant := 2;
   Zero_Page_X_Size : constant := 2;
   Zero_Page_Y_Size : constant := 2;
   Relative_Size    : constant := 2;
   Indirect_X_Size  : constant := 2;
   Indirect_Y_Size  : constant := 2;
   Absolute_Size    : constant := 3;
   Absolute_X_Size  : constant := 3;
   Absolute_Y_Size  : constant := 3;
   Indirect_Size    : constant := 3;
   type Cpu_Flag is (
      Negative,
      Overflow,
      B0,
      B1,
      Decimal,
      Interrupt_Disable,
      Zero,
      Carry
   );
   for Cpu_Flag use (
      Negative => 16#01#,
      Overflow => 16#02#,
      B0       => 16#04#,
      B1       => 16#08#,
      Decimal  => 16#10#,
      Interrupt_Disable => 16#20#,
      Zero              => 16#40#,
      Carry             => 16#80#
   ); 
   type Cpu_Flags is array (Cpu_Flag) of Boolean with Pack;
   function Cpu_Flag_Value (Flag: Cpu_Flag) return Integer;
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
   subtype Opcode_Mnemonics is Mnemonics range ADC .. TYA;
   function Is_Directive (Mnemonic : Mnemonics) return Boolean;
   function Affected_Flags (Mnemonic : Opcode_Mnemonics) return Cpu_Flags;
   function Mnemonic_Of_String (Instruction_Name : String) return Mnemonics;
   type Instruction is record
      Op_Code  : Byte;
      Mode     : Addressing_Mode;
      Size     : Byte;     
      Cycles   : Positive;
   end record;
   type Instruction_List is array (Positive range <>) of Instruction;
   type Instruction_List_Access is access constant Instruction_List;
   type Opcode_Table is array (Opcode_Mnemonics) of not null Instruction_List_Access;
   ADC_Instructions : aliased constant Instruction_List := (
      (Op_Code => 16#69#, Mode => Immediate,   Size => Immediate_Size,   Cycles => 2),
      (Op_Code => 16#65#, Mode => Zero_Page,   Size => Zero_Page_Size,   Cycles => 3),
      (Op_Code => 16#75#, Mode => Zero_Page_X, Size => Zero_Page_X_Size, Cycles => 4),
      (Op_Code => 16#6D#, Mode => Absolute,    Size => Absolute_Size,    Cycles => 4), 
      (Op_Code => 16#7D#, Mode => Absolute_X,  Size => Absolute_X_Size,  Cycles => 4),
      (Op_Code => 16#79#, Mode => Absolute_Y,  Size => Absolute_Y_Size,  Cycles => 4),
      (Op_Code => 16#61#, Mode => Indirect_X,  Size => Indirect_X_Size,  Cycles => 6),
      (Op_Code => 16#71#, Mode => Indirect_Y,  Size => Indirect_Y_Size,  Cycles => 5)
   );
   AND_Instructions : aliased constant Instruction_List := (
      (Op_Code => 16#29#, Mode => Immediate,   Size => Immediate_Size,   Cycles => 2),
      (Op_Code => 16#25#, Mode => Zero_Page,   Size => Zero_Page_Size,   Cycles => 3),
      (Op_Code => 16#35#, Mode => Zero_Page_X, Size => Zero_Page_X_Size, Cycles => 4),
      (Op_Code => 16#2D#, Mode => Absolute,    Size => Absolute_Size,    Cycles => 4),
      (Op_Code => 16#3D#, Mode => Absolute_X,  Size => Absolute_X_Size,  Cycles => 4),
      (Op_Code => 16#39#, Mode => Absolute_Y,  Size => Absolute_Y_Size,  Cycles => 4),
      (Op_Code => 16#21#, Mode => Indirect_X,  Size => Indirect_X_Size,  Cycles => 6),
      (Op_Code => 16#31#, Mode => Indirect_Y,  Size => Indirect_Y_Size,  Cycles => 5)
   );
   ASL_Instructions : aliased constant Instruction_List := (
      (Op_Code => 16#0A#, Mode => Accumulator, Size => Accumulator_Size, Cycles => 2),
      (Op_Code => 16#06#, Mode => Zero_Page,   Size => Zero_Page_Size,   Cycles => 5),
      (Op_Code => 16#16#, Mode => Zero_Page_X, Size => Zero_Page_X_Size, Cycles => 6),
      (Op_Code => 16#0E#, Mode => Absolute,    Size => Absolute_Size,    Cycles => 6),
      (Op_Code => 16#1E#, Mode => Absolute_X,  Size => Absolute_X_Size,  Cycles => 7)
   );
   BCC_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#90#, Mode => Relative, Size => Relative_Size, Cycles => 1)
   );
   BCS_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#B0#, Mode => Relative, Size => Relative_Size, Cycles => 1)
   );
   BEQ_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#F0#, Mode => Relative, Size => Relative_Size, Cycles => 1)
   );
   BIT_Instructions : aliased constant Instruction_List := (
      (Op_Code => 16#24#, Mode => Zero_Page, Size => Zero_Page_Size, Cycles => 3),
      (Op_Code => 16#2C#, Mode => Absolute,  Size => Absolute_Size,  Cycles => 3)
   );
   BMI_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#30#, Mode => Relative, Size => Relative_Size, Cycles => 1)
   );
   BNE_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#D0#, Mode => Relative, Size => Relative_Size, Cycles => 1)
   );
   BPL_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#10#, Mode => Relative, Size => Relative_Size, Cycles => 1)
   );
   BRK_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#00#, Mode => Implied, Size => Implied_Size + 1, Cycles => 7) --- 1 byte padding for break mark
   );
   BVC_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#50#, Mode => Relative, Size => Relative_Size, Cycles => 1)
   );
   BVS_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#70#, Mode => Relative, Size => Relative_Size, Cycles => 1)
   );
   CLC_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#18#, Mode => Implied, Size => Implied_Size, Cycles => 2)
   );
   CLD_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#D8#, Mode => Implied, Size => Implied_Size, Cycles => 2)
   );
   CLI_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#58#, Mode => Implied, Size => Implied_Size, Cycles => 2)
   );
   CLV_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#B8#, Mode => Implied, Size => Implied_Size, Cycles => 2)
   );
   CMP_Instructions : aliased constant Instruction_List := (
      (Op_Code => 16#C9#, Mode => Immediate,   Size => Immediate_Size,   Cycles => 2),
      (Op_Code => 16#C5#, Mode => Zero_Page,   Size => Zero_Page_Size,   Cycles => 3),
      (Op_Code => 16#D5#, Mode => Zero_Page_X, Size => Zero_Page_X_Size, Cycles => 4),
      (Op_Code => 16#CD#, Mode => Absolute,    Size => Absolute_Size,    Cycles => 4),
      (Op_Code => 16#DD#, Mode => Absolute_X,  Size => Absolute_X_Size,  Cycles => 4),
      (Op_Code => 16#D9#, Mode => Absolute_Y,  Size => Absolute_Y_Size,  Cycles => 4),
      (Op_Code => 16#C1#, Mode => Indirect_X,  Size => Indirect_X_Size,  Cycles => 6),
      (Op_Code => 16#D1#, Mode => Indirect_Y,  Size => Indirect_Y_Size,  Cycles => 5)
   );
   CPX_Instructions : aliased constant Instruction_List := (
      (Op_Code => 16#E0#, Mode => Immediate, Size => Immediate_Size, Cycles => 2),
      (Op_Code => 16#E4#, Mode => Zero_Page, Size => Zero_Page_Size, Cycles => 3),
      (Op_Code => 16#EC#, Mode => Absolute,  Size => Absolute_Size,  Cycles => 4)
   );
   CPY_Instructions : aliased constant Instruction_List := (
      (Op_Code => 16#C0#, Mode => Immediate, Size => Immediate_Size, Cycles => 2),
      (Op_Code => 16#C4#, Mode => Zero_Page, Size => Zero_Page_Size, Cycles => 3),
      (Op_Code => 16#CC#, Mode => Absolute,  Size => Absolute_Size,  Cycles => 4)
   );
   DEC_Instructions : aliased constant Instruction_List := (
      (Op_Code => 16#C6#, Mode => Zero_Page,   Size => Zero_Page_Size,   Cycles => 5),
      (Op_Code => 16#D6#, Mode => Zero_Page_X, Size => Zero_Page_X_Size, Cycles => 6),
      (Op_Code => 16#CE#, Mode => Absolute,    Size => Absolute_Size,    Cycles => 6),
      (Op_Code => 16#DE#, Mode => Absolute_X,  Size => Absolute_X_Size,  Cycles => 7)
   );
   DEX_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#CA#, Mode => Implied, Size => Implied_Size, Cycles => 2)
   );
   DEY_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#88#, Mode => Implied, Size => Implied_Size, Cycles => 2)
   );
   EOR_Instructions : aliased constant Instruction_List := (
      (Op_Code => 16#49#, Mode => Immediate,   Size => Immediate_Size,   Cycles => 2),
      (Op_Code => 16#45#, Mode => Zero_Page,   Size => Zero_Page_Size,   Cycles => 3),
      (Op_Code => 16#55#, Mode => Zero_Page_X, Size => Zero_Page_X_Size, Cycles => 4),
      (Op_Code => 16#4D#, Mode => Absolute,    Size => Absolute_Size,    Cycles => 4),
      (Op_Code => 16#5D#, Mode => Absolute_X,  Size => Absolute_X_Size,  Cycles => 4),
      (Op_Code => 16#59#, Mode => Absolute_Y,  Size => Absolute_Y_Size,  Cycles => 4),
      (Op_Code => 16#41#, Mode => Indirect_X,  Size => Indirect_X_Size,  Cycles => 6),
      (Op_Code => 16#51#, Mode => Indirect_Y,  Size => Indirect_Y_Size,  Cycles => 5)
   );
   INC_Instructions : aliased constant Instruction_List := (
      (Op_Code => 16#E6#, Mode => Zero_Page,   Size => Zero_Page_Size,   Cycles => 5),
      (Op_Code => 16#F6#, Mode => Zero_Page_X, Size => Zero_Page_X_Size, Cycles => 6),
      (Op_Code => 16#EE#, Mode => Absolute,    Size => Absolute_Size,    Cycles => 6),
      (Op_Code => 16#FE#, Mode => Absolute_X,  Size => Absolute_X_Size,  Cycles => 7)
   );
   INX_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#E8#, Mode => Implied, Size => Implied_Size, Cycles => 2)
   );
   INY_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#C8#, Mode => Implied, Size => Implied_Size, Cycles => 2)
   );
   JMP_Instructions : aliased constant Instruction_List := (
      (Op_Code => 16#4C#, Mode => Absolute, Size => Absolute_Size, Cycles => 3),
      (Op_Code => 16#6C#, Mode => Indirect, Size => Indirect_Size, Cycles => 5)
   );
   JSR_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#20#, Mode => Absolute, Size => Absolute_Size, Cycles => 6)
   );
   LDA_Instructions : aliased constant Instruction_List := (
      (Op_Code => 16#A9#, Mode => Immediate,   Size => Immediate_Size,   Cycles => 2),
      (Op_Code => 16#A5#, Mode => Zero_Page,   Size => Zero_Page_Size,   Cycles => 3),
      (Op_Code => 16#B5#, Mode => Zero_Page_X, Size => Zero_Page_X_Size, Cycles => 4),
      (Op_Code => 16#AD#, Mode => Absolute,    Size => Absolute_Size,    Cycles => 4),
      (Op_Code => 16#BD#, Mode => Absolute_X,  Size => Absolute_X_Size,  Cycles => 4),
      (Op_Code => 16#B9#, Mode => Absolute_Y,  Size => Absolute_Y_Size,  Cycles => 4),
      (Op_Code => 16#A1#, Mode => Indirect_X,  Size => Indirect_X_Size,  Cycles => 6),
      (Op_Code => 16#B1#, Mode => Indirect_Y,  Size => Indirect_Y_Size,  Cycles => 5)
   );
   LDX_Instructions : aliased constant Instruction_List := (
      (Op_Code => 16#A2#, Mode => Immediate,   Size => Immediate_Size,   Cycles => 2),
      (Op_Code => 16#A6#, Mode => Zero_Page,   Size => Zero_Page_Size,   Cycles => 3),
      (Op_Code => 16#B6#, Mode => Zero_Page_Y, Size => Zero_Page_Y_Size, Cycles => 4),
      (Op_Code => 16#AE#, Mode => Absolute,    Size => Absolute_Size,    Cycles => 4),
      (Op_Code => 16#BE#, Mode => Absolute_Y,  Size => Absolute_Y_Size,  Cycles => 4)
   );
   LDY_Instructions : aliased constant Instruction_List := (
      (Op_Code => 16#A0#, Mode => Immediate,   Size => Immediate_Size,   Cycles => 2),
      (Op_Code => 16#A4#, Mode => Zero_Page,   Size => Zero_Page_Size,   Cycles => 3),
      (Op_Code => 16#B4#, Mode => Zero_Page_X, Size => Zero_Page_X_Size, Cycles => 4),
      (Op_Code => 16#AC#, Mode => Absolute,    Size => Absolute_Size,    Cycles => 4),
      (Op_Code => 16#BC#, Mode => Absolute_X,  Size => Absolute_X_Size,  Cycles => 4)
   );
   LSR_Instructions : aliased constant Instruction_List := (
      (Op_Code => 16#4A#, Mode => Accumulator, Size => Accumulator_Size, Cycles => 2),
      (Op_Code => 16#46#, Mode => Zero_Page,   Size => Zero_Page_Size,   Cycles => 5),
      (Op_Code => 16#56#, Mode => Zero_Page_X, Size => Zero_Page_X_Size, Cycles => 6),
      (Op_Code => 16#4E#, Mode => Absolute,    Size => Absolute_Size,    Cycles => 6),
      (Op_Code => 16#5E#, Mode => Absolute_X,  Size => Absolute_X_Size,  Cycles => 7)
   );
   NOP_Instructions : aliased constant Instruction_List := (
       1 => (Op_Code => 16#EA#, Mode => Implied, Size => Implied_Size, Cycles => 2)
   );
   ORA_Instructions : aliased constant Instruction_List := (
      (Op_code => 16#09#, Mode => Immediate,   Size => Immediate_Size,   Cycles => 2),
      (Op_Code => 16#05#, Mode => Zero_Page,   Size => Zero_Page_Size,   Cycles => 3),
      (Op_Code => 16#15#, Mode => Zero_Page_X, Size => Zero_Page_X_Size, Cycles => 4),
      (Op_Code => 16#0D#, Mode => Absolute,    Size => Absolute_Size,    Cycles => 4),
      (Op_Code => 16#1D#, Mode => Absolute_X,  Size => Absolute_X_Size,  Cycles => 4),
      (Op_Code => 16#19#, Mode => Absolute_Y,  Size => Absolute_Y_Size,  Cycles => 4),
      (Op_Code => 16#01#, Mode => Indirect_X,  Size => Indirect_X_Size,  Cycles => 6),
      (Op_code => 16#11#, Mode => Indirect_Y,  Size => Indirect_Y_Size,  Cycles => 5)
   );
   PHA_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#48#, Mode => Implied, Size => Implied_Size, Cycles => 3)
   );
   PHP_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#08#, Mode => Implied, Size => Implied_Size, Cycles => 3)
   );
   PLA_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#68#, Mode => Implied, Size => Implied_Size, Cycles => 4)
   );
   PLP_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#28#, Mode => Implied, Size => Implied_Size, Cycles => 4)
   );
   ROL_Instructions : aliased constant Instruction_List := (
      (Op_Code => 16#2A#, Mode => Accumulator, Size => Accumulator_Size, Cycles => 2),
      (Op_Code => 16#26#, Mode => Zero_Page,   Size => Zero_Page_Size,   Cycles => 5),
      (Op_Code => 16#36#, Mode => Zero_Page_X, Size => Zero_Page_X_Size, Cycles => 6),
      (Op_Code => 16#2E#, Mode => Absolute,    Size => Absolute_Size,    Cycles => 6),
      (Op_Code => 16#3E#, Mode => Absolute_X,  Size => Absolute_X_Size,  Cycles => 7)
   );
   ROR_Instructions : aliased constant Instruction_List := (
      (Op_Code => 16#6A#, Mode => Accumulator, Size => Accumulator_Size, Cycles => 2),
      (Op_Code => 16#66#, Mode => Zero_Page,   Size => Zero_Page_Size,   Cycles => 5),
      (Op_Code => 16#76#, Mode => Zero_Page_X, Size => Zero_Page_X_Size, Cycles => 6),
      (Op_Code => 16#6E#, Mode => Absolute,    Size => Absolute_Size,    Cycles => 6),
      (Op_Code => 16#7E#, Mode => Absolute_X,  Size => Absolute_X_Size,  Cycles => 7)
   );
   RTI_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#40#, Mode => Implied, Size => Implied_Size, Cycles => 6)
   );
   RTS_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#60#, Mode => Implied, Size => Implied_Size, Cycles => 6)
   );
   SBC_Instructions : aliased constant Instruction_List := (
      (Op_Code => 16#E9#, Mode => Immediate,   Size => Immediate_Size,   Cycles => 2),
      (Op_Code => 16#E5#, Mode => Zero_Page,   Size => Zero_Page_Size,   Cycles => 3),
      (Op_Code => 16#F5#, Mode => Zero_Page_X, Size => Zero_Page_X_Size, Cycles => 4),
      (Op_Code => 16#ED#, Mode => Absolute,    Size => Absolute_Size,    Cycles => 4),
      (Op_Code => 16#FD#, Mode => Absolute_X,  Size => Absolute_X_Size,  Cycles => 4),
      (Op_Code => 16#F9#, Mode => Absolute_Y,  Size => Absolute_Y_Size,  Cycles => 4),
      (Op_Code => 16#E1#, Mode => Indirect_X,  Size => Indirect_X_Size,  Cycles => 6),
      (Op_Code => 16#F1#, Mode => Indirect_Y,  Size => Indirect_Y_Size,  Cycles => 5)
   );
   SEC_Instructions : aliased constant Instruction_List := (
       1 => (Op_Code => 16#38#, Mode => Implied, Size => Implied_Size, Cycles => 2)
   );
   SED_Instructions : aliased constant Instruction_List := (
       1 => (Op_Code => 16#F8#, Mode => Implied, Size => Implied_Size, Cycles => 2)
   );
   SEI_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#78#, Mode => Implied, Size => Implied_Size, Cycles => 2)
   );
   STA_Instructions : aliased constant Instruction_List := (
      (Op_Code => 16#85#, Mode => Zero_Page,   Size => Zero_Page_Size,   Cycles => 3),
      (Op_Code => 16#95#, Mode => Zero_Page_X, Size => Zero_Page_X_Size, Cycles => 4),
      (Op_Code => 16#8D#, Mode => Absolute,    Size => Absolute_Size,    Cycles => 4),
      (Op_Code => 16#9D#, Mode => Absolute_X,  Size => Absolute_X_Size,  Cycles => 5),
      (Op_Code => 16#99#, Mode => Absolute_Y,  Size => Absolute_Y_Size,  Cycles => 5),
      (Op_Code => 16#81#, Mode => Indirect_X,  Size => Indirect_X_Size,  Cycles => 6),
      (Op_Code => 16#91#, Mode => Indirect_Y,  Size => Indirect_Y_Size,  Cycles => 6)
   );
   STX_Instructions : aliased constant Instruction_List := (
      (Op_Code => 16#86#, Mode => Zero_Page,   Size => Zero_Page_Size,   Cycles => 3),
      (Op_Code => 16#96#, Mode => Zero_Page_Y, Size => Zero_Page_Y_Size, Cycles => 4),
      (Op_Code => 16#8E#, Mode => Absolute,    Size => Absolute_Size,    Cycles => 4)
   );
   STY_Instructions : aliased constant Instruction_List := (
      (Op_Code => 16#84#, Mode => Zero_Page,   Size => Zero_Page_Size,   Cycles => 3),
      (Op_Code => 16#94#, Mode => Zero_Page_X, Size => Zero_Page_X_Size, Cycles => 4),
      (Op_Code => 16#8C#, Mode => Absolute,    Size => Absolute_Size,    Cycles => 4)
   );
   TAX_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#AA#, Mode => Implied, Size => Implied_Size, Cycles => 2)
   );
   TAY_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#A8#, Mode => Implied, Size => Implied_Size, Cycles => 2)
   );
   TSX_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#BA#, Mode => Implied, Size => Implied_Size, Cycles => 2)
   );
   TXA_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#8A#, Mode => Implied, Size => Implied_Size, Cycles => 2)
   );
   TXS_Instructions : aliased constant Instruction_List := (
      1 => (Op_Code => 16#9A#, Mode => Implied, Size => Implied_Size, Cycles => 2)
   );
   TYA_Instructions : aliased constant Instruction_List := (
       1 => (Op_Code => 16#98#, Mode => Implied, Size => Implied_Size, Cycles => 2)
   );
   Opcodes : constant Opcode_Table := (
      ADC    => ADC_Instructions'Access,
      AND_Op => AND_Instructions'Access,
      ASL    => ASL_Instructions'Access,
      BCC    => BCC_Instructions'Access,
      BCS    => BCS_Instructions'Access,
      BEQ    => BEQ_Instructions'Access,
      BIT    => BIT_Instructions'Access,
      BMI    => BMI_Instructions'Access,
      BNE    => BNE_Instructions'Access,
      BPL    => BPL_Instructions'Access,
      BRK    => BRK_Instructions'Access,
      BVC    => BVC_Instructions'Access,
      BVS    => BVS_Instructions'Access,
      CLC    => CLC_Instructions'Access,
      CLD    => CLD_Instructions'Access,
      CLI    => CLI_Instructions'Access,
      CLV    => CLV_Instructions'Access,
      CMP    => CMP_Instructions'Access,
      CPX    => CPX_Instructions'Access,
      CPY    => CPY_Instructions'Access,
      DEC    => DEC_Instructions'Access,
      DEX    => DEX_Instructions'Access,
      DEY    => DEY_Instructions'Access,
      EOR    => EOR_Instructions'Access,
      INC    => INC_Instructions'Access,
      INX    => INX_Instructions'Access,
      INY    => INY_Instructions'Access,
      JMP    => JMP_Instructions'Access,
      JSR    => JSR_Instructions'Access,
      LDA    => LDA_Instructions'Access,
      LDX    => LDX_Instructions'Access,
      LDY    => LDY_Instructions'Access,
      LSR    => LSR_Instructions'Access,
      NOP    => NOP_Instructions'Access,
      ORA    => ORA_Instructions'Access,
      PHA    => PHA_Instructions'Access,
      PHP    => PHP_Instructions'Access,
      PLA    => PLA_Instructions'Access,
      PLP    => PLP_Instructions'Access,
      ROL    => ROL_Instructions'Access,
      ROR    => ROR_Instructions'Access,
      RTI    => RTI_Instructions'Access,
      RTS    => RTS_Instructions'Access,
      SBC    => SBC_Instructions'Access,
      SEC    => SEC_Instructions'Access,
      SED    => SED_Instructions'Access,
      SEI    => SEI_Instructions'Access,
      STA    => STA_Instructions'Access,
      STX    => STX_Instructions'Access,
      STY    => STY_Instructions'Access,
      TAX    => TAX_Instructions'Access,
      TAY    => TAY_Instructions'Access,
      TSX    => TSX_Instructions'Access,
      TXA    => TXA_Instructions'Access,
      TXS    => TXS_Instructions'Access,
      TYA    => TYA_Instructions'Access
   );  
   function Lookup_Instruction (
      Name : Opcode_Mnemonics;
      Mode : Addressing_Mode
   ) return Instruction;
end Instructions; 
