package io.business;

import io.business.processes.BusinessProcessHelper;
import io.business.properties.Type;

/**
 * Helper class to run some tests.
 * @author zerodi
 */
public class Runner {


    public static void main(String[] args) {
        PaymentProcessor paymentProcessor = new PaymentProcessor();
        paymentProcessor.addBusinessProcess(BusinessProcessHelper.firstProcess());
        paymentProcessor.addBusinessProcess(BusinessProcessHelper.secondProcess());
        paymentProcessor.addBusinessProcess(BusinessProcessHelper.thirdProcess());
        paymentProcessor.addBusinessProcess(BusinessProcessHelper.fourthProcess());
        paymentProcessor.addBusinessProcess(BusinessProcessHelper.fifthProcessA());
        paymentProcessor.addBusinessProcess(BusinessProcessHelper.fifthProcessB());
        paymentProcessor.addBusinessProcess(BusinessProcessHelper.sixthProcess());
        paymentProcessor.addBusinessProcess(BusinessProcessHelper.seventhProcessA());
        paymentProcessor.addBusinessProcess(BusinessProcessHelper.seventhProcessB());

        Payment payment = new Payment(new Product()
                .withProperties(
                        new Type("Membership")

                ), Reason.PAYMENT);

        paymentProcessor.process(payment);
    }
}
