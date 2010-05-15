with Genetics;
private generic
    type State is private;
    Initial : in State;
    with procedure Part (First_Stud, Last_Stud : Positive;  
			 S                     : in out State);
    Height  : in Positive;
    Width   : in Positive;
    with package Genetics is new Standard.Genetics (<>);
procedure Process (Genome : Genetics.Genome);
