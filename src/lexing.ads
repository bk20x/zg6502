package Lexing is
   type Token_Kind is (
      Mnemonic,    
      Identifier,  -- Labels or symbols
      Literal,     --
      Directive,   -- .dcb
      Immediate,   -- `#` 
      Comma,       
      Open_Paren,  
      Close_Paren, 
      Colon,       
      End_Of_Line, 
      Invalid      
   );
   
   type Token(Kind : Token_Kind := Invalid) is record 
      case Kind is
         when Mnemonic | Identifier | Directive =>
            Name   : String(1 .. 32); 
            Length : Natural;
         when Literal =>
            Value : Integer;
         when others =>
            null;
      end case;
   end record;

   type String_Access is access all String;

   type Assembly_Lexer is record
      Current_Token : Token;
      Position : Positive;
      Bufsize  : Positive;
      Buffer   : String_Access;      
   end record;

   procedure Init_Lexer (Lexer : in out Assembly_Lexer; Source : String_Access);
   procedure Skip_Whitespace (Lexer : in out Assembly_Lexer);
   procedure Parse_Literal (Lexer : in out Assembly_Lexer; Hex : Boolean := False);
end Lexing;
