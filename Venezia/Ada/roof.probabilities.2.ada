package body Roof.Probabilities is

    Q_Brick : constant array (Roof.Color, Lego.Brick) of Long_Float :=
       (Lego.Brown             => (Lego.Brick_1X1_Round => 0.033010,
				   Lego.Brick_1X2_Log   => 0.334465),
	Lego.Dark_Orange       => (Lego.Brick_1X1_Round => 0.642857,
				   Lego.Brick_1X2_Log   => 0.000000),
	Lego.Orange            => (Lego.Brick_1X1_Round => 0.000000,
				   Lego.Brick_1X2_Log   => 0.000000),
	Lego.Dark_Red          => (Lego.Brick_1X1_Round => 0.154286,
				   Lego.Brick_1X2_Log   => 0.000000),
	Lego.Red               => (Lego.Brick_1X1_Round => 0.021123,
				   Lego.Brick_1X2_Log   => 0.331069),
	Lego.Reddish_Brown     => (Lego.Brick_1X1_Round => 0.033010,
				   Lego.Brick_1X2_Log   => 0.334465),
	Lego.Medium_Orange     => (Lego.Brick_1X1_Round => 0.000000,
				   Lego.Brick_1X2_Log   => 0.000000),
	Lego.Bright_Pink       => (Lego.Brick_1X1_Round => 0.000000,
				   Lego.Brick_1X2_Log   => 0.000000),
	Lego.Clear             => (Lego.Brick_1X1_Round => 0.000000,
				   Lego.Brick_1X2_Log   => 0.000000),
	Lego.Dark_Gray         => (Lego.Brick_1X1_Round => 0.038571,
				   Lego.Brick_1X2_Log   => -0.000000),
	Lego.Light_Orange      => (Lego.Brick_1X1_Round => 0.000000,
				   Lego.Brick_1X2_Log   => 0.000000),
	Lego.Light_Pink        => (Lego.Brick_1X1_Round => 0.000000,
				   Lego.Brick_1X2_Log   => 0.000000),
	Lego.Magenta           => (Lego.Brick_1X1_Round => 0.000000,
				   Lego.Brick_1X2_Log   => 0.000000),
	Lego.Pink              => (Lego.Brick_1X1_Round => 0.000000,
				   Lego.Brick_1X2_Log   => 0.000000),
	Lego.Sand_Green        => (Lego.Brick_1X1_Round => 0.038571,
				   Lego.Brick_1X2_Log   => -0.000000),
	Lego.Sand_Red          => (Lego.Brick_1X1_Round => 0.000000,
				   Lego.Brick_1X2_Log   => 0.000000),
	Lego.Tan               => (Lego.Brick_1X1_Round => 0.038571,
				   Lego.Brick_1X2_Log   => -0.000000),
	Lego.Very_Light_Orange => (Lego.Brick_1X1_Round => 0.000000,
				   Lego.Brick_1X2_Log   => 0.000000));


    generic
	First : Lego.Part;
	Last  : Lego.Part;
    package Cumulative is
	Q : array (Roof.Color, First .. Last) of Long_Float;
	procedure Initialize_If_Needed;
    end Cumulative;

    package body Cumulative is

	Initialized : Boolean := False;

	procedure Initialize_If_Needed is
	    use type Lego.Color;
	begin
	    if not Initialized then
		for Part in First .. Last loop
		    for Color in Roof.Color loop
			if Color = Roof.Color'First then
			    Q (Color, Part) := Probabilities.Q (Color, Part);
			else
			    Q (Color, Part) :=
			       Q (Lego.Color'Pred (Color), Part) +
				  Probabilities.Q (Color, Part);
			end if;
		    end loop;
		end loop;
		Initialized := True;
	    end if;
	end Initialize_If_Needed;

    end Cumulative;

    package Cumulative_Brick is new Cumulative (Lego.Brick'First,  
						Lego.Brick'Last);

    function Q (C : Roof.Color; P : Lego.Part) return Long_Float is
    begin
	return Q_Brick (C, P);
    end Q;

    function Cumulative_Q (C : Roof.Color; P : Lego.Part) return Long_Float is
    begin
	Cumulative_Brick.Initialize_If_Needed;
	return Cumulative_Brick.Q (C, P);
    end Cumulative_Q;

end Roof.Probabilities;  
