package controllers

import (
	"github.com/rmn87/m-cute/models"
	"github.com/labstack/echo"
	"net/http"
	"gopkg.in/mgo.v2/bson"
	"fmt"
)

func ListBrokers(c echo.Context) error {
	brokers, err := models.GetBrokers()
	if err != nil {
		fmt.Println(err)
		return c.Render(http.StatusOK, "base", nil)
	}

	return c.JSON(http.StatusOK, brokers)
}

func CreateBroker(c echo.Context) error {
	broker := &models.Broker{}
	if err := c.Bind(broker); err != nil {
		return err
	}
	broker.Save()
	return c.JSON(http.StatusOK, broker)
}

func UpdateBroker(c echo.Context) error {
	id := c.Param("id")
	broker := &models.Broker{}
	if err := c.Bind(broker); err != nil {
		return err
	}
	broker.Id = bson.ObjectIdHex(id)
	broker.Save()
	return c.JSON(http.StatusOK, broker)
}

func DeleteBroker(c echo.Context) error {
	id := c.Param("id")
	models.DeleteBrokerById(id)
	return c.JSON(http.StatusOK, &models.Status{true})
}