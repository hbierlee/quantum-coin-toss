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

            bool manual = Array.IndexOf(args, "--manual") > -1;

            if (manual) {
                ConsoleKey key;
                do {
                    System.Console.WriteLine("(Alice flips a coin and presses [H] for Heads or [T] for Tails)");
                    key = System.Console.ReadKey(true).Key;
                } while (key != ConsoleKey.H && key != ConsoleKey.T);

                bool aliceRectilinear = key == ConsoleKey.H;

                
                using (var qsim = new QuantumSimulator())
                {
                    var result = QuantumCoinTossManual.Run(qsim, n, aliceRectilinear).Result;

                    Console.WriteLine(result);
                }

                return ;
                // Console.ReadLine();
                // System.Console.WriteLine("Alice: ");
                // Console.ReadLine();
                // System.Console.WriteLine("Bob: ");

                // read alice choice

            } else {
                Console.WriteLine("auto");

                using (var qsim = new QuantumSimulator())
                {
                    var result = QuantumCoinTossAuto.Run(qsim, n).Result;

                    Console.WriteLine(result);
                }
            }
        }

        }
    }
}