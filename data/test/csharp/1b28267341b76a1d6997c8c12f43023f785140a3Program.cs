using System;
using System.Collections.Generic;
using Autofac;

namespace ProcessStateMachineStub
{
    class Program
    {
        static void Main(string[] args)
        {
            var container = ContainerFactory.Create();
            var processExecuter = container.Resolve<ProcessExecuterBase>();

            var process = new Process("Parent")
                {
                    Children = new List<Process>()
                        {
                            new Process("Child 1", true),
                            new Process("Child 2")
                        }
                };

            processExecuter.Execute(process);
            processExecuter.Execute(process);
            processExecuter.Execute(process);

            Console.ReadLine();
        }
    }
}
