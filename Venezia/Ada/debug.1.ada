with Genetics;
generic
    Height : in Positive;
    Width  : in Positive;
    with package Genetics is new Standard.Genetics (<>);
package Debug is

    procedure Trace (Genome : Genetics.Genome);

end Debug;
