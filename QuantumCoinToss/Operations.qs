namespace Operations
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;

    operation Start (n : Int) : Unit {
        Message("Hello quantum world!");

        mutable bitstring = new Bool[n];
        for (idx in 0..n-1) {
            if (Bernouli(0.5)) {
                set bitstring[idx] = false;
            } else {
                set bitstring[idx] = true;
            }
        }
        
    }

    // TODO can be made into multiple experiments efficiently?
    operation Bernouli (p : Double) : Bool {
        let outcome = Random([p, (1. - p)]);
        return outcome == 0;
        // return false;
    }

    operation EncodeBitstring (bitstring : Bool[], register : Qubit[], rectilinear : Bool) : Unit {
        for (i in 0..Length(register) - 1) {
            Encode (register[i], rectilinear, bitstring[i]);
        }
    }


    // encode a single qubit (in |0> state) according to a bit (False for 0, True for 1) and a basis (false for diagonal, true for rectilinear)
    operation Encode (qubit : Qubit, rectilinear: Bool, bit: Bool) : Unit {
        Message("Encode");
        //  f   b    q    f b q
        // <R>, 0 -> -    T F -
        // <R>, 1 -> | -> T T |
        // <D>, 0 -> /    F F /
        // <D>, 1 -> \    F T \  
        if (rectilinear && not(bit)) {
           // do nothing, qubit is already |0>
            Message("|0>");
        }
        if (rectilinear && bit) { // TODO else if not working for some reason
            X(qubit);   // |1>
            Message("|1>");
        }
        if (not(rectilinear) && not(bit)) {
            H(qubit);   // |+>
            Message("|+>");
        }
        if (not(rectilinear) && bit) {
            X(qubit);   // |1>
            H(qubit);   // |->
            Message("|->");
        }
    }
}
