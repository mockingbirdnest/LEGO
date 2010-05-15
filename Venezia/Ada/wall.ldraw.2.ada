with Ada.Numerics.Float_Random;
with Ada.Text_Io;
with Lego;
with Wall.Ldraw.Layout;
with Wall.Options;
with Wall.Probabilities;
with Wall.Process;
package body Wall.Ldraw is

    package Anfr renames Ada.Numerics.Float_Random;

    use type Options.Constraint;
    use type Options.Parts_Option;
    use type Options.Visibility_Option;

    package Actual_Layout is new Layout;

    Color_Generator : Anfr.Generator;

    type Output_State is
	record
	    Y               : Integer;
	    Layout_State    : Actual_Layout.State;
	    Last_Color      : Lego.Color;
	    Start_Of_Row    : Boolean;
	    In_Left_Margin  : Boolean;
	    In_Right_Margin : Boolean;
	    Cycle_Color     : Lego.Color;
	end record;

    function Effective_Parts
		(Parts : Options.Parts_Option; Height : Positive; Y : Integer)
		return Options.Parts_Option is
    begin
	if Parts = Options.Tiles then
	    if Y = 1 - Height then
		return Options.Tiles;
	    else
		return Options.Plates_1Xn;
	    end if;
	else
	    return Parts;
	end if;
    end Effective_Parts;

    procedure Output_Part (First_Stud, Last_Stud : Positive;
			   S                     : in out Output_State) is
	use type Lego.Color;
	use type Options.Parts_Option;

	subtype Cyclic_Wall is
	   Positive range Cycle_Margin + 1 ..
			     Cycle_Margin + Width (Effective => False);

	Is_Left_Right : constant Boolean  :=
	   (Left /= null and then Last_Stud <= Left (1 - S.Y)) or else
	      (Right /= null and then First_Stud >=
					 Width - Right (1 - S.Y) + 1);
	Is_Top_Bottom : constant Boolean  :=
	   (Bottom /= null and then S.Y = 0) or else
	      (Top /= null and then S.Y = 1 - Height);
	Stud_Count    : constant Positive := Last_Stud - First_Stud + 1;

	C      : Lego.Color;
	Is_Tee : Boolean := False;
	P      : Lego.Part;
	Hide   : Boolean;
	Skip   : Boolean;
	X, Z   : Integer;
	M      : Actual_Layout.Matrix;

	First_Not_In_Left_Margin : Boolean := False;
	Last_Not_In_Right_Margin : Boolean := False;

	function Random (P : Lego.Part) return Lego.Color is
	    R : Long_Float range 0.0 .. 1.0;
	    use type Lego.Color;
	begin

	    -- The last entry in Cumulative_Q will be very close to 1.0, but it
	    -- may not be exactly 1.0 because of rounding.  Adjust the random
	    -- number to avoid leaving a tiny hole.
	    R := Long_Float (Anfr.Random (Color_Generator)) *
		    Probabilities.Cumulative_Q (Wall.Color'Last, P);
	    for Color in Lego.Color loop
		if Probabilities.Q (Color, P) > 0.0 then
		    if Probabilities.Cumulative_Q (Color, P) >= R then
			return Color;
		    end if;
		end if;
	    end loop;
	end Random;

	procedure Put (S : String) is
	begin
	    if not Skip then
		Ada.Text_Io.Put (Options.File, S);
	    end if;
	end Put;

	procedure Put_Line (S : String) is
	begin
	    if not Skip then
		Ada.Text_Io.Put_Line (Options.File, S);
	    end if;
	end Put_Line;

	procedure Put (M : Actual_Layout.Matrix) is
	begin
	    -- By column...
	    for I in M'Range (2) loop
		for J in M'Range (1) loop

		    declare
			S : constant String :=
			   Integer'Image (Integer (M (J, I)));
		    begin
			if S (S'First) = ' ' then
			    Put (S);
			else
			    Put (" " & S);
			end if;
		    end;

		end loop;
	    end loop;
	end Put;

    begin
	case Stud_Count is
	    when 1 =>
		Is_Tee := Standard.Options.Is_In (First_Stud, Options.Tee);
	    when 2 =>
		Is_Tee := Standard.Options.Is_In
			     (First_Stud, Options.Tee) or else
			  Standard.Options.Is_In (Last_Stud, Options.Tee);
	    when others =>
		null;
	end case;

	Actual_Layout.Append (First_Stud => First_Stud,
			      Last_Stud  => Last_Stud,
			      S          => S.Layout_State,
			      X          => X,
			      Z          => Z,
			      M          => M,
			      Part       => P);

	if Options.Cycle then
	    if S.In_Left_Margin and then First_Stud in Cyclic_Wall then
		S.In_Left_Margin         := False;
		First_Not_In_Left_Margin := True;
	    end if;
	    if not S.In_Left_Margin and then not S.In_Right_Margin then
		if First_Stud not in Cyclic_Wall then
		    S.In_Right_Margin := True;
		elsif Last_Stud + 1 not in Cyclic_Wall then
		    Last_Not_In_Right_Margin := True;
		end if;
	    end if;
	end if;

	if Is_Top_Bottom then

	    -- A constraint line.  For historical reasons, it doesn't consume
	    -- colors.
	    C := Lego.Clear;
	elsif S.In_Left_Margin or else S.In_Right_Margin then
	    C := Lego.Clear;
	else

	    -- Pick a color.  Make sure that we don't have two consecutive
	    -- parts of the same color.  That includes the start-of-cycle
	    -- color.
	    C := Random (P);
	    pragma Assert (Lego.Available (C, P));
	    while not S.Start_Of_Row and then
		     (C = S.Last_Color or else
		      (Last_Not_In_Right_Margin and then
		       C = S.Cycle_Color)) loop
		C := Random (P);
		pragma Assert (Lego.Available (C, P));
	    end loop;
	    S.Last_Color := C;
	end if;

	-- If this is the first part of the "real" wall, record its color to
	-- avoid it when generating the last part of the "real" wall.
	if First_Not_In_Left_Margin then
	    S.Cycle_Color := C;
	end if;

	Skip := (Is_Left_Right and then
		 Options.Visibility (Options.Left_Right) = Options.Skip) or else
		(Is_Top_Bottom and then
		 Options.Visibility (Options.Top_Bottom) = Options.Skip) or else
		(Is_Tee and then  
		 Options.Visibility (Options.Tees) = Options.Skip) or else
		((S.In_Left_Margin or else S.In_Right_Margin) and then  
		 Options.Visibility (Options.Margin) = Options.Skip);
	Hide := (Is_Left_Right and then
		 Options.Visibility (Options.Left_Right) = Options.Hide) or else
		(Is_Top_Bottom and then
		 Options.Visibility (Options.Top_Bottom) = Options.Hide) or else
		(Is_Tee and then  
		 Options.Visibility (Options.Tees) = Options.Hide) or else
		((S.In_Left_Margin or else S.In_Right_Margin) and then
		 Options.Visibility (Options.Margin) = Options.Hide);

	if Is_Left_Right then

	    -- To preserve coloring we want this one to consume colors but to
	    -- be shown clear.  Compatibility...
	    C := Lego.Clear;
	end if;

	if Hide then
	    Put ("0 MLCAD HIDE ");
	end if;
	Put ("1");

	case Options.Color is
	    when Standard.Options.Direct =>
		Put (" " & Lego.Direct_Image (C));
	    when Standard.Options.False =>
		Put (" " & Lego.False_Image (C));
	    when Standard.Options.Ldraw =>
		Put (" " & Lego.Ldraw_Image (C));
	end case;

	Put (" " & Integer'Image (X) & " " &
	     Integer'Image (8 * S.Y) & " " & Integer'Image (Z));

	Put (M);

	Put_Line (" " & Lego.Part_Id_Image (P) & ".DAT");

	S.Start_Of_Row := False;
	if Last_Stud = Width then
	    S.Y               := S.Y - 1;
	    S.Start_Of_Row    := True;
	    S.In_Left_Margin  := Options.Cycle;
	    S.In_Right_Margin := False;
	    S.Layout_State    :=
	       Actual_Layout.Initialize
		  (Corners => Corner,
		   Parts   => Effective_Parts (Parts  => Options.Parts,
					       Height => Height,
					       Y      => S.Y));
	    if not Skip or else not Is_Top_Bottom then
		Ada.Text_Io.Put_Line (Options.File, "0 STEP");
		Ada.Text_Io.Put_Line (Options.File,
				      "0 WRITE End of step" &
					 Integer'Image (-S.Y - Bottom_Height));
	    end if;
	end if;
    exception
	when Actual_Layout.No_Such_Part =>
	    Ada.Text_Io.Put_Line (Ada.Text_Io.Standard_Error,
				  "No such part at studs" &
				     Positive'Image (First_Stud) & " to" &
				     Positive'Image (Last_Stud));
	    if Options.Parts = Options.Plates_2Xn then
		Ada.Text_Io.Put_Line
		   (Ada.Text_Io.Standard_Error,
		    "This may be an oddity due to " &
		       Options.Parts_Option'Image (Options.Parts));
	    end if;
	    for I in First_Stud .. Last_Stud loop
		Output_Part (I, I, S);
	    end loop;
    end Output_Part;


    procedure Output_Header is
    begin
	Ada.Text_Io.Put_Line (Options.File, "0 Author: Generate_Wall");
	Ada.Text_Io.Put_Line (Options.File, "0 Unofficial Model");
	Ada.Text_Io.Put_Line (Options.File,
			      "0 Rotation Center 0 0 0 1 ""Custom""");
	Ada.Text_Io.Put_Line (Options.File, "0 Rotation Config 0 0");
    end Output_Header;

    procedure Output_Genome (Genome  : Genetics.Genome;
			     Age     : Positive;
			     Fitness : Genetics.Fitness) is

	procedure Actual_Output is
	   new Process
		  (State    => Output_State,
		   Initial  =>
		      (Y               => 0,
		       Layout_State    =>
			  Actual_Layout.Initialize
			     (Corners => Corner,
			      Parts   =>
				 Effective_Parts (Parts  => Options.Parts,  
						  Height => Height,
						  Y      => 0)),
		       Last_Color      => Lego.Color'First,
		       Start_Of_Row    => True,
		       In_Left_Margin  => Options.Cycle,
		       In_Right_Margin => False,
		       Cycle_Color     => Lego.Color'First),
		   Part     => Output_Part,
		   Genetics => Genetics);

    begin

	-- We want to make sure that different walls explore different sequences of the
	-- color generator, otherwise we would have biases.  We use as the seed the number
	-- of studs, which is as good a number as any.
	Anfr.Reset (Color_Generator,
		    Options.Private_Options.Height *
		       Options.Private_Options.Width + Options.Color_Seed);
	Ada.Text_Io.Put_Line (Options.File,
			      "0 /result_fitness" &
				 Genetics.Fitness'Image (Fitness));
	Ada.Text_Io.Put_Line (Options.File,
			      "0 /result_generation" & Positive'Image (Age));
	Actual_Output (Genome);
    end Output_Genome;

end Wall.Ldraw;
