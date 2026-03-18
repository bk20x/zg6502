with Ada.Text_IO;
package body Inspecting is
   procedure Print_Instruction (Instr : Instructions.Instruction) is
      use Ada.Text_IO;
   begin
      Put_Line ("(OpCode =>" & Instr.Op_Code'Image & "; Mode => " & Instr.Mode'Image & "; Size =>" & Instr.Size'Image & "; Cycles =>" & Instr.Cycles'Image  & ")");
   end Print_Instruction;

   procedure Print_Token (Tok : Lexing.Token) is 
   begin
      null;
   end Print_Token;
end Inspecting;