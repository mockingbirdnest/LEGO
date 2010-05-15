with Ada.Unchecked_Conversion;
package Lego is

    type Part_Id is new Positive;

    type Part is (Brick_1X1_Round, Brick_1X2_Log,
		  Plate_2X2_Corner,
		  Plate_1X1, Plate_1X3, Plate_1X4, Plate_1X6, Plate_1X2,
		  Plate_2X2, Plate_2X3, Plate_2X4, Plate_2X6,
		  Tile_1X1, Tile_1X2, Tile_1X4, Tile_1X6);
    subtype Brick is Part range Brick_1X1_Round .. Brick_1X2_Log;
    subtype Plate_1Xn is Part range Plate_2X2_Corner .. Plate_1X2;
    subtype Plate_2Xn is Part range Plate_1X2 .. Plate_2X6;
    subtype Tile is Part range Tile_1X1 .. Tile_1X6;

    type Color is
       (Brown, Dark_Orange, Orange, Dark_Red, Red, Reddish_Brown, Medium_Orange,

	Bright_Pink, Clear, Dark_Gray, Light_Orange, Light_Pink,
	Magenta, Pink, Sand_Green, Sand_Red, Tan, Very_Light_Orange);

    function Available (C : Color; P : Part) return Boolean;

    function Direct_Image (C : Color) return String;
    function False_Image (C : Color) return String;
    function Ldraw_Image (C : Color) return String;
    function Part_Id_Image (P : Part) return String;


end Lego;

