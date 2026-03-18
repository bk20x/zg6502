with Lexing;
with Instructions;
package Inspecting is    
   procedure Print_Instruction (Instr : Instructions.Instruction);
   procedure Print_Token (Token : Lexing.Token_Record);
end Inspecting;