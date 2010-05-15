with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Text_Io;
with Debug;
with Generator;
with Genetics;
with Options;
with Roof.Ldraw;
with Roof.Options;

procedure Generate_Roof is
begin
    Roof.Options.Analyze;

    declare

	use Roof;

	use type Options.Constraint;
	use type Options.Positions;

	package Genetics is
	   new Standard.Genetics
		  (Genome_Size          => Height * (Width - 1),
		   Pool_Size            => 1,
		   Population_Size      => Roof.Options.Population,
		   Mutation_Probability => Roof.Options.Mutations);
	package Ef is new Ada.Numerics.Generic_Elementary_Functions
			     (Genetics.Fitness);

	Width_Minus_One : constant Genetics.Gene'Base :=
	   Genetics.Gene'Base (Width - 1);

	-- Called on each newly created genome (on the first day of creation or
	-- after reproduction) to make sure that it satisfies the constraints.
	procedure Apply_Constraints (Genome : in out Genetics.Genome) is
	    First, Last : Genetics.Gene'Base;
	    use type Genetics.Gene;
	begin
	    if Left /= null then
		for I in reverse Left'Range loop
		    First := Genetics.Gene'Base (I - Left'First) *
				Width_Minus_One + Genome'First;
		    if Left (I) > 0 then
			Last                       :=
			   First + Genetics.Gene'Base (Left (I)) - 1;
			Genome (First .. Last - 1) := (others => False);
			Genome (Last)              := True;
		    end if;
		end loop;
	    end if;
	    if Right /= null then

		for I in reverse Right'Range loop
		    Last := Genetics.Gene'Base (I - Right'First + 1) *
			       Width_Minus_One;
		    if Right (I) > 0 then
			First                      :=
			   Last - Genetics.Gene'Base (Right (I)) + 1;
			Genome (First + 1 .. Last) := (others => False);
			Genome (First)             := True;
		    end if;
		end loop;
	    end if;
	end Apply_Constraints;

	function Compute_Fitness (Genome     : Genetics.Genome;
				  Individual : Genetics.Individual;
				  Trace      : Boolean)
				 return Genetics.Fitness is
	    type Imperfection_Kind is
	       (Part_Imperfection, Last_Log_Imperfection,
		Log_Per_Column_Imperfection,
		Log_Total_Imperfection, Separation_Imperfection);

	    Last_Log_Cost       : constant := 0.5;
	    Log_Per_Column_Cost : constant := 0.125;
	    Log_Total_Cost      : constant := 0.25;
	    Separation_Cost     : constant := 0.125;

	    At_Edge_Of_Aligned_Rows  : Boolean;
	    Column                   : Positive range 1 .. Width - 1;
	    Deep_In_Left_Constraint  : Boolean;
	    Deep_In_Right_Constraint : Boolean;
	    In_Left_Constraint       : Boolean;
	    In_Right_Constraint      : Boolean;
	    Part_Width               : Natural;
	    Result                   : Genetics.Fitness := 0.0;
	    Row                      : Positive range 1 .. Height;

	    Last_Log : array (Positive range 1 .. Width - 1) of Natural :=
	       (others => 0);
	    Logs     : array (Positive range 1 .. Width - 1) of Natural :=
	       (others => 0);

	    use type Genetics.Fitness;

	    procedure Trace_Imperfection (Kind : Imperfection_Kind) is
	    begin
		if Trace then
		    case Kind is
			when Part_Imperfection =>
			    Ada.Text_Io.Put (Ada.Text_Io.Standard_Error,
					     "Inexistent part");
			when Last_Log_Imperfection =>
			    Ada.Text_Io.Put (Ada.Text_Io.Standard_Error,
					     "Inappropriate last log");
			when Log_Per_Column_Imperfection =>
			    Ada.Text_Io.Put (Ada.Text_Io.Standard_Error,
					     "Inappropriate logs per column");
			when Log_Total_Imperfection =>
			    Ada.Text_Io.Put (Ada.Text_Io.Standard_Error,
					     "Inappropriate logs total");
			when Separation_Imperfection =>
			    Ada.Text_Io.Put_Line
			       (Ada.Text_Io.Standard_Error, "Separation");
		    end case;
		    Ada.Text_Io.Put_Line
		       (Ada.Text_Io.Standard_Error,
			" at row" & Positive'Image (Row) &
			   ", column" & Positive'Image (Column));
		end if;
	    end Trace_Imperfection;

	    function Part_Cost (Width : Positive) return Genetics.Fitness is
	    begin
		case Width is
		    when 1 | 2 =>
			return 0.0;
		    when others =>
			Trace_Imperfection (Part_Imperfection);
			return Genetics.Fitness (Width);
		end case;
	    end Part_Cost;
	    pragma Inline (Part_Cost);

	    use type Genetics.Gene;
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

		-- True if the current separation is in the left/right constraint. 
		In_Left_Constraint  :=
		   Left /= null and then Column <=
					    Left (Positive'Min (Row, Height));
		In_Right_Constraint :=
		   Right /= null and then
		      Column >= Width - Right (Positive'Min (Row, Height));

		if not Genome (I) and then not In_Left_Constraint and then
		   not In_Right_Constraint then
		    Last_Log (Column) := Row;
		    Logs (Column)     := Logs (Column) + 1;
		end if;

		-- True if the current separation is in the left/right constraint, and the
		-- separation immediately below is, too.
		Deep_In_Left_Constraint  :=
		   In_Left_Constraint and then Row > 1 and then
		      Column <= Left (Row - 1);
		Deep_In_Right_Constraint :=
		   In_Right_Constraint and then Row > 1 and then
		      Column >= Width - Right (Row - 1);

		-- Here Part_Width is the width of the part being constructed.
		if Column = Positive (Width_Minus_One) then

		    -- End of a row.
		    if Genome (I) then
			Result := Result + Part_Cost (Part_Width) +
				     Part_Cost (1);
		    else
			if Row > 1 and then
			   not Genome (I - Width_Minus_One) and then
			   not Deep_In_Left_Constraint and then
			   not Deep_In_Right_Constraint then
			    Result := Result + Separation_Cost;
			    Trace_Imperfection (Separation_Imperfection);
			end if;
			if not In_Right_Constraint then
			    Result := Result + Part_Cost (Part_Width + 1);
			end if;
		    end if;
		    Part_Width := 0;
		    if Row < Height then
			Row := Row + 1;
		    end if;
		else
		    if Genome (I) then
			if not In_Left_Constraint then
			    Result := Result + Part_Cost (Part_Width);
			end if;
			Part_Width := 0;
		    else
			if Row > 1 and then
			   not Genome (I - Width_Minus_One) and then
			   not Deep_In_Left_Constraint and then
			   not Deep_In_Right_Constraint then
			    Result := Result + Separation_Cost;
			    Trace_Imperfection (Separation_Imperfection);
			end if;
		    end if;
		end if;

		Part_Width := Part_Width + 1;
		if Column = Positive (Width_Minus_One) then
		    Column := 1;
		else
		    Column := Column + 1;
		end if;
	    end loop;

	    declare
		-- Use extra precision here.
		type Fitness is new Long_Long_Float;
		Original_Result : constant Fitness := Fitness (Result);
		New_Result      : Fitness          := Fitness (Result);
		Lo              : Fitness          := Fitness (Height) / 20.0;
		Hi              : Fitness          := Fitness (Height) / 5.0;
		Correction      : Fitness;
		Total           : Natural          := 0;
	    begin
		for I in 1 .. Width - 1 loop
		    Column     := I;
		    Total      := Total + Logs (I);
		    -- if Trace then
		    --                  Ada.Text_Io.Put_Line
		    --                     ("I =" & Integer'Image (I) & " Logs =" &
		    --                      Integer'Image (Logs (I)) & " Lo =" &
		    --                      Fitness'Image (Lo) & " Hi =" & Fitness'Image (Hi));
		    -- end if;
		    Correction := Fitness'Max
				     (0.0, Log_Per_Column_Cost *
					      (Fitness (Logs (I)) - Lo) *
					      (Fitness (Logs (I)) - Hi));
		    New_Result := New_Result + Correction;
		    if Correction > 0.0 then
			Trace_Imperfection (Log_Per_Column_Imperfection);
		    end if;
		    if Last_Log (I) not in Height - 5 .. Height then
			New_Result := New_Result + Last_Log_Cost;
			Trace_Imperfection (Last_Log_Imperfection);
		    end if;
		    New_Result := Fitness (Genetics.Fitness (New_Result));
		end loop;
		Correction := Fitness'Max
				 (0.0, Log_Total_Cost *
					  (Fitness (Total) -
					   0.175 * Fitness (Height) *
					      Fitness (Width_Minus_One)));
		if Correction > 0.0 then
		    Trace_Imperfection (Log_Total_Imperfection);
		end if;
		New_Result := New_Result + Correction;
		Result     := Genetics.Fitness (New_Result);
	    end;

	    return Ef.Exp (-100.0 * Result / Genetics.Fitness (Height * Width));
	end Compute_Fitness;

	procedure Output_Roof (Genome  : Genetics.Genome;
			       Age     : Positive;
			       Fitness : Genetics.Fitness) is
	    package Ldraw is new Roof.Ldraw (Genetics);
	begin
	    Ldraw.Output_Header;
	    Roof.Options.Output;
	    Ldraw.Output_Genome (Genome, Age, Fitness);
	end Output_Roof;

	package Debug is new Standard.Debug (Height   => Height,  
					     Width    => Width,
					     Genetics => Genetics);

	-- No optimization is taking place for a wall of width 1, but we
	-- still want to select the colors and output a file.
	procedure Roof_Generator is
	   new Generator (Crossover         => Roof.Options.Crossover,
			  Generations       => Roof.Options.Generations,
			  Seed              => Roof.Options.Seed,
			  Optimize          => Width > 1,
			  Trace             => Roof.Options.Trace,
			  Genetics          => Genetics,
			  Apply_Constraints => Apply_Constraints,
			  Compute_Fitness   => Compute_Fitness,
			  Output_Genome     => Output_Roof,
			  Trace_Genome      => Debug.Trace);

    begin
	if Roof.Options.Error then
	    return;
	end if;
	Roof_Generator;
    end;
end Generate_Roof;
pragma Main;
