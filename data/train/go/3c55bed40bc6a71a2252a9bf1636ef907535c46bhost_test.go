package host

import "testing"
import "fmt"

func  TestManager(t *testing.T) {
  manager := HostManager{
    hosts: map[string]*Host{},
        }
  resp := manager.register("test")
  fmt.Println(resp)
  resp2 := manager.getHost(resp.id)
  fmt.Println(resp2)
  if resp.id != resp2.id {
    t.Fail()
  }
}

func BenchmarkHostManager(b *testing.B) {
  manager := HostManager{
    hosts: map[string]*Host{},
        }
  resp := manager.register("test")
  id := resp.id
  b.ResetTimer()
  for i := 0; i < b.N; i++ {
    manager.getHost(id)
  }
}

func TestManagerCheckIn(t *testing.T) {
  manager := HostManager{
    hosts: map[string]*Host{},
        }
  resp := manager.register("test")
  resp2 := manager.checkin(resp.id)
  fmt.Println(resp2)
  resp3 := manager.getHost(resp.id)
  fmt.Println(resp3)
}
