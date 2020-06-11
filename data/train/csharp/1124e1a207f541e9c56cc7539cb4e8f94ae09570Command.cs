using System.Collections.Generic;

public abstract class Command : ICommand
{
    private IList<string> arguments;
    private IHarvesterController harvesterController;
    private IProviderController providerController;

    public Command(IList<string> arguments, IHarvesterController harvesterController, IProviderController providerController)
    {
        this.arguments = arguments;
        this.harvesterController = harvesterController;
        this.providerController = providerController;
    }

    protected IHarvesterController HarvesterController => this.harvesterController;

    protected IProviderController ProviderController => this.providerController;

    public IList<string> Arguments => this.arguments;

    public abstract string Execute();
}
