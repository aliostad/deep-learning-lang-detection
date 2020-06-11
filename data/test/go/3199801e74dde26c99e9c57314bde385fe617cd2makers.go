package main

import (
	"math/rand"
	"time"
)

func NewCartMaker(f float64) NetMaker {
	//return AliveCartMaker{f: f, p: 0.666666666666}
	return AliveCartMaker{f: f, p: 0}
	//return HoleCartMaker{f: f, nholes: 10, hsize: 3}
}

type HoleCartMaker struct {
	f      float64
	nholes int
	hsize  int
}

func (h HoleCartMaker) Make(n int, f float64) Net {
	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	net := Net{neurons: make([][]Neuron, n, n)}
	for i := 0; i < n; i++ {
		net.neurons[i] = make([]Neuron, n, n)
		for j := 0; j < n; j++ {
			net.neurons[i][j] = Neuron{
				alive:     true,
				firing:    false,
				net:       net,
				potential: 0.5,
				x:         i,
				y:         j,
			}
			if r.Float64() < h.f {
				net.neurons[i][j].firing = true
			}
		}
	}

	xmod := len(net.neurons)
	for i := 0; i < h.nholes; i++ {
		x, y := r.Int()%n, r.Int()%n
		for xx := 0; xx < h.hsize; xx += 1 {
			xidx := (x + xx) % xmod
			ymod := len(net.neurons[xidx])
			for yy := 0; yy < h.hsize; yy += 1 {
				yidx := (y + yy) % ymod
				net.neurons[xidx][yidx].alive = false
				net.neurons[xidx][yidx].potential = 0
			}
		}
	}

	return net
}

type CartMaker struct {
	f float64
}

func (cm CartMaker) Make(n int, f float64) Net {
	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	net := Net{neurons: make([][]Neuron, n, n)}
	for i := 0; i < n; i++ {
		net.neurons[i] = make([]Neuron, n, n)
		for j := 0; j < n; j++ {
			net.neurons[i][j] = Neuron{
				alive:     true,
				firing:    false,
				net:       net,
				potential: 0.5,
				x:         i,
				y:         j,
			}
			if r.Float64() < cm.f {
				net.neurons[i][j].firing = true
			}
		}
	}
	return net
}

type AliveCartMaker struct {
	f float64
	p float64
}

func (cm AliveCartMaker) Make(n int, f float64) Net {
	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	net := Net{neurons: make([][]Neuron, n, n)}
	for i := 0; i < n; i++ {
		net.neurons[i] = make([]Neuron, n, n)
		for j := 0; j < n; j++ {
			net.neurons[i][j] = Neuron{
				alive:     true,
				firing:    false,
				net:       net,
				potential: 0.5,
				x:         i,
				y:         j,
			}
			if r.Float64() < cm.f {
				net.neurons[i][j].firing = true
			}
			if r.Float64() < cm.p {
				net.neurons[i][j].alive = false
				net.neurons[i][j].potential = 0
			}
		}
	}
	return net
}
