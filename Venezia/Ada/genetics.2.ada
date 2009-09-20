with Ada.Numerics.Discrete_Random;
with Ada.Text_Io;
with Ada.Float_Text_Io;

package body Genetics is

    Instantiation_Id : Integer := 0;

    package body Randomizer is

        package Boolean_Random is new Ada.Numerics.Discrete_Random (Boolean);
        package Float_Random renames Ada.Numerics.Float_Random;
        package Gene_Random is new Ada.Numerics.Discrete_Random (Gene);

        Boolean_Generator : Boolean_Random.Generator;
        Float_Generator   : Float_Random.Generator;
        Gene_Generator    : Gene_Random.Generator;

        Is_First_Call_To_Random : Boolean := True;
        Random_Genome           : Genome;

        function Random return Genome is
            Offset : Gene;
            Result : Genome;
        begin

            -- In order to speed-up the initialization, the first time around we generate a truly random genome.  After
            -- that we return a random rotation of that genome.
            if Is_First_Call_To_Random then
                for G in Result'Range loop
                    Random_Genome (G) :=
                       Boolean_Random.Random (Boolean_Generator);
                    Result (G)        := Random_Genome (G);
                end loop;
                Is_First_Call_To_Random := False;
            else
                Offset := Gene_Random.Random (Gene_Generator);
                for G in Result'Range loop
                    Result (G) :=
                       Random_Genome
                          (((G - Gene'First + Offset) mod Gene'Last) +
                           Gene'First);
                end loop;
            end if;
            return Result;
        end Random;

        function One_Point_Crossover (G1, G2 : Genome) return Genome is
            Result : Genome;
        begin
            One_Point_Crossover (G1, G2, Result);
            return Result;
        end One_Point_Crossover;

        function Two_Point_Crossover (G1, G2 : Genome) return Genome is
            Result : Genome;
        begin
            Two_Point_Crossover (G1, G2, Result);
            return Result;
        end Two_Point_Crossover;

        function Mutate (G : Genome) return Genome is
            Result : Genome := G;
        begin
            Mutate (Result);
            return Result;
        end Mutate;

        procedure One_Point_Crossover (G1, G2 : Genome; G : out Genome) is
            Point : constant Gene := Gene_Random.Random (Gene_Generator);
        begin
            -- Ada.Text_Io.Put_Line (Ada.Text_Io.Standard_Error,
            --                       "Xover1 " & Gene'Image (Point));
            if Boolean_Random.Random (Boolean_Generator) then
                G (Gene'First .. Point - 1) := G1 (Gene'First .. Point - 1);
                G (Point .. Gene'Last)      := G2 (Point .. Gene'Last);
            else
                G (Gene'First .. Point - 1) := G2 (Gene'First .. Point - 1);
                G (Point .. Gene'Last)      := G1 (Point .. Gene'Last);
            end if;
        end One_Point_Crossover;

        procedure Two_Point_Crossover (G1, G2 : Genome; G : out Genome) is
            P1     : constant Gene := Gene_Random.Random (Gene_Generator);
            P2     : constant Gene := Gene_Random.Random (Gene_Generator);
            Point1 : Gene;
            Point2 : Gene;
        begin
            if P1 < P2 then
                Point1 := P1;
                Point2 := P2;
            else
                Point1 := P2;
                Point2 := P1;
            end if;
            -- Ada.Text_Io.Put_Line (Ada.Text_Io.Standard_Error,
            --                       "Xover2 " & Gene'Image (Point1) &
            --                          Gene'Image (Point2));
            if Boolean_Random.Random (Boolean_Generator) then
                G (Gene'First .. Point1 - 1) := G1 (Gene'First .. Point1 - 1);
                G (Point1 .. Point2 - 1)     := G2 (Point1 .. Point2 - 1);
                G (Point2 .. Gene'Last)      := G1 (Point2 .. Gene'Last);
            else
                G (Gene'First .. Point1 - 1) := G2 (Gene'First .. Point1 - 1);
                G (Point1 .. Point2 - 1)     := G1 (Point1 .. Point2 - 1);
                G (Point2 .. Gene'Last)      := G2 (Point2 .. Gene'Last);
            end if;
        end Two_Point_Crossover;

        procedure Mutate (G : in out Genome) is
            Mutations :
               array (1 .. Natural'Max
                              (1, Natural (Mutation_Probability *
                                           Float (Gene'Last - Gene'First + 1))))
                  of
                  Gene :=
               (others => Gene_Random.Random (Gene_Generator));
        begin
            -- for I in Gene loop
            --     if Float_Random.Random (Float_Generator) <
            --        Mutation_Probability then
            --         G (I) := not G (I);
            --     end if;
            -- end loop;
            for M in Mutations'Range loop
                -- Ada.Text_Io.Put_Line (Ada.Text_Io.Standard_Error,
                --                       "Mutated " & Gene'Image (Mutations (M)));
                G (Mutations (M)) := not G (Mutations (M));
            end loop;
        end Mutate;

        function Pick (F : Access_Constant_Fitnesses) return Individual is
            Key : constant Fitness :=
               Fitness (Float_Random.Random (Float_Generator)) *
                  F.Cumulative (Individual'Last);

            L, M, U : Individual'Base;
        begin
            -- Ada.Float_Text_Io.Put
            --    (Ada.Text_Io.Standard_Error,
            --     Float (Key), 1, 20, 0);
            -- Ada.Text_Io.New_Line (Ada.Text_Io.Standard_Error);
            -- Knuth 6.2 Algorithm B.
            L := F.Cumulative'First;
            U := F.Cumulative'Last;
            loop
                if U < L then
                    -- Exercise 1 says that U = L - 1 and Ku < K < Kl.
                    -- if L = 825 then
                    --     --     -- for I in F.Cumulative'Range loop
                    --     --     --     Ada.Text_Io.Put
                    --     --     --        (Ada.Text_Io.Standard_Error,
                    --     --     --         "Cum(" & Individual'Image (I) & ") = ");
                    --     --     --     Ada.Float_Text_Io.Put
                    --     --     --        (
                    --     --     --         Ada.Text_Io.Standard_Error,
                    --     --     --         Float (F.Cumulative (I)), 1, 20, 0);
                    --     --     --     Ada.Text_Io.New_Line (Ada.Text_Io.Standard_Error);
                    --     --     -- end loop;
                    --     --     Ada.Text_Io.Put
                    --     --        (Ada.Text_Io.
                    --     --         Standard_Error,
                    --     --         "Picked " & Individual'Image (L) & " ");
                    --     Ada.Float_Text_Io.Put
                    --        (Ada.Text_Io.Standard_Error,
                    --         Float (Key), 1, 20, 0);
                    --     Ada.Text_Io.New_Line (Ada.Text_Io.Standard_Error);
                    -- end if;
                    -- Ada.Text_Io.Put_Line
                    --    (Ada.Text_Io.
                    --     Standard_Error, "Picked2 " & Individual'Image (L));
                    return L;
                end if;
                M := (U + L) / 2;
                if Key < F.Cumulative (M) then
                    U := M - 1;
                elsif Key > F.Cumulative (M) then
                    L := M + 1;
                elsif M < Individual'First then
                    -- Ada.Text_Io.Put_Line
                    --    (Ada.Text_Io.
                    --     Standard_Error, "Picked first");
                    return Individual'First;
                else
                    -- Ada.Text_Io.Put_Line
                    --    (Ada.Text_Io.
                    --     Standard_Error, "Picked " & Individual'Image (M));
                    return M;
                end if;
            end loop;
        end Pick;

    begin
        Instantiation_Id := Instantiation_Id + Seed;
        Boolean_Random.Reset (Boolean_Generator, Instantiation_Id);
        Float_Random.Reset (Float_Generator, Instantiation_Id);
        Gene_Random.Reset (Gene_Generator, Instantiation_Id);
    end Randomizer;

    procedure Process_Population (P : Access_Constant_Population;
                                  S : Access_All_State) is

        task type Processor (P : Access_Constant_Population;
                             First, Last : Individual;
                             S : Access_All_State) is
        end Processor;

        task body Processor is
        begin
            Process_Subpopulation (P => P,
                                   First => First,
                                   Last => Last,
                                   S => S);
        end Processor;

    begin
        if Pool_Size = 1 then
            Process_Subpopulation (P => P,
                                   First => Individual'First,
                                   Last => Individual'Last,
                                   S => S);
        else

            declare
                Length : constant Individual'Base :=
                   (Individual'Last - Individual'First + 1) /
                      Individual'Base (Pool_Size) + 1;

                type Access_Processor is access Processor;

                A_Processor : Access_Processor;
                First, Last : Individual'Base;
            begin
                First := Individual'First;
                while First <= Individual'Last loop
                    Last        := Individual'Min
                                      (Individual'Last, First + Length - 1);
                    A_Processor := new Processor (P => P,
                                                  First => First,
                                                  Last => Last,
                                                  S => S);
                    First       := Last + 1;
                end loop;
            end;

        end if;
    end Process_Population;

    function Compute_Fitnesses
                (P : Access_Constant_Population; O : Options)
                return Fitnesses is

        procedure Compute_Range_Of_Individual_Fitnesses
                     (Population : Access_Constant_Population;
                      First, Last : Individual;
                      Fitnesses : Access_All_Fitnesses) is
        begin
            for I in First .. Last loop
                Fitnesses.Individual (I) :=
                   Compute_Fitness (Population (I), I, O);
            end loop;
        end Compute_Range_Of_Individual_Fitnesses;

        procedure Compute_All_Individual_Fitnesses is
           new Process_Population
                  (State => Fitnesses,
                   Access_All_State => Access_All_Fitnesses,
                   Process_Subpopulation =>
                      Compute_Range_Of_Individual_Fitnesses);

        Result : aliased Fitnesses;
    begin

        -- First, compute the individual fitnesses in parallel.
        Compute_All_Individual_Fitnesses (P => P,
                                          S => Result'Unchecked_Access);

        -- Then compute the cumulative fitnesses.  This is a sequential step, but a fast one.
        Result.Cumulative (P'First - 1) := 0.0;
        for I in Individual loop
            Result.Cumulative (I) :=
               Result.Cumulative (I - 1) + Result.Individual (I);
        end loop;

        return Result;
    end Compute_Fitnesses;

end Genetics;

