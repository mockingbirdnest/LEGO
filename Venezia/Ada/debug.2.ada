with Ada.Text_Io;
with Process;
package body Debug is

    type Trace_State is null record;

    procedure Trace_Part (First_Stud, Last_Stud : Positive;
			  S                     : in out Trace_State) is
	Width_Indicator : constant array (Positive range <>) of Character :=
	   "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	Part_Width      : constant Positive                               :=
	   Last_Stud - First_Stud + 1;
    begin
	if Part_Width = 1 then
	    Ada.Text_Io.Put (Ada.Text_Io.Standard_Error, '|');
	else
	    Ada.Text_Io.Put (Ada.Text_Io.Standard_Error, '[');
	    for I in 1 .. Part_Width - 2 loop
		Ada.Text_Io.Put (Ada.Text_Io.Standard_Error,
				 Width_Indicator (Part_Width));
	    end loop;
	    Ada.Text_Io.Put (Ada.Text_Io.Standard_Error, ']');
	end if;
	if Last_Stud = Width then
	    Ada.Text_Io.New_Line (Ada.Text_Io.Standard_Error);
	end if;
    end Trace_Part;

    procedure Trace (Genome : Genetics.Genome) is
	procedure Actual_Trace is new Process (State    => Trace_State,
					       Initial  => (null record),
					       Part     => Trace_Part,
					       Height   => Height,
					       Width    => Width,
					       Genetics => Genetics);
    begin
	Actual_Trace (Genome);
    end Trace;

end Debug;
