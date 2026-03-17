with Ada.Text_IO;  use Ada.Text_IO;
with Instructions; use Instructions;
with Lexing; use Lexing;
procedure Zg6502 is
   Lexer : Assembly_Lexer;
   str : aliased String := "0FFF";
begin
   Init_Lexer (Lexer => Lexer, Source => str'Unchecked_Access);
   Parse_Literal (Lexer, Hex => True);
   Put_Line(Lexer.Token.Value'Image);
end Zg6502;
