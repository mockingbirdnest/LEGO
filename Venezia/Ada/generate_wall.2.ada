with Ada.Numerics.Float_Random;
with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Text_Io;
with Genetics;
with Lego;
with Options;

procedure Generate_Wall is

    package Anfr renames Ada.Numerics.Float_Random;

    use type Options.Constraint;
    use type Options.Constraint_Array;
    use type Options.Positions;
    use type Options.Visibility_Option;

    Pool_Size : constant := 1;

    Color_Generator : Anfr.Generator;

    Q : constant array (Lego.Color range Lego.Brown .. Lego.Medium_Orange,
                        Lego.Part)
                    of Float :=
       ((0.0, 0.0930782, 0.162234, 0.185097, 0.17991,
         0.0734287, 0.249504, 0.199671, 0.163888, 0.199025),
        (0.194719, 0.373236, 0.0, 0.0, 0.0,
         0.464175, 0.0, 0.0, 0.175684, 0.0),
        (0.153331, 0.0455786, 0.143734, 0.139848, 0.118911,
         0.00717916, 0.0, 0.198671, 0.0, 0.0),
        (0.164624, 0.134984, 0.178555, 0.225018, 0.233726,
         0.131876, 0.250165, 0.200553, 0.165653, 0.200789),
        (0.164624, 0.134984, 0.178555, 0.225018, 0.233726,
         0.131876, 0.250165, 0.200553, 0.165653, 0.200789),
        (0.164624, 0.134984, 0.178555, 0.225018, 0.233726,
         0.131876, 0.250165, 0.200553, 0.165653, 0.200789),
        (0.158077, 0.0831548, 0.158369, 0.0, 0.0,
         0.0595881, 0.0, 0.0, 0.16347, 0.198607));
    -- ((0.0, 0.0964228, 0.16123, 0.181568, 0.175153,
    --   0.0780935, 0.249504, 0.199593, 0.164183, 0.199051),
    --  (0.190301, 0.337705, 0.0, 0.0, 0.0,
    --   0.414619, 0.0, 0.0, 0.174342, 0.0),
    --  (0.156168, 0.0674792, 0.149957, 0.153996, 0.137983,
    --   0.0377248, 0.0, 0.198983, 0.0, 0.0),
    --  (0.165116, 0.138318, 0.177547, 0.221479, 0.228955,
    --   0.136526, 0.250165, 0.200475, 0.165947, 0.200815),
    --  (0.165116, 0.138318, 0.177547, 0.221479, 0.228955,
    --   0.136526, 0.250165, 0.200475, 0.165947, 0.200815),
    --  (0.165116, 0.138318, 0.177547, 0.221479, 0.228955,
    --   0.136526, 0.250165, 0.200475, 0.165947, 0.200815),
    --  (0.158184, 0.0834396, 0.156173, 0.0, 0.0,
    --   0.0599854, 0.0, 0.0, 0.163636, 0.198504));

    Pleasantness : array (Lego.Color) of Float :=
       (Lego.Bright_Pink | Lego.Clear | Lego.Light_Orange |
        Lego.Light_Pink | Lego.Magenta | Lego.Pink |
        Lego.Sand_Red | Lego.Tan | Lego.Very_Light_Orange => 0.0,

        Lego.Brown => 0.13,
        Lego.Dark_Orange => 0.18,
        Lego.Dark_Red => 0.18,
        Lego.Medium_Orange => 0.05,
        Lego.Orange => 0.10,
        Lego.Red => 0.18,
        Lego.Reddish_Brown => 0.18
        );


    Bottom      : constant Options.Constraint         := Options.Bottom;
    Color       : constant Options.Color_Option       := Options.Color;
    Color_Seed  : constant Integer                    := Options.Color_Seed;
    Corner      : constant Options.Positions          := Options.Corner;
    Crossover   : constant Options.Crossover_Option   := Options.Crossover;
    File        : Ada.Text_Io.File_Type renames Options.File;
    Generations : constant Positive                   := Options.Generations;
    Left        : Options.Constraint;
    Mutations   : constant Float                      := Options.Mutations;
    Parts       : constant Options.Parts_Option       := Options.Parts;
    Population  : constant Positive                   := Options.Population;
    Right       : Options.Constraint;
    Seed        : constant Integer                    := Options.Seed;
    Tee         : constant Options.Positions          := Options.Tee;
    Top         : constant Options.Constraint         := Options.Top;
    Trace       : constant Options.Trace_Options      := Options.Trace;
    Visibility  : constant Options.Visibility_Options := Options.Visibility;

    Height : constant Positive := Options.Height +
                                     Boolean'Pos (Bottom /= null) +
                                     Boolean'Pos (Top /= null);
    Width  : constant Positive := Options.Width;

    type Separations is array (1 .. Height, 1 .. Width - 1) of Boolean;

    package Genetics is
       new Standard.Genetics (Genome_Size => Height * (Width - 1),
                              Pool_Size => Pool_Size,
                              Population_Size => Population,
                              Mutation_Probability =>
                                 Mutations);

    package Ef is new Ada.Numerics.Generic_Elementary_Functions
                         (Genetics.Fitness);

    Width_Minus_One : constant Genetics.Gene :=
       Genetics.Gene (Width - 1);

    Best_Individual : Genetics.Individual;
    Best_Fitness    : Genetics.Fitness;

    Has_Mozart        : Boolean;
    Mozart            : Genetics.Genome;
    Mozart_Individual : Genetics.Individual;
    Mozart_Fitness    : Genetics.Fitness;

    procedure Apply_Constraints (Genome : in out Genetics.Genome) is
        First, Last : Genetics.Gene'Base;
        use type Genetics.Gene;
    begin
        if Bottom /= null then
            Last := Genome'First - 1;
            for I in Bottom'Range loop
                First                      := Last + 1;
                Last                       := Last + Genetics.Gene (Bottom (I));
                Genome (First .. Last - 1) := (others => False);
                if Last <= Width_Minus_One then
                    Genome (Last) := True;
                end if;
            end loop;
        end if;
        if Top /= null then
            Last := Genome'Last - Width_Minus_One;
            for I in Top'Range loop
                First                      := Last + 1;
                Last                       := Last + Genetics.Gene (Top (I));
                Genome (First .. Last - 1) := (others => False);
                if Last <= Genome'Last then
                    Genome (Last) := True;
                end if;
            end loop;
        end if;
        if Left /= null then
            for I in Left'Range loop
                First :=
                   Genetics.Gene'Base (I - Left'First) * Width_Minus_One +
                      Genome'First;
                if Left (I) > 0 then
                    Last                       :=
                       First + Genetics.Gene'Base (Left (I)) - 1;
                    Genome (First .. Last - 1) := (others => False);
                    Genome (Last)              := True;
                end if;
            end loop;
        end if;
        if Right /= null then
            for I in Right'Range loop
                Last :=
                   Genetics.Gene'Base (I - Right'First + 1) * Width_Minus_One;
                if Right (I) > 0 then
                    First                      :=
                       Last - Genetics.Gene'Base (Right (I)) + 1;
                    Genome (First + 1 .. Last) := (others => False);
                    Genome (First)             := True;
                end if;
            end loop;
        end if;
    end Apply_Constraints;

    function Compute_Fitness (Genome : Genetics.Genome;
                              Individual : Genetics.Individual)
                             return Genetics.Fitness is
        Corner_Cost     : constant := 2.0;
        Tee_Cost        : constant := 0.1;
        Separation_Cost : constant := 1.0;

        Anchors                 :
           array (1 .. Options.Length (Tee)) of Natural :=
           (others => 0);
        At_Edge_Of_Aligned_Rows : Boolean;
        Part_Width              : Natural;
        Column                  : Natural;
        Result                  : Genetics.Fitness      := 0.0;
        Row                     : Positive;

        use type Genetics.Fitness;

        function Part_Cost (Width : Positive) return Genetics.Fitness is
        begin
            case Width is
                when 1 | 2 | 4 | 6 =>
                    return 0.0;
                when 3 =>
                    case Parts is
                        when Options.Plates =>
                            return 0.0;
                        when Options.Tiles =>
                            if (Bottom /= null and then Row = 1) or else
                               (Top /= null and then Row = Height) then
                                -- In horizontal constraint.
                                return 0.0;
                            else
                                return Genetics.Fitness (Width);
                            end if;
                    end case;
                when 8 =>
                    return 0.1;
                when others =>
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
               Row > 1 and then
                  ((Left /= null and then
                    Column = Left (Row) and then
                    Column = Left (Row - 1)) or else
                   (Right /= null and then
                    Column = Width - Right (Row) and then
                    Column = Width - Right (Row - 1)));

            -- Here Part_Width is the width of the part being constructed.
            if Column = Positive (Width_Minus_One) then

                -- End of a row.
                if Genome (I) then
                    Result := Result + Part_Cost (Part_Width) +
                                 Part_Cost (1);
                    if Row > 1 and then
                       not At_Edge_Of_Aligned_Rows and then
                       Genome (I - Width_Minus_One) then
                        Result := Result + Separation_Cost;
                    end if;
                else
                    if Right = null or else Column < Width - Right (Row) then
                        Result := Result + Part_Cost (Part_Width + 1);
                    end if;
                end if;
                Part_Width := 0;
                Row        := Row + 1;
            else
                if Genome (I) then
                    if Left = null or else Column > Left (Row) then
                        Result := Result + Part_Cost (Part_Width);
                    end if;
                    Part_Width := 0;
                    if Row > 1 and then
                       not At_Edge_Of_Aligned_Rows and then
                       Genome (I - Width_Minus_One) then
                        Result := Result + Separation_Cost;
                    end if;
                end if;
            end if;

            if (Bottom = null or else Row > 1) and then
               (Top = null or else Row < Height) then

                if Corner /= null then
                    for J in Corner'Range loop
                        if Column = Corner (J) then

                            -- We are at the separation immediately after the stud for a corner.
                            if Genome (I) or else Genome (I - 1) then

                                -- This is an 1xN or Nx1 corner.  Fine.
                                null;
                            elsif (Column = 2 or else
                                   Genome (I - 2)) and then
                                  (Column = Positive (Width_Minus_One) or else
                                   Genome (I + 1)) then

                                -- This case can be covered by a 2x2 corner, but only for plates.
                                case Parts is
                                    when Options.Plates =>
                                        null;
                                    when Options.Tiles =>
                                        Result := Result + Corner_Cost;
                                end case;
                            else
                                -- This is not a corner that we like.
                                Result := Result + Corner_Cost;
                            end if;
                        end if;
                    end loop;
                end if;

                if Tee /= null then
                    for J in Tee'Range loop
                        if Column = Tee (J) then

                            -- We are at the separation immediately after the stud for a tee.
                            if (Column = Width or else
                                Genome (I)) and then
                               (Column = 1 or else Genome (I - 1)) then

                                -- This is an 1x1 on the stud of the tee.
                                Anchors (J) := Anchors (J) + 1;
                            elsif (Column = Width or else
                                   Genome (I)) and then
                                  (Column = 2 or else Genome (I - 2)) then

                                -- This is a corner before the stud of the tee.
                                Anchors (J) := Anchors (J) + 1;
                            elsif (Column = 1 or else Genome (I - 1)) and then
                                  (Column = Positive (Width_Minus_One) or else
                                   Genome (I + 1)) then

                                -- This is a corner after the stud of the tee.
                                Anchors (J) := Anchors (J) + 1;
                            end if;
                        end if;
                    end loop;
                end if;

            end if;

            Part_Width := Part_Width + 1;
            if Column = Positive (Width_Minus_One) then
                Column := 1;
            else
                Column := Column + 1;
            end if;
        end loop;

        if Tee /= null then

            declare
                Lo         : Genetics.Fitness :=
                   Genetics.Fitness (Options.Height) / 3.0;
                Hi         : Genetics.Fitness :=
                   Genetics.Fitness (Options.Height) / 2.0;
                Correction : Genetics.Fitness;
            begin
                -- Make sure that we have at least 3 values that are considered "good".
                if Hi - Lo < 4.0 then
                    Correction := 2.0 - (Hi - Lo) / 2.0;
                    Lo         := Lo - Correction;
                    Hi         := Hi + Correction;
                end if;
                for J in Tee'Range loop
                    Result :=
                       Result +
                          Genetics.Fitness'Max
                             (0.0, Tee_Cost *
                                      (Genetics.Fitness (Anchors (J)) - Lo) *
                                      (Genetics.Fitness (Anchors (J)) - Hi));
                end loop;
            end;

        end if;

        Result := Ef.Exp (-100.0 * Result /
                           Genetics.Fitness (Height * Width));

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
    end Compute_Fitness;


    generic
        type State is private;
        Initial : in State;
        with procedure Part (First_Stud, Last_Stud : Positive;
                             S : in out State);
    procedure Process_Wall (Genome : Genetics.Genome);

    procedure Process_Wall (Genome : Genetics.Genome) is
        Has_Separation : Separations;
        Part_Width     : Natural;
        S              : State;
    begin
        S := Initial;

        declare
            C : Integer;
        begin
            C := 0;
            for H in 1 .. Height loop
                for W in 1 .. Width - 1 loop
                    Has_Separation (H, W) := Genome (Genetics.Gene (C + W));
                end loop;
                C := C + Width - 1;
            end loop;
        end;

        for H in 1 .. Height loop
            Part_Width := 1;
            for W in 1 .. Width - 1 loop
                if Has_Separation (H, W) then
                    Part (First_Stud => W - Part_Width + 1,
                          Last_Stud => W,
                          S => S);
                    Part_Width := 1;
                else
                    Part_Width := Part_Width + 1;
                end if;
            end loop;
            Part (First_Stud => Width - Part_Width + 1,
                  Last_Stud => Width,
                  S => S);
        end loop;
    end Process_Wall;

    type Trace_State is null record;

    procedure Trace_Part (First_Stud, Last_Stud : Positive;
                          S : in out Trace_State) is
        Width_Indicator :
           constant array (Positive range <>) of Character :=
           "123456789ABCDEFGHIJKLM";
        Part_Width      : constant Positive                :=
           Last_Stud - First_Stud + 1;
    begin
        if Part_Width = 1 then
            Ada.Text_Io.Put (Ada.Text_Io.Standard_Error, '|');
        else
            Ada.Text_Io.Put (Ada.Text_Io.Standard_Error, '[');
            for I in 1 .. Part_Width - 2 loop
                Ada.Text_Io.Put (Ada.Text_Io.Standard_Error,
                                 Width_Indicator (Part_Width));
            end loop;
            Ada.Text_Io.Put (Ada.Text_Io.Standard_Error, ']');
        end if;
        if Last_Stud = Width then
            Ada.Text_Io.New_Line (Ada.Text_Io.Standard_Error);
        end if;
    end Trace_Part;


    type Reproduction_State is
        record
            Children  : Genetics.Access_All_Population;
            Fitnesses : Genetics.Access_Constant_Fitnesses;
        end record;
    pragma Convention (Ada_Pass_By_Reference,
                       Reproduction_State); -- To avoid a warning.

    type Access_All_Reproduction_State is access all Reproduction_State;
    for Access_All_Reproduction_State'Storage_Size use 0;

    procedure Beget_Children (P : Genetics.Access_Constant_Population;
                              First, Last : Genetics.Individual;
                              S : Access_All_Reproduction_State) is
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
                           (P (Parent1),
                            P (Parent2), S.Children (I));

                    when 2 =>
                        Randomizer.Two_Point_Crossover
                           (P (Parent1),
                            P (Parent2), S.Children (I));
                end case;
                Randomizer.Mutate (S.Children (I));
                Apply_Constraints (S.Children (I));
            end;

        end loop;
    end Beget_Children;

    procedure Beget_Children is
       new Genetics.Process_Population
              (State => Reproduction_State,
               Access_All_State => Access_All_Reproduction_State,
               Process_Subpopulation => Beget_Children);

    function Compute_Fitnesses is
       new Genetics.Compute_Fitnesses (Compute_Fitness);

    procedure Trace_Wall is new Process_Wall
                                   (State => Trace_State,
                                    Initial => (null record),
                                    Part => Trace_Part);

    P1 : aliased Genetics.Population;
    P2 : aliased Genetics.Population;

    Current   : Genetics.Access_All_Population;
    Next      : Genetics.Access_All_Population;
    Fitnesses : aliased Genetics.Fitnesses;
    Age       : Positive;

    use type Genetics.Fitness;
