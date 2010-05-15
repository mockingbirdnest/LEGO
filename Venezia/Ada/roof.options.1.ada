with Ada.Text_Io;

package Roof.Options is

    type Visibility_Option is (Skip, Show, Hide);
    type Visibility_Element is (Left_Right);
    type Visibility_Options is array (Visibility_Element) of Visibility_Option;

    subtype Color_Option is Standard.Options.Color_Option;
    subtype Constraint is Standard.Options.Constraint;
    subtype Crossover_Option is Standard.Options.Crossover_Option;
    subtype Positions is Standard.Options.Positions;
    subtype Trace_Options is Standard.Options.Trace_Options;

    Error : Boolean := False;

    -- These variables are self-initialized when this package gets elaborated
    -- and the command line gets parsed.  The default below are used if the
    -- corresponding option is not present on the command line.

    Color       : Color_Option       := Standard.Options.Direct;
    Color_Seed  : Integer            := 0;
    Crossover   : Crossover_Option   := 2;
    File        : Ada.Text_Io.File_Type;
    Generations : Positive           := 100;
    Mutations   : Float              := 0.001;
    Population  : Positive           := 1000;
    Seed        : Integer            := 42;
    Trace       : Trace_Options      := (others => False);
    Visibility  : Visibility_Options := (Left_Right => Hide);

    -- These options should not be used directly.  Use the functions in Wall
    -- instead.
    package Private_Options is
	Height : Positive := 10;
	Left   : Constraint;
	Right  : Constraint;
	Width  : Positive := 10;
    end Private_Options;

    procedure Analyze;
    procedure Output;

end Roof.Options;
