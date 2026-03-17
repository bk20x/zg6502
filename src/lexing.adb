with Ada.Characters.Latin_1;
with Ada.Characters.Handling;
with Ada.Text_IO; use Ada.Text_IO;
package body Lexing is
   procedure Init_Lexer (Lexer : in out Assembly_Lexer; Source : String_Access) is
   begin
      Lexer.Buffer  := Source;
      Lexer.Pos     := Source.all'First;
      Lexer.Bufsize := Source.all'Length;
   end Init_Lexer;

   procedure Skip_Whitespace (Lexer : in out Assembly_Lexer) is 
      use Ada.Characters.Latin_1;
      type Whitespace_Chars is range 0..32;
      Buf : constant String_Access := Lexer.Buffer;
   begin
      while Has_More (Lexer) and then Character'Pos(Buf(Lexer.Pos)) in Whitespace_Chars loop
         if Buf(Lexer.Pos) = LF then
            Lexer.Token := (Kind => End_Of_Line);
            exit;
         end if;
         Lexer.Pos := Lexer.Pos + 1;
      end loop;
   end Skip_Whitespace;

   procedure Parse_Literal (Lexer : in out Assembly_Lexer; Hex : Boolean := False) is
      use Ada.Characters.Handling;
      subtype Hex_Chars is Character range 'A'..'F';
      subtype Hex_Digits is Character range '0'..'9';
      Buf    : constant String_Access := Lexer.Buffer;
      Result : Integer := 0;
      Hex_Int: Integer := 0;
      C      : Character;
   begin
      if Hex then
         while Has_More (Lexer) loop
            C := To_Upper(Buf(Lexer.Pos));
            if C in Hex_Chars | Hex_Digits then
               Hex_Int := Parse_Hex_Int(C); --- later check if it is Invalid_Hex_Integer and report to user when i start tracking some more useful stuff like line no
               Result  := (Result * 16) + Hex_Int;
               Lexer.Pos := Lexer.Pos + 1;
            else
               exit;
            end if;
         end loop;
      else
         while Has_More (Lexer) loop
            C := Buf(Lexer.Pos);
            if C in Hex_Digits then
               Result := (Result * 10) + (Character'Pos(C) - Character'Pos('0'));
               Lexer.Pos := Lexer.Pos + 1;
            else
               exit;
            end if;
         end loop;
      end if;
      Lexer.Token := (Kind => Literal, Value => Result);
   end Parse_Literal;
end Lexing;