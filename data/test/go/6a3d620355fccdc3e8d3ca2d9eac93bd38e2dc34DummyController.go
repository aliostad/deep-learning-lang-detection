package logic

import (
    "github.com/pip-services/pip-services-runtime-go"
    "github.com/pip-services/pip-services-runtime-go/logic"            
    "github.com/pip-services/pip-services-template-go/db"            
)

type DummyController struct {
    logic.AbstractController
}

func NewDummyController(config *runtime.DynamicMap) *DummyController {
    c := DummyController { AbstractController: *logic.NewAbstractController("Dummy.Controller", config) }
    return &c
}

func (c *DummyController) Init(refs *runtime.References) error {
    if err := c.AbstractController.Init(refs); err != nil { return err }
    
    if c.DB() == nil {
        return c.NewInternalError("Data access is not specified")
    } 
    
    return nil
}

func (c *DummyController) DB() db.IDummyDataAccess {
    return c.AbstractController.DB().(db.IDummyDataAccess)
}

func (c *DummyController) GetDummies(filter *runtime.FilterParams, paging *runtime.PagingParams) (*db.DummyDataPage, error) {
    timing := c.Instrument("Dummy.GetDummies")
    defer func() { timing.EndTiming() }()
    
    return c.DB().GetDummies(filter, paging)
}

func (c *DummyController) GetDummyById(dummyID string) (*db.Dummy, error) {
    timing := c.Instrument("Dummy.GetDummyById")
    defer func() { timing.EndTiming() }()
    
    return c.DB().GetDummyById(dummyID)
}

func (c *DummyController) CreateDummy(dummy *db.Dummy) (*db.Dummy, error) {
    timing := c.Instrument("Dummy.CreateDummy")
    defer func() { timing.EndTiming() }()
    
    return c.DB().CreateDummy(dummy)
}

func (c *DummyController) UpdateDummy(dummyID string, dummy *runtime.DynamicMap) (*db.Dummy, error) {
    timing := c.Instrument("Dummy.UpdateDummy")
    defer func() { timing.EndTiming() }()
    
    return c.DB().UpdateDummy(dummyID, dummy)
}

func (c *DummyController) DeleteDummy(dummyID string) error {
    timing := c.Instrument("Dummy.DeleteDummy")
    defer func() { timing.EndTiming() }()
    
    return c.DB().DeleteDummy(dummyID)
}
