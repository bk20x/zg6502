with Ada.Characters.Latin_1;
package body Lexing is
   procedure Init_Lexer (Lexer : in out Assembly_Lexer; Source : String_Access) is
   begin
      Lexer.Buffer   := Source;
      Lexer.Position := Source.all'First;
      Lexer.Bufsize  := Source.all'Length;
   end Init_Lexer;

   procedure Skip_Whitespace (Lexer : in out Assembly_Lexer) is 
      use Ada.Characters.Latin_1;
      type Whitespace_Chars is range 0..32;
      Pos : Positive := Lexer.Position;
      Buf : constant String_Access := Lexer.Buffer;
   begin
      while Pos < Lexer.Bufsize and then Character'Pos(Buf(Pos)) in Whitespace_Chars loop
         if Buf(Pos) = LF then
            Lexer.Token := (Kind => End_Of_Line);
         end if;
         Pos := Pos + 1;
      end loop;
      Lexer.Position := Pos;
   end Skip_Whitespace;

   procedure Parse_Literal (Lexer : in out Assembly_Lexer; Hex : Boolean := False) is
      Pos   : Positive := Lexer.Position;
      Start : constant Positive := Pos;
   begin
      null;
   end Parse_Literal;
end Lexing;