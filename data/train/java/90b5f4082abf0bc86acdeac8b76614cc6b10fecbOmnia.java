package omnia;

import omnia.db.DbHandler;
import omnia.snmp.SnmpPluginHandler;

/**
 * 
 * @author Marcus Hoff <marcus.hoff@ring2.dk>
 */
public class Omnia {

    public static Thread collector;
    public static ConfigurationHandler configurationHandler;
    public static DbHandler dbHandler;
    public static SnmpPluginHandler snmpPluginHandler;

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        configurationHandler = new ConfigurationHandler();
        dbHandler = new DbHandler();
        snmpPluginHandler = new SnmpPluginHandler();
        collector = new Thread(new Collector());
        collector.start();

    }
}
