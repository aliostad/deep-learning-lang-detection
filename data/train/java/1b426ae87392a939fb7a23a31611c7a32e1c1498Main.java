package es.upm.miw.pd.doo.polymorphism.colecciones.operaciones;

public class Main {

    public static void main(String[] args) {
        OperationHandler operationHandler = new OperationHandler();
        operationHandler.add(new Summation(3, 4));

        System.out.println("Total1:" + operationHandler.total());

        operationHandler.add(new Subtraction(1, 1));
        operationHandler.add(new Summation(3, 5));
        operationHandler.add(new Subtraction(4, 1));
        operationHandler.add(new Summation(3, 6));
        operationHandler.add(new Subtraction(3, 2));
        System.out.println("Total2:" + operationHandler.total());
        operationHandler.add(new Multiplication(2, 1));
        System.out.println("Total3:" + operationHandler.total());
    }

}
