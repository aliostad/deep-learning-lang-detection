package main

type Config struct {
  Broker Broker
  Controller Controller
  Doors []Door
}

type Broker struct {
  Hostname string
  Port int
  Username string
  Password string
  UpdateTopic string
  MetadataTopic string
  ControlTopic string
}

type Controller struct {
  Name string
  IsController bool
  LogLevel string
  Timezone string
}

type Door struct {
  Name string
  SensorPin int
  ControlPin int
}

func NewConfig() *Config {

  var broker Broker
  broker.Hostname = "localhost"
  broker.Port = 1883
  broker.Username = ""
  broker.Password = ""
  broker.UpdateTopic = "home/garage/door/update"
  broker.MetadataTopic = "home/garage/door/metadata"
  broker.ControlTopic = "home/garage/door/control"

  var controller Controller
  controller.Name = "GarageController"
  controller.IsController = true
  controller.LogLevel = "INFO"
  controller.Timezone = "UTC"

  doors := []Door{}

  return &Config{
    Broker: broker,
    Controller: controller,
    Doors: doors,
  }
}
