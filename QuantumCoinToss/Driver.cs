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
                System.Console.WriteLine("%%% IRC %%%");
                System.Console.WriteLine($"{DateTime.Now.ToString("hh:mm")} -!- alice has joined #channel");
                System.Console.WriteLine($"{DateTime.Now.ToString("hh:mm")} -!- bob has joined #channel");
                Say("alice", "Bob, let's flip a coin to decide who gets the car.");
                Say("alice", "However, we're going to use a _quantum_ coin-toss");
                Say("alice", "I don't trust you anymore, ever since you cheated on me with Chuck.");
                Say("bob", "Sure. You flip it, I'll call it.");

                ConsoleKey key;
                do {
                    System.Console.WriteLine("(Alice flips a coin and presses [H] for Heads or [T] for Tails)");
                    key = System.Console.ReadKey(true).Key;
                } while (key != ConsoleKey.H && key != ConsoleKey.T);

                bool aliceRectilinear = key == ConsoleKey.H;

                Say("alice", "Ok, I flipped a coin.");
                Say("alice", "I'm now going to boot up my quantum computer, which will generate a random bitstring of 0's and 1's.");
                Say("alice", "If I tossed Heads, I'll rectilinearly encode the 0's and 1's, so that they become |0> and |1> qubits, respectively.");
                Say("alice", "If I tossed Tails, I'll diagonally encode the 0's and 1's, so that they become |-> and |+> qubits, respectively.");
                Say("alice", "Then I'll send the qubits to you.");
                Say("bob",   "Ok, since I don't know how you encoded the bits into qubits, I will just randomly switch between rectilinear and diagonal bases to measure/decode the qubit.");
                Say("bob",   "I'll put the results of the rectilinear measurements in one table, and the diagonal measurements in another.");

                
                using (var qsim = new QuantumSimulator())
                {
                    var result = QuantumCoinTossManual.Run(qsim, n, aliceRectilinear).Result;

                    Console.WriteLine(result);
                }

                Console.WriteLine("@alice has left the channel.");
                Console.WriteLine("@bob has left the channel.");
                Console.WriteLine("@eve has left the channel.");
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

        static void Say(string user, string msg) {
            String ts = DateTime.Now.ToString("hh:mm");
            System.Console.WriteLine($"{ts} <@{user}> {msg}");
            Console.ReadKey(true);
        }
    }
}