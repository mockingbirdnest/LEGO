with Ada.Numerics.Long_Real_Arrays;
use Ada.Numerics.Long_Real_Arrays;

with Ada.Text_Io;
with Lego;
procedure Matrices is

    use type Lego.Part;

    package Lfio is new Ada.Text_Io.Float_Io (Long_Float);

    subtype Color is Lego.Color range Lego.Brown .. Lego.Medium_Orange;

    Color_Length : constant := Color'Pos (Color'Last) -
                                  Color'Pos (Color'First) + 1;

    Verbose : constant Boolean := False;

    Pleasantness : constant array (Color) of Long_Float :=
       -- (Lego.Brown => 0.13,
       --  Lego.Dark_Orange => 0.20, --0.18,
       --  Lego.Dark_Red => 0.18,
       --  Lego.Medium_Orange => 0.05,
       --  Lego.Orange => 0.10,
       --  Lego.Red => 0.18,
       --  Lego.Reddish_Brown => 0.18
       --  );
       (Lego.Brown => 0.129396,
        Lego.Dark_Orange => 0.203082,
        Lego.Orange => 0.080981,
        Lego.Dark_Red => 0.179458,
        Lego.Red => 0.179458,
        Lego.Reddish_Brown => 0.179458,
        Lego.Medium_Orange => 0.048167);

    -- Lengths_1Xn : array (Lego.Part range Lego.Plate_2X2_Corner ..
    --                                         Lego.Plate_1X6)
    --                  of Long_Float :=
    --    (Lego.Plate_2X2_Corner => 0.0245,
    --     Lego.Plate_1X2 => 0.1943,
    --     Lego.Plate_1X1 => 0.0757,
    --     Lego.Plate_1X3 => 0.1851,
    --     Lego.Plate_1X6 => 0.2494,
    --     Lego.Plate_1X4 => 0.2710);

    type System (Equations : Positive; Unknowns : Positive) is
        record
            A : Real_Matrix (1 .. Equations, 1 .. Unknowns) :=
               (others => (others => 0.0));
            B : Real_Vector (1 .. Equations)                := (others => 0.0);
        end record;

    function Transpose (M : Real_Matrix) return Real_Matrix is
        Result : Real_Matrix (M'Range (2), M'Range (1));
        T      : Long_Float'Base;
    begin
        for I in M'Range (1) loop
            for J in M'Range (2) loop
                Result (J, I) := M (I, J);
            end loop;
        end loop;
        return Result;
    end Transpose;

    generic
        type Part is (<>);
        type Part_Probabilities is array (Part) of Long_Float;
        with function Available (C : Color; P : Part) return Boolean;
    function Build_System (Probabilities : Part_Probabilities) return System;

    function Build_System (Probabilities : Part_Probabilities) return System is
        Part_First  : constant Natural := Part'Pos (Part'First);
        Part_Last   : constant Natural := Part'Pos (Part'Last);
        Part_Length : constant Natural := Part_Last - Part_First + 1;
        Zeros       : Natural          := 0;
    begin

        -- Count the unavailable parts to determine how many zero equations we have.
        for C in Color loop
            for P in Part loop
                if not Available (C, P) then
                    Zeros := Zeros + 1;
                end if;
            end loop;
        end loop;

        declare
            S : System (Equations => Color_Length + Part_Length + Zeros - 1,
                        Unknowns => Color_Length * Part_Length);
            A : Real_Matrix renames S.A;
            B : Real_Vector renames S.B;
        begin

            -- Color equations.  They are not independent, so we drop the last one.
            for C in 1 .. Color_Length - 1 loop
                B (C) := Pleasantness (Color'Val (C - 1));
                for P in Part loop
                    A (C, C + Color_Length *
                                 (Part'Pos (P) - Part_First)) :=
                       Probabilities (P);
                end loop;
            end loop;

            -- Part equations.
            for P in Part loop
                B (Color_Length + Part'Pos (P) - Part_First) := 1.0;
                for C in 1 .. Color_Length loop
                    if Available (Color'Val (C - 1), P) then
                        A (Color_Length + Part'Pos (P) - Part_First,
                           C + Color_Length * (Part'Pos (P) - Part_First)) :=
                           1.0;
                    end if;
                end loop;
            end loop;

            -- Zero equations.
            declare
                Z : Positive := 1;
            begin
                for P in Part loop
                    for C in 1 .. Color_Length loop
                        if not Available (Color'Val (C - 1), P) then
                            A (Color_Length - 1 + Part_Length + Z,
                               C + Color_Length *
                                      (Part'Pos (P) - Part_First)) :=
                               1.0;
                            B (Color_Length - 1 + Part_Length + Z) :=
                               0.0;
                            Z                                      :=
                               Z + 1;
                        end if;
                    end loop;
                end loop;
            end;

            if Verbose then
                for I in A'Range (1) loop
                    for J in A'Range (2) loop
                        Lfio.Put (Item => A (I, J),
                                  Fore => 2,
                                  Aft => 3,
                                  Exp => 0);
                    end loop;
                    Ada.Text_Io.Put (" = ");
                    Lfio.Put (Item => B (I),
                              Fore => 2,
                              Aft => 3,
                              Exp => 0);
                    Ada.Text_Io.New_Line;
                end loop;
                Ada.Text_Io.New_Line;
            end if;

            return S;
        end;

    end Build_System;


    generic
        type Part is (<>);
    procedure Solve_System (S : System);

    procedure Solve_System (S : System) is
        A          : Real_Matrix renames S.A;
        B          : Real_Vector renames S.B;
        A_T        : constant Real_Matrix := Transpose (A);
        A_Normal   : constant Real_Matrix := A * A_T;
        Q          : constant Real_Vector := Solve (A_Normal, B);
        X_Ls       : constant Real_Vector := A_T * Q;
        Part_First : constant Natural     := Part'Pos (Part'First);
        Part_Last  : constant Natural     := Part'Pos (Part'Last);
    begin
        if Verbose then
            for I in A_Normal'Range (1) loop
                for J in A_Normal'Range (2) loop
                    Lfio.Put (Item => A_Normal (I, J),
                              Fore => 2,
                              Aft => 3,
                              Exp => 0);
                end loop;
                Ada.Text_Io.Put (" = ");
                Lfio.Put (Item => B (I),
                          Fore => 2,
                          Aft => 3,
                          Exp => 0);
                Ada.Text_Io.New_Line;
            end loop;
            Ada.Text_Io.New_Line;

            for I in Q'Range loop
                Lfio.Put (Item => Q (I),
                          Fore => 2,
                          Aft => 3,
                          Exp => 0);
                Ada.Text_Io.New_Line;
            end loop;
            Ada.Text_Io.New_Line;
        end if;

        for C in Color loop
            Ada.Text_Io.Put ("LEGO." & Color'Image (C));
            Ada.Text_Io.Set_Col (20);
            Ada.Text_Io.Put (" => (");
            for P in Part loop
                Ada.Text_Io.Set_Col (20);
                Ada.Text_Io.Put ("LEGO." & Part'Image (P));
                Ada.Text_Io.Set_Col (45);
                Ada.Text_Io.Put (" => ");
                Lfio.Put (Item =>
                             X_Ls (1 + Color'Pos (C) +
                                   Color_Length * (Part'Pos (P) - Part_First)),
                          Fore => 2,
                          Aft => 6,
                          Exp => 0);
                if P = Part'Last then
                    Ada.Text_Io.Put ("),");
                else
                    Ada.Text_Io.Put (",");
                end if;
                Ada.Text_Io.New_Line;
            end loop;
        end loop;
        Ada.Text_Io.New_Line;
    end Solve_System;


    generic
        type Part is (<>);
        type Conditional_Probabilities is array (Color, Part) of Long_Float;
    procedure Verify_System (S : System; Q : Conditional_Probabilities);

    procedure Verify_System (S : System; Q : Conditional_Probabilities) is
        Part_First  : constant Natural := Part'Pos (Part'First);
        Part_Last   : constant Natural := Part'Pos (Part'Last);
        Part_Length : constant Natural := Part_Last - Part_First + 1;
        A           : Real_Matrix renames S.A;
        Conditional : Real_Vector (1 .. Color_Length * Part_Length);
    begin
        for C in Color loop
            for P in Part loop
                Conditional (1 + Color'Pos (C) +
                             Color_Length * (Part'Pos (P) - Part_First)) :=
                   Q (C, P);
            end loop;
        end loop;

        declare
            B    : constant Real_Vector := A * Conditional;
            Last : Long_Float;
        begin

            -- Color equations.
            for C in Color'First .. Color'Pred (Color'Last) loop
                Ada.Text_Io.Put (Color'Image (C));
                Ada.Text_Io.Set_Col (20);
                Ada.Text_Io.Put (" => ");
                Lfio.Put (B (1 + Color'Pos (C)),
                          Fore => 2,
                          Aft => 6,
                          Exp => 0);
                Ada.Text_Io.New_Line;
            end loop;

            Last := 1.0;
            for C in Color'First .. Color'Pred (Color'Last) loop
                Last := Last - B (1 + Color'Pos (C));
            end loop;
            Ada.Text_Io.Put (Color'Image (Color'Last));
            Ada.Text_Io.Set_Col (20);
            Ada.Text_Io.Put (" => ");
            Lfio.Put (Last,
                      Fore => 2,
                      Aft => 6,
                      Exp => 0);
            Ada.Text_Io.New_Line;

            -- Length equations.
            for P in Part loop
                Ada.Text_Io.Put (Part'Image (P));
                Ada.Text_Io.Set_Col (20);
                Ada.Text_Io.Put (" => ");
                Lfio.Put (B (Color_Length + Part'Pos (P) - Part_First),
                          Fore => 2,
                          Aft => 6,
                          Exp => 0);
                Ada.Text_Io.New_Line;
            end loop;

            -- Zero equations.
            for I in Color_Length +
                        (Lego.Part'Pos (Lego.Plate_1Xn'Last) -
                         Lego.Part'Pos (Lego.Plate_1Xn'First) + 1) ..
                        B'Last loop
                Ada.Text_Io.Put (Integer'Image (I));
                Ada.Text_Io.Set_Col (20);
                Ada.Text_Io.Put (" => ");
                Lfio.Put (B (I),
                          Fore => 2,
                          Aft => 6,
                          Exp => 0);
                Ada.Text_Io.New_Line;
            end loop;
        end;

    end Verify_System;


    type Plate_1Xn_Probabilities is array (Lego.Plate_1Xn) of Long_Float;

    function Build_Plate_1Xn_System is
       new Build_System (Part => Lego.Plate_1Xn,
                         Part_Probabilities => Plate_1Xn_Probabilities,
                         Available => Lego.Available);

    procedure Solve_Plate_1Xn_System is new Solve_System (Lego.Plate_1Xn);

    type Plate_1Xn_Conditional_Probabilities is
       array (Color, Lego.Plate_1Xn) of Long_Float;

    procedure Verify_Plate_1Xn_System is
       new Verify_System (Part => Lego.Plate_1Xn,
                          Conditional_Probabilities =>
                             Plate_1Xn_Conditional_Probabilities);


    type Plate_2Xn_Probabilities is array (Lego.Plate_2Xn) of Long_Float;

    function Build_Plate_2Xn_System is
       new Build_System (Part => Lego.Plate_2Xn,
                         Part_Probabilities => Plate_2Xn_Probabilities,
                         Available => Lego.Available);

    procedure Solve_Plate_2Xn_System is new Solve_System (Lego.Plate_2Xn);


    type Tile_Probabilities is array (Lego.Tile) of Long_Float;

    function Build_Tile_System is
       new Build_System (Part => Lego.Tile,
                         Part_Probabilities => Tile_Probabilities,
                         Available => Lego.Available);

    procedure Solve_Tile_System is new Solve_System (Lego.Tile);

begin

    declare
        S : constant System :=
           Build_Plate_1Xn_System
              (Probabilities => (Lego.Plate_2X2_Corner => 0.0245,
                                 Lego.Plate_1X1 => 0.0757,
                                 Lego.Plate_1X2 => 0.1943,
                                 Lego.Plate_1X3 => 0.1851,
                                 Lego.Plate_1X4 => 0.2710,
                                 Lego.Plate_1X6 => 0.2494));
    begin
        Solve_Plate_1Xn_System (S);

        Verify_Plate_1Xn_System
           (S,
            Q => (Lego.Brown => (Lego.Plate_2X2_Corner => 0.0,
                                 Lego.Plate_1X2 => 0.0930782,
                                 Lego.Plate_1X1 => 0.162234,
                                 Lego.Plate_1X3 => 0.185097,
                                 Lego.Plate_1X6 => 0.17991,
                                 Lego.Plate_1X4 => 0.0734287),
                  Lego.Dark_Orange => (Lego.Plate_2X2_Corner => 0.194719,
                                       Lego.Plate_1X2 => 0.373236,
                                       Lego.Plate_1X1 => 0.0,
                                       Lego.Plate_1X3 => 0.0,
                                       Lego.Plate_1X6 => 0.0,
                                       Lego.Plate_1X4 => 0.464175),
                  Lego.Orange => (Lego.Plate_2X2_Corner => 0.153331,
                                  Lego.Plate_1X2 => 0.0455786,
                                  Lego.Plate_1X1 => 0.143734,
                                  Lego.Plate_1X3 => 0.139848,
                                  Lego.Plate_1X6 => 0.118911,
                                  Lego.Plate_1X4 => 0.00717916),
                  Lego.Dark_Red => (Lego.Plate_2X2_Corner => 0.164624,
                                    Lego.Plate_1X2 => 0.134984,
                                    Lego.Plate_1X1 => 0.178555,
                                    Lego.Plate_1X3 => 0.225018,
                                    Lego.Plate_1X6 => 0.233726,
                                    Lego.Plate_1X4 => 0.131876),
                  Lego.Red => (Lego.Plate_2X2_Corner => 0.164624,
                               Lego.Plate_1X2 => 0.134984,
                               Lego.Plate_1X1 => 0.178555,
                               Lego.Plate_1X3 => 0.225018,
                               Lego.Plate_1X6 => 0.233726,
                               Lego.Plate_1X4 => 0.131876),
                  Lego.Reddish_Brown => (Lego.Plate_2X2_Corner => 0.164624,
                                         Lego.Plate_1X2 => 0.134984,
                                         Lego.Plate_1X1 => 0.178555,
                                         Lego.Plate_1X3 => 0.225018,
                                         Lego.Plate_1X6 => 0.233726,
                                         Lego.Plate_1X4 => 0.131876),
                  Lego.Medium_Orange => (Lego.Plate_2X2_Corner => 0.158077,
                                         Lego.Plate_1X2 => 0.0831548,
                                         Lego.Plate_1X1 => 0.158369,
                                         Lego.Plate_1X3 => 0.0,
                                         Lego.Plate_1X6 => 0.0,
                                         Lego.Plate_1X4 => 0.0595881)));
    end;

    declare
        S : constant System :=
           Build_Plate_2Xn_System
              (Probabilities => (Lego.Plate_1X2 => 0.0806,
                                 Lego.Plate_2X2 => 0.1992,
                                 Lego.Plate_2X3 => 0.1900,
                                 Lego.Plate_2X4 => 0.2759,
                                 Lego.Plate_2X6 => 0.2543));
    begin
        Solve_Plate_2Xn_System (S);
    end;

    declare
        S : constant System :=
           Build_Tile_System
              (Probabilities => (Lego.Tile_1X1 => 0.1281, --0.003,
                                 Lego.Tile_1X2 => 0.2467, --0.004,
                                 Lego.Tile_1X4 => 0.3234, --0.008,
                                 Lego.Tile_1X6 => 0.3018)); --0.008))
    begin
        Solve_Tile_System (S);
    end;

end Matrices;

