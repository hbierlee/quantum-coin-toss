# Quantum Coin flip
Implementation of the [quantum coin flip protocol](https://en.wikipedia.org/wiki/Quantum_coin_flipping) [1] for my Uppsala University Cryptology course [1DT075], Spring semester 2018. Requires C# SDK. Compile and see `lecture/lecture.tex`, `report/report.tex` and `presentation/presentation.tex` for more info.

## Run instructions
```
cd QuantumCoinToss
dotnet run
```

Or with CLI options: `dotnet run [[-- n] --manual]`

Specify `n` for number of simulated qubits, `--manual` flag for manual mode with accompanying Alice-Bob dialogue.

## References
[1] M. Blum, Coin Flipping per Telephone: A Protocol for Solving Problems Impossible (1981)
