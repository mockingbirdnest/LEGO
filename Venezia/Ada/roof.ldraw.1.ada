with Genetics;
generic
    with package Genetics is new Standard.Genetics (<>);
package Roof.Ldraw is

    procedure Output_Header;
    procedure Output_Genome (Genome  : Genetics.Genome;
			     Age     : Positive;
			     Fitness : Genetics.Fitness);

end Roof.Ldraw;
