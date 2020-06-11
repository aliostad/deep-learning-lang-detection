using Machine.Fakes;
using Machine.Specifications;
using System.Threading;

namespace LongRunningProcess.Tests.Process
{
    [Subject(typeof(LongRunningProcess.Process))]
    public class When_duration_is_default
    {
        Establish Context = () => Process = new LongRunningProcess.Process(string.Empty, null);

        It Should_be_indeterminate_by_default = () => Process.DurationType.ShouldEqual(ProcessDurationType.Indeterminate);

        static IProcess Process;
    }

    [Subject(typeof(LongRunningProcess.Process))]
    public class When_duration_is_set
    {
        Establish Context = () => Process = new LongRunningProcess.Process(string.Empty, null);

        Because Of = () => Process.DurationType = ProcessDurationType.Determinate;

        It Should_be_determinate = () => Process.DurationType.ShouldEqual(ProcessDurationType.Determinate);

        static IProcess Process;
    }

    [Subject(typeof(LongRunningProcess.Process))]
    public class When_process_is_over_100_but_not_complete
    {
        Establish Context = () =>
        {
            Process = new LongRunningProcess.Process(string.Empty, null);
            Process.DurationType = ProcessDurationType.Determinate;
        };

        Because Of = () => Process.Report(101);

        It Should_become_indeterminate = () => Process.DurationType.ShouldEqual(ProcessDurationType.Indeterminate);

        static IProcess Process;
    }

    [Subject(typeof(LongRunningProcess.Process))]
    public class When_process_is_over_100_but_complete
    {
        Establish Context = () =>
        {
            Process = new LongRunningProcess.Process(string.Empty, null);
            Process.DurationType = ProcessDurationType.Determinate;
            Process.Completed = true;
        };

        Because Of = () => Process.Report(101);

        It Should_be_determinate = () => Process.DurationType.ShouldEqual(ProcessDurationType.Determinate);

        static IProcess Process;
    }

    [Subject(typeof(LongRunningProcess.Process))]
    public class When_children_exceed_100_weighting : WithFakes
    {
        Establish Context = () =>
        {
            Factory = An<IProcessFactory>();

            Process = new LongRunningProcess.Process(string.Empty, Factory);
            Process.DurationType = ProcessDurationType.Determinate;

            Child = An<IProcess>();
            Child.WhenToldTo(c => c.OverallProgress).Return(50);
            Child.WhenToldTo(c => c.OverallStatus).Return(new[] { string.Empty });

            Factory.WhenToldTo(c => c.Create(Param<string>.IsAnything, Param<CancellationTokenSource>.IsAnything)).Return(Child);
        };

        Because Of = () =>
        {
            Process.Step(string.Empty, 50);
            Process.Step(string.Empty, 51);
        };

        It Should_become_indeterminate = () => Process.DurationType.ShouldEqual(ProcessDurationType.Indeterminate);

        static IProcessFactory Factory;

        static IProcess Process;

        static IProcess Child;
    }
}
