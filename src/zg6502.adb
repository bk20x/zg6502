with Ada.Text_IO;  use Ada.Text_IO;
with Instructions; use Instructions;
with Lexing; use Lexing;
procedure Zg6502 is
   Lexer : Assembly_Lexer;
   Input : aliased String := "hello bro";
begin
   Init_Lexer (Lexer => Lexer, Source => Input'Unchecked_Access);
   Parse_Symbol (Lexer);
   Put_Line (Lexer.Token.Name);
   Skip_Whitespace (Lexer);
   Parse_Symbol (Lexer);
   Put_Line (Lexer.Token.Name);
end Zg6502;
