package main

import (
    "component-tech/rtree"
    "component-tech/strict_json"
    "crypto/rand"
    "encoding/base64"
    "fmt"
    "io/ioutil"
    "math"
    "net/http"
    "os"
    "strconv"
    "strings"
    "sync"
    "time"
)


func assert(expr bool, msg string) {
    if !expr {
        panic(msg)
    }
}


func Min(a, b float32) float32 {
    if a <= b {
        return a
    } else {
        return b
    }
}


const MaxConsumersPerBroker = 2000
const MaxRTreeNodes = 50
const MinFillRatio = 0.35
const DefaultMapSize = 500
const CoronerTimeout = time.Duration(1) * time.Minute


type Consumer struct {
    ID       string
    Area     rtree.Rect
    Coroner  *time.Timer
    TreeNode *rtree.RTreeNode
    Broker   *Broker
}

func NewConsumer() *Consumer {
    consumer := new(Consumer)
    return consumer
}

type Broker struct {
    URL          string
    ConsumerTree *rtree.RTree
    Coroner      *time.Timer
}

func NewBroker() *Broker {
    broker := new(Broker)
    broker.URL = ""
    minFill := MaxRTreeNodes * MinFillRatio
    broker.ConsumerTree = rtree.New(MaxRTreeNodes, int(minFill))
    return broker
}

type Registry struct {
    BrokerList   []*Broker
    BrokerMap    map[string]*Broker
    ConsumerMap  map[string]*Consumer
    RWLock       sync.RWMutex
}

func NewRegistry() *Registry {
    return &Registry{
        BrokerList:   make([]*Broker, 0, 20),
        ConsumerMap:  make(map[string]*Consumer, DefaultMapSize),
        BrokerMap:    make(map[string]*Broker, DefaultMapSize),
    }
}

func (r *Registry) RemoveConsumer(consumer *Consumer) {
    consumer.Coroner.Stop()

    if _, ok := r.ConsumerMap[consumer.ID]; !ok {
        // We only remove consumers under the broker wlock,
        // so this should never happen.
        panic("consumer has already been removed!")
    }

    delete(r.ConsumerMap, consumer.ID)
    consumer.TreeNode.Remove()
    consumer.Broker = nil
}

func (r *Registry) ChooseBroker(consumer *Consumer) *Broker {
    var selectedBroker *Broker

    minArea := float32(math.Inf(1))
    minEnlargement := float32(math.Inf(1))

    // Copied from RTree
    for _, broker := range r.BrokerList {
        node := broker.ConsumerTree.Root
        area := node.Bounds.Area()
        containingBox := consumer.Area.Union(&node.Bounds)
        containingArea := containingBox.Area()
        enlargement := containingArea - area

        if enlargement < minEnlargement ||
            (enlargement == minEnlargement && area < minArea) {
            minEnlargement = enlargement
            minArea = Min(area, minArea)
            selectedBroker = broker
        }
    }

    return selectedBroker
}

func (r *Registry) AddConsumer(consumer *Consumer) error {
    if consumer.Broker != nil {
        // This is a pre-existing consumer
        assert(consumer.TreeNode != nil, "active consumer lacks tree node")
        r.RemoveConsumer(consumer)
    }

    consumer.Broker = r.ChooseBroker(consumer)
    if consumer.Broker == nil {
        return fmt.Errorf("No brokers available")
    }

    consumer.TreeNode = consumer.Broker.ConsumerTree.Insert(consumer, consumer.Area)
    r.ConsumerMap[consumer.ID] = consumer
    return nil
}

type AnnounceConsumerMessage struct {
    Longitude float32 `json:"longitude"`
    Latitude  float32 `json:"latitude"`
    Radius    float32 `json:"radius"`
}

func (msg *AnnounceConsumerMessage) Bounds() rtree.Rect {
    return rtree.Rect{
        Left: msg.Longitude - msg.Radius,
        Top: msg.Latitude - msg.Radius,
        Bottom: msg.Latitude + msg.Radius,
        Right: msg.Longitude + msg.Radius,
    }
}

func (r *Registry) announceConsumer(w http.ResponseWriter, req *http.Request, body []byte) {
    registerConsumer := false
    consumerID := ""
    var consumer *Consumer

    var msg AnnounceConsumerMessage
    err := strict_json.Unmarshal(body, &msg)
    if err != nil {
        http.Error(w, err.Error(), 400)
        return
    }

    // Take the write lock - we will always be modifying the rtree
    r.RWLock.Lock()
    defer r.RWLock.Unlock()

    pathParts := strings.Split(req.URL.Path, "/")
    switch len(pathParts) {
    case 3:
        registerConsumer = true
    case 4:
        consumerID = pathParts[3]
        var ok bool
        consumer, ok = r.ConsumerMap[consumerID]
        if !ok {
            registerConsumer = true
        }
    }

    if registerConsumer {
        var consID [16]byte
        _, err = rand.Read(consID[:])
        if err != nil {
            http.Error(w, err.Error(), 500)
            return
        }
        consumer = NewConsumer()
        consumer.Area = msg.Bounds()
        consumer.ID = base64.URLEncoding.EncodeToString(consID[:])

        consumer.Coroner = time.AfterFunc(CoronerTimeout, func() {
            r.RemoveConsumer(consumer)
        })
    }

    err = r.AddConsumer(consumer)
    if err != nil {
        w.Write([]byte(err.Error()))
        return
    }

    consumer.Coroner.Reset(CoronerTimeout)

    w.Write([]byte(fmt.Sprintf(`{"consumer_id": "%s", "broker_url": "%s"}`, consumer.ID, consumer.Broker.URL)))
}

