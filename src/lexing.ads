package Lexing is pragma Preelaborate;
   type Token_Kind is (
      Identifier,  -- Labels or symbols or Mnemonics
      Literal,     --
      Directive,   -- .dcb, !dcb
      Hash,   -- `#` for immediate mode  addressing
      Comma,       
      Open_Paren,  
      Close_Paren, 
      Colon,       
      End_Of_Line, 
      End_Of_File,
      Error,
      Invalid      
   );
   type Whitespace_Chars is range 0..32;
   subtype Symbol_Chars  is Character range 'A'..'Z';
   subtype Hex_Chars     is Character range 'A'..'F';
   subtype Digit_Chars   is Character range '0'..'9';
   subtype String_32     is String (1..32);
   subtype String_64     is String (1..64);
   type Token (Kind : Token_Kind := Invalid) is record 
      case Kind is
         when Identifier | Directive =>
            Name   : String_32; 
            Length : Positive;
         when Error => 
            Message : String_64;
            Msg_Len : Positive;
         when Literal =>
            Value : Integer;
         when others =>
            null;
      end case;
   end record;

   type String_Access is access all String;   
   type Assembly_Lexer is record
      Tok     : Token;
      Pos     : Positive;
      Bufsize : Positive;
      Line    : Positive;
      Buffer  : String_Access;      
   end record;
   procedure Inc (I : in out Integer; By : Integer := 1);
   procedure Init_Lexer (Lexer : in out Assembly_Lexer; Source : String_Access);
   procedure Skip_Whitespace (Lexer : in out Assembly_Lexer);
   procedure Advance (Lexer : in out Assembly_Lexer);
   procedure Parse_Literal (Lexer : in out Assembly_Lexer; Hex : Boolean := False);
   procedure Parse_Symbol  (Lexer : in out Assembly_Lexer);
   function  Has_More (Lexer : in Assembly_Lexer) return Boolean is
      (Lexer.Pos <= Lexer.Bufsize);

   Invalid_Hex_Integer : constant Integer := -1;
   function Parse_Hex_Int (C : Character) return Integer is
      (case C is
       when '0' .. '9' => Character'Pos(C) - Character'Pos('0'),
       when 'A' .. 'F' => Character'Pos(C) - Character'Pos('A') + 10,
       when 'a' .. 'f' => Character'Pos(C) - Character'Pos('a') + 10,
       when others     => Invalid_Hex_Integer);
end Lexing;
