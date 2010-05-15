with Roof.Options;
pragma Elaborate (Roof.Options);
package body Roof is

    use type Options.Constraint;
    use type Standard.Options.Constraint_Array;

    R : Options.Constraint;
    L : Options.Constraint;

    function Height return Positive is
    begin
	return Options.Private_Options.Height;
    end Height;

    function Width return Positive is
    begin
	return Options.Private_Options.Width;
    end Width;

    function Left return Options.Constraint is
    begin
	if L = null and then Options.Private_Options.Left /= null then
	    L := new Standard.Options.Constraint_Array'
			(Options.Private_Options.Left.all);
	end if;
	return L;
    end Left;

    function Right return Options.Constraint is
    begin
	if R = null and then Options.Private_Options.Right /= null then
	    R := new Standard.Options.Constraint_Array'
			(Options.Private_Options.Right.all);
	end if;
	return R;
    end Right;

end Roof;  
