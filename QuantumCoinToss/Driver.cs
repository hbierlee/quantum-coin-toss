using System;

using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;
using System.Collections;
using System.Collections.Generic;

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

            // TODO doesn't work if n is not specified
            // TODO rename flag to '--demo'?
            bool manual = Array.IndexOf(args, "--manual") > -1;

            if (manual) {
                ConsoleKey key;
                do {
                    System.Console.WriteLine("(Alice flips a coin and presses [H] for Heads or [T] for Tails)");
                    key = System.Console.ReadKey(true).Key;
                } while (key != ConsoleKey.H && key != ConsoleKey.T);

                bool aliceRectilinear = key == ConsoleKey.H;
                
                (QArray<bool> bitstring, QArray<long> rectilinearTable, QArray<long> diagonalTable) result;
                using (var qsim = new QuantumSimulator())
                {
                    Console.Write("Running an *actual* simulation of a Quantum Coin-flip.. ");
                    result = QuantumCoinTossManual.Run(qsim, n, aliceRectilinear).Result;
                }

                Console.WriteLine("done!");

                System.Console.WriteLine("R D B");
                System.Console.WriteLine("=====");
                using(IEnumerator<long> rs = result.rectilinearTable.GetEnumerator())
                using(IEnumerator<long> ds = result.diagonalTable.GetEnumerator())
                while (rs.MoveNext() && ds.MoveNext()) {
                    string left = rs.Current == -1 ? " " : rs.Current.ToString();
                    string right = ds.Current == -1 ? " " : ds.Current.ToString();
                    System.Console.WriteLine($"{left} {right} ?");
                }

                ConsoleKey keyBob;
                do {
                    System.Console.WriteLine("(Bob calls Alice's coin-flip: [H] for Heads or [T] for Tails)");
                    keyBob = System.Console.ReadKey(true).Key;
                } while (keyBob != ConsoleKey.H && keyBob != ConsoleKey.T);

                bool bobRectilinear = keyBob == ConsoleKey.H;

                // TODO make this comparison slower / progress bar like "Comparing 2 booleans extra slowly for suspense.. 42,2%"
                if (aliceRectilinear == bobRectilinear) {
                    Console.WriteLine("Bob Wins!");
                } else {
                    Console.WriteLine("Alice Wins!");
                }

                System.Console.WriteLine("R D B");
                System.Console.WriteLine("=====");
                using(IEnumerator<long> rs = result.rectilinearTable.GetEnumerator())   // TODO much code duplication, could be cleaned up
                using(IEnumerator<long> ds = result.diagonalTable.GetEnumerator())
                using(IEnumerator<bool> bs = result.bitstring.GetEnumerator())
                while (rs.MoveNext() && ds.MoveNext() && bs.MoveNext()) {
                    string r = rs.Current == -1 ? " " : rs.Current.ToString();
                    string d = ds.Current == -1 ? " " : ds.Current.ToString();
                    string b = bs.Current ? "1" : "0";
                    System.Console.WriteLine($"{r} {d} {b}");
                }
                Console.WriteLine("Verification of rectilinear-table: " + verifyTable(result.rectilinearTable, result.bitstring));
                Console.WriteLine("Verification of diagonal-table: " + verifyTable(result.diagonalTable, result.bitstring));
                return ;
            } else {
                Console.WriteLine("auto");

                using (var qsim = new QuantumSimulator())
                {
                    var result = QuantumCoinTossAuto.Run(qsim, n).Result;

                    Console.WriteLine(result);
                }
            }
        }

        static double verifyTable (IEnumerable<long> table, IEnumerable<bool> bitstring) {
            int count = 0;
            int correct = 0;

            using(IEnumerator<long> ts = table.GetEnumerator())
            using(IEnumerator<bool> bs = bitstring.GetEnumerator())
            while (ts.MoveNext() && bs.MoveNext()) {
                if (ts.Current != -1) {
                    count++;
                    if ((ts.Current != 0) == bs.Current) {  // if bitstring and table agree, increment correct counter
                        correct++;
                    }
                }
            }

            return correct / (double) count;
        }
    }
}