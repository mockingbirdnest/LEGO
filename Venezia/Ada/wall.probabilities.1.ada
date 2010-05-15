with Lego;
package Wall.Probabilities is

    function Q (C : Wall.Color; P : Lego.Part) return Long_Float;
    function Cumulative_Q (C : Wall.Color; P : Lego.Part) return Long_Float;

    pragma Inline (Q);
    pragma Inline (Cumulative_Q);

end Wall.Probabilities;
