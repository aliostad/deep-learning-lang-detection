package dagger

import "github.com/izumin5210/go-dagger/_example/instrument"

type CoffeeShop struct {
	provideHeaterProvider HeaterProvider
	thermosiphonProvider  ThermosiphonProvider
	providePumpProvider   PumpProvider
	coffeeMakerProvider   CoffeeMakerProvider
}

func buildCoffeeShop(builder *CoffeeShop_Builder) *CoffeeShop {
	coffeeShop := &CoffeeShop{}
	coffeeShop.provideHeaterProvider = &Heater_DoubleCheckProvider{
		provider: &DripCoffeeModule_ProvideHeaterFactory{
			module: builder.dripCoffeeModule,
		},
	}
	coffeeShop.thermosiphonProvider = &Thermosiphon_Factory{
		heaterProvider: coffeeShop.provideHeaterProvider,
	}
	coffeeShop.providePumpProvider = &Thermosiphon_Pump_Factory{
		thermosiphonProvider: coffeeShop.thermosiphonProvider,
	}
	coffeeShop.coffeeMakerProvider = &CoffeeMaker_Factory{
		heaterProvider: coffeeShop.provideHeaterProvider,
		pumpProvider:   coffeeShop.providePumpProvider,
	}
	return coffeeShop
}

func (c *CoffeeShop) Maker() *instrument.CoffeeMaker {
	return &instrument.CoffeeMaker{
		Heater: c.provideHeaterProvider.Get(),
		Pump:   c.providePumpProvider.Get(),
	}
}

type CoffeeShop_Builder struct {
	dripCoffeeModule *instrument.DripCoffeeModule
}

func (b *CoffeeShop_Builder) Build() instrument.CoffeeShop {
	if b.dripCoffeeModule == nil {
		b.dripCoffeeModule = &instrument.DripCoffeeModule{}
	}
	return buildCoffeeShop(b)
}

func (b *CoffeeShop_Builder) DripCoffeeModule(dripCoffeeModule *instrument.DripCoffeeModule) *CoffeeShop_Builder {
	b.dripCoffeeModule = dripCoffeeModule
	return b
}
