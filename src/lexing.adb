with Ada.Characters.Latin_1;
with Ada.Characters.Handling;
package body Lexing is
   procedure Inc (I : in out Integer; By : Integer := 1) is 
   begin
      I := I + By;
   end Inc;

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
            Lexer.Tok := (Kind => End_Of_Line);
            exit;
         end if;
         Lexer.Pos := Lexer.Pos + 1;
      end loop;
   end Skip_Whitespace;

   procedure Parse_Literal (Lexer : in out Assembly_Lexer; Hex : Boolean := False) is
      use Ada.Characters.Handling;
      Buf    : constant String_Access := Lexer.Buffer;
      Result : Integer := 0;
      C      : Character;
   begin
      if Hex then
         while Has_More (Lexer) loop
            C := To_Upper (Buf(Lexer.Pos));
            if C in Hex_Chars | Digit_Chars then               
               Result := (Result * 16) + Parse_Hex_Int(C); 
               Lexer.Pos := Lexer.Pos + 1;
            else
               exit;
            end if;
         end loop;
      else
         while Has_More (Lexer) loop
            C := Buf(Lexer.Pos);
            if C in Digit_Chars then
               Result := (Result * 10) + (Character'Pos(C) - Character'Pos('0'));
               Lexer.Pos := Lexer.Pos + 1;
            else
               exit;
            end if;
         end loop;
      end if;
      Lexer.Tok := (Kind => Literal, Value => Result);
   end Parse_Literal;

   procedure Parse_Symbol (Lexer : in out Assembly_Lexer) is
      use Ada.Characters.Handling;
      Start  : constant Positive := Lexer.Pos;
      Buf    : constant String_Access := Lexer.Buffer;
      Result : String_32 := (others => ' ');
      Length : Natural := 0;
      C      : Character;
   begin
      while Has_More (Lexer) and then Length <= Result'Last loop
         C := To_Upper (Buf (Lexer.Pos));
         if C in Symbol_Chars then
            Lexer.Pos := Lexer.Pos + 1;
            Length := Lexer.Pos - Start;
            Result(Length) := C;
         else 
            exit;
         end if;         
      end loop;
      Lexer.Tok := (Kind => Identifier, Name => Result, Length => Length);
   end Parse_Symbol;


   procedure Advance (Lexer : in out Assembly_Lexer) is 
      use Ada.Characters.Handling;
      use Ada.Characters.Latin_1;
      Buf : constant String_Access := Lexer.Buffer;
   begin
      Skip_Whitespace (Lexer);
      case To_Upper (Buf (Lexer.Pos)) is 
         when '#'          => 
            Inc(Lexer.Pos);
            Lexer.Tok := (Kind => Hash);
         when ':'          => 
            Inc(Lexer.Pos);
            Lexer.Tok := (Kind => Colon);
         when ','          => 
            Inc(Lexer.Pos);
            Lexer.Tok := (Kind => Comma);
         when '('          => 
            Inc(Lexer.Pos);
            Lexer.Tok := (Kind => Open_Paren);
         when ')'          => 
            Inc(Lexer.Pos);
            Lexer.Tok := (Kind => Close_Paren);
         when '$' => 
            Inc(Lexer.Pos);
            Parse_Literal (Lexer, Hex => True);
         when Symbol_Chars => Parse_Symbol (Lexer);
         when Digit_Chars  => Parse_Literal (Lexer);
         when others => Lexer.Tok := (Kind => Invalid);
      end case;
   end Advance;
end Lexing;