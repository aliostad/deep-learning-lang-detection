package dip.cbuu.processes;




public class MyProcess {
	private static MyProcess instance = null;
//	public QuantizationProcess qp = null;
//    public ScalingProcess sp = null;
//    public GradientProcess gp = null;
    public HistogramProcess histogramProcess = null;
    public PatchExtraction patchExtraction = null;
    public SpatialFiltering spatialFiltering = null;
    public FourierProcess fourierProcess = null;

	public static MyProcess getInstance() {
		if (instance==null) {
			instance = new MyProcess();
		}
		return instance;
	}
	
	public MyProcess() {
		initTool();
	}
	
	private void initTool(){
//    	qp = new QuantizationProcess();
//    	sp = new ScalingProcess();
//    	gp = new GradientProcess();
		fourierProcess = new FourierProcess();
    	histogramProcess = new HistogramProcess();
    	patchExtraction = new PatchExtraction();
    	spatialFiltering = new SpatialFiltering();
    }
}