begin
    if Options.Error then
        return;
    end if;

    if Options.Left /= null then
        Left := new Options.Constraint_Array'
                       ((1 .. Boolean'Pos (Bottom /= null) => 0) &
                        Options.Left.all &
                        (1 .. Boolean'Pos (Top /= null) => 0));
    end if;
    if Options.Right /= null then
        Right := new Options.Constraint_Array'
                        ((1 .. Boolean'Pos (Bottom /= null) => 0) &
                         Options.Right.all &
                         (1 .. Boolean'Pos (Top /= null) => 0));
    end if;

    -- Random population at the beginning.
    Current := P1'Access;
    Next    := P2'Access;

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
              (Genetics.Access_Constant_Population (Current));

        -- Print the best individual.
        exit when Best_Fitness = 1.0;
        if Trace (Options.Age) then
            Ada.Text_Io.Put_Line
               (Ada.Text_Io.Standard_Error,
                Integer'Image (Age) &
                   Genetics.Fitness'Image (Best_Fitness));
        end if;
        if (Has_Mozart and then
            Trace (Options.Mozart)) or else
           Trace (Options.Genome) then
            Trace_Wall (Current (Best_Individual));
        end if;

        -- Reproduction.
        declare
            S : aliased Reproduction_State :=
               (Children => Next,
                Fitnesses => Fitnesses'Unchecked_Access);
        begin
            Beget_Children
               (Genetics.Access_Constant_Population (Current),
                S'Unchecked_Access);
        end;

        -- Switch the generations.
        declare
            Tmp : constant Genetics.Access_All_Population :=
               Current;
        begin
            Current := Next;
            Next    := Tmp;
        end;

        Age := Age + 1;
    end loop;

    if Trace (Options.Mozart) then
        Ada.Text_Io.Put_Line (Ada.Text_Io.Standard_Error,
                              "Mozart" &
                                 Genetics.Fitness'Image (Mozart_Fitness));
        Trace_Wall (Mozart);
    end if;

    -- Anfr.Reset (Color_Generator, 42);

    -- We want to make sure that different walls explore different sequences of the
    -- color generator, otherwise we would have biases.  We use as the seed the number
    -- of studs, which is as good a number as any.
    Anfr.Reset (Color_Generator, Options.Height * Options.Width + Color_Seed);

    Ada.Text_Io.Put_Line (File, "0 Author: Generate_Wall");
    Ada.Text_Io.Put_Line (File, "0 Unofficial Model");
    Ada.Text_Io.Put_Line (File, "0 Rotation Center 0 0 0 1 ""Custom""");
    Ada.Text_Io.Put_Line (File, "0 Rotation Config 0 0");
    if Bottom /= null then
        Ada.Text_Io.Put_Line (File, "0 /bottom " & Options.Image (Bottom));
    end if;
    Ada.Text_Io.Put_Line (File, "0 /color " &
                                   Options.Color_Option'Image (Color));
    Ada.Text_Io.Put_Line (File, "0 /colorseed" & Integer'Image (Color_Seed));
    if Corner /= null then
        for J in Corner'Range loop
            Ada.Text_Io.Put_Line (File,
                                  "0 /corner" & Positive'Image (Corner (J)));
        end loop;
    end if;
    Ada.Text_Io.Put_Line (File, "0 /crossover" &
                                   Options.Crossover_Option'Image (Crossover));
    Ada.Text_Io.Put_Line (File, "0 /height" & Positive'Image (Options.Height));
    if Left /= null then
        Ada.Text_Io.Put_Line (File, "0 /left " & Options.Image (Options.Left));
    end if;
    Ada.Text_Io.Put_Line (File, "0 /mutations" & Float'Image (Mutations));
    Ada.Text_Io.Put_Line (File, "0 /population" &
                                   Positive'Image (Population));
    if Right /= null then
        Ada.Text_Io.Put_Line (File, "0 /right " &
                                       Options.Image (Options.Right));
    end if;
    Ada.Text_Io.Put_Line (File, "0 /seed" & Integer'Image (Seed));
    if Tee /= null then
        for J in Tee'Range loop
            Ada.Text_Io.Put_Line (File,
                                  "0 /tee" & Positive'Image (Tee (J)));
        end loop;
    end if;
    if Top /= null then
        Ada.Text_Io.Put_Line (File, "0 /top " & Options.Image (Top));
    end if;
    Ada.Text_Io.Put_Line (File, "0 /width" & Positive'Image (Options.Width));
    Ada.Text_Io.Put_Line (File, "0 /result_fitness" &
                                   Genetics.Fitness'Image (Mozart_Fitness));
    Ada.Text_Io.Put_Line (File, "0 /result_generation" & Positive'Image (Age));


    declare
        type Horizontal is (X_Axis, Z_Axis);
        Other        : constant array (Horizontal) of Horizontal :=
           (X_Axis => Z_Axis, Z_Axis => X_Axis);
        Cumulative_Q : array (Q'Range (1), Q'Range (2)) of Float;

        type Output_State is
            record
                X, Y, Z      : Integer;
                Direction    : Horizontal;
                Last_Color   : Lego.Color;
                Start_Of_Row : Boolean;
            end record;

        procedure Output_Part (First_Stud, Last_Stud : Positive;
                               S : in out Output_State) is
            use type Lego.Color;
            use type Options.Parts_Option;

            Is_Left_Right : constant Boolean  :=
               (Left /= null and then
                Last_Stud <= Left (1 - S.Y)) or else
               (Right /= null and then
                First_Stud >= Width - Right (1 - S.Y) + 1);
            Is_Top_Bottom : constant Boolean  :=
               (Bottom /= null and then S.Y = 0) or else
                  (Top /= null and then S.Y = 1 - Height);
            Part_Width    : constant Positive :=
               Last_Stud - First_Stud + 1;
            Use_Plates    : constant Boolean  :=
               Parts = Options.Plates or else S.Y /= 1 - Height;

            C           : Lego.Color;
            Corner_Stud : Natural := 0;
            Is_2X2      : Boolean;
            Is_Tee      : Boolean := False;
            P           : Lego.Part;
            Hide        : Boolean;
            Skip        : Boolean;

            function Random (P : Lego.Part) return Lego.Color is
                R : Float range 0.0 .. 1.0;
                use type Lego.Color;
            begin
                loop

                    -- The last entry in Cumulative_Q will be very close to 1.0, but it
                    -- may not be exactly 1.0 because of rounding.  Adjust the random
                    -- number to avoid leaving a tiny hole.
                    R := Anfr.Random (Color_Generator) *
                            Cumulative_Q (Cumulative_Q'Last (1), P);

                    Scan_Cumulative_Q:
                        for Color in Cumulative_Q'Range (1) loop
                            if Q (Color, P) > 0.0 then
                                if Cumulative_Q (Color, P) >= R then

                                    -- Embarrassment: the  conditional probabilities were computed using
                                    -- a different availability matrix than the current one as far as tiles
                                    -- are concerned.  So it is possible for Random to produce unavailable
                                    -- parts in rare cases, something which would not happen if the
                                    -- conditional probabilities were right (Tile_1x4 DarkRed is one such
                                    -- example).  When that happens, we just try again. 
                                    if Lego.Available (Color, P) then
                                        return Color;
                                    else
                                        pragma Assert (P in Lego.Tile_1X1 ..
                                                               Lego.Tile_1X6);
                                        exit Scan_Cumulative_Q;
                                    end if;
                                end if;
                            end if;
                        end loop Scan_Cumulative_Q;
                end loop;
            end Random;

            procedure Put (S : String) is
            begin
                if not Skip then
                    Ada.Text_Io.Put (File, S);
                end if;
            end Put;

            procedure Put_Line (S : String) is
            begin
                if not Skip then
                    Ada.Text_Io.Put_Line (File, S);
                end if;
            end Put_Line;

        begin

            -- Determine the part to generate.
            Is_2X2 := Part_Width = 3 and then
                         Options.Is_In ((First_Stud + Last_Stud) / 2, Corner);
            case Part_Width is
                when 1 =>
                    if Use_Plates then
                        P := Lego.Plate_1X1;
                    else
                        P := Lego.Tile_1X1;
                    end if;
                    Is_Tee := Options.Is_In (First_Stud, Tee);
                when 2 =>
                    if Use_Plates then
                        P := Lego.Plate_1X2;
                    else
                        P := Lego.Tile_1X2;
                    end if;
                    Is_Tee := Options.Is_In (First_Stud, Tee) or else
                                 Options.Is_In (Last_Stud, Tee);
                when 3 =>
                    if Is_2X2 then
                        P := Lego.Plate_2X2_Corner;
                    else
                        P := Lego.Plate_1X3;
                    end if;
                when 4 =>
                    if Use_Plates then
                        P := Lego.Plate_1X4;
                    else
                        P := Lego.Tile_1X4;
                    end if;
                when 6 =>
                    if Use_Plates then
                        P := Lego.Plate_1X6;
                    else
                        P := Lego.Tile_1X6;
                    end if;
                when others =>
                    for I in First_Stud .. Last_Stud loop
                        Output_Part (I, I, S);
                    end loop;
                    return;
            end case;

            if Is_Top_Bottom then

                -- A constraint line.  For historical reasons, it doesn't consume colors.
                C := Lego.Clear;
            else

                -- Pick a color.  Make sure that we don't have two consecutive parts of the same color. 
                C := Random (P);
                pragma Assert (Lego.Available (C, P));
                while not S.Start_Of_Row and then C = S.Last_Color loop
                    C := Random (P);
                    pragma Assert (Lego.Available (C, P));
                end loop;
                S.Last_Color := C;
            end if;

            Skip := (Is_Left_Right and then
                     Visibility (Options.Left_Right) = Options.Skip) or else
                    (Is_Top_Bottom and then
                     Visibility (Options.Top_Bottom) = Options.Skip) or else
                    (Is_Tee and then
                     Visibility (Options.Tees) = Options.Skip);
            Hide := (Is_Left_Right and then
                     Visibility (Options.Left_Right) = Options.Hide) or else
                    (Is_Top_Bottom and then
                     Visibility (Options.Top_Bottom) = Options.Hide) or else
                    (Is_Tee and then
                     Visibility (Options.Tees) = Options.Hide);

            if Is_Left_Right then

                -- To preserve coloring we want this one to consume colors but to be shown clear.  Compatibility...
                C := Lego.Clear;
            end if;

            if Hide then
                Put ("0 MLCAD HIDE ");
            end if;
            Put ("1");

            case Color is
                when Options.Direct =>
                    Put (" " & Lego.Direct_Image (C));
                when Options.False =>
                    Put (" " & Lego.False_Image (C));
                when Options.Ldraw =>
                    Put (" " & Lego.Ldraw_Image (C));
            end case;

            if Is_2X2 then
                case S.Direction is
                    when X_Axis =>
                        S.X := S.X + 1;
                        S.Z := S.Z - 1;
                    when Z_Axis =>
                        S.X := S.X - 1;
                        S.Z := S.Z + 1;
                end case;
                S.Direction := Other (S.Direction);
            elsif Corner /= null and then First_Stud /= Last_Stud then
                for I in Corner'Range loop
                    if Corner (I) = First_Stud then
                        Corner_Stud := Corner (I);
                        S.Direction := Other (S.Direction);
                        exit;
                    end if;
                end loop;
            end if;

            case S.Direction is
                when X_Axis =>
                    Put (" " & Integer'Image (20 * S.X + 10 * Part_Width) &
                         " " & Integer'Image (8 * S.Y) &
                         " " & Integer'Image (20 * S.Z + 10 * 1));
                    if Is_2X2 then
                        Put (" 0 0 1 0 1 0 -1 0 0");
                    else
                        Put (" 1 0 0 0 1 0 0 0 1");
                    end if;
                when Z_Axis =>
                    Put (" " & Integer'Image (20 * S.X + 10 * 1) &
                         " " & Integer'Image (8 * S.Y) &
                         " " & Integer'Image (20 * S.Z + 10 * Part_Width));
                    Put (" 0 0 -1 0 1 0 1 0 0");
            end case;

            if Corner /= null then
                for I in Corner'Range loop
                    if Corner (I) = Last_Stud then
                        Corner_Stud := Corner (I);
                        case S.Direction is
                            when X_Axis =>
                                S.X := S.X + Part_Width - 1;
                                S.Z := S.Z + 1;
                            when Z_Axis =>
                                S.Z := S.Z + Part_Width - 1;
                                S.X := S.X + 1;
                        end case;
                        S.Direction := Other (S.Direction);
                        exit;
                    end if;
                end loop;
            end if;

            Put_Line (" " & Lego.Part_Id_Image (P) & ".DAT");

            S.Start_Of_Row := False;
            if Last_Stud = Width then
                S.Y            := S.Y - 1;
                S.X            := 0;
                S.Z            := 0;
                S.Direction    := X_Axis;
                S.Start_Of_Row := True;
                if not Skip or else not Is_Top_Bottom then
                    Ada.Text_Io.Put_Line (File, "0 STEP");
                    if Bottom = null then
                        Ada.Text_Io.Put_Line (File, "0 WRITE End of step" &
                                                       Integer'Image (-S.Y));
                    else
                        Ada.Text_Io.Put_Line (File,
                                              "0 WRITE End of step" &
                                                 Integer'Image (-S.Y - 1));
                    end if;
                end if;
            elsif Corner_Stud /= Last_Stud then
                case S.Direction is
                    when X_Axis =>
                        S.X := S.X + Part_Width;
                    when Z_Axis =>
                        S.Z := S.Z + Part_Width;
                end case;
            end if;
        end Output_Part;

        procedure Output_Wall is
           new Process_Wall
                  (State => Output_State,
                   Initial =>
                      (X => 0,
                       Y => 0,
                       Z => 0,
                       Direction => X_Axis,
                       Last_Color => Lego.Color'First,
                       Start_Of_Row => True),
                   Part => Output_Part);

        use type Lego.Color;
    begin
        for Part in Cumulative_Q'Range (2) loop
            for Color in Cumulative_Q'Range (1) loop
                if Color = Cumulative_Q'First (1) then
                    Cumulative_Q (Color, Part) := Q (Color, Part);
                else
                    Cumulative_Q (Color, Part) :=
                       Cumulative_Q (Lego.Color'Pred (Color), Part) +
                          Q (Color, Part);
                end if;
            end loop;
        end loop;

        Output_Wall (Mozart);
    end;

end Generate_Wall;
pragma Main (Stack_Size => 2 ** 28);
