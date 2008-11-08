with Ada.Numerics.Float_Random;
with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Text_Io;
with Genetics;
with Layout;
with Lego;
with Options;

procedure Generate_Wall is

    package Anfr renames Ada.Numerics.Float_Random;

    use type Lego.Part;
    use type Options.Constraint;
    use type Options.Constraint_Array;
    use type Options.Parts_Option;
    use type Options.Positions;
    use type Options.Visibility_Option;

    Pool_Size : constant := 1;

    Color_Generator : Anfr.Generator;

    Q_1Xn : constant array (Lego.Color range Lego.Brown .. Lego.Medium_Orange,
                            Lego.Plate_1Xn) of Long_Float :=
       (Lego.Brown => (
                       Lego.Plate_2X2_Corner => -0.000000,
                       Lego.Plate_1X1 => 0.162231,
                       Lego.Plate_1X3 => 0.185095,
                       Lego.Plate_1X4 => 0.073424,
                       Lego.Plate_1X6 => 0.179917,
                       Lego.Plate_1X2 => 0.093076),
        Lego.Dark_Orange => (
                             Lego.Plate_2X2_Corner => 0.194670,
                             Lego.Plate_1X1 => 0.000000,
                             Lego.Plate_1X3 => 0.000000,
                             Lego.Plate_1X4 => 0.464179,
                             Lego.Plate_1X6 => 0.000000,
                             Lego.Plate_1X2 => 0.373237),
        Lego.Orange => (
                        Lego.Plate_2X2_Corner => 0.153353,
                        Lego.Plate_1X1 => 0.143723,
                        Lego.Plate_1X3 => 0.139839,
                        Lego.Plate_1X4 => 0.007166,
                        Lego.Plate_1X6 => 0.118940,
                        Lego.Plate_1X2 => 0.045570),
        Lego.Dark_Red => (
                          Lego.Plate_2X2_Corner => 0.164628,
                          Lego.Plate_1X1 => 0.178560,
                          Lego.Plate_1X3 => 0.225022,
                          Lego.Plate_1X4 => 0.131881,
                          Lego.Plate_1X6 => 0.233714,
                          Lego.Plate_1X2 => 0.134987),
        Lego.Red => (
                     Lego.Plate_2X2_Corner => 0.164628,
                     Lego.Plate_1X1 => 0.178560,
                     Lego.Plate_1X3 => 0.225022,
                     Lego.Plate_1X4 => 0.131881,
                     Lego.Plate_1X6 => 0.233714,
                     Lego.Plate_1X2 => 0.134987),
        Lego.Reddish_Brown => (
                               Lego.Plate_2X2_Corner => 0.164628,
                               Lego.Plate_1X1 => 0.178560,
                               Lego.Plate_1X3 => 0.225022,
                               Lego.Plate_1X4 => 0.131881,
                               Lego.Plate_1X6 => 0.233714,
                               Lego.Plate_1X2 => 0.134987),
        Lego.Medium_Orange => (
                               Lego.Plate_2X2_Corner => 0.158092,
                               Lego.Plate_1X1 => 0.158366,
                               Lego.Plate_1X3 => 0.000000,
                               Lego.Plate_1X4 => 0.059588,
                               Lego.Plate_1X6 => 0.000000,
                               Lego.Plate_1X2 => 0.083155));

    Q_2Xn : constant array (Lego.Color range Lego.Brown .. Lego.Medium_Orange,
                            Lego.Plate_2Xn) of Long_Float :=
       (Lego.Brown => (
                       Lego.Plate_1X2 => 0.139812,
                       Lego.Plate_2X2 => 0.143145,
                       Lego.Plate_2X3 => 0.135680,
                       Lego.Plate_2X4 => 0.231364,
                       Lego.Plate_2X6 => 0.000000),
        Lego.Dark_Orange => (
                             Lego.Plate_1X2 => 0.274529,
                             Lego.Plate_2X2 => 0.476092,
                             Lego.Plate_2X3 => 0.453249,
                             Lego.Plate_2X4 => -0.000000,
                             Lego.Plate_2X6 => 0.000000),
        Lego.Orange => (
                        Lego.Plate_1X2 => 0.093722,
                        Lego.Plate_2X2 => 0.029235,
                        Lego.Plate_2X3 => 0.027030,
                        Lego.Plate_2X4 => 0.073594,
                        Lego.Plate_2X6 => 0.165801),
        Lego.Dark_Red => (
                          Lego.Plate_1X2 => 0.129305,
                          Lego.Plate_2X2 => 0.117176,
                          Lego.Plate_2X3 => 0.110909,
                          Lego.Plate_2X4 => 0.195395,
                          Lego.Plate_2X6 => 0.278066),
        Lego.Red => (
                     Lego.Plate_1X2 => 0.129305,
                     Lego.Plate_2X2 => 0.117176,
                     Lego.Plate_2X3 => 0.110909,
                     Lego.Plate_2X4 => 0.195395,
                     Lego.Plate_2X6 => 0.278066),
        Lego.Reddish_Brown => (
                               Lego.Plate_1X2 => 0.129305,
                               Lego.Plate_2X2 => 0.117176,
                               Lego.Plate_2X3 => 0.110909,
                               Lego.Plate_2X4 => 0.195395,
                               Lego.Plate_2X6 => 0.278066),
        Lego.Medium_Orange => (
                               Lego.Plate_1X2 => 0.104023,
                               Lego.Plate_2X2 => 0.000000,
                               Lego.Plate_2X3 => 0.051313,
                               Lego.Plate_2X4 => 0.108856,
                               Lego.Plate_2X6 => 0.000000));

    Q_Tile : constant array (Lego.Color range Lego.Brown .. Lego.Medium_Orange,
                             Lego.Tile) of Long_Float :=
       (Lego.Brown => (
                       Lego.Tile_1X1 => 0.226587,
                       Lego.Tile_1X2 => 0.122846,
                       Lego.Tile_1X4 => 0.034822,
                       Lego.Tile_1X6 => 0.194839),
        Lego.Dark_Orange => (
                             Lego.Tile_1X1 => -0.000000,
                             Lego.Tile_1X2 => 0.000000,
                             Lego.Tile_1X4 => 0.627959,
                             Lego.Tile_1X6 => 0.000000),
        Lego.Orange => (
                        Lego.Tile_1X1 => 0.000000,
                        Lego.Tile_1X2 => 0.328257,
                        Lego.Tile_1X4 => 0.000000,
                        Lego.Tile_1X6 => -0.000000),
        Lego.Dark_Red => (
                          Lego.Tile_1X1 => 0.273248,
                          Lego.Tile_1X2 => 0.212707,
                          Lego.Tile_1X4 => -0.000000,
                          Lego.Tile_1X6 => 0.304771),
        Lego.Red => (
                     Lego.Tile_1X1 => 0.250083,
                     Lego.Tile_1X2 => 0.168095,
                     Lego.Tile_1X4 => 0.094139,
                     Lego.Tile_1X6 => 0.250195),
        Lego.Reddish_Brown => (
                               Lego.Tile_1X1 => 0.250083,
                               Lego.Tile_1X2 => 0.168095,
                               Lego.Tile_1X4 => 0.094139,
                               Lego.Tile_1X6 => 0.250195),
        Lego.Medium_Orange => (
                               Lego.Tile_1X1 => 0.000000,
                               Lego.Tile_1X2 => 0.000000,
                               Lego.Tile_1X4 => 0.148939,
                               Lego.Tile_1X6 => 0.000000));


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

    Bottom_Height : constant Natural  := Boolean'Pos (Bottom /= null);
    Top_Height    : constant Natural  := Boolean'Pos (Top /= null);
    Height        : constant Positive :=
       Options.Height + Bottom_Height + Top_Height;
    Width         : constant Positive := Options.Width;

    type Separations is array (1 .. Height, 1 .. Width - 1) of Boolean;

    package Genetics is
       new Standard.Genetics (Genome_Size => Height * (Width - 1),
                              Pool_Size => Pool_Size,
                              Population_Size => Population,
                              Mutation_Probability =>
                                 Mutations);

    package Ef is new Ada.Numerics.Generic_Elementary_Functions
                         (Genetics.Fitness);

    Width_Minus_One : constant Genetics.Gene'Base :=
       Genetics.Gene'Base (Width - 1);

    Best_Individual : Genetics.Individual;
    Best_Fitness    : Genetics.Fitness;

    Has_Mozart        : Boolean;
    Mozart            : Genetics.Genome;
    Mozart_Individual : Genetics.Individual;
    Mozart_Fitness    : Genetics.Fitness;

    -- Called on each newly created genome (on the first day of creation or
    -- after reproduction) to make sure that it satisfies the constraints.
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

            declare
                -- Use the top constraint as long as it has an effect on the left
                -- constraint.
                Use_Top : Boolean := Top /= null and then
                                        Left (Left'Last - Top_Height) > 0;
            begin
                for I in reverse Left'First + Bottom_Height ..
                                    Left'Last - Top_Height loop
                    First :=
                       Genetics.Gene'Base (I - Left'First) * Width_Minus_One +
                          Genome'First;
                    if Left (I) > 0 then
                        Last :=
                           First + Genetics.Gene'Base (Left (I)) - 1;
                        if Use_Top then
                            Genome (First .. Last - 1) :=
                               Genome (Genome'Last - Width_Minus_One + 1 ..
                                          Genome'Last - Width_Minus_One +
                                             Genetics.Gene'Base (Left (I)) - 1);
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
                -- Use the top constraint as long as it has an effect on the right
                -- constraint.
                Use_Top : Boolean := Top /= null and then
                                        Right (Right'Last - Top_Height) > 0;
            begin
                for I in reverse Right'First + Bottom_Height ..
                                    Right'Last - Top_Height loop
                    Last :=
                       Genetics.Gene'Base (I - Right'First + 1) *
                          Width_Minus_One;
                    if Right (I) > 0 then
                        First :=
                           Last - Genetics.Gene'Base (Right (I)) + 1;
                        if Use_Top then
                            Genome (First + 1 .. Last) :=
                               Genome (Genome'Last -
                                       Genetics.Gene'Base (Right (I)) + 2 ..
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
    end Apply_Constraints;

    function Compute_Fitness (Genome : Genetics.Genome;
                              Individual : Genetics.Individual;
                              Trace : Boolean)
                             return Genetics.Fitness is
        type Imperfection_Kind is (Corner_Imperfection, Part_Imperfection,
                                   Separation_Imperfection, Tee_Imperfection);

        Anchors : array (1 .. Options.Length (Tee)) of Natural :=
           (others => 0);

        Corner_Cost     : constant := 2.0;
        Tee_Cost        : constant := 0.1;
        Separation_Cost : constant := 1.0;

        After_Corner             : Boolean;
        At_Edge_Of_Aligned_Rows  : Boolean;
        Column                   : Positive range 1 .. Width - 1;
        Deep_In_Left_Constraint  : Boolean;
        Deep_In_Right_Constraint : Boolean;
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
                        Ada.Text_Io.Put_Line
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
                    case Parts is
                        when Options.Plates_1Xn | Options.Plates_2Xn =>
                            return 0.0;
                        when Options.Tiles =>
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
                    if Options.Parts = Options.Plates_2Xn and then
                       Spans_Corner then
                        return 0.0;
                    else
                        Trace_Imperfection (Part_Imperfection);
                        return Genetics.Fitness (Width);
                    end if;
                when 6 =>
                    if Options.Parts = Options.Plates_2Xn and then
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

            After_Corner := False;
            if Corner /= null then
                for J in Corner'Range loop
                    if Column = Corner (J) then

                        -- We are at the separation immediately after the stud for a corner.
                        After_Corner := True;
                        Spans_Corner := True;
                    end if;
                end loop;
            end if;

            -- True if the current separation is in the left/right constraint.  For the top
            -- row, we look at the left/right constraint of the row below.
            In_Left_Constraint  :=
               Left /= null and then
                  Column <= Left (Positive'Min (Row, Height - Top_Height));
            In_Right_Constraint :=
               Right /= null and then
                  Column >= Width - Right (Positive'Min (Row,
                                                         Height - Top_Height));

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
                    Result       := Result + Part_Cost
                                                (Part_Width, Spans_Corner) +
                                       Part_Cost (1, Spans_Corner => False);
                    Spans_Corner := False;
                    if Row > 1 and then
                       not At_Edge_Of_Aligned_Rows and then
                       Genome (I - Width_Minus_One) and then
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
                if Genome (I) then
                    if not In_Left_Constraint then
                        Result       := Result + Part_Cost
                                                    (Part_Width, Spans_Corner);
                        Spans_Corner := False;
                    end if;
                    Part_Width := 0;
                    if Row > 1 and then
                       not At_Edge_Of_Aligned_Rows and then
                       Genome (I - Width_Minus_One) and then
                       not Deep_In_Left_Constraint and then
                       not Deep_In_Right_Constraint then
                        Result := Result + Separation_Cost;
                        Trace_Imperfection (Separation_Imperfection);
                    end if;
                end if;
            end if;

            if Row in Bottom_Height + 1 .. Height - Top_Height then
                if After_Corner then

                    if Parts = Options.Plates_2Xn then
                        if Genome (I) or else Genome (I - 1) then

                            -- This is an 1xN or Nx1 corner.  Hard to do with 2xn parts.
                            Trace_Imperfection (Corner_Imperfection);
                            Result := Result + Corner_Cost;
                        elsif Column = 2 or else
                              Genome (I - 2) or else
                              Column = Positive
                                          (Width_Minus_One) or else
                              Genome (I + 1) then

                            -- This is a 2xN or Nx2 corner.  Fine.
                            null;
                        else
                            -- This is not a corner that we like.
                            Trace_Imperfection (Corner_Imperfection);
                            Result := Result + Corner_Cost;
                        end if;
                    else
                        if Genome (I) or else Genome (I - 1) then

                            -- This is an 1xN or Nx1 corner.  Fine.
                            null;
                        elsif (Column = 2 or else
                               Genome (I - 2)) and then
                              (Column = Positive
                                           (Width_Minus_One) or else
                               Genome (I + 1)) then

                            -- This case can be covered by a 2x2 corner, but only for plates.
                            -- This could possibly be handled by the cost function, but I don't
                            -- want to change the optimization landscape.
                            case Parts is
                                when Options.Plates_1Xn =>
                                    null;
                                when Options.Tiles =>
                                    Trace_Imperfection (Corner_Imperfection);
                                    Result := Result + Corner_Cost;
                                when Options.Plates_2Xn =>
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
                            elsif (Column = 1 or else
                                   Genome (I - 1)) and then
                                  (Column = Positive
                                               (Width_Minus_One) or else
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
                Tee_Factor : Genetics.Fitness;
            begin
                -- Make sure that we have at least 3 values that are considered "good".
                if Hi - Lo < 4.0 then
                    Correction := 2.0 - (Hi - Lo) / 2.0;
                    Lo         := Lo - Correction;
                    Hi         := Hi + Correction;
                end if;
                for J in Tee'Range loop
                    Tee_Factor :=
                       Genetics.Fitness'Max
                          (0.0, (Genetics.Fitness (Anchors (J)) - Lo) *
                                   (Genetics.Fitness (Anchors (J)) - Hi));
                    if Tee_Factor > 0.0 then
                        Trace_Imperfection (Tee_Imperfection);
                        Result := Result + Tee_Factor * Tee_Cost;
                    end if;
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
           "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
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
       new Genetics.Compute_Fitnesses (Boolean, Compute_Fitness);

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

    -- No optimization is taking place for a wall of width 1, but we
    -- still want to select the colors and output a file.
    if Width > 1 then

        if Options.Left /= null then
            Left := new Options.Constraint_Array'
                           ((1 .. Bottom_Height => 0) &
                            Options.Left.all &
                            (1 .. Top_Height => 0));
        end if;
        if Options.Right /= null then
            Right := new Options.Constraint_Array'
                            ((1 .. Bottom_Height => 0) &
                             Options.Right.all &
                             (1 .. Top_Height => 0));
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
                  (Genetics.Access_Constant_Population (Current), False);

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

            -- For tracing.
            pragma Assert (not Trace (Options.Imperfections) or else
                           Mozart_Fitness =
                              Compute_Fitness
                                 (Mozart, Mozart_Individual, True));
        end if;

    end if;

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
        Cumulative_Q : array (Q_1Xn'Range (1), Lego.Part) of Long_Float;

        function Q (C : Lego.Color; P : Lego.Part) return Long_Float is
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

        type Output_State is
            record
                Y            : Integer;
                Layout_State : Layout.State;
                Last_Color   : Lego.Color;
                Start_Of_Row : Boolean;
            end record;

        function Effective_Parts (Parts : Options.Parts_Option;
                                  Height : Positive;
                                  Y : Integer)
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
            Stud_Count    : constant Positive := Last_Stud - First_Stud + 1;

            C      : Lego.Color;
            Is_Tee : Boolean := False;
            P      : Lego.Part;
            Hide   : Boolean;
            Skip   : Boolean;
            X, Z   : Integer;
            M      : Layout.Matrix;

            function Random (P : Lego.Part) return Lego.Color is
                R : Long_Float range 0.0 .. 1.0;
                use type Lego.Color;
            begin

                -- The last entry in Cumulative_Q will be very close to 1.0, but it
                -- may not be exactly 1.0 because of rounding.  Adjust the random
                -- number to avoid leaving a tiny hole.
                R := Long_Float (Anfr.Random (Color_Generator)) *
                        Cumulative_Q (Cumulative_Q'Last (1), P);
                for Color in Cumulative_Q'Range (1) loop
                    if Q (Color, P) > 0.0 then
                        if Cumulative_Q (Color, P) >= R then
                            return Color;
                        end if;
                    end if;
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

            procedure Put (M : Layout.Matrix) is
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
                    Is_Tee := Options.Is_In (First_Stud, Tee);
                when 2 =>
                    Is_Tee := Options.Is_In (First_Stud, Tee) or else
                                 Options.Is_In (Last_Stud, Tee);
                when others =>
                    null;
            end case;

            Layout.Append (First_Stud => First_Stud,
                           Last_Stud => Last_Stud,
                           S => S.Layout_State,
                           X => X,
                           Z => Z,
                           M => M,
                           Part => P);

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

            Put (" " & Integer'Image (X) & " " & Integer'Image (8 * S.Y) &
                 " " & Integer'Image (Z));

            Put (M);

            Put_Line (" " & Lego.Part_Id_Image (P) & ".DAT");

            S.Start_Of_Row := False;
            if Last_Stud = Width then
                S.Y            := S.Y - 1;
                S.Start_Of_Row := True;
                S.Layout_State :=
                   Layout.Initialize
                      (Corners => Corner,
                       Parts => Effective_Parts
                                   (Parts => Parts,
                                    Height => Height,
                                    Y => S.Y));
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
            end if;
        exception
            when Layout.No_Such_Part =>
                Ada.Text_Io.Put_Line
                   (Ada.Text_Io.Standard_Error,
                    "No such part at studs" & Positive'Image (First_Stud) &
                       " to" & Positive'Image (Last_Stud));
                if Parts = Options.Plates_2Xn then
                    Ada.Text_Io.Put_Line
                       (Ada.Text_Io.Standard_Error,
                        "This may be an oddity due to " &
                           Options.Parts_Option'Image (Parts));
                end if;
                for I in First_Stud .. Last_Stud loop
                    Output_Part (I, I, S);
                end loop;
        end Output_Part;

        procedure Output_Wall is
           new Process_Wall
                  (State => Output_State,
                   Initial =>
                      (Y => 0,
                       Layout_State =>
                          Layout.Initialize
                             (Corners => Corner,
                              Parts => Effective_Parts
                                          (Parts => Parts,
                                           Height => Height,
                                           Y => 0)),
                       Last_Color => Lego.Color'First,
                       Start_Of_Row => True),
                   Part => Output_Part);

    begin

        declare
            Part_First, Part_Last : Lego.Part;

            use type Lego.Color;
        begin
            case Options.Parts is
                when Options.Plates_1Xn =>
                    Part_First := Lego.Plate_1Xn'First;
                    Part_Last  := Lego.Plate_1Xn'Last;
                when Options.Plates_2Xn =>
                    Part_First := Lego.Plate_2Xn'First;
                    Part_Last  := Lego.Plate_2Xn'Last;
                when Options.Tiles =>
                    Part_First := Lego.Tile'First;
                    Part_Last  := Lego.Tile'Last;
            end case;
            for Part in Part_First .. Part_Last loop
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
    end;

end Generate_Wall;
pragma Main (Stack_Size => 2 ** 28);
