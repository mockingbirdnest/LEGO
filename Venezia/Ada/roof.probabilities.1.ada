with Lego;
package Roof.Probabilities is

    function Q (C : Roof.Color; P : Lego.Part) return Long_Float;
    function Cumulative_Q (C : Roof.Color; P : Lego.Part) return Long_Float;

    pragma Inline (Q);
    pragma Inline (Cumulative_Q);

end Roof.Probabilities;
