with Ada.Numerics.Generic_Real_Arrays;
with Lego;
with Wall.Options;
generic
package Wall.Ldraw.Layout is

    No_Such_Part : exception;

    package Arrays is new Ada.Numerics.Generic_Real_Arrays (Float);
    type Matrix is new Arrays.Real_Matrix (1 .. 3, 1 .. 3);

    type State is private;

    function Initialize
		(Corners : Options.Positions; Parts : Options.Parts_Option)
		return State;

    procedure Append (First_Stud, Last_Stud : Positive;
		      S                     : in out State;
		      X, Z                  : out Integer;
		      M                     : out Matrix;
		      Part                  : out Lego.Part);

private
    type Direction is (North, East);
    type State is
	record
	    Corners   : Options.Positions;
	    Parts     : Options.Parts_Option;
	    Direction : Layout.Direction;

	    -- The following are in studs.
	    Last_X1, Last_X2, Last_Z1, Last_Z2 : Integer;
	end record;
end Wall.Ldraw.Layout;

