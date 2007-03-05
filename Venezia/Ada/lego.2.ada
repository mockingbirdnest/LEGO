package body Lego is

    type Ldraw_Id is range 0 .. 511;
    type Rgb_Intensity is range 0 .. 255;

    type Color_Definition is
        record
            Ldraw            : Ldraw_Id;
            Transparent      : Boolean;
            Red, Green, Blue : Rgb_Intensity;
        end record;

    Clear_Id : constant Ldraw_Id := 47;
    None     : Ldraw_Id renames Clear_Id;

    Color_Definitions : array (Color) of Color_Definition :=
       (Bright_Pink => (Ldraw => None,
                        Transparent => False,
                        Red => 16#F3#, -- BrickLink
                        Green => 16#9A#,
                        Blue => 16#C2#),
        Brown => (Ldraw => 6,
                  Transparent => False,
                  Red => 92,
                  Green => 32,
                  Blue => 0),
        Clear => (Ldraw => Clear_Id,
                  Transparent => True,
                  Red => 255,
                  Green => 255,
                  Blue => 255),
        Dark_Orange => (Ldraw => 484,
                        Transparent => False,
                        Red => 179,
                        Green => 62,
                        Blue => 0),
        Dark_Red => (Ldraw => 320,
                     Transparent => False,
                     Red => 120,
                     Green => 0,
                     Blue => 28),
        Light_Orange => (Ldraw => None,
                         Transparent => False,
                         Red => 16#F7#, -- BrickLink
                         Green => 16#AD#,
                         Blue => 16#63#),
        Light_Pink => (Ldraw => None,
                       Transparent => False,
                       Red => 16#DC#, -- Peeron
                       Green => 16#90#,
                       Blue => 16#95#),
        Magenta => (Ldraw => 26,
                    Transparent => False,
                    Red => 16#D8#,
                    Green => 16#1B#,
                    Blue => 16#6D#),
        Medium_Orange => (Ldraw => 462,
                          Transparent => False,
                          Red => 16#FE#,
                          Green => 16#9F#,
                          Blue => 16#06#),
        Orange => (Ldraw => 25,
                   Transparent => False,
                   Red => 16#F9#,
                   Green => 16#60#,
                   Blue => 16#00#),
        Pink => (Ldraw => 13,
                 Transparent => False,
                 Red => 16#F9#,
                 Green => 16#A4#,
                 Blue => 16#C5#),
        Red => (Ldraw => 4,
                Transparent => False,
                Red => 196,
                Green => 0,
                Blue => 38),
        Reddish_Brown => (Ldraw => 70,
                          Transparent => False,
                          Red => 16#69#,
                          Green => 16#40#,
                          Blue => 16#27#),
        Sand_Red => (Ldraw => 335,
                     Transparent => False,
                     Red => 191,
                     Green => 135,
                     Blue => 130),
        Tan => (Ldraw => 19,
                Transparent => False,
                Red => 16#E8#,
                Green => 16#CF#,
                Blue => 16#A1#),
        Very_Light_Orange => (Ldraw => None,
                              Transparent => False,
                              Red => 16#FF#, -- BrickLink
                              Green => 16#CC#,
                              Blue => 16#A0#)
        );

    function Available (C : Color; P : Part) return Boolean is
    begin
        case P is
            when Plate_2X2_Corner =>
                case C is
                    when Brown =>
                        return False;
                    when Dark_Orange =>
                        return True;
                    when Orange =>
                        return True;
                    when Dark_Red =>
                        return True;
                    when Red =>
                        return True;
                    when Reddish_Brown =>
                        return True;
                    when Medium_Orange =>
                        return True;
                    when others =>
                        return False;
                end case;
            when Plate_1X1 =>
                case C is
                    when Brown =>
                        return True;
                    when Dark_Orange =>
                        return False;
                    when Orange =>
                        return True;
                    when Dark_Red =>
                        return True;
                    when Red =>
                        return True;
                    when Reddish_Brown =>
                        return True;
                    when Medium_Orange =>
                        return True;
                    when others =>
                        return False;
                end case;
            when Plate_1X2 =>
                case C is
                    when Brown =>
                        return True;
                    when Dark_Orange =>
                        return True;
                    when Orange =>
                        return True;
                    when Dark_Red =>
                        return True;
                    when Red =>
                        return True;
                    when Reddish_Brown =>
                        return True;
                    when Medium_Orange =>
                        return True;
                    when others =>
                        return False;
                end case;
            when Plate_1X3 =>
                case C is
                    when Brown =>
                        return True;
                    when Dark_Orange =>
                        return False;
                    when Orange =>
                        return True;
                    when Dark_Red =>
                        return True;
                    when Red =>
                        return True;
                    when Reddish_Brown =>
                        return True;
                    when Medium_Orange =>
                        return False;
                    when others =>
                        return False;
                end case;
            when Plate_1X4 =>
                case C is
                    when Brown =>
                        return True;
                    when Dark_Orange =>
                        return True;
                    when Orange =>
                        return True;
                    when Dark_Red =>
                        return True;
                    when Red =>
                        return True;
                    when Reddish_Brown =>
                        return True;
                    when Medium_Orange =>
                        return True;
                    when others =>
                        return False;
                end case;
            when Plate_1X6 =>
                case C is
                    when Brown =>
                        return True;
                    when Dark_Orange =>
                        return False;
                    when Orange =>
                        return True;
                    when Dark_Red =>
                        return True;
                    when Red =>
                        return True;
                    when Reddish_Brown =>
                        return True;
                    when Medium_Orange =>
                        return False;
                    when others =>
                        return False;
                end case;
            when Plate_2X2 =>
                case C is
                    when Brown =>
                        return True;
                    when Dark_Orange =>
                        return True;
                    when Orange =>
                        return True;
                    when Dark_Red =>
                        return True;
                    when Red =>
                        return True;
                    when Reddish_Brown =>
                        return True;
                    when Medium_Orange =>
                        return False;
                    when others =>
                        return False;
                end case;
            when Plate_2X3 =>
                case C is
                    when Brown =>
                        return True;
                    when Dark_Orange =>
                        return True;
                    when Orange =>
                        return True;
                    when Dark_Red =>
                        return True;
                    when Red =>
                        return True;
                    when Reddish_Brown =>
                        return True;
                    when Medium_Orange =>
                        return True;
                    when others =>
                        return False;
                end case;
            when Plate_2X4 =>
                case C is
                    when Brown =>
                        return True;
                    when Dark_Orange =>
                        return False; -- Not ordered.
                    when Orange =>
                        return True;
                    when Dark_Red =>
                        return True;
                    when Red =>
                        return True;
                    when Reddish_Brown =>
                        return True;
                    when Medium_Orange =>
                        return True;
                    when others =>
                        return False;
                end case;
            when Plate_2X6 =>
                case C is
                    when Brown =>
                        return False; -- Not ordered.
                    when Dark_Orange =>
                        return False;
                    when Orange =>
                        return True;
                    when Dark_Red =>
                        return True;
                    when Red =>
                        return True;
                    when Reddish_Brown =>
                        return True;
                    when Medium_Orange =>
                        return False; -- Not ordered.
                    when others =>
                        return False;
                end case;
            when Tile_1X1 =>
                case C is
                    when Brown =>
                        return True;
                    when Dark_Orange =>
                        return False;
                    when Orange =>
                        return False;
                    when Dark_Red =>
                        return True;
                    when Red =>
                        return True;
                    when Reddish_Brown =>
                        return True;
                    when Medium_Orange =>
                        return False;
                    when others =>
                        return False;
                end case;
            when Tile_1X2 =>
                case C is
                    when Brown =>
                        return True;
                    when Dark_Orange =>
                        return False;
                    when Orange =>
                        return True;
                    when Dark_Red =>
                        return True;
                    when Red =>
                        return True;
                    when Reddish_Brown =>
                        return True;
                    when Medium_Orange =>
                        return False;
                    when others =>
                        return False;
                end case;
            when Tile_1X4 =>
                case C is
                    when Brown =>
                        return True;
                    when Dark_Orange =>
                        return True;
                    when Orange =>
                        return False;
                    when Dark_Red =>
                        return False;
                    when Red =>
                        return True;
                    when Reddish_Brown =>
                        return True;
                    when Medium_Orange =>
                        return True;
                    when others =>
                        return False;
                end case;
            when Tile_1X6 =>
                case C is
                    when Brown =>
                        return True;
                    when Dark_Orange =>
                        return False;
                    when Orange =>
                        return False;
                    when Dark_Red =>
                        return True;
                    when Red =>
                        return True;
                    when Reddish_Brown =>
                        return True;
                    when Medium_Orange =>
                        return False;
                    when others =>
                        return False;
                end case;
        end case;
    end Available;

    function Direct_Image (C : Color) return String is
        Hex : array (Rgb_Intensity range 0 .. 15) of Character :=
           "0123456789ABCDEF";
    begin
        if Color_Definitions (C).Transparent then
            return "0x03" & Hex (Color_Definitions (C).Red / 16) &
                      Hex (Color_Definitions (C).Red mod 16) &
                      Hex (Color_Definitions (C).Green / 16) &
                      Hex (Color_Definitions (C).Green mod 16) &
                      Hex (Color_Definitions (C).Blue / 16) &
                      Hex (Color_Definitions (C).Blue mod 16);
        else
            return "0x02" & Hex (Color_Definitions (C).Red / 16) &
                      Hex (Color_Definitions (C).Red mod 16) &
                      Hex (Color_Definitions (C).Green / 16) &
                      Hex (Color_Definitions (C).Green mod 16) &
                      Hex (Color_Definitions (C).Blue / 16) &
                      Hex (Color_Definitions (C).Blue mod 16);
        end if;
    end Direct_Image;

    function Ldraw_Image (C : Color) return String is
    begin
        return Ldraw_Id'Image (Color_Definitions (C).Ldraw);
    end Ldraw_Image;

    function False_Image (C : Color) return String is
    begin
        case C is
            when Clear | Brown | Red | Orange =>
                return Ldraw_Image (C);
            when Dark_Orange =>
                return " 26"; -- Magenta
            when Dark_Red =>
                return " 22"; -- Purple
            when Medium_Orange =>
                return " 14"; -- Yellow
            when Reddish_Brown =>
                return " 19"; -- Tan
            when others =>
                pragma Assert (False);
                null;
        end case;
    end False_Image;

    function Part_Id_Image (P : Part) return String is
    begin
        case P is
            when Plate_2X2_Corner =>
                return "2420";
            when Plate_1X1 =>
                return "3024";
            when Plate_1X2 =>
                return "3023";
            when Plate_1X3 =>
                return "3623";
            when Plate_1X4 =>
                return "3710";
            when Plate_1X6 =>
                return "3666";
            when Plate_2X2 =>
                return "3022";
            when Plate_2X3 =>
                return "3021";
            when Plate_2X4 =>
                return "3020";
            when Plate_2X6 =>
                return "3795";
            when Tile_1X1 =>
                return "3070B";
            when Tile_1X2 =>
                return "3069B";
            when Tile_1X4 =>
                return "2431";
            when Tile_1X6 =>
                return "6636";
        end case;
    end Part_Id_Image;

end Lego;

