package main

import ()

type Net struct {
    Layers [][]*Node
}

func NewNet() (net *Net) {
    net = &Net{
        Layers: make([][]Node, 0),
    }

    return net
}

func (net *Net) AddLayer(size int) (layer []*Node) {
    parentLayer := nil
    if len(net.Layers) > 0 {
        parentLayer = net.Layers[len(net.Layers)-1]
    }

    layer = make([]Node, size)

    for i := 0; i < size; i++ {
        layer[i] = NewNode(parentLayer)
    }

    net.Layers = append(net.Layers, layer)
    return layer
}

func (net *Net) Propagate(inputs []byte, outputs []byte) {
    inputLayer := net.Layers[0]
    for i, input := range inputs {
        inputLayer[i].Value = float64(input) / 255.0
    }

    for _, layer := range net.Layers[1:] {
        c := make(chan bool)

        for _, node := range layer {
            go node.Calculate()
        }

        for i := 0; i < len(layer); i++ {
            <-c
        }
    }

    outputLayer := net.Layers[len(net.Layers)-1]

    for i, node := range outputLayer {
        outputs[i] = byte(node.Value * 255.0)
    }

    return outputs
}

func (net *Net) Fill(genome Genome) {
    ch := make(chan float64)
    done := make(chan bool)

    go genome.Pump(ch, done)

    for _, layer := range net.Layers[1:] {
        for _, node := range layer {
            node.Fill(ch)
        }
    }

    done <- true
}
