/**
 *
 */
package uk.co.tui.manage.viewdata;

import java.util.HashMap;
import java.util.Map;


/**
 * @author veena.pn
 *
 */
public class ManageHomePageStaticContentViewData
{

    /** The extra content map. */
    private Map<String, String> manageHomePageContentMap = new HashMap<String, String>();


    /**
     * Puts all the manageHomePageContentMap content.
     */
    public Map<String, String> getManageHomePageContentMap()
    {
        return manageHomePageContentMap;
    }




    /**
     * @param manageHomePageContentMap
     *           the manageHomePageContentMap to set
     */
    public void setManageHomePageContentMap(final Map<String, String> manageHomePageContentMap)
    {
        this.manageHomePageContentMap = manageHomePageContentMap;
    }




}