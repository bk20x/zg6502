with Ada.Text_IO;
package body Inspecting is
   procedure Print_Instruction (Instr : Instruction) is
      use Ada.Text_IO;
   begin
      Put_Line ("(OpCode =>" & Instr.Op_Code'Image & "; Mode => " & Instr.Mode'Image & "; Size =>" & Instr.Size'Image & "; Cycles =>" & Instr.Cycles'Image  & ")");
   end Print_Instruction;
end Inspecting;