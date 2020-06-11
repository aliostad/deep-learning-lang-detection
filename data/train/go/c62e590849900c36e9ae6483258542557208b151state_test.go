package brain

import (
    "fmt"
    "testing"
)

var TEST_NETWORK_SIZE = [3]int{12, 25, 25}

func TestState(t *testing.T) {
    testingNet := MakeNetwork(TEST_NETWORK_SIZE, false)
    testingNet.Connect()
    testingNet.Mirror()
    testingNet.ConnectHemispheres()

    testingNet.CreateSensor("eye", 1, 9, "y", [3]int{8, 0, 12}, 2, func(nodes []*Node, influences map[string]*Output) {
        for _, node := range nodes {
            node.Value = 1
        }
    })

    // this is to make sure adding/removing connections works
    for i := 0; i < 100; i++ {
        testingNet.Cycle()
    }

    testingNet.SaveState("test", ".")
    loadedNet := LoadState("test", ".")
    fmt.Println("Finished loading state.")
    same := Test(testingNet, loadedNet)
    if !same {
        t.Error("Loaded state did not match original state.")
    }
}

func BenchmarkBuildNet(b *testing.B) {
    for i := 0; i < b.N; i++ {
        testingNet := MakeNetwork(TEST_NETWORK_SIZE, false)
        testingNet.Connect()
        testingNet.Mirror()
        testingNet.ConnectHemispheres()
    }
}

func BenchmarkCycleNet(b *testing.B) {
    testingNet := MakeNetwork(TEST_NETWORK_SIZE, false)
    testingNet.Connect()
    testingNet.Mirror()
    testingNet.ConnectHemispheres()
    for i := 0; i < b.N; i++ {
        testingNet.Cycle()
    }
}

func BenchmarkInitialConnectionCount(b *testing.B) {
    testingNet := MakeNetwork(TEST_NETWORK_SIZE, true)
    testingNet.Connect()
    testingNet.Mirror()
    testingNet.ConnectHemispheres()
    for i := 0; i < b.N; i++ {
        testingNet.CountConnections()
    }
    fmt.Println(testingNet.CountConnections())
}

func BenchmarkCycledConnectionCount(b *testing.B) {
    testingNet := MakeNetwork(TEST_NETWORK_SIZE, true)
    testingNet.Connect()
    testingNet.Mirror()
    testingNet.ConnectHemispheres()
    for i := 0; i < 50; i++ {
        testingNet.Cycle()
    }
    for i := 0; i < b.N; i++ {
        testingNet.CountConnections()
    }
    fmt.Println(testingNet.CountConnections())
}