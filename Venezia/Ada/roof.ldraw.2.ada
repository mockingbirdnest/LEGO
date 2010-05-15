with Ada.Numerics.Float_Random;
with Ada.Numerics.Generic_Real_Arrays;
with Ada.Text_Io;
with Lego;
with Process;
with Roof.Options;
with Roof.Probabilities;
package body Roof.Ldraw is

    package Anfr renames Ada.Numerics.Float_Random;

    use type Lego.Part;
    use type Options.Constraint;
    use type Options.Visibility_Option;

    Color_Generator : Anfr.Generator;

    type Output_State is
	record
	    Y                                  : Integer;
	    Last_X1, Last_X2, Last_Z1, Last_Z2 : Integer;
	    Last_Color                         : Lego.Color;
	    Last_Part                          : Lego.Part;
	    Start_Of_Row                       : Boolean;
	end record;

    No_Such_Part : exception;

    package Arrays is new Ada.Numerics.Generic_Real_Arrays (Float);
    type Matrix is new Arrays.Real_Matrix (1 .. 3, 1 .. 3);

    procedure Append (First_Stud, Last_Stud : Positive;
		      S                     : in out Output_State;
		      X, Z                  : out Integer;
		      M                     : out Matrix;
		      Part                  : out Lego.Part) is
	Stud_Count : constant Positive := Last_Stud - First_Stud + 1;
    begin
	case Stud_Count is
	    when 1 =>
		Part := Lego.Brick_1X1_Round;
	    when 2 =>
		Part := Lego.Brick_1X2_Log;
	    when others =>
		raise No_Such_Part;
	end case;
	M         := ((-1.0, 0.0, 0.0), (0.0, 1.0, 0.0), (0.0, 0.0, -1.0));
	S.Last_X1 := S.Last_X2;
	S.Last_X2 := S.Last_X2 + Stud_Count;
	X         := (20 * (S.Last_X1 + S.Last_X2)) / 2;
	Z         := (20 * (S.Last_Z1 + S.Last_Z2)) / 2;
    end Append;

    procedure Output_Part (First_Stud, Last_Stud : Positive;
			   S                     : in out Output_State) is
	use type Lego.Color;

	Is_Left_Right : constant Boolean  :=
	   (Left /= null and then Last_Stud <= Left (1 - S.Y)) or else
	      (Right /= null and then First_Stud >=
					 Width - Right (1 - S.Y) + 1);
	Stud_Count    : constant Positive := Last_Stud - First_Stud + 1;

	C      : Lego.Color;
	Is_Tee : Boolean := False;
	P      : Lego.Part;
	Hide   : Boolean;
	Skip   : Boolean;
	X, Z   : Integer;
	M      : Matrix;

	function Random (P : Lego.Part) return Lego.Color is
	    R : Long_Float range 0.0 .. 1.0;
	    use type Lego.Color;
	begin

	    -- The last entry in Cumulative_Q will be very close to 1.0, but it
	    -- may not be exactly 1.0 because of rounding.  Adjust the random
	    -- number to avoid leaving a tiny hole.
	    R := Long_Float (Anfr.Random (Color_Generator)) *
		    Probabilities.Cumulative_Q (Lego.Color'Last, P);
	    for Color in Lego.Color loop
		if Probabilities.Q (Color, P) > 0.0 then
		    if Probabilities.Cumulative_Q (Color, P) >= R then
			return Color;
		    end if;
		end if;
	    end loop;
	end Random;

	procedure Put (S : String) is
	begin
	    if not Skip then
		Ada.Text_Io.Put (Options.File, S);
	    end if;
	end Put;

	procedure Put_Line (S : String) is
	begin
	    if not Skip then
		Ada.Text_Io.Put_Line (Options.File, S);
	    end if;
	end Put_Line;

	procedure Put (M : Matrix) is
	begin
	    -- By column...
	    for I in M'Range (2) loop
		for J in M'Range (1) loop

		    declare
			S : constant String :=
			   Integer'Image (Integer (M (J, I)));
		    begin
			if S (S'First) = ' ' then
			    Put (S);
			else
			    Put (" " & S);
			end if;
		    end;

		end loop;
	    end loop;
	end Put;

    begin
	Append (First_Stud => First_Stud,
		Last_Stud  => Last_Stud,
		S          => S,
		X          => X,
		Z          => Z,
		M          => M,
		Part       => P);


	-- Pick a color.  Make sure that we don't have two consecutive logs of
	-- the same color. 
	C := Random (P);
	pragma Assert (Lego.Available (C, P));
	while not S.Start_Of_Row and then C = S.Last_Color and then
		 (P = Lego.Brick_1X2_Log or else
		  S.Last_Part = Lego.Brick_1X2_Log) loop
	    C := Random (P);
	    pragma Assert (Lego.Available (C, P));
	end loop;
	S.Last_Color := C;
	S.Last_Part  := P;

	Skip := Is_Left_Right and then
		   Options.Visibility (Options.Left_Right) = Options.Skip;
	Hide := Is_Left_Right and then
		   Options.Visibility (Options.Left_Right) = Options.Hide;

	if Is_Left_Right then

	    -- To preserve coloring we want this one to consume colors but to
	    -- be shown clear.  Compatibility...
	    C := Lego.Clear;
	end if;

	if Hide then
	    Put ("0 MLCAD HIDE ");
	end if;
	Put ("1");

	case Options.Color is
	    when Standard.Options.Direct =>
		Put (" " & Lego.Direct_Image (C));
	    when Standard.Options.False =>
		Put (" " & Lego.False_Image (C));
	    when Standard.Options.Ldraw =>
		Put (" " & Lego.Ldraw_Image (C));
	end case;

	Put (" " & Integer'Image (X) & " " &
	     Integer'Image (24 * S.Y) & " " & Integer'Image (Z));

	Put (M);

	Put_Line (" " & Lego.Part_Id_Image (P) & ".DAT");

	S.Start_Of_Row := False;
	if Last_Stud = Width then
	    S.Y            := S.Y - 1;
	    S.Start_Of_Row := True;
	    S.Last_X1      := 0;
	    S.Last_X2      := 0;
	    S.Last_Z1      := 0;
	    S.Last_Z2      := 1;
	    if not Skip then
		Ada.Text_Io.Put_Line (Options.File, "0 STEP");
		Ada.Text_Io.Put_Line (Options.File, "0 WRITE End of step" &
						       Integer'Image (-S.Y));
	    end if;
	end if;
    exception
	when No_Such_Part =>
	    Ada.Text_Io.Put_Line (Ada.Text_Io.Standard_Error,
				  "No such part at studs" &
				     Positive'Image (First_Stud) & " to" &
				     Positive'Image (Last_Stud));
	    for I in First_Stud .. Last_Stud loop
		Output_Part (I, I, S);
	    end loop;
    end Output_Part;


    procedure Output_Header is
    begin
	Ada.Text_Io.Put_Line (Options.File, "0 Author: Generate_Roof");
	Ada.Text_Io.Put_Line (Options.File, "0 Unofficial Model");
	Ada.Text_Io.Put_Line (Options.File,
			      "0 Rotation Center 0 0 0 1 ""Custom""");
	Ada.Text_Io.Put_Line (Options.File, "0 Rotation Config 0 0");
    end Output_Header;

    procedure Output_Genome (Genome  : Genetics.Genome;
			     Age     : Positive;
			     Fitness : Genetics.Fitness) is

	procedure Actual_Output is
	   new Process (State    => Output_State,
			Initial  => (Y                 => 0,
				     Last_X1 | Last_X2 => 0,
				     Last_Z1           => 0,
				     Last_Z2           => 1,
				     Last_Color        => Lego.Color'First,
				     Last_Part         => Lego.Part'First,
				     Start_Of_Row      => True),
			Part     => Output_Part,
			Height   => Height,
			Width    => Width,
			Genetics => Genetics);

    begin

	-- We want to make sure that different walls explore different sequences of the
	-- color generator, otherwise we would have biases.  We use as the seed the number
	-- of studs, which is as good a number as any.
	Anfr.Reset (Color_Generator,
		    Options.Private_Options.Height *
		       Options.Private_Options.Width + Options.Color_Seed);
	Ada.Text_Io.Put_Line (Options.File,
			      "0 /result_fitness" &
				 Genetics.Fitness'Image (Fitness));
	Ada.Text_Io.Put_Line (Options.File,
			      "0 /result_generation" & Positive'Image (Age));
	Actual_Output (Genome);
    end Output_Genome;

end Roof.Ldraw;
