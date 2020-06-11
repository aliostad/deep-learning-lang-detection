package org.bimserver.cobie.shared.deserialization.cobietab.modelhandlers;

import org.bimserver.cobie.shared.deserialization.cobietab.COBieIfcModel;
import org.bimserver.emf.IfcModelInterfaceException;
import org.bimserver.emf.OidProvider;

public class IfcCommonHandler
{
    private IfcGuidHandler guidHandler;
    private GeometryHandler geometryHandler;
    private OwnerHistoryHandler ownerHistoryHandler;
    private PropertySetHandler propertySetHandler;
    private ClassificationHandler classificationHandler;
    private OidProvider<Long> oidHandler;
    private COBieIfcModel model;

    public IfcCommonHandler(COBieIfcModel cobieIfcmodel, OidProvider<Long> oidProvider) throws IfcModelInterfaceException
    {
        oidHandler = oidProvider;
        model = cobieIfcmodel;
        ownerHistoryHandler = new OwnerHistoryHandler(model, oidProvider);
        guidHandler = new IfcGuidHandler(model, oidProvider);
        classificationHandler = new ClassificationHandler(model, guidHandler, oidProvider, ownerHistoryHandler);
        propertySetHandler = new PropertySetHandler(model, oidProvider, guidHandler, ownerHistoryHandler);
        setGeometryHandler(new GeometryHandler(oidProvider, cobieIfcmodel, guidHandler));
    }

    public ClassificationHandler getClassificationHandler()
    {
        return classificationHandler;
    }

    public GeometryHandler getGeometryHandler()
    {
        return geometryHandler;
    }

    public IfcGuidHandler getGuidHandler()
    {
        return guidHandler;
    }

    public OidProvider<Long> getOidProvider()
    {
        return oidHandler;
    }

    public OwnerHistoryHandler getOwnerHistoryHandler()
    {
        return ownerHistoryHandler;
    }

    public PropertySetHandler getPropertySetHandler()
    {
        return propertySetHandler;
    }

    private void setGeometryHandler(GeometryHandler geometryHandler)
    {
        this.geometryHandler = geometryHandler;
    }

}
