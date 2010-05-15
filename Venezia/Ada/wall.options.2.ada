with Ada.Command_Line;
with Ada.Strings.Unbounded;

package body Wall.Options is

    package Asu renames Ada.Strings.Unbounded;

    use type Standard.Options.Constraint;
    use type Standard.Options.Positions;

    procedure Usage (Message : String) is
	use Ada.Text_Io;
	use Ascii;
    begin
	Put_Line (Current_Error, "Error: " & Message);
	Put_Line (Current_Error, "Usage: generate_wall [/parameter value]*");
	New_Line (Current_Error);
	Put_Line (Current_Error,
		  "  /bottom widths:none" & Ht & Ht &
		     "Widths constraining the bottom row, e.g. 12461");
	Put_Line (Current_Error,
		  "  /color direct|false|ldraw:direct" & Ht &
		     "Selects color mode" & Lf & Ht & Ht & Ht & Ht &
		     "direct: 24 bit colors for L3P" & Lf & Ht & Ht & Ht & Ht &
		     "false: basic colors for parts report" & Lf & Ht & Ht &
		     Ht & Ht & Ht & "Dark-Orange->Magenta" & Lf & Ht & Ht & Ht &
		     Ht & Ht & "Dark-Red->Purple" & Lf & Ht & Ht & Ht & Ht &
		     Ht & "Medium-Orange->Yellow" & Lf & Ht & Ht & Ht & Ht &
		     Ht & "Reddish-Brown->Tan" & Lf & Ht & Ht & Ht &
		     Ht & "ldraw: indexed colors for MLCAD");
	Put_Line (Current_Error, "  /colorseed n:0" & Ht & Ht & Ht &
				    "Random number seed for colors");
	Put_Line (Current_Error, "  /corner n:none" & Ht & Ht &
				    "Position of a corner in studs");
	Put_Line (Current_Error,
		  "  /crossover 1|2:2" & Ht & Ht &
		     "Number of crossover points for reproduction");
	Put_Line (Current_Error, "  /cycle false|true:false" & Ht & Ht &
				    "Whether the generated wall is cyclic");
	Put_Line (Current_Error, "  /hide top_bottom|left_right|tees" &
				    Ht & "Elements to hide");
	Put_Line (Current_Error, "  /generations n:100" & Ht & Ht &
				    "Number of generations to produce");
	Put_Line (Current_Error, "  /height n" & Ht & Ht & Ht &
				    "Number of rows to produce; mandatory");
	Put_Line (Current_Error,
		  "  /left widths:none" & Ht & Ht &
		     "Widths constraining the left side, e.g. 012001");
	Put_Line (Current_Error,
		  "  /mutations p:0.001" & Ht & Ht &
		     "Probability of mutation between 0.0 and 1.0");
	Put_Line (Current_Error,
		  "  /output filename" & Ht & Ht &
		     "Output file; will be overwritten; mandatory");
	Put_Line (Current_Error, "  /parts plates|tiles:plates_1xN:plates_2xN" &
				    Ht & Ht & "Kind of LEGO parts to generate");
	Put_Line (Current_Error, "  /population n:1000" & Ht & Ht &
				    "Number of individuals in a generation");
	Put_Line (Current_Error,
		  "  /right widths:none" & Ht & Ht &
		     "Widths constraining the right side, e.g. 012001");
	Put_Line (Current_Error, "  /seed n:42" & Ht & Ht &
				    Ht & "Random number seed");
	Put_Line (Current_Error, "  /show top_bottom|left_right|tees" &
				    Ht & "Elements to show");
	Put_Line (Current_Error, "  /skip top_bottom|left_right|tees" &
				    Ht & "Elements to skip");
	Put_Line (Current_Error, "  /tee n:none" & Ht & Ht & Ht &
				    "Position of a tee in studs");
	Put_Line (Current_Error,
		  "  /top widths:none" & Ht & Ht &
		     "Widths constraining the top row, e.g. 12461");
	Put_Line (Current_Error,
		  "  /trace age|genome|imperfections|mozart" & Ht &
		     "Traces evolution" & Lf & Ht & Ht & Ht & Ht &
		     "age: generation number and best fitness" & Lf & Ht & Ht &
		     Ht & Ht & "genome: best genome of each generation" &
		     Lf & Ht & Ht & Ht & Ht &
		     "imperfections: lists imperfections of the final mozart" &
		     Lf & Ht & Ht & Ht & Ht &
		     "mozart: best genome found so far");
	Put_Line (Current_Error, "  /width n" & Ht & Ht & Ht &
				    "Total width in studs; mandatory");
	Error := True;
    end Usage;

    procedure Analyze is
	Has_Height : Boolean := False;
	Has_Output : Boolean := False;
	Has_Width  : Boolean := False;
	Index      : Positive;
	Output     : Asu.Unbounded_String;
    begin
	if Ada.Command_Line.Argument_Count mod 2 = 0 then

	    Index := 1;
	    while Index <= Ada.Command_Line.Argument_Count loop

		declare
		    Param : constant String :=
		       Ada.Command_Line.Argument (Index);
		    Value : constant String :=
		       Ada.Command_Line.Argument (Index + 1);
		begin
		    if Param = "/bottom" then
			Private_Options.Bottom :=
			   Standard.Options.Value (Value);
		    elsif Param = "/color" then
			Color := Color_Option'Value (Value);
		    elsif Param = "/colorseed" then
			Color_Seed := Integer'Value (Value);
		    elsif Param = "/corner" then
			Private_Options.Corner :=
			   Private_Options.Corner & Positive'Value (Value);
		    elsif Param = "/cross" or else Param = "/crossover" then
			Crossover := Crossover_Option'Value (Value);
		    elsif Param = "/cycle" then
			Cycle := Boolean'Value (Value);
		    elsif Param = "/gen" or else Param = "/generations" then
			Generations := Positive'Value (Value);
		    elsif Param = "/h" or else Param = "/height" then
			Private_Options.Height := Positive'Value (Value);
			Has_Height             := True;
		    elsif Param = "/hide" then
			Visibility (Visibility_Element'Value (Value)) := Hide;
		    elsif Param = "/left" then
			Private_Options.Left := Standard.Options.Value (Value);
		    elsif Param = "/mut" or else Param = "/mutations" then
			Mutations := Float'Value (Value);
		    elsif Param = "/out" or else Param = "/output" then
			Output     := Asu.To_Unbounded_String (Value);
			Has_Output := True;
		    elsif Param = "/parts" then
			begin
			    Parts := Parts_Option'Value (Value);
			exception
			    when Constraint_Error =>
				-- For compatibility, we also support /parts plates.
				Parts := Parts_Option'Value (Value & "_1xN");
			end;
		    elsif Param = "/pop" or else Param = "/population" then
			Population := Positive'Value (Value);
		    elsif Param = "/right" then
			Private_Options.Right := Standard.Options.Value (Value);
		    elsif Param = "/seed" then
			Seed := Integer'Value (Value);
		    elsif Param = "/show" then
			Visibility (Visibility_Element'Value (Value)) := Show;
		    elsif Param = "/skip" then
			Visibility (Visibility_Element'Value (Value)) := Skip;
		    elsif Param = "/tee" then
			Tee := Tee & Positive'Value (Value);
		    elsif Param = "/top" then
			Private_Options.Top := Standard.Options.Value (Value);
		    elsif Param = "/trace" then
			Trace (Standard.Options.Trace_Kind'Value (Value)) :=
			   True;
		    elsif Param = "/w" or else Param = "/width" then
			-- In studs.
			Private_Options.Width := Positive'Value (Value);
			Has_Width             := True;
		    else
			Usage ("Unknown parameter " & Param & " " & Value);
			return;
		    end if;
		exception
		    when Constraint_Error =>
			Usage ("Error parsing parameter " &
			       Param & " " & Value);
			return;
		end;

		Index := Index + 2;
	    end loop;

	else
	    Usage ("Odd number of parameters" &
		   Integer'Image (Ada.Command_Line.Argument_Count));
	    return;
	end if;

	if not Has_Height and then not Has_Output and then not Has_Width then
	    Usage ("Missing /height, /output or /width");
	    return;
	end if;
	if Private_Options.Corner /= null and then not Cycle then
	    for I in Private_Options.Corner'Range loop
		if Private_Options.Corner (I) not in 2 .. Width - 1 then
		    Usage ("Misplaced corner" &
			   Integer'Image (Private_Options.Corner (I)));
		    return;
		end if;
	    end loop;
	end if;
	if Cycle then
	    if Tee /= null then
		Usage ("No tee for cyclic wall");
	    end if;
	    if Left /= null or else Right /= null then
		Usage ("No left or right constraint for cyclic wall");
	    end if;
	    if Top /= null or else Bottom /= null then
		Usage ("No top or bottom constraint (yet) for cyclic wall");
	    end if;
	    if Private_Options.Corner = null or else
	       Private_Options.Corner'Length /= 4 then
		Usage ("Exactly 4 corners for cyclic wall");
	    end if;
	end if;
	if Tee /= null then
	    if Parts = Plates_1Xn then
		for I in Tee'Range loop
		    if Tee (I) not in 1 .. Width then
			Usage ("Misplaced tee" & Integer'Image (Tee (I)));
			return;
		    end if;
		end loop;
	    else
		Usage ("Tees not allowed for " & Parts_Option'Image (Parts));
	    end if;
	end if;
	if Bottom /= null then
	    declare
		Sum : Natural := 0;
	    begin
		for I in Bottom'Range loop
		    Sum := Sum + Bottom (I);
		end loop;
		if Sum /= Width then
		    Usage ("Incorrect bottom constraint of length" &
			   Integer'Image (Sum));
		    return;
		end if;
	    end;
	end if;
	if Top /= null then
	    declare
		Sum : Natural := 0;
	    begin
		for I in Top'Range loop
		    Sum := Sum + Top (I);
		end loop;
		if Sum /= Width then
		    Usage ("Incorrect top constraint of length" &
			   Integer'Image (Sum));
		    return;
		end if;
	    end;
	end if;
	if Left /= null then
	    if Left'Length /= Height then
		Usage ("Incorrect left constraint of length" &
		       Integer'Image (Left'Length));
		return;
	    end if;
	end if;
	if Right /= null then
	    if Right'Length /= Height then
		Usage ("Incorrect right constraint of length" &
		       Integer'Image (Right'Length));
		return;
	    end if;
	end if;

	begin
	    Ada.Text_Io.Open (File => File,
			      Mode => Ada.Text_Io.Out_File,
			      Name => Asu.To_String (Output));
	exception
	    when others =>
		Ada.Text_Io.Create (File => File,
				    Mode => Ada.Text_Io.Out_File,
				    Name => Asu.To_String (Output));
	end;

    end Analyze;

    procedure Output is
    begin
	if Private_Options.Bottom /= null then
	    Ada.Text_Io.Put_Line (File,
				  "0 /bottom " & Standard.Options.Image
						    (Private_Options.Bottom));
	end if;
	Ada.Text_Io.Put_Line (File, "0 /color " & Color_Option'Image (Color));
	Ada.Text_Io.Put_Line (File, "0 /colorseed" &
				       Integer'Image (Color_Seed));
	if Private_Options.Corner /= null then
	    for J in Private_Options.Corner'Range loop
		Ada.Text_Io.Put_Line
		   (File, "0 /corner" &
			     Positive'Image (Private_Options.Corner (J)));
	    end loop;
	end if;
	Ada.Text_Io.Put_Line
	   (File, "0 /crossover" & Crossover_Option'Image (Crossover));
	Ada.Text_Io.Put_Line (File, "0 /cycle " & Boolean'Image (Cycle));
	Ada.Text_Io.Put_Line (File, "0 /height" & Positive'Image
						     (Private_Options.Height));
	if Private_Options.Left /= null then
	    Ada.Text_Io.Put_Line (File, "0 /left " & Standard.Options.Image
							(Private_Options.Left));
	end if;
	Ada.Text_Io.Put_Line (File, "0 /mutations" & Float'Image (Mutations));
	Ada.Text_Io.Put_Line (File, "0 /population" &
				       Positive'Image (Population));
	if Private_Options.Right /= null then
	    Ada.Text_Io.Put_Line (File,
				  "0 /right " & Standard.Options.Image
						   (Private_Options.Right));
	end if;
	Ada.Text_Io.Put_Line (File, "0 /seed" & Integer'Image (Seed));
	if Tee /= null then
	    for J in Tee'Range loop
		Ada.Text_Io.Put_Line (File,
				      "0 /tee" & Positive'Image (Tee (J)));
	    end loop;
	end if;
	if Private_Options.Top /= null then
	    Ada.Text_Io.Put_Line (File, "0 /top " & Standard.Options.Image
						       (Private_Options.Top));
	end if;
	Ada.Text_Io.Put_Line (File, "0 /width" & Positive'Image
						    (Private_Options.Width));
    end Output;

end Wall.Options;

