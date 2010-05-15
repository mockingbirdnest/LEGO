with Genetics;
private generic
    type State is private;
    Initial : in State;
    with package Genetics is new Standard.Genetics (<>);
    with procedure Part (First_Stud, Last_Stud : Positive;  
			 S                     : in out State);
procedure Wall.Process (Genome : Genetics.Genome);
