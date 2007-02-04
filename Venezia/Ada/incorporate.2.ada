with Ada.Command_Line;
with Ada.Text_Io;
procedure Incorporate is

    Usage : constant String :=
       "Usage: incorporate in-ldr-file in-mpd-file out-mpd-file";

    End_Marker     : constant String := "0";
    File_Directive : constant String := "0 FILE ";
    Ldr_Extension  : constant String := ".ldr";
    Mpd_Extension  : constant String := ".mpd";
    Line_Length    : constant        := 10000;

    In_Ldr_File  : Ada.Text_Io.File_Type;
    In_Mpd_File  : Ada.Text_Io.File_Type;
    Out_Mpd_File : Ada.Text_Io.File_Type;

    In_Replaced_Section : Boolean := False;

    function Valid (Name : String; Extension : String) return Boolean is
    begin
        if Name (Name'Last - Extension'Length + 1 .. Name'Last) /=
           Extension then
            return False;
        end if;
        for I in Name'Range loop
            if Name (I) = '\' then
                return False;
            end if;
        end loop;
        return True;
    end Valid;

begin
    if Ada.Command_Line.Argument_Count /= 3 then
        Ada.Text_Io.Put_Line (Ada.Text_Io.Standard_Error,
                              "Incorrect number of parameters");
        Ada.Text_Io.Put_Line (Ada.Text_Io.Standard_Error, Usage);
        return;
    end if;

    declare
        In_Ldr_File_Name  : constant String := Ada.Command_Line.Argument (1);
        In_Mpd_File_Name  : constant String := Ada.Command_Line.Argument (2);
        Out_Mpd_File_Name : constant String := Ada.Command_Line.Argument (3);
    begin
        if not Valid (In_Ldr_File_Name, Ldr_Extension) then
            Ada.Text_Io.Put_Line (Ada.Text_Io.Standard_Error,
                                  "invalid file name " & In_Ldr_File_Name);
            Ada.Text_Io.Put_Line (Ada.Text_Io.Standard_Error, Usage);
            return;
        end if;
        if not Valid (In_Mpd_File_Name, Mpd_Extension) then
            Ada.Text_Io.Put_Line (Ada.Text_Io.Standard_Error,
                                  "invalid file name " & In_Mpd_File_Name);
            Ada.Text_Io.Put_Line (Ada.Text_Io.Standard_Error, Usage);
            return;
        end if;
        if not Valid (Out_Mpd_File_Name, Mpd_Extension) then
            Ada.Text_Io.Put_Line (Ada.Text_Io.Standard_Error,
                                  "invalid file name " & Out_Mpd_File_Name);
            Ada.Text_Io.Put_Line (Ada.Text_Io.Standard_Error, Usage);
            return;
        end if;
        if In_Mpd_File_Name = Out_Mpd_File_Name then
            Ada.Text_Io.Put_Line (Ada.Text_Io.Standard_Error,
                                  "invalid sharing of mpd files");
            Ada.Text_Io.Put_Line (Ada.Text_Io.Standard_Error, Usage);
            return;
        end if;

        Ada.Text_Io.Open (File => In_Ldr_File,
                          Mode => Ada.Text_Io.In_File,
                          Name => In_Ldr_File_Name);
        Ada.Text_Io.Open (File => In_Mpd_File,
                          Mode => Ada.Text_Io.In_File,
                          Name => In_Mpd_File_Name);

        begin
            Ada.Text_Io.Create (File => Out_Mpd_File,
                                Mode => Ada.Text_Io.Out_File,
                                Name => Out_Mpd_File_Name);
        exception
            when others =>
                Ada.Text_Io.Open (File => Out_Mpd_File,
                                  Mode => Ada.Text_Io.Out_File,
                                  Name => Out_Mpd_File_Name);
        end;

        while not Ada.Text_Io.End_Of_File (In_Mpd_File) loop

            declare
                Line : String (1 .. Line_Length);
                Last : Natural;
            begin
                Ada.Text_Io.Get_Line (File => In_Mpd_File,
                                      Item => Line,
                                      Last => Last);
                if Last >= Line'First + File_Directive'Length - 1 and then
                   Line (Line'First .. Line'First + File_Directive'Length - 1) =
                      File_Directive then
                    Ada.Text_Io.Put_Line
                       (File => Out_Mpd_File,
                        Item => Line (Line'First .. Last));
                    if Line (Line'First + File_Directive'Length ..
                                Line'First + File_Directive'Length +
                                   In_Ldr_File_Name'Length - 1) =
                       In_Ldr_File_Name then
                        In_Replaced_Section := True;
                        while not Ada.Text_Io.End_Of_File (In_Ldr_File) loop

                            declare
                                Line : String (1 .. Line_Length);
                                Last : Natural;
                            begin
                                Ada.Text_Io.Get_Line (File => In_Ldr_File,
                                                      Item => Line,
                                                      Last => Last);
                                Ada.Text_Io.Put_Line
                                   (File => Out_Mpd_File,
                                    Item => Line (Line'First .. Last));
                            end;

                        end loop;
                        Ada.Text_Io.Put_Line (Out_Mpd_File, End_Marker);
                    else
                        In_Replaced_Section := False;
                    end if;
                elsif not In_Replaced_Section then
                    Ada.Text_Io.Put_Line (File => Out_Mpd_File,
                                          Item => Line (Line'First .. Last));
                end if;
            end;

        end loop;
    end;
end Incorporate;

