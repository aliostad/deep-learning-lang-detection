#include "DebugServer.h"
#include "LiteLib.h"

DebugServer::DebugServer(
	CoreDumpInvokeIfc *_core_dump_invoke_ifc,
	ZoogMonitor::Connection *zoog_monitor)
	: _core_dump_invoke_ifc(_core_dump_invoke_ifc)
{
	Signal_context_capability core_dump_invoke_sigh_cap =
		signal_receiver.manage(&core_dump_invoke_context);

	zoog_monitor->core_dump_invoke_sigh(core_dump_invoke_sigh_cap);

	start();
}

void DebugServer::entry()
{
	while (1)
	{
		Signal s = signal_receiver.wait_for_signal();
		if (s.context() == &core_dump_invoke_context)
		{
			PDBG("core_dump_invoke_context");
			_core_dump_invoke_ifc->dump_core();
		}
		else
		{
			PDBG("unknown context");
			lite_assert(0);	// unknown context
		}
	}

}
