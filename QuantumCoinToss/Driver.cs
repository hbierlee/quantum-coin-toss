using System;

using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

using Operations;

namespace Driver
{
    class Driver
    {
        static void Main(string[] args)
        {
            int n;
            if (args.Length == 0) {
                n = 20;   
            } else {
                try {
                    n = Int32.Parse(args[0]);
                } catch (FormatException) {
                    Console.WriteLine($"Unable to parse '{args[0]}'");
                    return ;
                }
            }
            System.Console.WriteLine($"Number of qubits = {n}");
            using (var qsim = new QuantumSimulator())
            {
                Start.Run(qsim, 20, true).Wait();
            }
        }
    }
}