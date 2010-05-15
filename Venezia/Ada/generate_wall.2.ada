with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Text_Io;
with Debug;
with Generator;
with Genetics;
with Options;
with Wall.Ldraw;
with Wall.Options;

procedure Generate_Wall is
begin
    Wall.Options.Analyze;

    declare

	use Wall;

	use type Options.Constraint;
	use type Options.Positions;
	use type Wall.Options.Parts_Option;

	Separations_Per_Row : constant Natural := Width - 1;

	-- The genome represents the separations between parts. 
	package Genetics is
	   new Standard.Genetics
		  (Genome_Size          => Height * Separations_Per_Row,
		   Pool_Size            => 1,
		   Population_Size      => Wall.Options.Population,
		   Mutation_Probability => Wall.Options.Mutations);
	package Ef is new Ada.Numerics.Generic_Elementary_Functions
			     (Genetics.Fitness);

	-- Called on each newly created genome (on the first day of creation or
	-- after reproduction) to make sure that it satisfies the constraints.
	procedure Apply_Constraints (Genome : in out Genetics.Genome) is
	    Last_In_Bottom_Row : constant Genetics.Gene :=
	       Genetics.Gene (Separations_Per_Row);

	    First, Last : Genetics.Gene'Base;
	    use Genetics.Operators;
	begin
	    if Bottom /= null then
		Last := Genome'First - 1;
		for I in Bottom'Range loop
		    First                      := Last + 1;
		    Last                       := Last + Bottom (I);
		    Genome (First .. Last - 1) := (others => False);
		    if Last <= Last_In_Bottom_Row then
			Genome (Last) := True;
		    end if;
		end loop;
	    end if;
	    if Top /= null then
		Last := Genome'Last - Separations_Per_Row;
		for I in Top'Range loop
		    First                      := Last + 1;
		    Last                       := Last + Top (I);
		    Genome (First .. Last - 1) := (others => False);
		    if Last <= Genome'Last then
			Genome (Last) := True;
		    end if;
		end loop;
	    end if;
	    if Left /= null then

		declare
		    -- Use the top constraint as long as it has an effect on
		    -- the left constraint.
		    Use_Top : Boolean := Top /= null and then
					    Left (Left'Last - Top_Height) > 0;
		begin
		    for I in reverse Left'First + Bottom_Height ..
					Left'Last - Top_Height loop
			First := (I - Left'First) * Separations_Per_Row +
				    Genome'First;
			if Left (I) > 0 then
			    Last := First + Left (I) - 1;
			    if Use_Top then
				Genome (First .. Last - 1) :=
				   Genome (Genome'Last -
					   Separations_Per_Row + 1 ..
					      Genome'Last -
						 Separations_Per_Row +
						 Left (I) - 1);
			    else
				Genome (First .. Last - 1) := (others => False);
			    end if;
			    Genome (Last) := True;
			end if;
			if I < Left'Last - Top_Height and then
			   Left (I) > Left (I + 1) then
			    Use_Top := False;
			end if;
		    end loop;
		end;

	    end if;
	    if Right /= null then

		declare
		    -- Use the top constraint as long as it has an effect on
		    -- the right constraint.
		    Use_Top : Boolean := Top /= null and then
					    Right (Right'Last - Top_Height) > 0;
		begin
		    for I in reverse Right'First + Bottom_Height ..
					Right'Last - Top_Height loop
			Last :=
			   Genome'First +
			      (I - Right'First + 1) * Separations_Per_Row - 1;
			if Right (I) > 0 then
			    First := Last - Right (I) + 1;
			    if Use_Top then
				Genome (First + 1 .. Last) :=
				   Genome (Genome'Last - Right (I) + 2 ..
					      Genome'Last);
			    else
				Genome (First + 1 .. Last) := (others => False);
			    end if;
			    Genome (First) := True;
			end if;
			if I < Right'Last - Top_Height and then
			   Right (I) > Right (I + 1) then
			    Use_Top := False;
			end if;
		    end loop;
		end;

	    end if;
	    if Wall.Options.Cycle then

		-- Copy the part that spans the beginning of the "real" wall at
		-- the end of the "real" wall.  Don't do this for the top and
		-- bottom constraints.
		declare
		    Original_Width : constant Positive  :=
		       Width (Effective => False);
		    After_Width    : Natural;  
		    Before_Width   : Natural;  
		    Wall_Start     : Genetics.Gene'Base :=
		       Genetics.Gene (Cycle_Margin) +
			  Bottom_Height * Separations_Per_Row;
		begin
		    while Wall_Start < Genome'Last -
					  Top_Height * Separations_Per_Row loop
			After_Width  := 0;
			Before_Width := 0;
			for I in Wall_Start .. Wall_Start + Original_Width loop
			    exit when Genome (I);
			    After_Width := After_Width + 1;
			end loop;
			if After_Width > 0 then
			    for I in reverse Wall_Start - (Cycle_Margin - 1) ..
						Wall_Start loop
				exit when Genome (I);
				Before_Width := Before_Width + 1;
			    end loop;

			    -- Avoid the nasty situation where Before_Width
			    -- covers the entire margin: the separation at
			    -- position Wall_Start - Before_Width is actually
			    -- on the previous row.  It's no big deal to cheat
			    -- with the periodicity, as the part is surely too
			    -- long anyway.
			    if Before_Width = Cycle_Margin then
				Before_Width := Cycle_Margin - 1;
			    end if;
			end if;

			Genome (Wall_Start +  
				Original_Width - Before_Width ..
				   Wall_Start +  
				      Original_Width + After_Width) :=
			   Genome (Wall_Start - Before_Width ..
				      Wall_Start + After_Width);

			Wall_Start := Wall_Start + Separations_Per_Row;
		    end loop;
		end;
	    end if;
	end Apply_Constraints;

	function Compute_Fitness (Genome     : Genetics.Genome;
				  Individual : Genetics.Individual;
				  Trace      : Boolean)
				 return Genetics.Fitness is
	    type Imperfection_Kind is
	       (Corner_Imperfection, Part_Imperfection,
		Separation_Imperfection, Tee_Imperfection);
	    type Location is (Left2, Left, Here, Right, Below);

	    Anchors : array (1 .. Options.Length (Wall.Options.Tee))
			 of Natural := (others => 0);

	    Corner_Cost     : constant := 2.0;
	    Tee_Cost        : constant := 0.1;
	    Separation_Cost : constant := 1.0;

	    After_Corner             : Boolean;
	    At_Edge_Of_Aligned_Rows  : Boolean;
	    Column                   : Positive range 1 .. Separations_Per_Row;
	    Deep_In_Left_Constraint  : Boolean;
	    Deep_In_Right_Constraint : Boolean;
	    End_Of_Row_Width         : Positive;
	    In_Left_Constraint       : Boolean;
	    In_Right_Constraint      : Boolean;
	    Part_Width               : Natural;
	    Result                   : Genetics.Fitness := 0.0;
	    Row                      : Positive range 1 .. Height;
	    Spans_Corner             : Boolean          := False;

	    use type Genetics.Fitness;

	    procedure Trace_Imperfection (Kind : Imperfection_Kind) is
	    begin
		if Trace then
		    case Kind is
			when Corner_Imperfection =>
			    Ada.Text_Io.Put (Ada.Text_Io.Standard_Error,
					     "Misplaced corner");
			when Part_Imperfection =>
			    Ada.Text_Io.Put (Ada.Text_Io.Standard_Error,
					     "Inexistent part");
			when Separation_Imperfection =>
			    Ada.Text_Io.Put
			       (Ada.Text_Io.Standard_Error, "Separation");
			when Tee_Imperfection =>
			    Ada.Text_Io.Put (Ada.Text_Io.Standard_Error,
					     "Inappropriate tees");
		    end case;
		    Ada.Text_Io.Put_Line
		       (Ada.Text_Io.Standard_Error,
			" at row" & Positive'Image (Row) &
			   ", column" & Positive'Image (Column));
		end if;
	    end Trace_Imperfection;

	    function Part_Cost (Width : Positive; Spans_Corner : Boolean)
			       return Genetics.Fitness is
	    begin
		case Width is
		    when 1 | 2 | 4 =>
			return 0.0;
		    when 3 =>
			case Wall.Options.Parts is
			    when Wall.Options.Plates_1Xn |
				 Wall.Options.Plates_2Xn =>
				return 0.0;
			    when Wall.Options.Tiles =>
				if (Bottom /= null and then Row = 1) or else
				   (Top /= null and then Row = Height) then
				    -- In horizontal constraint.
				    return 0.0;
				else
				    Trace_Imperfection (Part_Imperfection);
				    return Genetics.Fitness (Width);
				end if;
			end case;
		    when 5 | 7 =>
			if Wall.Options.Parts = Wall.Options.Plates_2Xn and then
			   Spans_Corner then
			    return 0.0;
			else
			    Trace_Imperfection (Part_Imperfection);
			    return Genetics.Fitness (Width);
			end if;
		    when 6 =>
			if Wall.Options.Parts = Wall.Options.Plates_2Xn and then
			   Spans_Corner then
			    Trace_Imperfection (Part_Imperfection);
			    return Genetics.Fitness (Width);
			else
			    return 0.0;
			end if;
		    when 8 =>
			return 0.1;
		    when others =>
			Trace_Imperfection (Part_Imperfection);
			return Genetics.Fitness (Width);
		end case;
	    end Part_Cost;
	    pragma Inline (Part_Cost);

	    function Has_Separation (I     : Genetics.Gene;  
				     Where : Location := Here) return Boolean is
		use Genetics.Operators;
	    begin
		case Where is
		    when Left2 =>
			return Column = 2 or else Genome (I - 2);
		    when Left =>
			return Column = 1 or else Genome (I - 1);
		    when Here =>
			return Column = Width or else Genome (I);
		    when Right =>
			return Column = Separations_Per_Row or else
				  Genome (I + 1);
		    when Below =>  
			return Row > 1 and then Genome
						   (I - Separations_Per_Row);
		end case;
	    end Has_Separation;
	    pragma Inline (Has_Separation);

	begin
	    Row        := 1;
	    Part_Width := 1;
	    Column     := 1;
	    for I in Genome'Range loop
		At_Edge_Of_Aligned_Rows :=
		   Row > 1 and then ((Left /= null and then
				      Column = Left (Row) and then
				      Column = Left (Row - 1)) or else
				     (Right /= null and then
				      Column = Width - Right (Row) and then
				      Column = Width - Right (Row - 1)));

		After_Corner := False;
		if Corner /= null then
		    for J in Corner'Range loop
			if Column = Corner (J) then

			    -- We are at the separation immediately after the
			    -- stud for a corner.
			    After_Corner := True;
			    Spans_Corner := True;
			end if;
		    end loop;
		end if;

		-- True if the current separation is in the left/right
		-- constraint.  For the top row, we look at the left/right
		-- constraint of the row below.
		In_Left_Constraint  :=
		   Left /= null and then
		      Column <= Left (Positive'Min (Row, Height - Top_Height));
		In_Right_Constraint :=
		   Right /= null and then
		      Column >= Width - Right (Positive'Min
						  (Row, Height - Top_Height));

		-- True if the current separation is in the left/right
		-- constraint, and the separation immediately below is, too.
		Deep_In_Left_Constraint  :=
		   In_Left_Constraint and then Row > 1 and then
		      Column <= Left (Row - 1);
		Deep_In_Right_Constraint :=
		   In_Right_Constraint and then Row > 1 and then
		      Column >= Width - Right (Row - 1);

		-- Here Part_Width is the width of the part being constructed.
		if Column = Separations_Per_Row then

		    -- On the last separation of the row.
		    if Has_Separation (I) then
			Result       :=
			   Result + Part_Cost (Part_Width, Spans_Corner) +
			      Part_Cost (1, Spans_Corner => False);
			Spans_Corner := False;
			if not At_Edge_Of_Aligned_Rows and then
			   Has_Separation (I, Below) and then
			   not Deep_In_Left_Constraint and then
			   not Deep_In_Right_Constraint then
			    Result := Result + Separation_Cost;
			    Trace_Imperfection (Separation_Imperfection);
			end if;
		    else
			if not In_Right_Constraint then
			    Result       :=
			       Result + Part_Cost
					   (Part_Width + 1, Spans_Corner);
			    Spans_Corner := False;
			end if;
		    end if;
		    Part_Width := 0;
		    if Row < Height then
			Row := Row + 1;
		    end if;
		else
		    if Has_Separation (I) then
			if not In_Left_Constraint then
			    Result       :=
			       Result + Part_Cost (Part_Width, Spans_Corner);
			    Spans_Corner := False;
			end if;
			Part_Width := 0;
			if not At_Edge_Of_Aligned_Rows and then
			   Has_Separation (I, Below) and then
			   not Deep_In_Left_Constraint and then
			   not Deep_In_Right_Constraint then
			    Result := Result + Separation_Cost;
			    Trace_Imperfection (Separation_Imperfection);
			end if;
		    end if;
		end if;

		if Row in Bottom_Height + 1 .. Height - Top_Height then
		    if After_Corner then

			if Wall.Options.Parts = Wall.Options.Plates_2Xn then
			    if Has_Separation (I) or else
			       Has_Separation (I, Left) then

				-- This is an 1xN or Nx1 corner.  Hard to do
				-- with 2xn parts.
				Trace_Imperfection (Corner_Imperfection);
				Result := Result + Corner_Cost;
			    elsif Has_Separation (I, Left2) or else
				  Has_Separation (I, Right) then

				-- This is a 2xN or Nx2 corner.  Fine.
				null;
			    else
				-- This is not a corner that we like.
				Trace_Imperfection (Corner_Imperfection);
				Result := Result + Corner_Cost;
			    end if;
			else
			    if Has_Separation (I) or else
			       Has_Separation (I, Left) then

				-- This is an 1xN or Nx1 corner.  Fine.
				null;
			    elsif Has_Separation (I, Left2) and then
				  Has_Separation (I, Right) then

				-- This case can be covered by a 2x2 corner,
				-- but only for plates.  This could possibly be
				-- handled by the cost function, but I don't
				-- want to change the optimization landscape.
				case Wall.Options.Parts is
				    when Wall.Options.Plates_1Xn =>
					null;
				    when Wall.Options.Tiles =>
					Trace_Imperfection
					   (Corner_Imperfection);
					Result := Result + Corner_Cost;
				    when Wall.Options.Plates_2Xn =>
					pragma Assert (False);
					null;
				end case;
			    else
				-- This is not a corner that we like.
				Trace_Imperfection (Corner_Imperfection);
				Result := Result + Corner_Cost;
			    end if;
			end if;
		    end if;

		    if Wall.Options.Tee /= null then
			for J in Wall.Options.Tee'Range loop
			    if Column = Wall.Options.Tee (J) then

				-- We are at the separation immediately after
				-- the stud for a tee.
				if Has_Separation (I) and then
				   Has_Separation (I, Left) then

				    -- This is an 1x1 on the stud of the tee.
				    Anchors (J) := Anchors (J) + 1;
				elsif Has_Separation (I) and then
				      Has_Separation (I, Left2) then

				    -- This is a corner before the stud of the
				    -- tee.
				    Anchors (J) := Anchors (J) + 1;
				elsif Has_Separation (I, Left) and then
				      Has_Separation (I, Right) then

				    -- This is a corner after the stud of the
				    -- tee.
				    Anchors (J) := Anchors (J) + 1;
				end if;
			    end if;
			end loop;
		    end if;

		end if;

		Part_Width := Part_Width + 1;
		if Column = Separations_Per_Row then
		    Column := 1;
		else
		    Column := Column + 1;
		end if;
	    end loop;

	    if Wall.Options.Tee /= null then

		declare
		    -- Use extra precision here for compatibility with Windows.
		    type Fitness is new Long_Long_Float;
		    Original_Result : constant Fitness := Fitness (Result);
		    New_Result      : Fitness          := Fitness (Result);
		    Lo              : Fitness          :=
		       Fitness (Wall.Options.Private_Options.Height) / 3.0;
		    Hi              : Fitness          :=
		       Fitness (Wall.Options.Private_Options.Height) / 2.0;
		    Correction      : Fitness;
		begin
		    -- Make sure that we have at least 3 values that are
		    -- considered "good".
		    if Hi - Lo < 4.0 then
			Correction := 2.0 - (Hi - Lo) / 2.0;
			Lo         := Lo - Correction;
			Hi         := Hi + Correction;
		    end if;
		    -- Beware!  This loop seems to be very sensitive to
		    -- (apparently) neutral code transformations.  Perhaps
		    -- because of floating-point optimizations, who knows.  At
		    -- any rate, any change should be checked using the
		    -- regression test. 
		    --
		    -- The above comment is probably no longer true now that we
		    -- force extra-precision computations.
		    for J in Wall.Options.Tee'Range loop
			New_Result :=
			   New_Result +
			      Fitness'Max
				 (0.0, Tee_Cost * (Fitness (Anchors (J)) - Lo) *
					  (Fitness (Anchors (J)) - Hi));
			New_Result := Fitness (Genetics.Fitness (New_Result));
		    end loop;
		    if New_Result /= Original_Result then
			Trace_Imperfection (Tee_Imperfection);
		    end if;
		    Result := Genetics.Fitness (New_Result);
		end;

	    end if;

	    return Ef.Exp (-100.0 * Result / Genetics.Fitness (Height * Width));
	end Compute_Fitness;

	procedure Output_Wall (Genome  : Genetics.Genome;
			       Age     : Positive;
			       Fitness : Genetics.Fitness) is
	    package Ldraw is new Wall.Ldraw (Genetics);
	begin
	    Ldraw.Output_Header;
	    Wall.Options.Output;
	    Ldraw.Output_Genome (Genome, Age, Fitness);
	end Output_Wall;

	package Debug is new Standard.Debug (Height   => Height,  
					     Width    => Width,
					     Genetics => Genetics);

	-- No optimization is taking place for a wall of width 1, but we still
	-- want to select the colors and output a file.
	procedure Wall_Generator is
	   new Generator (Crossover         => Wall.Options.Crossover,
			  Generations       => Wall.Options.Generations,
			  Seed              => Wall.Options.Seed,
			  Optimize          => Width > 1,
			  Trace             => Wall.Options.Trace,
			  Genetics          => Genetics,
			  Apply_Constraints => Apply_Constraints,
			  Compute_Fitness   => Compute_Fitness,
			  Output_Genome     => Output_Wall,
			  Trace_Genome      => Debug.Trace);

    begin
	if Wall.Options.Error then
	    return;
	end if;
	Wall_Generator;
    end;
end Generate_Wall;
--pragma Main (Stack_Size => 2 ** 28);
