/*
 * gonn - Super simple neural network in go
 *
 */

package main

import (
    "fmt"
    "math"
    "math/rand"
    "time"
)

type NN struct {
    // Number of input, hidden, and output nodes.
    ni  int
    nh  int
    no  int

    // Activations for nodes.
    ai  []float64
    ah  []float64
    ao  []float64

    // Weights.
    wi  [][]float64
    wo  [][]float64

    // Last change in weights for momentum. FIXME: ??
    ci  [][]float64
    co  [][]float64
}

//FIXME: For debug only:
func (net *NN) Pprint() {
    fmt.Println("ni:", net.ni)
    fmt.Println("nh:", net.nh)
    fmt.Println("no:", net.no)

    fmt.Println("ai:", net.ai)
    fmt.Println("ah:", net.ah)
    fmt.Println("ao:", net.ao)

    fmt.Println("wi:", net.wi)
    fmt.Println("wo:", net.wo)

    fmt.Println("ci:", net.ci)
    fmt.Println("co:", net.co)
}

type TrainingDataElement struct {
    input  []float64
    output []float64
}

type DataElement struct {
    input []float64
}

func Create(ni, nh, no int) *NN {
    // Initialize network.
    net := NN{ni: ni + 1, nh: nh, no: no}

    // Initialize activations to [1.0 1.0 1.0 ...]
    net.ai, net.ah, net.ao = makeSlice(net.ni, 1.0), makeSlice(net.nh, 1.0), makeSlice(net.no, 1.0)

    // Create weights...
    net.wi, net.wo = makeMatrix(net.ni, net.nh, 0.0), makeMatrix(net.nh, net.no, 0.0)

    // ...and set them to random values. FIXME: Extract?
    for i := 0; i < net.ni; i++ {
        for j := 0; j < net.nh; j++ {
            net.wi[i][j] = randInRange(-0.2, 0.2)
        }
    }
    for i := 0; i < net.nh; i++ {
        for j := 0; j < net.no; j++ {
            net.wo[i][j] = randInRange(-2.0, 2.0)
        }
    }

    // FIXME: What are these used for?
    net.ci, net.co = makeMatrix(net.ni, net.nh, 0.0), makeMatrix(net.nh, net.no, 0.0)

    return &net
}

func (net *NN) Train(data []TrainingDataElement, iterations int, R, M float64) {
    // R: Learning rate
    // M: Momentum factor
    // TODO: Instead of iterations, wait for equilibrium.
    for i := 1; i <= iterations; i++ {
        err := 0.0
        for j := range data {
            net.update(data[j].input)
            err = err + net.backPropagate(data[j].output, R, M)
        }
    }
}

func (net *NN) Test(data []DataElement) [][]float64 {
    out := make([][]float64, len(data))
    for i := range data {
        out[i] = net.update(data[i].input)
    }

    return out
}

func (net *NN) update(input []float64) []float64 {
    // Input activations.
    for i := 0; i < net.ni-1; i++ { //TODO What is bias mode?
        net.ai[i] = input[i]
    }

    // Hidden layer activations.
    for i := 0; i < net.nh; i++ {
        sum := 0.0
        for j := 0; j < net.ni; j++ {
            sum = sum + net.ai[j]*net.wi[j][i]
        }
        net.ah[i] = sigmoid(sum)
    }

    // Output activations.
    for i := 0; i < net.no; i++ {
        sum := 0.0
        for j := 0; j < net.nh; j++ {
            sum = sum + net.ah[j]*net.wo[j][i]
        }
        net.ao[i] = sigmoid(sum)
    }

    output := make([]float64, len(net.ao))
    copy(output, net.ao)
    return output
}

func (net *NN) backPropagate(output []float64, R, M float64) float64 {
    // Calculate error for output.
    output_deltas := makeSlice(net.no, 0.0)
    for i := 0; i < net.no; i++ {
        err := output[i] - net.ao[i]
        output_deltas[i] = dsigmoid(net.ao[i]) * err
    }

    // Calculate error for hidden layer.
    hidden_deltas := makeSlice(net.nh, 0.0)
    for i := 0; i < net.nh; i++ {
        err := 0.0
        for j := 0; j < net.no; j++ {
            err = err + output_deltas[j]*net.wo[i][j]
        }
        hidden_deltas[i] = dsigmoid(net.ah[i]) * err
    }

    // Update output weights.
    for i := 0; i < net.nh; i++ {
        for j := 0; j < net.no; j++ {
            change := output_deltas[j] * net.ah[i]
            net.wo[i][j] = net.wo[i][j] + R*change + M*net.co[i][j]
            net.co[i][j] = change
        }
    }

    // Update input weights.
    for i := 0; i < net.ni; i++ {
        for j := 0; j < net.nh; j++ {
            change := hidden_deltas[j] * net.ai[i]
            net.wi[i][j] = net.wi[i][j] + R*change + M*net.ci[i][j]
            net.ci[i][j] = change
        }
    }

    // Calculate error.
    err := 0.0
    for i := 0; i < len(output); i++ {
        err += 0.5 * math.Pow((output[i]-net.ao[i]), 2)
    }
    return err
}

func sigmoid(x float64) float64 {
    return math.Tanh(x)
}

func dsigmoid(x float64) float64 {
    return (1.0 - math.Pow(x, 2))
}

// Utility functions. TODO: See if some of these are found in stdlib.
func makeSlice(size int, fill float64) []float64 {
    slice := make([]float64, size)
    for i := range slice {
        slice[i] = fill
    }
    return slice
}

func makeMatrix(x, y int, fill float64) [][]float64 {
    matrix := make([][]float64, x)
    for i := range matrix {
        matrix[i] = makeSlice(y, fill)
    }
    return matrix
}

func randInRange(lower, upper float64) float64 {
    rand.Seed(time.Now().UnixNano())
    return (rand.Float64()*(math.Abs(lower)+upper) - math.Abs(lower))
}
