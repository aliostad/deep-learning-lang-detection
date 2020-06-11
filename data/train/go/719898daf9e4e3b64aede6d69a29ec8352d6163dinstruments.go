package main

import (
	"log"

	"github.com/gin-gonic/gin"
)

// Instrument present a chirurgical instrument
type Instrument struct {
	Ref  string `db:"ref" json:"ref"`
	Name string `db:"name" json:"name"`
}

// GetInstruments return all the instruments we have
func (env *Env) GetInstruments(c *gin.Context) {
	type Instruments []Instrument
	var instruments Instruments
	_, err := env.dbmap.Select(&instruments, "SELECT * FROM instrument")
	if err != nil {
		c.JSON(404, gin.H{"error": "no intrument(s) into the table"})
	} else {
		c.JSON(200, instruments)
	}
}

//GetInstrumentBoxes return the boxes that contain the instrument
func (env *Env) GetInstrumentBoxes(c *gin.Context) {
	id := c.Params.ByName("id")
	type InstrumentBox struct {
		Name     string `json:"name"`
		Quantity string `json:"quantity"`
		Missing  string `json:"missing"`
	}
	type InstrumentBoxes []InstrumentBox
	var boxes InstrumentBoxes
	_, err := env.dbmap.Select(&boxes, "SELECT box.name, box_composition.quantity, box_composition.missing FROM box_composition  INNER JOIN box ON box_composition.boxid=box.registration_number AND box_composition.instrumentid=?", id)
	if err != nil {
		log.Println(err)
		c.JSON(404, gin.H{"error": "no intrument(s) into the table"})
	} else {
		c.JSON(200, boxes)
	}
}

//CreateInstrument add an instrument in the databse
func (env *Env) CreateInstrument(c *gin.Context) {
	var instrument Instrument
	c.Bind(&instrument)
	if instrument.Name == "" || instrument.Ref == "" {
		c.JSON(422, gin.H{"error": "fields are empty"})
	} else {
		err := env.dbmap.Insert(&instrument)
		if err != nil {
			log.Println(err)
			c.JSON(500, "Insert failed")
		} else {
			c.JSON(201, "Insert successful")
		}
	}
}

// curl -i -X POST -H "Content-Type: application/json" -d '{"name":"bisoutri", "ref":"refbisout"}' http://localhost:5000/api/v1/instruments
