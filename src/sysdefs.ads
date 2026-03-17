package Sysdefs is pragma Pure;
   subtype Data_Value_Range is Integer range 0..255;
   subtype Addr_Value_Range is Integer range 0..65_535;
   Max_Value : constant Integer := Addr_Value_Range'Last;
end Sysdefs;