with Genetics;
with Options;
generic
    -- Parameters of the genetic algorithm.
    Crossover   : Options.Crossover_Option;
    Generations : Positive;
    Seed        : Integer;

    -- True if we want to run a genetic algorithm to optimize fitness.
    Optimize    : Boolean;

    -- Options for tracing the generic algorithm.
    Trace       : Options.Trace_Options;

    with package Genetics is new Standard.Genetics (<>);

    -- Called on each newly created genome (on the first day of creation or
    -- after reproduction) to make sure that it satisfies the constraints.
    with procedure Apply_Constraints (Genome : in out Genetics.Genome);

    with function Compute_Fitness (Genome     : Genetics.Genome;
				   Individual : Genetics.Individual;
				   Trace      : Boolean)
				  return Genetics.Fitness;

    with procedure Output_Genome (Genome  : Genetics.Genome;
				  Age     : Positive;
				  Fitness : Genetics.Fitness);
    with procedure Trace_Genome (Genome : Genetics.Genome);
procedure Generator;
