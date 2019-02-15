namespace Operations
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Extensions.Diagnostics;
    open Microsoft.Quantum.Extensions.Convert;

    // TODO "rectilinear" Bools might be replaceable for PauliZ/PauliX
    operation Start (n : Int, aliceRectilinear: Bool) : Unit {
        // 
        // Alice:
        // 
        Message("Hello quantum world!");

        mutable bitstring = new Bool[n];
        for (idx in 0..n-1) {
            if (Bernouli(0.5)) {
                set bitstring[idx] = false;
            } else {
                set bitstring[idx] = true;
            }
        }


        using (register = Qubit[n]) {
            EncodeBitstring(bitstring, register, aliceRectilinear);

            // TODO would be neat if Bob / Alice code is properly separated (to simulate quantum channel)
            // Send only (register) to Bob over quantum channel
            // Bob:
            // 

            mutable rectilinearTable = new Int[n];
            mutable diagonalTable = new Int[n];

            // TODO could all the qubit be measured together? (Or would this give wrong results?)
            // TODO better, check ApplyPauli!

            for (i in 0..n-1) {
                if (Bernouli(0.5)) {
                    set rectilinearTable[i] = ResultAsInt([Measure([PauliZ], [register[i]])]);
                    set diagonalTable[i] = -1;
                } else {
                    set diagonalTable[i] = ResultAsInt([Measure([PauliX], [register[i]])]);
                    set rectilinearTable[i] = -1;
                }
            }

            for (i in 0..n-1) {
                Message(ToStringB(bitstring[i]) + ": " + ToStringI(rectilinearTable[i]) + "," + ToStringI(diagonalTable[i]));
            }

            ResetAll(register);
        }
    }

    // TODO can be made into multiple experiments version efficiently? To generate the bitstring quicker (index -> unsigned int binary)?
    operation Bernouli (p : Double) : Bool {
        let outcome = Random([p, (1. - p)]);
        return outcome == 0;
        // return false;
    }

    // TODO probably overkill and can be refactored out
    operation EncodeBitstring (bitstring : Bool[], register : Qubit[], rectilinear : Bool) : Unit {
        for (i in 0..Length(register) - 1) {
            Encode (register[i], rectilinear, bitstring[i]);
        }
    }


    // encode a single qubit (in |0> state) according to a bit (False for 0, True for 1) and a basis (false for diagonal, true for rectilinear)
    operation Encode (qubit : Qubit, rectilinear : Bool, bit : Bool) : Unit {
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
