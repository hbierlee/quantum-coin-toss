﻿namespace Tests
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;

    operation AllocateQubitTest () : Unit {
        using (q = Qubit()) {
            Assert([PauliZ], [q], Zero, "Newly allocated qubit must be in |0> state");
        }
        
        Message("Test passed");
    }
}