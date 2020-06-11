package bp.model.data;

public class SubProcess extends Activity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
    private Process process;

    public SubProcess(final String uniqueName) {
        super(uniqueName);
    }

    public SubProcess() {
		super();
	}

	public Process getProcess() {
        return this.process;
    }

    public void setProcess(final Process process) {
        this.process = process;
    }

    @Override
    protected void initializeDetails() {
        // TODO Auto-generated method stub

    }

    @Override
    protected void initializeComponent() {
        // TODO Auto-generated method stub

    }

}
