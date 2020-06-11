package me.sudohippie.designpattern.behavioral.chainofresponsibility;

/**
 * Raghav Sidhanti
 * 9/13/13
 */
public class Client {
    public static void main(String[] args){
        Command temperature = new Command("The temperature is", "temperature");
        Command humidity = new Command("The humidity is", "humidity");
        Command pressure = new Command("The pressure is", "pressure");

        // build chain
        Handler nullHandler = new NullHandler(null);
        Handler temperatureHandler = new TemperatureHandler(nullHandler);
        Handler humidityHandler = new HumidityHandler(temperatureHandler);

        humidityHandler.handle(temperature);
        humidityHandler.handle(humidity);
        humidityHandler.handle(pressure);
    }
}
