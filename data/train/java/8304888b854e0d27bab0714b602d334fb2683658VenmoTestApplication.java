import service.CardService;
import service.PaymentService;
import service.UserService;
import service.Venmo;
import tests.VenmoTest;

/**
 * Created by hbhaisare on 19/11/2016.
 */
public class VenmoTestApplication {

    /**
     * Venmo tests
     *
     * @param args
     */
    public static void main(String[] args) {

        UserService userService = new UserService();
        CardService cardService = new CardService();
        PaymentService paymentService = new PaymentService();
        Venmo venmo = new Venmo(userService, cardService, paymentService);
        VenmoTest venmoTest = new VenmoTest(venmo);

        venmoTest.run();
    }
}
