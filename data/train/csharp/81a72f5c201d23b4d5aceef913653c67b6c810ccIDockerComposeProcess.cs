namespace IDockerComposeProcess
{
    using Models;
    using Results;

    public interface IDockerComposeProcess
    {
        IDockerComposeProcessResult Build(IDockerComposeProcessModel dockerComposeProcessModel);

        IDockerComposeProcessResult Config(IDockerComposeProcessModel dockerComposeProcessModel);

        IDockerComposeProcessResult Create(IDockerComposeProcessModel dockerComposeProcessModel);

        IDockerComposeProcessResult Down(IDockerComposeProcessModel dockerComposeProcessModel);

        IDockerComposeProcessResult Events(IDockerComposeProcessModel dockerComposeProcessModel);

        IDockerComposeProcessResult Help(IDockerComposeProcessModel dockerComposeProcessModel);

        IDockerComposeProcessResult Kill(IDockerComposeProcessModel dockerComposeProcessModel);

        IDockerComposeProcessResult Logs(IDockerComposeProcessModel dockerComposeProcessModel);

        IDockerComposeProcessResult Pause(IDockerComposeProcessModel dockerComposeProcessModel);

        IDockerComposeProcessResult Port(IDockerComposeProcessModel dockerComposeProcessModel);

        IDockerComposeProcessResult ListContainers(IDockerComposeProcessModel dockerComposeProcessModel);

        IDockerComposeProcessResult Pull(IDockerComposeProcessModel dockerComposeProcessModel);

        IDockerComposeProcessResult Restart(IDockerComposeProcessModel dockerComposeProcessModel);

        IDockerComposeProcessResult RemoveContainer(IDockerComposeProcessModel dockerComposeProcessModel);

        IDockerComposeProcessResult Run(IDockerComposeProcessModel dockerComposeProcessModel);

        IDockerComposeProcessResult Scale(IDockerComposeProcessModel dockerComposeProcessModel);

        IDockerComposeProcessResult Start(IDockerComposeProcessModel dockerComposeProcessModel);

        IDockerComposeProcessResult Stop(IDockerComposeProcessModel dockerComposeProcessModel);

        IDockerComposeProcessResult Unpause(IDockerComposeProcessModel dockerComposeProcessModel);

        IDockerComposeProcessResult Up(IDockerComposeProcessModel dockerComposeProcessModel);

        IDockerComposeProcessResult Version(IDockerComposeProcessModel dockerComposeProcessModel);
    }
}
