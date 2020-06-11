package com.demo.partern.responsibilityChain;

/**
 * 责任链模式
 * 报销流程,项目经理<部门经理<总经理
 * 其中项目经理报销额度不能大于500,则部门经理的报销额度是不大于1000,超过1000则需要总经理审核
 * 
 */
public class GeneralHandler extends ConsumeHandler {
    @Override
    public void doHandler(String user, double free) {
        if (free >= 1000) {
            if (user.equals("lwxzy")) {
                System.out.println("给予报销:" + free);
            } else {
                System.out.println("报销不通过");
            }
        } else {
            if (getNextHandler() != null) {
                getNextHandler().doHandler(user, free);
            }
        }

    }

    public static void main(String[] args) {
        ProjectHandler projectHandler = new ProjectHandler();
        DeptHandler deptHandler = new DeptHandler();
        GeneralHandler generalHandler = new GeneralHandler();
        projectHandler.setNextHandler(deptHandler);
        deptHandler.setNextHandler(generalHandler);

        projectHandler.doHandler("lwx", 450);
        projectHandler.doHandler("lwx", 600);
        projectHandler.doHandler("zy", 600);
        projectHandler.doHandler("zy", 1500);
        projectHandler.doHandler("lwxzy", 1500);
    }
}
