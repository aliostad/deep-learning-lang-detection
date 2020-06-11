using ClutchNet;
using DashcamNet.Thrift;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Thrift.Protocol;

namespace DashcamNet.Common
{
    class ChunkBuilder {

    private Chunk chunk;
    private int chunkSize;

    public ChunkBuilder(){
        this.chunk = new Chunk();
        chunk.EnvGroup=Configuration.GetEnvironmentGroup();
        chunk.Env=Configuration.GetEnvironment();
        chunk.HostIp=HostUtil.GetHostIp();
        chunk.HostName=HostUtil.GetHostName();
        chunk.AppId=Configuration.GetAppId();
        chunk.ProcessId=0;

        List<LogEvent> logEventList = new List<LogEvent>();
        List<Span> spanList = new List<Span>();
        List<MetricEvent> metricList = new List<MetricEvent>();
        List<Event> eventList = new List<Event>();
        chunk.LogEvents=logEventList;
        chunk.Spans=spanList;
        chunk.Metrics=metricList;
        chunk.Events=eventList;
    }

    public void clear(){
        this.chunk.LogEvents.Clear();
        this.chunk.Metrics.Clear();
        this.chunk.Spans.Clear();
        this.chunk.Events.Clear();
        this.chunkSize = 0;
    }

    public void putMsg(TBase tBase){
        if(tBase is LogEvent) {
            this.chunk.LogEvents.Add((LogEvent) tBase);
            this.chunkSize ++;
            return;
        }else if(tBase is  MetricEvent){
            this.chunk.Metrics.Add((MetricEvent) tBase);
            this.chunkSize++;
            return;
        }else if(tBase is  Span){
            this.chunk.Spans.Add((Span) tBase);
            this.chunkSize ++;
            return;
        }else if(tBase is Event){
            this.chunk.Events.Add((Event) tBase);
            this.chunkSize ++;
            return;
        }
    }

    public int getChunkSize(){
        return this.chunkSize;
    }

    public Chunk getChunk() {
        return chunk;
    }
}
}
