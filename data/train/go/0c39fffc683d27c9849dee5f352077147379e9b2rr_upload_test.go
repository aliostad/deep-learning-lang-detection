package task

import (
	trans "./../"
	// "./../models"
	"cydex/transfer"
	// "fmt"
	. "github.com/smartystreets/goconvey/convey"
	"testing"
)

func CreateNode(nid string, free_size uint64) *trans.Node {
	node := trans.NewNode(nil, nil)
	node.Nid = nid
	// node.Node = &models.Node{
	// 	Nid: nid,
	// }
	node.Info.FreeStorage = free_size
	return node
}

func NewReq(size uint64) *UploadReq {
	n := &UploadReq{
		UploadTaskReq: &transfer.UploadTaskReq{
			Size: size,
		},
	}
	return n
}

func Test_RoundRobinUploadScheduler(t *testing.T) {
	var err error

	Convey("Test RoundRobinUploadScheduler", t, func() {
		rr := NewRoundRobinUploadScheduler()
		var node *trans.Node
		nodes := [4]*trans.Node{}
		nodes[0] = CreateNode("n1", 128)
		nodes[1] = CreateNode("n2", 512)
		nodes[2] = CreateNode("n3", 256)
		for _, n := range nodes {
			if n != nil {
				rr.AddNode(n)
			}
		}

		Convey("dispatch without size", func() {
			// fmt.Printf("%p\n", rr)
			Convey("disptach", func() {
				node, err = rr.DispatchUpload(nil)
				So(err, ShouldBeNil)
				So(node.Nid, ShouldEqual, "n1")
				So(rr.NumUnits(), ShouldEqual, 3)

				node, err = rr.DispatchUpload(nil)
				So(err, ShouldBeNil)
				So(node.Nid, ShouldEqual, "n2")

				node, err = rr.DispatchUpload(nil)
				So(err, ShouldBeNil)
				So(node.Nid, ShouldEqual, "n3")

				node, err = rr.DispatchUpload(nil)
				So(err, ShouldBeNil)
				So(node.Nid, ShouldEqual, "n1")

				node, err = rr.DispatchUpload(nil)
				So(err, ShouldBeNil)
				So(node.Nid, ShouldEqual, "n2")
			})

			Convey("Delete one node", func() {
				rr.DelNode(nodes[0])
				So(rr.NumUnits(), ShouldEqual, 2)

				node, err = rr.DispatchUpload(nil)
				So(err, ShouldBeNil)
				So(node.Nid, ShouldEqual, "n2")

				node, err = rr.DispatchUpload(nil)
				So(err, ShouldBeNil)
				So(node.Nid, ShouldEqual, "n3")

				node, err = rr.DispatchUpload(nil)
				So(err, ShouldBeNil)
				So(node.Nid, ShouldEqual, "n2")
			})

			Convey("Add another node", func() {
				rr.DelNode(nodes[0])
				nodes[3] = CreateNode("n4", 256)
				rr.AddNode(nodes[3])
				So(rr.NumUnits(), ShouldEqual, 3)

				node, err = rr.DispatchUpload(nil)
				So(err, ShouldBeNil)
				So(node.Nid, ShouldEqual, "n2")

				node, err = rr.DispatchUpload(nil)
				So(err, ShouldBeNil)
				So(node.Nid, ShouldEqual, "n3")

				node, err = rr.DispatchUpload(nil)
				So(err, ShouldBeNil)
				So(node.Nid, ShouldEqual, "n4")

				node, err = rr.DispatchUpload(nil)
				So(err, ShouldBeNil)
				So(node.Nid, ShouldEqual, "n2")
			})

			Convey("Reset", func() {
				rr.Reset()
				node, err = rr.DispatchUpload(nil)
				So(node, ShouldBeNil)
				So(err, ShouldNotBeNil)
			})
		})

		Convey("dispatch with size", func() {
			Convey("normal", func() {
				req := NewReq(129)
				node, err = rr.DispatchUpload(req)
				So(node.Nid, ShouldEqual, "n2")

				req = NewReq(383)
				node, err = rr.DispatchUpload(req)
				So(node.Nid, ShouldEqual, "n2")

				req = NewReq(383)
				node, err = rr.DispatchUpload(req)
				So(node.Nid, ShouldEqual, "n2")

				req = NewReq(12)
				node, err = rr.DispatchUpload(req)
				So(node.Nid, ShouldEqual, "n1")
			})

			Convey("too big", func() {
				req := NewReq(1024 * 1024)
				node, err = rr.DispatchUpload(req)
				So(node, ShouldBeNil)
			})
		})
	})
}
