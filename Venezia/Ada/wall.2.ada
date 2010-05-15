with Wall.Options;
pragma Elaborate (Wall.Options);
package body Wall is

    use type Options.Constraint;
    use type Standard.Options.Constraint_Array;

    package Private_Options renames Options.Private_Options;

    R                : Options.Constraint;
    L                : Options.Constraint;
    Effective_Corner : Options.Positions;

    function Fill_Margins
		(P    : Standard.Options.Position_Array;
		 From : Integer;
		 To   : Integer) return Standard.Options.Position_Array is
	Shifted_Positions : Standard.Options.Position_Array := P;

	First : Natural  := Shifted_Positions'Last;
	Last  : Positive := Shifted_Positions'First;

	Has_Found_First : Boolean := False;
	Has_Found_Last  : Boolean := False;

	Tentative_Position : Integer;
	use type Standard.Options.Position_Array;
    begin
	if From > To then
	    return (1 .. 0 => 0);
	else
	    for I in Shifted_Positions'Range loop
		Tentative_Position :=
		   Shifted_Positions (I) +
		      From * Private_Options.Width + Cycle_Margin;

		-- No corners on the first and last studs.
		if Tentative_Position in 2 .. Width - 1 then
		    if not Has_Found_First then
			First           := I;
			Has_Found_First := True;
		    end if;
		    Last                  := I;
		    Shifted_Positions (I) := Tentative_Position;
		end if;
	    end loop;

	    return Shifted_Positions (First .. Last) &
		      Fill_Margins (P, From + 1, To);
	end if;
    end Fill_Margins;

    function Height return Positive is
    begin
	return Private_Options.Height + Bottom_Height + Top_Height;
    end Height;

    function Width (Effective : Boolean := True) return Positive is
    begin
	if Options.Cycle and then Effective then
	    return 2 * Cycle_Margin + Private_Options.Width;
	else
	    return Private_Options.Width;
	end if;
    end Width;

    function Bottom return Options.Constraint is
    begin
	return Private_Options.Bottom;
    end Bottom;

    function Bottom_Height return Natural is
    begin
	return Boolean'Pos (Private_Options.Bottom /= null);
    end Bottom_Height;

    function Corner (Effective : Boolean := True) return Options.Positions is
	use type Options.Positions;
    begin
	if Options.Cycle and then Effective and then
	   Private_Options.Corner /= null then
	    if Effective_Corner = null then

		declare
		    -- Number of times that the corner array repeats in the
		    -- margins.
		    Corner_Repetitions : constant Integer :=
		       (Cycle_Margin + Private_Options.Corner'Length - 1) /
			  Private_Options.Corner'Length;
		begin
		    Effective_Corner :=
		       new Standard.Options.Position_Array'
			      (Fill_Margins (Private_Options.Corner.all,
					     From => -Corner_Repetitions,
					     To   => Corner_Repetitions));
		end;

	    end if;
	    return Effective_Corner;
	else
	    return Private_Options.Corner;
	end if;
    end Corner;

    function Top return Options.Constraint is
    begin
	return Private_Options.Top;
    end Top;

    function Top_Height return Natural is
    begin
	return Boolean'Pos (Private_Options.Top /= null);
    end Top_Height;

    function Left return Options.Constraint is
    begin
	if L = null and then Private_Options.Left /= null then
	    L := new Standard.Options.Constraint_Array'
			((1 .. Bottom_Height => 0) &
			 Private_Options.Left.all & (1 .. Top_Height => 0));
	end if;
	return L;
    end Left;

    function Right return Options.Constraint is
    begin
	if R = null and then Private_Options.Right /= null then
	    R := new Standard.Options.Constraint_Array'
			((1 .. Bottom_Height => 0) &
			 Private_Options.Right.all & (1 .. Top_Height => 0));
	end if;
	return R;
    end Right;

end Wall;
