with Ada.Text_Io;
with Lego;
procedure Ldraw2Direct is

    Part_Marker : constant String := "1 ";

    Line     : String (1 .. 1000);
    Last     : Natural;
    Space    : Natural;
    Verbatim : Boolean;
begin

    -- declare
    --     F : Ada.Text_Io.File_Type;
    -- begin
    --     Ada.Text_Io.Open (File => F,
    --                       Mode => Ada.Text_Io.In_File,
    --                       Name => "Assembly.mpd",
    --                       Form => "");
    --     Ada.Text_Io.Set_Input (File => F);
    -- end;

    while not Ada.Text_Io.End_Of_File loop
        Ada.Text_Io.Get_Line (Item => Line,
                              Last => Last);
        Verbatim := True;

        if Last >= Line'First + Part_Marker'Length - 1 and then
           Line (Line'First .. Line'First + Part_Marker'Length - 1) =
              Part_Marker then

            Space := 0;
            for I in Line'First + Part_Marker'Length .. Last loop
                if Line (I) = ' ' then
                    Space := I;
                    exit;
                end if;
            end loop;

            declare
                Ldraw_Image : constant String :=
                   ' ' & Line (Line'First + Part_Marker'Length .. Space - 1);
            begin
                -- Ada.Text_Io.Put_Line
                --    (Ada.Text_Io.Standard_Error,
                --     ">>" & Ldraw_Image & "<<");
                for C in Lego.Color loop
                    if Lego.Ldraw_Image (C) = Ldraw_Image then
                        Verbatim := False;
                        Ada.Text_Io.Put
                           (Line (Line'First ..
                                     Line'First + Part_Marker'Length - 1));
                        Ada.Text_Io.Put (Lego.Direct_Image (C));
                        Ada.Text_Io.Put_Line (Line (Space .. Last));
                        exit;
                    end if;
                end loop;
            end;

        end if;

        if Verbatim then
            Ada.Text_Io.Put_Line (Line (Line'First .. Last));
        end if;
    end loop;
end Ldraw2Direct;

