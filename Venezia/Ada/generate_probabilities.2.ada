with Ada.Text_Io;

package body Generate_Probabilities is

    package Lfio is new Ada.Text_Io.Float_Io (Long_Float);

    Color_Length : constant Positive :=
       Color'Pos (Color'Last) - Color'Pos (Color'First) + 1;

    Verbose : constant Boolean := False;

    function Build_System (Probabilities : Part_Probabilities) return System is
	Part_First  : constant Natural := Part'Pos (Part'First);
	Part_Last   : constant Natural := Part'Pos (Part'Last);
	Part_Length : constant Natural := Part_Last - Part_First + 1;
	Zeros       : Natural          := 0;
    begin

	-- Count the unavailable parts to determine how many zero equations we have.
	for C in Color loop
	    for P in Part loop
		if not Available (C, P) then
		    Zeros := Zeros + 1;
		end if;
	    end loop;
	end loop;

	declare
	    S : System (Equations => Color_Length + Part_Length + Zeros - 1,
			Unknowns  => Color_Length * Part_Length);
	    A : Real_Matrix renames S.A;
	    B : Real_Vector renames S.B;
	begin

	    -- Color equations.  They are not independent, so we drop the last one.
	    for C in 1 .. Color_Length - 1 loop
		B (C) := Pleasantness (Color'Val (C - 1));
		for P in Part loop
		    A (C, C + Color_Length * (Part'Pos (P) - Part_First)) :=
		       Probabilities (P);
		end loop;
	    end loop;

	    -- Part equations.
	    for P in Part loop
		B (Color_Length + Part'Pos (P) - Part_First) := 1.0;
		for C in 1 .. Color_Length loop
		    if Available (Color'Val (C - 1), P) then
			A (Color_Length + Part'Pos (P) - Part_First,
			   C + Color_Length * (Part'Pos (P) - Part_First)) :=
			   1.0;
		    end if;
		end loop;
	    end loop;

	    -- Zero equations.
	    declare
		Z : Positive := 1;
	    begin
		for P in Part loop
		    for C in 1 .. Color_Length loop
			if not Available (Color'Val (C - 1), P) then
			    A (Color_Length - 1 + Part_Length + Z,
			       C + Color_Length *
				      (Part'Pos (P) - Part_First)) := 1.0;
			    B (Color_Length - 1 + Part_Length + Z) := 0.0;
			    Z                                      := Z + 1;
			end if;
		    end loop;
		end loop;
	    end;

	    if Verbose then
		for I in A'Range (1) loop
		    for J in A'Range (2) loop
			Lfio.Put (Item => A (I, J),
				  Fore => 2,
				  Aft  => 3,
				  Exp  => 0);
		    end loop;
		    Ada.Text_Io.Put (" = ");
		    Lfio.Put (Item => B (I), Fore => 2, Aft => 3, Exp => 0);
		    Ada.Text_Io.New_Line;
		end loop;
		Ada.Text_Io.New_Line;
	    end if;

	    return S;
	end;

    end Build_System;

    procedure Solve_System (S : System) is
	A          : Real_Matrix renames S.A;
	B          : Real_Vector renames S.B;
	A_T        : constant Real_Matrix := Transpose (A);
	A_Normal   : constant Real_Matrix := A * A_T;
	Q          : constant Real_Vector := Solve (A_Normal, B);
	X_Ls       : constant Real_Vector := A_T * Q;
	Part_First : constant Natural     := Part'Pos (Part'First);
	Part_Last  : constant Natural     := Part'Pos (Part'Last);
    begin
	if Verbose then
	    for I in A_Normal'Range (1) loop
		for J in A_Normal'Range (2) loop
		    Lfio.Put (Item => A_Normal (I, J),
			      Fore => 2,
			      Aft  => 3,
			      Exp  => 0);
		end loop;
		Ada.Text_Io.Put (" = ");
		Lfio.Put (Item => B (I), Fore => 2, Aft => 3, Exp => 0);
		Ada.Text_Io.New_Line;
	    end loop;
	    Ada.Text_Io.New_Line;

	    for I in Q'Range loop
		Lfio.Put (Item => Q (I), Fore => 2, Aft => 3, Exp => 0);
		Ada.Text_Io.New_Line;
	    end loop;
	    Ada.Text_Io.New_Line;
	end if;

	for C in Color loop
	    Ada.Text_Io.Put ("LEGO." & Color'Image (C));
	    Ada.Text_Io.Set_Col (20);
	    Ada.Text_Io.Put (" => (");
	    for P in Part loop
		Ada.Text_Io.Set_Col (20);
		Ada.Text_Io.Put ("LEGO." & Part'Image (P));
		Ada.Text_Io.Set_Col (45);
		Ada.Text_Io.Put (" => ");
		Lfio.Put (Item =>
			     X_Ls (1 + Color'Pos (C) +
				   Color_Length * (Part'Pos (P) - Part_First)),
			  Fore => 2,
			  Aft  => 6,
			  Exp  => 0);
		if P = Part'Last then
		    Ada.Text_Io.Put ("),");
		else
		    Ada.Text_Io.Put (",");
		end if;
		Ada.Text_Io.New_Line;
	    end loop;
	end loop;
	Ada.Text_Io.New_Line;
    end Solve_System;

    procedure Verify_System (S : System; Q : Conditional_Probabilities) is
	Part_First  : constant Natural := Part'Pos (Part'First);
	Part_Last   : constant Natural := Part'Pos (Part'Last);
	Part_Length : constant Natural := Part_Last - Part_First + 1;
	A           : Real_Matrix renames S.A;
	Conditional : Real_Vector (1 .. Color_Length * Part_Length);
    begin
	for C in Color loop
	    for P in Part loop
		Conditional (1 + Color'Pos (C) +
			     Color_Length * (Part'Pos (P) - Part_First)) :=
		   Q (C, P);
	    end loop;
	end loop;

	declare
	    B    : constant Real_Vector := A * Conditional;
	    Last : Long_Float;
	begin

	    -- Color equations.
	    for C in Color'First .. Color'Pred (Color'Last) loop
		Ada.Text_Io.Put (Color'Image (C));
		Ada.Text_Io.Set_Col (20);
		Ada.Text_Io.Put (" => ");
		Lfio.Put (B (1 + Color'Pos (C)), Fore => 2, Aft => 6, Exp => 0);
		Ada.Text_Io.New_Line;
	    end loop;

	    Last := 1.0;
	    for C in Color'First .. Color'Pred (Color'Last) loop
		Last := Last - B (1 + Color'Pos (C));
	    end loop;
	    Ada.Text_Io.Put (Color'Image (Color'Last));
	    Ada.Text_Io.Set_Col (20);
	    Ada.Text_Io.Put (" => ");
	    Lfio.Put (Last, Fore => 2, Aft => 6, Exp => 0);
	    Ada.Text_Io.New_Line;

	    -- Length equations.
	    for P in Part loop
		Ada.Text_Io.Put (Part'Image (P));
		Ada.Text_Io.Set_Col (20);
		Ada.Text_Io.Put (" => ");
		Lfio.Put (B (Color_Length + Part'Pos (P) - Part_First),
			  Fore => 2,
			  Aft  => 6,
			  Exp  => 0);
		Ada.Text_Io.New_Line;
	    end loop;

	    -- Zero equations.
	    for I in Color_Length +
			(Part'Pos (Part'Last) - Part'Pos (Part'First) + 1) ..
			B'Last loop
		Ada.Text_Io.Put (Integer'Image (I));
		Ada.Text_Io.Set_Col (20);
		Ada.Text_Io.Put (" => ");
		Lfio.Put (B (I), Fore => 2, Aft => 6, Exp => 0);
		Ada.Text_Io.New_Line;
	    end loop;
	end;

    end Verify_System;

end Generate_Probabilities;
