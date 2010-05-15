with Genetics;
generic
    with package Genetics is new Standard.Genetics (<>);
package Wall.Ldraw is

    procedure Output_Header;
    procedure Output_Genome (Genome  : Genetics.Genome;
			     Age     : Positive;
			     Fitness : Genetics.Fitness);

end Wall.Ldraw;
