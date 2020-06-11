package framework.commanding;

public class CloningCommandHandlerFactory<TCommand extends ICommand, TCommandHandler extends ICommandHandler<TCommand>> implements ICommandHandlerFactory<TCommand>
{
	// dependency
	private final ICloneable<TCommandHandler> cloneableCommandHandler;
	
	public CloningCommandHandlerFactory(ICloneable<TCommandHandler> cloneableCommandHandler)
	{
		// inject dependency
		if (cloneableCommandHandler == null)
		{
			throw new NullPointerException("cloneableCommandHandler is null");
		}
		
		this.cloneableCommandHandler = cloneableCommandHandler;
	}
	
	@Override
	public ICommandHandler<TCommand> createCommandHandler()
	{
		return this.cloneableCommandHandler.clone();
	}
}
