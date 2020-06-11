package main

import (
  "context"
  "fmt"
  "github.com/nheyn/go-redux/store"
)

func main() {
  ctx := context.Background()
  s := store.New(store.State{
    "COUNTER_STATE": counter(0),
  })

  initialCountInfo := &countInfo{}
  s.Select(initialCountInfo)
  fmt.Println(initialCountInfo.value)

  s.Dispatch(ctx, incurment(1))
  s.Dispatch(ctx, incurment(1))
  s.Dispatch(ctx, incurment(10))

  postiveCountInfo := &countInfo{}
  s.Select(postiveCountInfo)
  fmt.Println(postiveCountInfo.value, "is postive?", postiveCountInfo.isPositive)

  s.Dispatch(ctx, decurment(1))
  s.Dispatch(ctx, decurment(1))
  s.Dispatch(ctx, decurment(100))

  negitiveCountInfo := &countInfo{}
  s.Select(negitiveCountInfo)
  fmt.Println(negitiveCountInfo.value, "is negitive?", negitiveCountInfo.isNegitive())

  err := s.Dispatch(ctx, incurment(-1))
  fmt.Println("Error when trying to incurment by a negitive returns:", err)
}
