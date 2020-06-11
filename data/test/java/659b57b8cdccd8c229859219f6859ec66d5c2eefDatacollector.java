package jvs_TESTS;

import javax.jws.WebService;

/**
 *
 * @author vincent
 */

@WebService(endpointInterface = "jvs_TESTS.IDatacollector")
public class Datacollector implements IDatacollector
{
    private String[] processList;
    
    public void printProcessNames()
    {
        for( String process : processList)
        {
            System.out.println(process);
        }
    }

    @Override
    public void setProcessNames(String[] processList)
    {
        this.processList = processList;
        printProcessNames();
    }
    
}
