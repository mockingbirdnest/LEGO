with Generate_Probabilities;
with Lego;
procedure Wall.Probabilities.Generate is

    subtype Color is Lego.Color range Lego.Brown .. Lego.Medium_Orange;

    type Color_Probabilities is array (Color) of Long_Float;

    Pleasantness : constant Color_Probabilities :=
       -- (Lego.Brown => 0.13,
       --  Lego.Dark_Orange => 0.20, --0.18,
       --  Lego.Dark_Red => 0.18,
       --  Lego.Medium_Orange => 0.05,
       --  Lego.Orange => 0.10,
       --  Lego.Red => 0.18,
       --  Lego.Reddish_Brown => 0.18
       --  );
       (Lego.Brown         => 0.129396,
	Lego.Dark_Orange   => 0.203082,
	Lego.Orange        => 0.080981,
	Lego.Dark_Red      => 0.179458,
	Lego.Red           => 0.179458,
	Lego.Reddish_Brown => 0.179458,
	Lego.Medium_Orange => 0.048167);

    -- Lengths_1Xn : array (Lego.Part range Lego.Plate_2X2_Corner ..
    --                                         Lego.Plate_1X6)
    --                  of Long_Float :=
    --    (Lego.Plate_2X2_Corner => 0.0245,
    --     Lego.Plate_1X2 => 0.1943,
    --     Lego.Plate_1X1 => 0.0757,
    --     Lego.Plate_1X3 => 0.1851,
    --     Lego.Plate_1X6 => 0.2494,
    --     Lego.Plate_1X4 => 0.2710);  

    package Generate_1Xn is
       new Generate_Probabilities (Part                => Lego.Plate_1Xn,
				   Color               => Color,
				   Color_Probabilities => Color_Probabilities,
				   Pleasantness        => Pleasantness);

    type Plate_1Xn_Probabilities is array (Lego.Plate_1Xn) of Long_Float;

    function Build_Plate_1Xn_System is
       new Generate_1Xn.Build_System
	      (Part_Probabilities => Plate_1Xn_Probabilities,
	       Available          => Lego.Available);

    type Plate_1Xn_Conditional_Probabilities is
       array (Color, Lego.Plate_1Xn) of Long_Float;

    procedure Verify_Plate_1Xn_System is
       new Generate_1Xn.Verify_System (Conditional_Probabilities =>
					  Plate_1Xn_Conditional_Probabilities);


    package Generate_2Xn is
       new Generate_Probabilities (Part                => Lego.Plate_2Xn,
				   Color               => Color,
				   Color_Probabilities => Color_Probabilities,
				   Pleasantness        => Pleasantness);

    type Plate_2Xn_Probabilities is array (Lego.Plate_2Xn) of Long_Float;

    function Build_Plate_2Xn_System is
       new Generate_2Xn.Build_System
	      (Part_Probabilities => Plate_2Xn_Probabilities,
	       Available          => Lego.Available);


    package Generate_Tile is
       new Generate_Probabilities (Part                => Lego.Tile,
				   Color               => Color,
				   Color_Probabilities => Color_Probabilities,
				   Pleasantness        => Pleasantness);

    type Tile_Probabilities is array (Lego.Tile) of Long_Float;

    function Build_Tile_System is
       new Generate_Tile.Build_System (Part_Probabilities => Tile_Probabilities,
				       Available          => Lego.Available);
begin
    declare
	S : constant Generate_1Xn.System :=
	   Build_Plate_1Xn_System (Probabilities =>
				      (Lego.Plate_2X2_Corner => 0.0245,
				       Lego.Plate_1X1        => 0.0757,
				       Lego.Plate_1X2        => 0.1943,
				       Lego.Plate_1X3        => 0.1851,
				       Lego.Plate_1X4        => 0.2710,
				       Lego.Plate_1X6        => 0.2494));
    begin
	Generate_1Xn.Solve_System (S);

	Verify_Plate_1Xn_System
	   (S,
	    Q => (Lego.Brown         => (Lego.Plate_2X2_Corner => 0.0,
					 Lego.Plate_1X2        => 0.0930782,
					 Lego.Plate_1X1        => 0.162234,
					 Lego.Plate_1X3        => 0.185097,
					 Lego.Plate_1X6        => 0.17991,
					 Lego.Plate_1X4        => 0.0734287),
		  Lego.Dark_Orange   => (Lego.Plate_2X2_Corner => 0.194719,
					 Lego.Plate_1X2        => 0.373236,
					 Lego.Plate_1X1        => 0.0,
					 Lego.Plate_1X3        => 0.0,
					 Lego.Plate_1X6        => 0.0,
					 Lego.Plate_1X4        => 0.464175),
		  Lego.Orange        => (Lego.Plate_2X2_Corner => 0.153331,
					 Lego.Plate_1X2        => 0.0455786,
					 Lego.Plate_1X1        => 0.143734,
					 Lego.Plate_1X3        => 0.139848,
					 Lego.Plate_1X6        => 0.118911,
					 Lego.Plate_1X4        => 0.00717916),
		  Lego.Dark_Red      => (Lego.Plate_2X2_Corner => 0.164624,
					 Lego.Plate_1X2        => 0.134984,
					 Lego.Plate_1X1        => 0.178555,
					 Lego.Plate_1X3        => 0.225018,
					 Lego.Plate_1X6        => 0.233726,
					 Lego.Plate_1X4        => 0.131876),
		  Lego.Red           => (Lego.Plate_2X2_Corner => 0.164624,
					 Lego.Plate_1X2        => 0.134984,
					 Lego.Plate_1X1        => 0.178555,
					 Lego.Plate_1X3        => 0.225018,
					 Lego.Plate_1X6        => 0.233726,
					 Lego.Plate_1X4        => 0.131876),
		  Lego.Reddish_Brown => (Lego.Plate_2X2_Corner => 0.164624,
					 Lego.Plate_1X2        => 0.134984,
					 Lego.Plate_1X1        => 0.178555,
					 Lego.Plate_1X3        => 0.225018,
					 Lego.Plate_1X6        => 0.233726,
					 Lego.Plate_1X4        => 0.131876),
		  Lego.Medium_Orange => (Lego.Plate_2X2_Corner => 0.158077,
					 Lego.Plate_1X2        => 0.0831548,
					 Lego.Plate_1X1        => 0.158369,
					 Lego.Plate_1X3        => 0.0,
					 Lego.Plate_1X6        => 0.0,
					 Lego.Plate_1X4        => 0.0595881)));
    end;

    declare
	S : constant Generate_2Xn.System :=
	   Build_Plate_2Xn_System (Probabilities => (Lego.Plate_1X2 => 0.0806,
						     Lego.Plate_2X2 => 0.1992,
						     Lego.Plate_2X3 => 0.1900,
						     Lego.Plate_2X4 => 0.2759,
						     Lego.Plate_2X6 => 0.2543));
    begin
	Generate_2Xn.Solve_System (S);
    end;

    declare
	S : constant Generate_Tile.System :=
	   Build_Tile_System (Probabilities =>
				 (Lego.Tile_1X1 => 0.1281, --0.003,
				  Lego.Tile_1X2 => 0.2467, --0.004,
				  Lego.Tile_1X4 => 0.3234, --0.008,
				  Lego.Tile_1X6 => 0.3018)); --0.008))
    begin
	Generate_Tile.Solve_System (S);
    end;

end Wall.Probabilities.Generate;
