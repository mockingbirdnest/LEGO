with Lego;
with Options;
package Wall is

    subtype Color is Lego.Color range Lego.Brown .. Lego.Medium_Orange;

    -- The margin added to both sides of the wall when generating cyclic walls.
    -- Must not be less than the size of the longest part.
    Cycle_Margin : constant Positive := 10;

    -- In the functions below, if Effective is False, the value actually
    -- specified by the user is returned.  If Effective is True, the value used
    -- for computing the wall is returned.  The two only differ if Cycle is
    -- True.

    function Height return Positive;
    function Width (Effective : Boolean := True) return Positive;

    function Bottom return Options.Constraint;
    function Bottom_Height return Natural;
    function Corner (Effective : Boolean := True) return Options.Positions;
    function Top return Options.Constraint;
    function Top_Height return Natural;
    function Left return Options.Constraint;
    function Right return Options.Constraint;

    pragma Inline (Height);
    pragma Inline (Width);
    pragma Inline (Bottom);
    pragma Inline (Bottom_Height);
    pragma Inline (Corner);
    pragma Inline (Top);
    pragma Inline (Top_Height);
    pragma Inline (Left);
    pragma Inline (Right);

end Wall;
