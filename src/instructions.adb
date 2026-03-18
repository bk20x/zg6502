with Sysdefs;
with Ada.Characters.Handling;
package body Instructions is
   function Cpu_Flag_Value (Flag : Cpu_Flag) return Integer is 
   begin
      return Cpu_Flag'Enum_rep(Flag);
   end Cpu_Flag_Value;

   function Affected_Flags (Mnemonic : Opcode_Mnemonics) return Cpu_Flags is --- hmmm, keeping this as a function for now. if end up needing to use the flags alot i should put in another lookup table
   begin
      case Mnemonic is 
         when ADC      => return (Negative | Overflow | Zero | Carry => True, others => False);
         when AND_Op   => return (Negative | Zero => True, others => False);
         when ASL      => return (Negative | Zero | Carry => True, others => False);
         when BIT      => return (Negative | Overflow | Zero => True, others => False);
         when CLC      => return (Carry => True, others => False);
         when CLD      => return (Decimal => True, others => False);
         when CLI      => return (Interrupt_Disable => True, others => False);
         when CLV      => return (Overflow => True, others => False);
         when CPX      => return (Negative | Zero | Carry => True, others => False);
         when CPY      => return (Negative | Zero | Carry => True, others => False);
         when DEC..LDY => return (Negative | Zero => True, others => False);
         when LSR      => return (Negative | Zero | Carry => True, others => False);
         when ORA      => return (Negative | Overflow | Zero => True, others => False);
         when ROL..ROR => return (Negative | Zero | Carry => True, others => False);
         when RTI..RTS => return (Negative..Carry => True);
         when SBC      => return (Negative | Overflow | Zero | Carry => True, others => False);
         when SEC      => return (Carry => True, others => False);
         when SED      => return (Decimal => True, others => False);
         when SEI      => return (Interrupt_Disable => True, others => False);
         when others   => return (others => False); 
      end case;
   end Affected_Flags;


   function Mnemonic_Of_String (Instruction_Name : String) return Mnemonics is
      use Ada.Characters.Handling;
      Name : constant String := To_Upper(Instruction_Name);
   begin
      if Name = "AND" then
         return AND_Op; --- bc AND is a keyword lol.
      else
         return Mnemonics'Value(Name);
      end if;
   exception
      when Constraint_Error =>
         raise Constraint_Error with "Invalid Mnemonic: " & Instruction_Name;
   end Mnemonic_Of_String;

   function Lookup_Instruction (Name : Opcode_Mnemonics; Mode : Addressing_Mode) return Instruction is
      Candidates : constant Instruction_List_Access := Opcodes(Name);
   begin
      for Instr of Candidates.all loop
         if Instr.Mode = Mode then
            return Instr;
         end if;
      end loop;
      raise Constraint_Error with "Invalid addressing mode " & Mode'Image & " for instruction " & Name'Image;
   end Lookup_Instruction;

   function In_Range_For_Mode (Mode : Addressing_Mode; Value : Integer) return Boolean is
      use Sysdefs;
   begin
      case Mode is 
         when Immediate | Zero_Page | Zero_Page_X | Zero_Page_Y | Indirect_X | Indirect_Y => 
               return Value in Data_Value_Range;
         when Absolute | Absolute_X | Absolute_Y | Indirect => 
               return Value in Addr_Value_Range;
         when Relative => 
               return Value in Integer(Integer_8'First) .. Integer(Integer_8'Last);
         when Implied | Accumulator => return False;
      end case;
   end In_Range_For_Mode;
end Instructions;
