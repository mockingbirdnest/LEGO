with Ada.Text_Io;

package Wall.Options is

    type Parts_Option is (Plates_1Xn, Plates_2Xn, Tiles);
    subtype Plates is Parts_Option range Plates_1Xn .. Plates_2Xn;

    type Visibility_Option is (Skip, Show, Hide);
    type Visibility_Element is (Top_Bottom, Left_Right, Tees, Margin);
    type Visibility_Options is array (Visibility_Element) of Visibility_Option;

    subtype Color_Option is Standard.Options.Color_Option;
    subtype Constraint is Standard.Options.Constraint;
    subtype Crossover_Option is Standard.Options.Crossover_Option;
    subtype Positions is Standard.Options.Positions;
    subtype Trace_Options is Standard.Options.Trace_Options;

    Error : Boolean := False;

    -- These variables are initialized when the command line gets parsed.  The
    -- default below are used if the corresponding option is not present on the
    -- command line.

    Color       : Color_Option       := Standard.Options.Direct;
    Color_Seed  : Integer            := 0;
    Crossover   : Crossover_Option   := 2;
    Cycle       : Boolean            := False;
    File        : Ada.Text_Io.File_Type;
    Generations : Positive           := 100;
    Mutations   : Float              := 0.001;
    Parts       : Parts_Option       := Plates_1Xn;
    Population  : Positive           := 1000;
    Seed        : Integer            := 42;
    Tee         : Positions;
    Trace       : Trace_Options      := (others => False);
    Visibility  : Visibility_Options :=
       (Top_Bottom => Skip, Left_Right => Skip, Tees => Hide, Margin => Skip);

    -- These options should not be used directly.  Use the functions in Wall
    -- instead.
    package Private_Options is
	Bottom : Constraint;
	Corner : Positions;
	Height : Positive := 10;
	Left   : Constraint;
	Right  : Constraint;
	Top    : Constraint;
	Width  : Positive := 10;
    end Private_Options;

    procedure Analyze;
    procedure Output;

end Wall.Options;

