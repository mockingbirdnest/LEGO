procedure Wall.Process (Genome : Genetics.Genome) is
    type Separations is array (1 .. Height, 1 .. Width - 1) of Boolean;

    Has_Separation : Separations;
    Part_Width     : Natural;
    S              : State;
begin
    S := Initial;

    declare
	C : Integer;
    begin
	C := 0;
	for H in 1 .. Height loop
	    for W in 1 .. Width - 1 loop
		Has_Separation (H, W) := Genome (Genetics.Gene (C + W));
	    end loop;
	    C := C + Width - 1;
	end loop;
    end;

    for H in 1 .. Height loop
	Part_Width := 1;
	for W in 1 .. Width - 1 loop
	    if Has_Separation (H, W) then
		Part (First_Stud => W - Part_Width + 1, Last_Stud => W, S => S);
		Part_Width := 1;
	    else
		Part_Width := Part_Width + 1;
	    end if;
	end loop;
	Part (First_Stud => Width - Part_Width + 1, Last_Stud => Width, S => S);
    end loop;
end Wall.Process;
