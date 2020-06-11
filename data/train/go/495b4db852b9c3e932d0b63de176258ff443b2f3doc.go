// Package dispatch implements a message processing mechanism.
//
// The basic idea is goroutine-per-request, which means each request runs in a
// separate goroutine.
//
//                   +  +  +
//                   |  |  |
//                   |  |  | goroutine per request
//                   |  |  |
//                   v  v  v
//          +---------------------+
//          |      Dispatcher     |
//          +----------+----------+
//            +--------+--------+
//            |        |  +-----|----------------------------------+
//            v        v  |     v       In-memory entity           |
//          +----+  +----+|+---------+                             |
//          |Dest|  |Dest|||  Dest   |                             |
//          +----+  +----+|+---------+                             |
//                        ||  Mutex  |             +------------+  |
//                        ||+-------+|   access    |            |  |
//                        |||Handler+------------->|            |  |
//                        ||+-------+|sequentially | Associated |  |
//                        ||+Handler+------------->|            |  |
//                        ||+-------+|             | Resources  |  |
//                        ||+Handler+------------->|            |  |
//                        ||+-------+|             |            |  |
//                        |+---------+             +------------+  |
//                        |                                        |
//                        +----------------------------------------+
//
//
package dispatch
