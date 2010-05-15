with Ada.Text_Io;
procedure Generator is

    type Reproduction_State is
	record
	    Children  : Genetics.Access_All_Population;
	    Fitnesses : Genetics.Access_Constant_Fitnesses;
	end record;
    pragma Convention (Ada_Pass_By_Reference,
		       Reproduction_State); -- To avoid a warning.

    type Access_All_Reproduction_State is access all Reproduction_State;
    for Access_All_Reproduction_State'Storage_Size use 0;

    Best_Individual : Genetics.Individual;
    Best_Fitness    : Genetics.Fitness;

    Has_Mozart        : Boolean;
    Mozart            : Genetics.Genome;
    Mozart_Individual : Genetics.Individual;
    Mozart_Fitness    : Genetics.Fitness;

    function Actual_Compute_Fitness (Genome     : Genetics.Genome;
				     Individual : Genetics.Individual;
				     Trace      : Boolean)
				    return Genetics.Fitness is
	Result : constant Genetics.Fitness :=
	   Compute_Fitness (Genome, Individual, Trace);
	use type Genetics.Fitness;
    begin
	if Result > Best_Fitness then
	    Best_Fitness    := Result;
	    Best_Individual := Individual;
	    if Best_Fitness > Mozart_Fitness then
		Has_Mozart        := True;
		Mozart_Fitness    := Best_Fitness;
		Mozart_Individual := Best_Individual;
		Mozart            := Genome;
	    end if;
	end if;
	return Result;
    end Actual_Compute_Fitness;

    procedure Beget_Children (P           : Genetics.Access_Constant_Population;
			      First, Last : Genetics.Individual;
			      S           : Access_All_Reproduction_State) is
	package Randomizer is new Genetics.Randomizer (Seed);
    begin
	for I in First .. Last loop

	    declare
		Parent1 : constant Genetics.Individual :=
		   Randomizer.Pick (S.Fitnesses);
		Parent2 : Genetics.Individual;

		use type Genetics.Individual;
	    begin

		-- Avoid self-fecundation.
		loop
		    Parent2 := Randomizer.Pick (S.Fitnesses);
		    exit when Parent1 /= Parent2;
		end loop;

		case Crossover is

		    when 1 =>
			Randomizer.One_Point_Crossover
			   (P (Parent1), P (Parent2), S.Children (I));

		    when 2 =>
			Randomizer.Two_Point_Crossover
			   (P (Parent1), P (Parent2), S.Children (I));
		end case;
		Randomizer.Mutate (S.Children (I));
		Apply_Constraints (S.Children (I));
	    end;

	end loop;
    end Beget_Children;

    procedure Beget_Children is
       new Genetics.Process_Population
	      (State                 => Reproduction_State,
	       Access_All_State      => Access_All_Reproduction_State,
	       Process_Subpopulation => Beget_Children);

    function Compute_Fitnesses is new Genetics.Compute_Fitnesses
					 (Boolean, Actual_Compute_Fitness);

    P1 : aliased Genetics.Population;
    P2 : aliased Genetics.Population;

    Current   : Genetics.Access_All_Population;
    Next      : Genetics.Access_All_Population;
    Fitnesses : aliased Genetics.Fitnesses;
    Age       : Positive;

    use type Genetics.Fitness;
begin
    -- No optimization is taking place in some cases, but we still want to
    -- select the colors and output a file.
    if Optimize then

	-- Random population at the beginning.
	Current := P1'Unchecked_Access;
	Next    := P2'Unchecked_Access;

	declare
	    package Randomizer is new Genetics.Randomizer (Seed);
	begin
	    for G in Current'Range loop
		Current (G) := Randomizer.Random;
		Apply_Constraints (Current (G));
	    end loop;
	end;

	Age := 1;
	while Age <= Generations loop

	    -- Evaluate fitness.
	    Best_Fitness := 0.0;
	    Has_Mozart   := False;
	    Fitnesses    :=
	       Compute_Fitnesses
		  (Genetics.Access_Constant_Population (Current), False);

	    -- Print the best individual.
	    exit when Best_Fitness = 1.0;
	    if Trace (Options.Age) then
		Ada.Text_Io.Put_Line (Ada.Text_Io.Standard_Error,
				      Integer'Image (Age) &
					 Genetics.Fitness'Image (Best_Fitness));
	    end if;
	    if (Has_Mozart and then Trace (Options.Mozart)) or else
	       Trace (Options.Genome) then
		Trace_Genome (Current (Best_Individual));
	    end if;

	    -- Reproduction.
	    declare
		S : aliased Reproduction_State :=
		   (Children => Next, Fitnesses => Fitnesses'Unchecked_Access);
	    begin
		Beget_Children (Genetics.Access_Constant_Population (Current),
				S'Unchecked_Access);
	    end;

	    -- Switch the generations.
	    declare
		Tmp : constant Genetics.Access_All_Population := Current;
	    begin
		Current := Next;
		Next    := Tmp;
	    end;

	    Age := Age + 1;
	end loop;

	if Trace (Options.Mozart) then
	    Ada.Text_Io.Put_Line
	       (Ada.Text_Io.Standard_Error,
		"Mozart" & Genetics.Fitness'Image (Mozart_Fitness));
	    Trace_Genome (Mozart);

	    -- For tracing.
	    pragma Assert (not Trace (Options.Imperfections) or else
			   Mozart_Fitness =
			      Compute_Fitness
				 (Mozart, Mozart_Individual, True));
	end if;

    end if;

    Output_Genome (Mozart, Age, Mozart_Fitness);
end Generator;
