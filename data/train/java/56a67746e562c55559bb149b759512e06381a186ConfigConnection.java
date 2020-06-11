package vn.javaweb.real.estate.model;

import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import vn.javaweb.real.estate.manage.AccountModelManage;
import vn.javaweb.real.estate.manage.BuyLandModelManage;
import vn.javaweb.real.estate.manage.InvoiceTransactionModelManage;
import vn.javaweb.real.estate.manage.PaymentModeModelManage;
import vn.javaweb.real.estate.manage.PersonModelManage;
import vn.javaweb.real.estate.manage.ProfileLandModelManage;
import vn.javaweb.real.estate.manage.RegionalPriceModelManage;

/**
 * @dateCreate 25/08/2015
 * @authorBy PhanAnh
 */
public class ConfigConnection {
    
    private static ConfigConnection instance;
    private final RegionalPriceModelManage regionalPriceModelManage;
    private final ProfileLandModelManage profileLandModelManage;
    private final PaymentModeModelManage paymentModeModelManage;
    private final AccountModelManage accountModelManage;
    private final PersonModelManage personModelManage;
    private final InvoiceTransactionModelManage invoiceTransactionModelManage;
    private final BuyLandModelManage buyLandModelManage;
    
    public static String PERSISTENCE_UNIT_NAME = "HousingPU";

    public ConfigConnection() {
        System.out.println("--------------------------------------");
        System.out.println("................LOADING...............");
        EntityManagerFactory emf = Persistence.createEntityManagerFactory(PERSISTENCE_UNIT_NAME);
        profileLandModelManage = new ProfileLandModelManage(emf);
        regionalPriceModelManage = new RegionalPriceModelManage(emf);
        paymentModeModelManage = new PaymentModeModelManage(emf);
        accountModelManage = new AccountModelManage(emf);
        personModelManage = new PersonModelManage(emf);
        invoiceTransactionModelManage = new InvoiceTransactionModelManage(emf);
        buyLandModelManage = new BuyLandModelManage(emf);
        System.out.println(".......MANAGE MODEL OPEN SUCSESS......");
        System.out.println("--------------------------------------");
    }
    
    public static ConfigConnection getInstance(){
        if(instance == null)
            instance = new ConfigConnection();
        return instance;
    }
    
    public ProfileLandModelManage getProfileLandModelManage(){
        return profileLandModelManage;
    }

    public RegionalPriceModelManage getRegionalPriceModelManage() {
        return regionalPriceModelManage;
    }

    public PaymentModeModelManage getPaymentModeModelManage() {
        return paymentModeModelManage;
    }

    public AccountModelManage getAccountModelManage() {
        return accountModelManage;
    }

    public PersonModelManage getPersonModelManage() {
        return personModelManage;
    }

    public InvoiceTransactionModelManage getInvoiceTransactionModelManage() {
        return invoiceTransactionModelManage;
    }

    public BuyLandModelManage getBuyLandModelManage() {
        return buyLandModelManage;
    }
    
}
