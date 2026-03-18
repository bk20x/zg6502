with Ada.Text_IO;  use Ada.Text_IO;
with Instructions; use Instructions;
with Lexing; use Lexing;
procedure Zg6502 is
   Lexer : Assembly_Lexer;
   Input : aliased String := "hello bro hello bro hello bro hello bro";
begin
   Init_Lexer (Lexer  => Lexer, 
               Source => Input'Unchecked_Access);
   while Has_More (Lexer) loop
      Advance (Lexer);
      Put_Line (Lexer.Tok.Kind'Image);
   end loop;
end Zg6502;
