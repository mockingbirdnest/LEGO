with Lego;
with Options;
package Roof is

    subtype Color is Lego.Color;

    function Height return Positive;
    function Width return Positive;
    function Left return Options.Constraint;
    function Right return Options.Constraint;
end Roof;
