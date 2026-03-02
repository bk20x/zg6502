with Ada.Text_IO;  use Ada.Text_IO;
with Instructions; use Instructions;
pragma Elaborate_All (Instructions);
procedure Zg6502 is
   L : constant Opcode_Mnemonic := LDA;
   I : constant Instruction := Lookup_Instruction (Name => L, Mode => Indirect_X);
begin
   Put_Line(I.Op_Code'Image);
end Zg6502;
