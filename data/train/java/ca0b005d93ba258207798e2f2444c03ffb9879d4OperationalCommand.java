package behavioral.designPattern.command;

public class OperationalCommand implements Command{

	private Service service;


	@Override
	public void execute(Service service) {
		System.out.println("Service start execution");
		if(service != null){
			service.initService();
			this.service = service;
		}else{
			// default execution
			this.service = new DefaultService("Default Service");
			this.service.initService();
		}
	}

	@Override
	public void undo() {

		if(this.service != null){
			// previous state
			this.service.previousState();
		}
	}

}
