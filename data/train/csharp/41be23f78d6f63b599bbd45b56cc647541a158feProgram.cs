namespace _04.Logistics
{
    using System;

    public class Program
    {
        private static void Main()
        {
            int loadCount = int.Parse(Console.ReadLine());
            double totalLoad = 0;

            double microbusLoad = 0;
            double truckLoad = 0;
            double trainLoad = 0;

            double avrageLoad = 0;

            for (int i = 0; i < loadCount; i++)
            {
                int load = int.Parse(Console.ReadLine());
                totalLoad += load;

                if (load <= 3)
                {
                    microbusLoad += load;
                }
                else if (load >= 4 && load <= 11)
                {
                    truckLoad += load;
                }
                else
                {
                    trainLoad += load;
                }
            }

            avrageLoad = (microbusLoad * 200 + truckLoad * 175 + trainLoad * 120) / totalLoad;

            Console.WriteLine("{0:F2}", avrageLoad);
            Console.WriteLine("{0:F2}%", microbusLoad / totalLoad * 100);
            Console.WriteLine("{0:F2}%", truckLoad / totalLoad * 100);
            Console.WriteLine("{0:F2}%", trainLoad / totalLoad * 100);
        }
    }
}