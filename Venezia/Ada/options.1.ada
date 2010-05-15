with Ada.Text_Io;

package Options is

    type Color_Option is (Direct, False, Ldraw);

    type Constraint_Array is array (Positive range <>) of Natural;
    type Constraint is access Constraint_Array;

    type Crossover_Option is range 1 .. 2;

    type Position_Array is array (Positive range <>) of Natural;
    type Positions is access Position_Array;

    type Trace_Kind is (Age, Genome, Imperfections, Mozart);
    type Trace_Options is array (Trace_Kind) of Boolean;

    function Image (C : Constraint) return String;
    function Value (S : String) return Constraint;
    function Max (C : Constraint) return Natural;

    function "&" (L : Positions; R : Natural) return Positions;
    function Length (P : Positions) return Natural;
    function Is_In (N : Natural; P : Positions) return Boolean;

end Options;

