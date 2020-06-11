package springpractice;

public class SampleServiceIntegrator {
    private SampleService serviceOne;
    private SampleService serviceTwo;

    public void initialize(){
        System.out.println("SampleServiceIntegrator is being initialized");
    }

    public SampleServiceIntegrator(SampleService serviceOne, SampleService serviceTwo) {
        this.serviceOne = serviceOne;
        this.serviceTwo = serviceTwo;
    }

    public void integrateServices(){
        serviceOne.giveService();
        serviceTwo.giveService();
    }
}
