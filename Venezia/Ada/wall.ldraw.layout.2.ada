package body Wall.Ldraw.Layout is

    use type Lego.Part;
    use type Options.Parts_Option;
    use type Options.Positions;

    Other : constant array (Direction) of Direction :=
       (North => East, East => North);

    Corner_North_West : constant Matrix :=
       ((0.0, 0.0, -1.0), (0.0, 1.0, 0.0), (1.0, 0.0, 0.0));
    Corner_South_East : constant Matrix :=
       ((0.0, 0.0, 1.0), (0.0, 1.0, 0.0), (-1.0, 0.0, 0.0));

    Straight_Matrix : constant array (Direction) of Matrix :=
       (East  => ((1.0, 0.0, 0.0), (0.0, 1.0, 0.0), (0.0, 0.0, 1.0)),
	North => ((0.0, 0.0, 1.0), (0.0, 1.0, 0.0), (-1.0, 0.0, 0.0)));


    function Straight_Part_Of
		(Stud_Count : Positive; S : State) return Lego.Part is
    begin
	case Stud_Count is
	    when 1 =>
		case S.Parts is
		    when Options.Tiles =>
			return Lego.Tile_1X1;
		    when Options.Plates_1Xn =>
			return Lego.Plate_1X1;
		    when Options.Plates_2Xn =>
			return Lego.Plate_1X2;
		end case;
	    when 2 =>
		case S.Parts is
		    when Options.Tiles =>
			return Lego.Tile_1X2;
		    when Options.Plates_1Xn =>
			return Lego.Plate_1X2;
		    when Options.Plates_2Xn =>
			return Lego.Plate_2X2;
		end case;
	    when 3 =>
		case S.Parts is
		    when Options.Tiles =>
			raise No_Such_Part;
		    when Options.Plates_1Xn =>
			return Lego.Plate_1X3;
		    when Options.Plates_2Xn =>
			return Lego.Plate_2X3;
		end case;
	    when 4 =>
		case S.Parts is
		    when Options.Tiles =>
			return Lego.Tile_1X4;
		    when Options.Plates_1Xn =>
			return Lego.Plate_1X4;
		    when Options.Plates_2Xn =>
			return Lego.Plate_2X4;
		end case;
	    when 6 =>
		case S.Parts is
		    when Options.Tiles =>
			return Lego.Tile_1X6;
		    when Options.Plates_1Xn =>
			return Lego.Plate_1X6;
		    when Options.Plates_2Xn =>
			return Lego.Plate_2X6;
		end case;
	    when others =>
		raise No_Such_Part;
	end case;
    end Straight_Part_Of;


    function Corner_Part_Of
		(Stud_Count : Positive; S : State) return Lego.Part is
    begin
	case S.Parts is
	    when Options.Tiles | Options.Plates_1Xn =>
		return Straight_Part_Of (Stud_Count, S);
	    when Options.Plates_2Xn =>
		case Stud_Count is
		    when 2 =>
			return Lego.Plate_1X2;
		    when 3 =>
			return Lego.Plate_2X2;
		    when 4 =>
			return Lego.Plate_2X3;
		    when 5 =>
			return Lego.Plate_2X4;
		    when 7 =>
			return Lego.Plate_2X6;
		    when others =>
			raise No_Such_Part;
		end case;
	end case;
    end Corner_Part_Of;

    function Straight_Matrix_Of (Part : Lego.Part; S : State) return Matrix is
    begin
	if Part = Lego.Plate_1X2 and then S.Parts = Options.Plates_2Xn then
	    -- We could just return Straigh_Matrix (Other (S.Direction)) here, but compatibility rules.
	    case S.Direction is
		when East =>
		    return ((0.0, 0.0, -1.0), (0.0, 1.0, 0.0), (1.0, 0.0, 0.0));
		when North =>
		    return ((-1.0, 0.0, 0.0), (0.0, 1.0, 0.0),
			    (0.0, 0.0, -1.0));
	    end case;
	else
	    return Straight_Matrix (S.Direction);
	end if;
    end Straight_Matrix_Of;

    function Depth (Parts : Options.Parts_Option) return Positive is
    begin
	case Parts is
	    when Options.Plates_1Xn | Options.Tiles =>
		return 1;
	    when Options.Plates_2Xn =>
		return 2;
	end case;
    end Depth;


    function Initialize
		(Corners : Options.Positions; Parts : Options.Parts_Option)
		return State is
    begin
	return (Corners           => Corners,
		Parts             => Parts,
		Direction         => East,
		Last_X1 | Last_X2 => 0,
		Last_Z1           => 0,
		Last_Z2           => Depth (Parts));
    end Initialize;

    procedure Append (First_Stud, Last_Stud : Positive;
		      S                     : in out State;
		      X, Z                  : out Integer;
		      M                     : out Matrix;
		      Part                  : out Lego.Part) is
	Stud_Count     : constant Positive                          :=
	   Last_Stud - First_Stud + 1;
	Is_Corner_Stud : array (First_Stud .. Last_Stud) of Boolean :=
	   (others => False);
	Part_Depth     : constant Positive                          :=
	   Depth (S.Parts);

	First_Corner_Candidate : Positive;
	Last_Corner_Candidate  : Positive;

	Ends_With_A_Corner   : Boolean;
	Spans_A_Corner       : Boolean;
	Starts_With_A_Corner : Boolean;

	procedure Place_In_Sequence (Width : Positive) is
	begin
	    case S.Direction is

		when East =>
		    S.Last_X1 := S.Last_X2;
		    S.Last_X2 := S.Last_X2 + Width;

		when North =>
		    S.Last_Z1 := S.Last_Z2;
		    S.Last_Z2 := S.Last_Z2 + Width;
	    end case;
	end Place_In_Sequence;

    begin
	-- Find the corners that lie on the part.
	Spans_A_Corner := False;
	if S.Corners /= null then
	    for I in S.Corners'Range loop
		if S.Corners (I) in First_Stud .. Last_Stud then
		    Is_Corner_Stud (S.Corners (I)) := True;
		    Spans_A_Corner                 := True;
		end if;
	    end loop;
	end if;

	if Spans_A_Corner then

	    -- The nasty case, the part spans a corner.
	    First_Corner_Candidate := First_Stud + Part_Depth - 1;
	    Last_Corner_Candidate  := Last_Stud - Part_Depth + 1;
	    Starts_With_A_Corner   := Is_Corner_Stud (First_Corner_Candidate);
	    Ends_With_A_Corner     := First_Corner_Candidate /=
					 Last_Corner_Candidate and then
				      Is_Corner_Stud (Last_Corner_Candidate);

	    if S.Parts = Options.Plates_1Xn and then Stud_Count = 3 and then
	       Is_Corner_Stud ((First_Stud + Last_Stud) / 2) then

		-- The nastiest case, this is a 2x2 corner.  It may define one, two or three corners.
		-- And its center is the center of its corner stud.
		Part := Lego.Plate_2X2_Corner;

		case S.Direction is

		    when East =>
			if Starts_With_A_Corner then
			    M := Corner_North_West;
			    X := 20 * S.Last_X2 + 10;
			    Z := (20 * (S.Last_Z2 + S.Last_Z1)) / 2 + 20;
			else
			    M := Corner_South_East;
			    X := 20 * S.Last_X2 + 30;
			    Z := (20 * (S.Last_Z2 + S.Last_Z1)) / 2;
			end if;

		    when North =>
			if Starts_With_A_Corner then
			    M := Corner_South_East;
			    X := (20 * (S.Last_X2 + S.Last_X1)) / 2 + 20;
			    Z := 20 * S.Last_Z2 + 10;
			else
			    M := Corner_North_West;
			    X := (20 * (S.Last_X2 + S.Last_X1)) / 2;
			    Z := 20 * S.Last_Z2 + 30;
			end if;
		end case;

		if Starts_With_A_Corner = Ends_With_A_Corner then

		    -- Odd number of corners.
		    case S.Direction is

			when East =>
			    S.Last_X1 := S.Last_X2 + 1;
			    S.Last_X2 := S.Last_X1 + 1;
			    S.Last_Z1 := S.Last_Z2 + 1;
			    S.Last_Z2 := S.Last_Z1;

			when North =>
			    S.Last_X1 := S.Last_X2 + 1;
			    S.Last_X2 := S.Last_X1;
			    S.Last_Z1 := S.Last_Z2 + 1;
			    S.Last_Z2 := S.Last_Z1 + 1;
		    end case;
		    S.Direction := Other (S.Direction);
		else

		    -- Two corners.
		    case S.Direction is

			when East =>
			    S.Last_X1 := S.Last_X2 + 2;
			    S.Last_X2 := S.Last_X1;
			    S.Last_Z1 := S.Last_Z2;
			    S.Last_Z2 := S.Last_Z1 + 1;

			when North =>
			    S.Last_X1 := S.Last_X2;
			    S.Last_X2 := S.Last_X1 + 1;
			    S.Last_Z1 := S.Last_Z2 + 2;
			    S.Last_Z2 := S.Last_Z1;
		    end case;
		end if;
	    else

		-- The not-too-nasty case, a straight part which defines one or two corners.
		Part := Corner_Part_Of (Stud_Count, S);
		if Starts_With_A_Corner then
		    case S.Direction is

			when East =>
			    S.Last_X1 := S.Last_X2;
			    S.Last_X2 := S.Last_X2 + Part_Depth;
			    S.Last_Z2 := S.Last_Z1 + Stud_Count -
					    Part_Depth + 1;

			when North =>
			    S.Last_Z1 := S.Last_Z2;
			    S.Last_Z2 := S.Last_Z2 + Part_Depth;
			    S.Last_X2 := S.Last_X1 + Stud_Count -
					    Part_Depth + 1;
		    end case;
		    S.Direction := Other (S.Direction);
		else
		    Place_In_Sequence (Stud_Count - Part_Depth + 1);
		end if;

		if Stud_Count = 1 then
		    -- Ugly compatibility hack: do not rotate a 1x1.
		    M := Straight_Matrix (Other (S.Direction));
		else
		    M := Straight_Matrix (S.Direction);
		end if;
		X := (20 * (S.Last_X1 + S.Last_X2)) / 2;
		Z := (20 * (S.Last_Z1 + S.Last_Z2)) / 2;

		-- Prepare for the next part.
		if Ends_With_A_Corner then
		    case S.Direction is

			when East =>
			    S.Last_X1 := S.Last_X2 - Part_Depth;
			    S.Last_Z1 := S.Last_Z2; -- Do we care?

			when North =>
			    S.Last_Z1 := S.Last_Z2 - Part_Depth;
			    S.Last_X1 := S.Last_X2; -- Do we care?
		    end case;
		    S.Direction := Other (S.Direction);
		end if;
	    end if;
	else

	    -- The easy case, the part just follows the last one.
	    Part := Straight_Part_Of (Stud_Count, S);
	    M    := Straight_Matrix_Of (Part, S);
	    Place_In_Sequence (Stud_Count);
	    X    := (20 * (S.Last_X1 + S.Last_X2)) / 2;
	    Z    := (20 * (S.Last_Z1 + S.Last_Z2)) / 2;
	end if;
    end Append;

end Wall.Ldraw.Layout;

