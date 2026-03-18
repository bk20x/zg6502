with Ada.Text_IO;  use Ada.Text_IO;
with Instructions; use Instructions;
with Lexing; use Lexing;
procedure Zg6502 is
   Lexer : Assembly_Lexer;
   Input : aliased String := "yobeertoyobeertoyobeertoyobeertoo";
begin
   Init_Lexer (Lexer  => Lexer, 
               Source => Input'Unchecked_Access);
   while Has_More (Lexer) loop
      Advance (Lexer);
      if Lexer.Tok.Kind = Error then 
         Put_Line(Lexer.Tok.Message(1..Lexer.Tok.Msg_Len));
      end if;
      Put_Line (Lexer.Tok.Kind'Image);
   end loop;
end Zg6502;
