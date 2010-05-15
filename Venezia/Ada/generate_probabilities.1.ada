with Ada.Numerics.Long_Real_Arrays;

generic
    type Part is (<>);  
    type Color is (<>);
    type Color_Probabilities is array (Color) of Long_Float;
    Pleasantness : Color_Probabilities;
package Generate_Probabilities is

    type System (<>) is private;

    generic
	type Part_Probabilities is array (Part) of Long_Float;
	with function Available (C : Color; P : Part) return Boolean;
    function Build_System (Probabilities : Part_Probabilities) return System;

    procedure Solve_System (S : System);

    generic
	type Conditional_Probabilities is array (Color, Part) of Long_Float;
    procedure Verify_System (S : System; Q : Conditional_Probabilities);

private
    use Ada.Numerics.Long_Real_Arrays;
    type System (Equations : Positive; Unknowns : Positive) is
	record
	    A : Real_Matrix (1 .. Equations, 1 .. Unknowns) :=
	       (others => (others => 0.0));
	    B : Real_Vector (1 .. Equations)                := (others => 0.0);
	end record;
end Generate_Probabilities;
