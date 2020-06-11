package info.hexin.designpattern.behavioral.chainofresponsibility;

public class Main {
    public static void main(String[] args) {
        DinnerRequest request1 = new DinnerRequest(100);
        DinnerRequest request2 = new DinnerRequest(400);
        DinnerRequest request3 = new DinnerRequest(600);

        Handler projectHandler = new ProjectHandler();
        Handler deptHandler = new DeptHandler();
        Handler bossHandler = new BossHandler();

        projectHandler.setNext(deptHandler);
        deptHandler.setNext(bossHandler);

        projectHandler.handleRequest(request1);
        projectHandler.handleRequest(request2);
        projectHandler.handleRequest(request3);
    }
}
