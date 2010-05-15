package body Options is

    function Image (C : Constraint_Array) return String is
	Img : constant String := Natural'Image (C (C'First));
    begin
	if C'Length = 1 then
	    return Img (Img'First + 1 .. Img'Last);
	else
	    return Img (Img'First + 1 .. Img'Last) & '-' &
		      Image (C (C'First + 1 .. C'Last));
	end if;
    end Image;


    function Image (C : Constraint) return String is
    begin
	return Image (C.all);
    end Image;

    function Value (S : String) return Constraint is
	Has_Dash : Boolean;
	Result   : Constraint;

	function Dashed_Value (S : String) return Constraint is
	begin
	    for I in S'Range loop
		if S (I) = '-' then

		    declare
			Rest : constant Constraint :=
			   Dashed_Value (S (I + 1 .. S'Last));
		    begin
			return new Constraint_Array'
				      (Integer'Value (S (S'First .. I - 1)) &
				       Rest.all);
		    end;

		end if;
	    end loop;
	    return new Constraint_Array'(1 => Integer'Value (S));
	end Dashed_Value;

    begin

	-- Two supported syntax: 0123432 or 0-1-2-3-4-3-2.  The latter allows numbers greater than 9.
	Has_Dash := False;
	for I in S'Range loop
	    if S (I) = '-' then
		Has_Dash := True;
		exit;
	    end if;
	end loop;

	if Has_Dash then
	    return Dashed_Value (S);
	else
	    Result := new Constraint_Array (S'Range);
	    for I in S'Range loop
		Result (I) := Integer'Value ((1 => S (I)));
	    end loop;
	    return Result;
	end if;
    end Value;

    function Max (C : Constraint) return Natural is
	Result : Natural := 0;
    begin
	if C = null then
	    return 0;
	else
	    for I in C'Range loop
		Result := Natural'Max (Result, C (I));
	    end loop;
	end if;
	return Result;
    end Max;

    function "&" (L : Positions; R : Natural) return Positions is
    begin
	if L = null then
	    return new Position_Array'(1 => R);
	else
	    return new Position_Array'(L.all & R);
	end if;
    end "&";

    function Length (P : Positions) return Natural is
    begin
	if P = null then
	    return 0;
	else
	    return P'Length;
	end if;
    end Length;

    function Is_In (N : Natural; P : Positions) return Boolean is
    begin
	if P /= null then
	    for I in P'Range loop
		if P (I) = N then
		    return True;
		end if;
	    end loop;
	end if;
	return False;
    end Is_In;

end Options;

