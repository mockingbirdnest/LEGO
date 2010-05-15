with Generate_Probabilities;
with Lego;
procedure Roof.Probabilities.Generate is

    type Color_Probabilities is array (Lego.Color) of Long_Float;

    Pleasantness : constant Color_Probabilities := (Lego.Dark_Orange   => 0.50,
						    Lego.Dark_Red      => 0.12,
						    Lego.Red           => 0.09,
						    Lego.Brown         => 0.10,
						    Lego.Reddish_Brown => 0.10,
						    Lego.Sand_Green    => 0.03,
						    Lego.Dark_Gray     => 0.03,
						    Lego.Tan           => 0.03,
						    others             => 0.00);

    package Generate_Brick is
       new Generate_Probabilities (Part                => Lego.Brick,
				   Color               => Lego.Color,
				   Color_Probabilities => Color_Probabilities,
				   Pleasantness        => Pleasantness);

    type Brick_Probabilities is array (Lego.Brick) of Long_Float;

    function Build_Brick_System is
       new Generate_Brick.Build_System
	      (Part_Probabilities => Brick_Probabilities,
	       Available          => Lego.Available);

    type Brick_Conditional_Probabilities is
       array (Lego.Color, Lego.Brick) of Long_Float;

    procedure Verify_Brick_System is
       new Generate_Brick.Verify_System
	      (Conditional_Probabilities => Brick_Conditional_Probabilities);
begin
    declare
	S : constant Generate_Brick.System :=
	   Build_Brick_System (Probabilities =>
				  (Lego.Brick_1X1_Round => 0.7777777,
				   Lego.Brick_1X2_Log   => 0.2222223));
    begin
	Generate_Brick.Solve_System (S);

	-- Verify_Plate_1Xn_System
	--    (S,
	--     Q => (Lego.Brown         => (Lego.Plate_2X2_Corner => 0.0,
	--                               Lego.Plate_1X2        => 0.0930782,
	--                               Lego.Plate_1X1        => 0.162234,
	--                               Lego.Plate_1X3        => 0.185097,
	--                               Lego.Plate_1X6        => 0.17991,
	--                               Lego.Plate_1X4        => 0.0734287),
	--        Lego.Dark_Orange   => (Lego.Plate_2X2_Corner => 0.194719,
	--                               Lego.Plate_1X2        => 0.373236,
	--                               Lego.Plate_1X1        => 0.0,
	--                               Lego.Plate_1X3        => 0.0,
	--                               Lego.Plate_1X6        => 0.0,
	--                               Lego.Plate_1X4        => 0.464175),
	--        Lego.Orange        => (Lego.Plate_2X2_Corner => 0.153331,
	--                               Lego.Plate_1X2        => 0.0455786,
	--                               Lego.Plate_1X1        => 0.143734,
	--                               Lego.Plate_1X3        => 0.139848,
	--                               Lego.Plate_1X6        => 0.118911,
	--                               Lego.Plate_1X4        => 0.00717916),
	--        Lego.Dark_Red      => (Lego.Plate_2X2_Corner => 0.164624,
	--                               Lego.Plate_1X2        => 0.134984,
	--                               Lego.Plate_1X1        => 0.178555,
	--                               Lego.Plate_1X3        => 0.225018,
	--                               Lego.Plate_1X6        => 0.233726,
	--                               Lego.Plate_1X4        => 0.131876),
	--        Lego.Red           => (Lego.Plate_2X2_Corner => 0.164624,
	--                               Lego.Plate_1X2        => 0.134984,
	--                               Lego.Plate_1X1        => 0.178555,
	--                               Lego.Plate_1X3        => 0.225018,
	--                               Lego.Plate_1X6        => 0.233726,
	--                               Lego.Plate_1X4        => 0.131876),
	--        Lego.Reddish_Brown => (Lego.Plate_2X2_Corner => 0.164624,
	--                               Lego.Plate_1X2        => 0.134984,
	--                               Lego.Plate_1X1        => 0.178555,
	--                               Lego.Plate_1X3        => 0.225018,
	--                               Lego.Plate_1X6        => 0.233726,
	--                               Lego.Plate_1X4        => 0.131876),
	--        Lego.Medium_Orange => (Lego.Plate_2X2_Corner => 0.158077,
	--                               Lego.Plate_1X2        => 0.0831548,
	--                               Lego.Plate_1X1        => 0.158369,
	--                               Lego.Plate_1X3        => 0.0,
	--                               Lego.Plate_1X6        => 0.0,
	--                               Lego.Plate_1X4        => 0.0595881)));
    end;

end Roof.Probabilities.Generate;
