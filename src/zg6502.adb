with Ada.Text_IO;  use Ada.Text_IO;
with Instructions; use Instructions;
procedure Zg6502 is
   I : constant Instruction := Lookup_Instruction (Name => LDA, Mode => Indirect_X);
begin
   Put_Line(I.Op_Code'Image);
end Zg6502;
