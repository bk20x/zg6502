with Ada.Characters.Handling;
package body Instructions is
   function Cpu_Flag(Flag : Cpu_Flags) return Integer is 
   begin
      return Cpu_Flags'Enum_rep(Flag);
   end Cpu_Flag;

   function Is_Directive(Mnemonic : Mnemonics) return Boolean is
   begin
      return Mnemonic in DB .. EQU;
   end Is_Directive;

   function Mnemonic_Of_String(Instruction_Name : String) return Mnemonics is
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

   function Lookup_Instruction(Name : Mnemonics; Mode : Addressing_Mode) return Instruction is
      Candidates : constant Instruction_List_Access := Opcode_Table(Name);
   begin
      for Instr of Candidates.all loop
         if Instr.Mode = Mode then
            return Instr;
         end if;
      end loop;
      raise Constraint_Error with "Invalid addressing mode " & Mode'Image & " for instruction " & Name'Image;
   end Lookup_Instruction;
end Instructions;
