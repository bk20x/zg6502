with Ada.Text_IO;  use Ada.Text_IO;
with Instructions; use Instructions;
with Lexing; use Lexing;
procedure Zg6502 is
   Lexer : Assembly_Lexer;
   str : aliased String := "Yoben Broben!";
   
begin
   Init_Lexer (Lexer => Lexer, Source => str'Unchecked_Access);

end Zg6502;
