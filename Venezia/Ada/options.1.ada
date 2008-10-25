with Ada.Text_Io;

package Options is

    type Color_Option is (Direct, False, Ldraw);

    type Constraint_Array is array (Positive range <>) of Natural;
    type Constraint is access Constraint_Array;

    type Crossover_Option is range 1 .. 2;

    type Parts_Option is (Plates_1Xn, Plates_2Xn, Tiles);
    subtype Plates is Parts_Option range Plates_1Xn .. Plates_2Xn;

    type Position_Array is array (Positive range <>) of Natural;
    type Positions is access Position_Array;

    type Trace_Kind is (Age, Genome, Imperfections, Mozart);
    type Trace_Options is array (Trace_Kind) of Boolean;
    pragma Convention (Ada_Pass_By_Reference, Trace_Options);

    type Visibility_Option is (Skip, Show, Hide);
    type Visibility_Element is (Top_Bottom, Left_Right, Tees);
    type Visibility_Options is array (Visibility_Element) of Visibility_Option;
    pragma Convention (Ada_Pass_By_Reference, Visibility_Options);

    function Image (C : Constraint) return String;
    function Max (C : Constraint) return Natural;

    function Length (P : Positions) return Natural;
    function Is_In (N : Natural; P : Positions) return Boolean;

    Error : Boolean := False;

    -- These variables are self-initialized when this package gets elaborated and the command line gets parsed.
    -- The default below are used if the corresponding option is not present on the command line.

    Bottom      : Constraint;
    Color       : Color_Option       := Direct;
    Color_Seed  : Integer            := 0;
    Corner      : Positions;
    Crossover   : Crossover_Option   := 2;
    File        : Ada.Text_Io.File_Type;
    Generations : Positive           := 100;
    Height      : Positive           := 10;
    Left        : Constraint;
    Mutations   : Float              := 0.001;
    Parts       : Parts_Option       := Plates_1Xn;
    Population  : Positive           := 1000;
    Right       : Constraint;
    Seed        : Integer            := 42;
    Tee         : Positions;
    Top         : Constraint;
    Trace       : Trace_Options      := (others => False);
    Visibility  : Visibility_Options := (Top_Bottom => Skip,
                                         Left_Right => Skip,
                                         Tees => Hide);
    Width       : Positive           := 10;

end Options;

