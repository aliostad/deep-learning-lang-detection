package alpaca.mock;

public class MissingDependencyException extends RuntimeException {
	private static final long serialVersionUID = -5776605327041473370L;

	public final ServiceIdentifier service;
	public final ServiceIdentifier missingService;
	
	public MissingDependencyException(
		ServiceIdentifier service,
		ServiceIdentifier missingService
	) {
		super(String.format(
			"Missing dependency in service %s: %s",
			service,
			missingService
		));
		this.service = service;
		this.missingService = missingService;
	}
}
