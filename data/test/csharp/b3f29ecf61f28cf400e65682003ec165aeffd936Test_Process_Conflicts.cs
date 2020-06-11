using System;
using System.Collections.Generic;
using Xunit;
using Common_Topics;

namespace test_ctci
{
    public class Test_Process_Conflicts
    {
        [Fact]
        public void FindConflicts()
        {
            Greedy_Process process1 = new Greedy_Process(1, 512, 1, Greedy_Process.Read);
            Greedy_Process process2 = new Greedy_Process(2, 432, 2, Greedy_Process.Write);
            Greedy_Process process3 = new Greedy_Process(3, 512, 3, Greedy_Process.Read);
            Greedy_Process process4 = new Greedy_Process(4, 932, 4, Greedy_Process.Read);
            Greedy_Process process5 = new Greedy_Process(5, 512, 5, Greedy_Process.Write);
            Greedy_Process process6 = new Greedy_Process(6, 932, 6, Greedy_Process.Read);
            Greedy_Process process7 = new Greedy_Process(7, 835, 7, Greedy_Process.Read);
            Greedy_Process process8 = new Greedy_Process(8, 432, 8, Greedy_Process.Read);

            List<Tuple<Greedy_Process, Greedy_Process>> result = Process_Conflicts.FindConflicts(new Greedy_Process[] {
                process1, process2, process3, process4, process5, process6, process7, process8
            });

            Assert.Equal(2, result.Count);
            Assert.Equal(5, result[0].Item1.Id);
            Assert.Equal(3, result[0].Item2.Id);
            Assert.Equal(5, result[1].Item1.Id);
            Assert.Equal(1, result[1].Item2.Id);
        }
    }
}