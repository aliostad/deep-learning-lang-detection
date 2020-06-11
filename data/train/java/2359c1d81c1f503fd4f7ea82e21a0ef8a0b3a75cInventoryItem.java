/**
 * 
 */
package com.pfe.crm.domain.entity;

import com.pfe.crm.core.domain.BaseEntity;

/**
 * Item
 * 
 * An inventory item (e.g. fire extinguisher, hose, etc.).
 * 
 * @author Ben Northrop
 * 
 */
public class InventoryItem extends BaseEntity
{

    private Service service;

    /**
     * @return Returns the service.
     */
    public Service getService()
    {
        return service;
    }

    /**
     * @param service
     *            The service to set.
     */
    public void setService(Service service)
    {
        this.service = service;
    }

}
