with Ada.Unchecked_Conversion;
package Lego is

    type Part_Id is new Positive;

    type Part is (Plate_2X2_Corner,
                  Plate_1X2, Plate_1X1, Plate_1X3, Plate_1X6, Plate_1X4,
                  Tile_1X1, Tile_1X2, Tile_1X4, Tile_1X6);
    type Color is
       (Brown, Dark_Orange, Orange, Dark_Red, Red, Reddish_Brown, Medium_Orange,

        Bright_Pink, Clear, Light_Orange, Light_Pink,
        Magenta, Pink, Sand_Red, Tan, Very_Light_Orange);

    Available : array (Color, Part) of Boolean :=
       (Bright_Pink =>
           (Plate_1X2 => True, others => False),
        Brown =>
           (Plate_1X1 | Plate_1X2 | Plate_1X3 |
            Plate_1X4 | Plate_1X6 | Tile_1X1 | Tile_1X2 | Tile_1X4 | Tile_1X6 =>
               True,
            others => False),
        Clear => (others => False),
        Dark_Orange =>
           (Plate_1X2 | Plate_1X4 | Plate_2X2_Corner | Tile_1X4 => True,
            others => False),
        Dark_Red =>
           (Tile_1X4 => False, others => True),
        Light_Orange =>
           (Plate_1X4 => True, others => False),
        Light_Pink =>
           (Plate_1X3 | Plate_1X6 => True, others => False),
        Magenta =>
           (Plate_1X6 => True, others => False),
        Medium_Orange =>
           (Plate_1X1 | Plate_1X2 | Plate_1X4 |
            Plate_2X2_Corner | Tile_1X4 => True,
            others => False),
        Orange =>
           (Tile_1X1 | Tile_1X4 | Tile_1X6 => False, others => True),
        Pink =>
           (Plate_1X1 | Plate_1X2 | Plate_1X3 | Plate_1X6 => True,
            others => False),
        Red =>
           (others => True),
        Reddish_Brown =>
           (Tile_1X6 => False, others => True),
        Sand_Red =>
           (Plate_1X2 => True, others => False),
        Tan =>
           (others => True),
        Very_Light_Orange =>
           (Plate_1X2 => True, others => False)
        );


    function Direct_Image (C : Color) return String;
    function False_Image (C : Color) return String;
    function Ldraw_Image (C : Color) return String;
    function Part_Id_Image (P : Part) return String;


end Lego;

