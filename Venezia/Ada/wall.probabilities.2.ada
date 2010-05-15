with Wall.Options;
package body Wall.Probabilities is

    Q_1Xn : constant array (Wall.Color, Lego.Plate_1Xn) of Long_Float :=
       (Lego.Brown         => (Lego.Plate_2X2_Corner => -0.000000,
			       Lego.Plate_1X1        => 0.162231,
			       Lego.Plate_1X3        => 0.185095,
			       Lego.Plate_1X4        => 0.073424,
			       Lego.Plate_1X6        => 0.179917,
			       Lego.Plate_1X2        => 0.093076),
	Lego.Dark_Orange   => (Lego.Plate_2X2_Corner => 0.194670,
			       Lego.Plate_1X1        => 0.000000,
			       Lego.Plate_1X3        => 0.000000,
			       Lego.Plate_1X4        => 0.464179,
			       Lego.Plate_1X6        => 0.000000,
			       Lego.Plate_1X2        => 0.373237),
	Lego.Orange        => (Lego.Plate_2X2_Corner => 0.153353,
			       Lego.Plate_1X1        => 0.143723,
			       Lego.Plate_1X3        => 0.139839,
			       Lego.Plate_1X4        => 0.007166,
			       Lego.Plate_1X6        => 0.118940,
			       Lego.Plate_1X2        => 0.045570),
	Lego.Dark_Red      => (Lego.Plate_2X2_Corner => 0.164628,
			       Lego.Plate_1X1        => 0.178560,
			       Lego.Plate_1X3        => 0.225022,
			       Lego.Plate_1X4        => 0.131881,
			       Lego.Plate_1X6        => 0.233714,
			       Lego.Plate_1X2        => 0.134987),
	Lego.Red           => (Lego.Plate_2X2_Corner => 0.164628,
			       Lego.Plate_1X1        => 0.178560,
			       Lego.Plate_1X3        => 0.225022,
			       Lego.Plate_1X4        => 0.131881,
			       Lego.Plate_1X6        => 0.233714,
			       Lego.Plate_1X2        => 0.134987),
	Lego.Reddish_Brown => (Lego.Plate_2X2_Corner => 0.164628,
			       Lego.Plate_1X1        => 0.178560,
			       Lego.Plate_1X3        => 0.225022,
			       Lego.Plate_1X4        => 0.131881,
			       Lego.Plate_1X6        => 0.233714,
			       Lego.Plate_1X2        => 0.134987),
	Lego.Medium_Orange => (Lego.Plate_2X2_Corner => 0.158092,
			       Lego.Plate_1X1        => 0.158366,
			       Lego.Plate_1X3        => 0.000000,
			       Lego.Plate_1X4        => 0.059588,
			       Lego.Plate_1X6        => 0.000000,
			       Lego.Plate_1X2        => 0.083155));

    Q_2Xn : constant array (Wall.Color, Lego.Plate_2Xn) of Long_Float :=
       (Lego.Brown         => (Lego.Plate_1X2 => 0.139812,
			       Lego.Plate_2X2 => 0.143145,
			       Lego.Plate_2X3 => 0.135680,
			       Lego.Plate_2X4 => 0.231364,
			       Lego.Plate_2X6 => 0.000000),
	Lego.Dark_Orange   => (Lego.Plate_1X2 => 0.274529,
			       Lego.Plate_2X2 => 0.476092,
			       Lego.Plate_2X3 => 0.453249,
			       Lego.Plate_2X4 => -0.000000,
			       Lego.Plate_2X6 => 0.000000),
	Lego.Orange        => (Lego.Plate_1X2 => 0.093722,
			       Lego.Plate_2X2 => 0.029235,
			       Lego.Plate_2X3 => 0.027030,
			       Lego.Plate_2X4 => 0.073594,
			       Lego.Plate_2X6 => 0.165801),
	Lego.Dark_Red      => (Lego.Plate_1X2 => 0.129305,
			       Lego.Plate_2X2 => 0.117176,
			       Lego.Plate_2X3 => 0.110909,
			       Lego.Plate_2X4 => 0.195395,
			       Lego.Plate_2X6 => 0.278066),
	Lego.Red           => (Lego.Plate_1X2 => 0.129305,
			       Lego.Plate_2X2 => 0.117176,
			       Lego.Plate_2X3 => 0.110909,
			       Lego.Plate_2X4 => 0.195395,
			       Lego.Plate_2X6 => 0.278066),
	Lego.Reddish_Brown => (Lego.Plate_1X2 => 0.129305,
			       Lego.Plate_2X2 => 0.117176,
			       Lego.Plate_2X3 => 0.110909,
			       Lego.Plate_2X4 => 0.195395,
			       Lego.Plate_2X6 => 0.278066),
	Lego.Medium_Orange => (Lego.Plate_1X2 => 0.104023,
			       Lego.Plate_2X2 => 0.000000,
			       Lego.Plate_2X3 => 0.051313,
			       Lego.Plate_2X4 => 0.108856,
			       Lego.Plate_2X6 => 0.000000));

    Q_Tile : constant array (Wall.Color, Lego.Tile) of Long_Float :=
       (Lego.Brown         => (Lego.Tile_1X1 => 0.226587,
			       Lego.Tile_1X2 => 0.122846,
			       Lego.Tile_1X4 => 0.034822,
			       Lego.Tile_1X6 => 0.194839),
	Lego.Dark_Orange   => (Lego.Tile_1X1 => -0.000000,
			       Lego.Tile_1X2 => 0.000000,
			       Lego.Tile_1X4 => 0.627959,
			       Lego.Tile_1X6 => 0.000000),
	Lego.Orange        => (Lego.Tile_1X1 => 0.000000,
			       Lego.Tile_1X2 => 0.328257,
			       Lego.Tile_1X4 => 0.000000,
			       Lego.Tile_1X6 => -0.000000),
	Lego.Dark_Red      => (Lego.Tile_1X1 => 0.273248,
			       Lego.Tile_1X2 => 0.212707,
			       Lego.Tile_1X4 => -0.000000,
			       Lego.Tile_1X6 => 0.304771),
	Lego.Red           => (Lego.Tile_1X1 => 0.250083,
			       Lego.Tile_1X2 => 0.168095,
			       Lego.Tile_1X4 => 0.094139,
			       Lego.Tile_1X6 => 0.250195),
	Lego.Reddish_Brown => (Lego.Tile_1X1 => 0.250083,
			       Lego.Tile_1X2 => 0.168095,
			       Lego.Tile_1X4 => 0.094139,
			       Lego.Tile_1X6 => 0.250195),
	Lego.Medium_Orange => (Lego.Tile_1X1 => 0.000000,
			       Lego.Tile_1X2 => 0.000000,
			       Lego.Tile_1X4 => 0.148939,
			       Lego.Tile_1X6 => 0.000000));

    generic
	First : Lego.Part;
	Last  : Lego.Part;
    package Cumulative is
	Q : array (Wall.Color, First .. Last) of Long_Float;
	procedure Initialize_If_Needed;
    end Cumulative;

    package body Cumulative is

	Initialized : Boolean := False;

	procedure Initialize_If_Needed is
	    use type Lego.Color;
	begin
	    if not Initialized then
		for Part in First .. Last loop
		    for Color in Wall.Color loop
			if Color = Wall.Color'First then
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

    package Cumulative_1Xn is new Cumulative (Lego.Plate_1Xn'First,  
					      Lego.Plate_1Xn'Last);
    package Cumulative_2Xn is new Cumulative (Lego.Plate_2Xn'First,  
					      Lego.Plate_2Xn'Last);
    package Cumulative_Tile is new Cumulative (Lego.Tile'First,  
					       Lego.Tile'Last);

    function Q (C : Wall.Color; P : Lego.Part) return Long_Float is
    begin
	case Options.Parts is
	    when Options.Plates_1Xn =>
		return Q_1Xn (C, P);
	    when Options.Plates_2Xn =>
		return Q_2Xn (C, P);
	    when Options.Tiles =>
		return Q_Tile (C, P);
	end case;
    end Q;

    function Cumulative_Q (C : Wall.Color; P : Lego.Part) return Long_Float is
    begin
	case Options.Parts is
	    when Options.Plates_1Xn =>
		Cumulative_1Xn.Initialize_If_Needed;
		return Cumulative_1Xn.Q (C, P);
	    when Options.Plates_2Xn =>
		Cumulative_2Xn.Initialize_If_Needed;
		return Cumulative_2Xn.Q (C, P);
	    when Options.Tiles =>
		Cumulative_Tile.Initialize_If_Needed;
		return Cumulative_Tile.Q (C, P);
	end case;
    end Cumulative_Q;

end Wall.Probabilities;  
