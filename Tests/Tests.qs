namespace Tests
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Extensions.Diagnostics;

    open Operations;

    // operation DumpTest () : Unit {
    //     Message("DumpTest/Playground.");
    //     using (qubit = Qubit()) {
    //         DumpRegister((), [qubit]);
    //         X(qubit);
    //         H(qubit);
    //         DumpRegister((), [qubit]);
    //         Reset(qubit);
    //     }
    //     Message("Test passed.");
    // }

    operation EncodeBitstringTest () : Unit {
        Message("EncodeBitstringTest.");

        using (register = Qubit[6]) {
            let bitstring = [true, false, true];
            EncodeBitstring(bitstring, register[0..2], true);

            Assert([PauliZ], register[0..0], One, "something went wrong..");
            Assert([PauliZ], register[1..1], Zero, "something went wrong..");
            Assert([PauliZ], register[2..2], One, "something went wrong..");

            AssertProb([PauliX], register[0..0], One, 0.5, "something went wrong..", 1e-5);
            AssertProb([PauliX], register[1..1], One, 0.5, "something went wrong..", 1e-5);
            AssertProb([PauliX], register[2..2], One, 0.5, "something went wrong..", 1e-5);

            EncodeBitstring(bitstring, register[3..5], false);

            Assert([PauliX], register[3..3], One, "something went wrong..");
            Assert([PauliX], register[4..4], Zero, "something went wrong..");
            Assert([PauliX], register[5..5], One, "something went wrong..");

            AssertProb([PauliZ], register[3..3], One, 0.5, "something went wrong..", 1e-5);
            AssertProb([PauliZ], register[4..4], One, 0.5, "something went wrong..", 1e-5);
            AssertProb([PauliZ], register[5..5], One, 0.5, "something went wrong..", 1e-5);

            ResetAll(register);
        }
    }

    operation EncodeTest () : Unit {
        Message("EncodeTest.");
        using (qubits = Qubit[4]) {
            Encode(qubits[0], true, false);
            DumpRegister((), qubits[0..0]);
            Assert([PauliZ], qubits[0..0], Zero, "A qubit encoded by (0,R) -> |0> must pass through a rectilinear filter   0% of the time.");
            AssertProb(
                [PauliX],   // "diagonal" filter
                qubits[0..0],    // qubit |0>
                One,    // it passes through the filter
                0.5,    // probability of  expected result
                "A qubit encoded by (0,R) -> |0> must pass through a diagonal filter   50% of the time.",
                1e-5
            );
            AssertProb(
                [PauliX],   // "diagonal" filter
                qubits[0..0],    // qubit |0>
                Zero,    // it is blocked by the filter
                0.5,    // probability of  expected result
                "A qubit encoded by (0,R) -> |0> must NOT pass through a diagonal filter   50% of the time.",
                1e-5
            );

            Encode(qubits[1], true, true);
            DumpRegister((), qubits[1..1]);
            Assert([PauliZ], qubits[1..1], One, "A qubit encoded by (1,R) -> |1> must pass through a rectilinear filter 100% of the time.");
            AssertProb(
                [PauliX],   // "diagonal" filter
                qubits[1..1],    // qubit |1>
                One,    // it passes through the filter
                0.5,    // probability of  expected result
                "A qubit encoded by (1,R) -> |1> must pass through a diagonal filter   50% of the time.",
                1e-5
            );
            AssertProb(
                [PauliX],   // "diagonal" filter
                qubits[1..1],    // qubit |0>
                Zero,    // it is blocked by the filter
                0.5,    // probability of  expected result
                "A qubit encoded by (1,R) -> |0> must NOT pass through a diagonal filter   50% of the time.",
                1e-5
            );

            Encode(qubits[2], false, false);
            DumpRegister((), qubits[2..2]);
            Assert([PauliX], qubits[2..2], Zero, "A qubit encoded by (0,D) -> |+> must pass through a diagonal filter 0% of the time.");
            AssertProb(
                [PauliZ],   // "rectilinear" filter
                qubits[2..2],    // qubit |1>
                One,    // it passes through the filter
                0.5,    // probability of  expected result
                "A qubit encoded by (0,D) -> |+> must pass through a rectilinear filter   50% of the time.",
                1e-5
            );
            AssertProb(
                [PauliZ],   // "rectilinear" filter
                qubits[2..2],    // qubit |0>
                Zero,    // it is blocked by the filter
                0.5,    // probability of  expected result
                "A qubit encoded by (0,D) -> |+> must NOT pass through a rectilinear filter   50% of the time.",
                1e-5
            );

            Encode(qubits[3], false, true);
            DumpRegister((), qubits[3..3]);
            Assert([PauliX], qubits[3..3], One, "A qubit encoded by (1,D) -> |-> must pass through a diagonal filter 100% of the time.");
            AssertProb(
                [PauliZ],   // "rectilinear" filter
                qubits[3..3],    // qubit |1>
                One,    // it passes through the filter
                0.5,    // probability of  expected result
                "A qubit encoded by (1,D) -> |-> must pass through a rectilinear filter   50% of the time.",
                1e-5
            );
            AssertProb(
                [PauliZ],   // "rectilinear" filter
                qubits[3..3],    // qubit |0>
                Zero,    // it is blocked by the filter
                0.5,    // probability of  expected result
                "A qubit encoded by (1,D) -> |-> must NOT pass through a rectilinear filter   50% of the time.",
                1e-5
            );

            ResetAll(qubits);
        }
        Message("Test passed");
    }
}
