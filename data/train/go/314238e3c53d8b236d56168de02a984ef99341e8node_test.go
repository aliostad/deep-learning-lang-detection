package node

import "testing"

func TestEmptyNodePriority(t *testing.T) {

	node := NewEmptyNode()
	if node.Priority != 0 {
		t.Errorf("Empty node priority should be 0 but is %d", node.Priority)
	}

}

func TestEmptyNodeLoad(t *testing.T) {

	node := NewEmptyNode()
	if node.Load != nil {
		t.Errorf("Empty node shouldn't have any load but is %v", node.Load)
	}
}

func TestNodeCreation(t *testing.T) {
	load := "this is the load"
	priority := uint(10)
	node := New(load, priority)
	if node.Priority != 10 {
		t.Errorf("Node should have a priority of %d but is %d", priority, node.Priority)
	}
	if node.Load != load {
		t.Errorf("Node should have load %v but is %v", load, node.Load)
	}
}

func TestNodePriority(t *testing.T) {
	priority := uint(10)
	node := New(nil, priority)
	if node.Priority != 10 {
		t.Errorf("Node should have a priority of %d but is %d", priority, node.Priority)
	}
}

func TestNodeLoad(t *testing.T) {
	load := "this is the load"
	node := New(load, 0)
	if node.Load != load {
		t.Errorf("Node should have load %v but is %v", load, node.Load)
	}
}
