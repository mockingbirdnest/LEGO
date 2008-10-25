with Ada.Numerics.Float_Random;
generic
    Genome_Size          : in Natural;
    Pool_Size            : in Positive;
    Population_Size      : in Positive;
    Mutation_Probability : in Ada.Numerics.Float_Random.Uniformly_Distributed;
package Genetics is

    type Fitness is new Float;
    type Gene is new Integer range 1 .. Genome_Size;
    type Individual is new Integer range 1 .. Population_Size;

    type Fitnesses is private;
    type Genome is array (Gene) of Boolean;
    type Population is array (Individual) of Genome;

    type Access_All_Fitnesses is access all Genetics.Fitnesses;
    type Access_Constant_Fitnesses is access constant Genetics.Fitnesses;
    type Access_All_Population is access all Genetics.Population;
    type Access_Constant_Population is access constant Genetics.Population;

    -- Each instance of this package has its own set of random generators.
    generic
        Seed : Integer;
    package Randomizer is

        function Random return Genome;

        function One_Point_Crossover (G1, G2 : Genome) return Genome;
        function Two_Point_Crossover (G1, G2 : Genome) return Genome;
        function Mutate (G : Genome) return Genome;

        procedure One_Point_Crossover (G1, G2 : Genome; G : out Genome);
        procedure Two_Point_Crossover (G1, G2 : Genome; G : out Genome);
        procedure Mutate (G : in out Genome);

        function Pick (F : Access_Constant_Fitnesses) return Individual;

    end Randomizer;

    generic
        type State is limited private;
        type Access_All_State is access all State;
        with procedure Process_Subpopulation (P : Access_Constant_Population;
                                              First, Last : Individual;
                                              S : Access_All_State);
    procedure Process_Population (P : Access_Constant_Population;
                                  S : Access_All_State);

    generic
        type Options is private;
        with function Compute_Fitness
                         (G : Genome; I : Individual; O : Options)
                         return Fitness;
    function Compute_Fitnesses
                (P : Access_Constant_Population; O : Options) return Fitnesses;

private
    type Array_Of_Fitness is array (Individual'Base range <>) of Fitness;

    type Fitnesses is
        record
            Individual : Array_Of_Fitness (Genetics.Individual);
            Cumulative : Array_Of_Fitness (Genetics.Individual'First - 1 ..
                                              Genetics.Individual'Last);
        end record;

    for Access_All_Fitnesses'Storage_Size use 0;
    for Access_Constant_Fitnesses'Storage_Size use 0;
    for Access_All_Population'Storage_Size use 0;
    for Access_Constant_Population'Storage_Size use 0;
end Genetics;

