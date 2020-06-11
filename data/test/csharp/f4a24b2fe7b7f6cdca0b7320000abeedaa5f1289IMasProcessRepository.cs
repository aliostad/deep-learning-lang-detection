using Comdiv.Persistence;

namespace Comdiv.MAS {
    public interface IMasProcessRepository {
        Process[] Query(Process query);
        void Clean(Process query);
        Process Get(Process query);
        Process Start(Process processinfo);
        Process Refresh(Process process);
        ProcessMessage Refresh(ProcessMessage message);
        void Finish(Process processinfo);
        ProcessMessage Send(ProcessMessage messageinfo );
        ProcessLog Log(ProcessLog processLog);
        ProcessMessage GetNext(Process process, ProcessMessage lastprocessed = null);
        T Update<T>(T target);
        App MyApp ();
        StorageWrapper<Process> Storage { get; }
    }
}