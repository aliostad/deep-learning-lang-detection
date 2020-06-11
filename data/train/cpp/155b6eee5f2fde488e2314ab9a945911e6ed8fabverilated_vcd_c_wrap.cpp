#include <boost/python.hpp>
#include "../include/verilated.h"
#include "../include/verilated_vcd_c.h"
using namespace boost::python;

BOOST_PYTHON_MODULE(verilated_vcd_c_wrap)
{
    void (VerilatedVcdC::*dumpx1) (vluint64_t) 	= &VerilatedVcdC::dump;
    void (VerilatedVcdC::*dumpx2) (double) 	= &VerilatedVcdC::dump;
    void (VerilatedVcdC::*dumpx3) (vluint32_t) 	= &VerilatedVcdC::dump;
    void (VerilatedVcdC::*dumpx4) (int) 	= &VerilatedVcdC::dump;

    class_<VerilatedVcdC, boost::noncopyable>("VerilatedVcdC")
		.def("open", &VerilatedVcdC::open)
		.def("close", &VerilatedVcdC::close)
		.def("dump", dumpx1)
		.def("dump", dumpx2)
		.def("dump", dumpx3)
		.def("dump", dumpx4);
}