type AnnounceBrokerMessage struct {
    URL string `json:"url"`
}

func (r *Registry) RemoveBroker(broker *Broker) {
    found := false
    for i, b := range r.BrokerList {
        if b == broker {
            copy(r.BrokerList[i:], r.BrokerList[i+1:])
            r.BrokerList[len(r.BrokerList)-1] = nil
            r.BrokerList = r.BrokerList[:len(r.BrokerList)-1]
            found = true
        }
    }

    assert(found, "could not find broker to remove")
}

func (r *Registry) announceBroker(w http.ResponseWriter, req *http.Request, body []byte) {
    var msg AnnounceBrokerMessage
    err := strict_json.Unmarshal(body, &msg)
    if err != nil {
        http.Error(w, err.Error(), 400)
        return
    }

    r.RWLock.RLock()
    broker, ok := r.BrokerMap[msg.URL]

    if ok {
        broker.Coroner.Reset(CoronerTimeout)
        r.RWLock.RUnlock()
        w.Write([]byte("OK"))
        return
    }

    // Need to add the broker
    r.RWLock.RUnlock()
    r.RWLock.Lock()
    defer r.RWLock.Unlock()

    // Recheck condition in case it changed after we dropped the lock
    broker, ok = r.BrokerMap[msg.URL]

    if ok {
        broker.Coroner.Reset(CoronerTimeout)
        w.Write([]byte("OK"))
        return
    }

    broker = NewBroker()
    broker.URL = msg.URL

    broker.Coroner = time.AfterFunc(CoronerTimeout, func() {
        r.RemoveBroker(broker)
    })

    r.BrokerMap[msg.URL] = broker
    r.BrokerList = append(r.BrokerList, broker)

    w.Write([]byte("OK"))
}

type AnnounceProducerMessage struct {
    Longitude float32 `json:"longitude"`
    Latitude  float32 `json:"latitude"`
}

func (r *Registry) announceProducer(w http.ResponseWriter, req *http.Request, body []byte) {
    var msg AnnounceProducerMessage
    err := strict_json.Unmarshal(body, &msg)
    if err != nil {
        http.Error(w, err.Error(), 400)
        return
    }

    r.RWLock.RLock()
    defer r.RWLock.RUnlock()

    pointsMap := make(map[string]int, 20)
    for _, broker := range r.BrokerList {
        broker.ConsumerTree.Visit(msg.Longitude, msg.Latitude, func(value interface{}, bounds rtree.Rect) {
            consumer := value.(*Consumer)
            broker := consumer.Broker
            points, ok := pointsMap[broker.URL]
            if !ok {
                pointsMap[broker.URL] = 1
            } else {
                pointsMap[broker.URL] = points + 1
            }
        })
    }

    var bestURL string
    bestPoints := -1
    for k, v := range pointsMap {
        if v > bestPoints {
            bestURL = k
        }
    }

    w.Write([]byte(fmt.Sprintf(`{"broker_url": "%s"}`, bestURL)))
}

func (r *Registry) ServeHTTP(w http.ResponseWriter, req *http.Request) {
    bodyBytes, err := ioutil.ReadAll(req.Body)
    if err != nil {
        http.Error(w, "Error reading request body", 500)
        return
    }

    switch {
    case req.Method == "POST" && strings.HasPrefix(req.URL.Path, "/announce/broker"):
        r.announceBroker(w, req, bodyBytes)
    case req.Method == "POST" && strings.HasPrefix(req.URL.Path, "/announce/producer"):
        r.announceProducer(w, req, bodyBytes)
    case req.Method == "POST" && strings.HasPrefix(req.URL.Path, "/announce/consumer"):
        r.announceConsumer(w, req, bodyBytes)
    default:
        http.Error(w, "Endpoint not found", 404)
    }
}

func main() {
    port, err := strconv.Atoi(os.Args[1])
    if err != nil {
        fmt.Println(err.Error())
        os.Exit(1)
    }

    registry := NewRegistry()
    http.Handle("/", registry)
    http.ListenAndServe(fmt.Sprintf(":%d", port), nil)
}
