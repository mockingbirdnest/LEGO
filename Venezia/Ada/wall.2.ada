with Wall.Options;
pragma Elaborate (Wall.Options);
package body Wall is

    use type Options.Constraint;
    use type Standard.Options.Constraint_Array;

    type Side is (Left, Right);

    package Private_Options renames Options.Private_Options;

    R : Options.Constraint;
    L : Options.Constraint;

    Effective_Bottom : Options.Constraint;
    Effective_Corner : Options.Positions;
    Effective_Top    : Options.Constraint;

    function Shift_Positions
		(Positions : Standard.Options.Position_Array;  
		 By        : Integer) return Standard.Options.Position_Array is
	Shifted_Positions : Standard.Options.Position_Array := Positions;

	First : Positive := Shifted_Positions'First;
	Last  : Natural  := Shifted_Positions'First - 1;

	Has_Found_First    : Boolean := False;
	Tentative_Position : Integer;
    begin
	for I in Shifted_Positions'Range loop
	    Tentative_Position := Shifted_Positions (I) + By;

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
	return Shifted_Positions (First .. Last);
    end Shift_Positions;

    function Margin_Constraint (Where : Side)
			       return Standard.Options.Constraint_Array is
	-- The longest part such than all shorter parts exist.
	Longest_Part : constant := 4;
    begin
	case Where is
	    when Left =>
		return (Cycle_Margin mod Longest_Part) &
			  (1 .. Cycle_Margin / Longest_Part => Longest_Part);
	    when Right =>
		return (1 .. Cycle_Margin / Longest_Part => Longest_Part) &
			  (Cycle_Margin mod Longest_Part);
	end case;
    end Margin_Constraint;

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

    function Bottom (Effective : Boolean := True) return Options.Constraint is
    begin
	if Options.Cycle and then Effective and then
	   Private_Options.Bottom /= null then
	    if Effective_Bottom = null then
		Effective_Bottom := new Standard.Options.Constraint_Array'
					   (Margin_Constraint (Left) &
					    Private_Options.Bottom.all &
					    Margin_Constraint (Right));
	    end if;
	    return Effective_Bottom;
	else
	    return Private_Options.Bottom;
	end if;
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
		    Max_Corners_Per_Part : constant := 3;
		    use type Standard.Options.Position_Array;
		begin
		    Effective_Corner :=
		       new Standard.Options.Position_Array'
			      (Shift_Positions
				  (Private_Options.Corner
				      (Private_Options.Corner'Last -
				       Max_Corners_Per_Part + 2 ..
					  Private_Options.Corner'Last),
				   By => Cycle_Margin - Private_Options.Width) &  
			       (Shift_Positions (Private_Options.Corner.all,
						 By => Cycle_Margin) &
				Shift_Positions
				   (Private_Options.Corner
				       (Private_Options.Corner'First ..
					   Private_Options.Corner'First +
					      Max_Corners_Per_Part - 2),
				    By => Cycle_Margin +
					     Private_Options.Width)));
		end;

	    end if;
	    return Effective_Corner;
	else
	    return Private_Options.Corner;
	end if;
    end Corner;

    function Top (Effective : Boolean := True) return Options.Constraint is
    begin
	if Options.Cycle and then Effective and then
	   Private_Options.Top /= null then
	    if Effective_Top = null then
		Effective_Top := new Standard.Options.Constraint_Array'
					(Margin_Constraint (Left) &
					 Private_Options.Top.all &
					 Margin_Constraint (Right));
	    end if;
	    return Effective_Top;
	else
	    return Private_Options.Top;
	end if;
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
