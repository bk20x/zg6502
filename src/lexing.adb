with System;
package body Lexing is
   procedure Init_Lexer (Lexer : in out Assembly_Lexer; Source : String_Access) is
   begin
      Lexer.Buffer   := Source;
      Lexer.Position := Source.all'First;
      Lexer.Bufsize  := Source.all'Length;
   end Init_Lexer;

   procedure Skip_Whitespace (Lexer : in out Assembly_Lexer) is 
      type Whitespace_Range is range 0..32;
      Pos : Positive := Lexer.Position;
      Buf : constant String_Access := Lexer.Buffer;
   begin
      while Pos < Lexer.Bufsize and Character'Pos(Buf(Pos)) in Whitespace_Range loop
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