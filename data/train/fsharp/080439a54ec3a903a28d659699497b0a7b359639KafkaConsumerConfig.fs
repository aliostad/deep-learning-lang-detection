namespace Sunergeo.Kafka

type KafkaConsumerOffsetAutoReset =
| Earliest
| Latest
| None
[<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
module KafkaConsumerOffsetAutoReset =
    let toString =
        function
        | KafkaConsumerOffsetAutoReset.Earliest -> "earliest"
        | Latest -> "latest"
        | None -> "none"

        
type KafkaConsumerIsolationLevel =
| ReadCommitted
| ReadUncommitted
[<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
module KafkaConsumerIsolationLevel =
    let toString =
        function
        | KafkaConsumerIsolationLevel.ReadCommitted -> "read_committed"
        | ReadUncommitted -> "read_uncommitted"

type KafkaConsumerConfig = {
    // A list of host/port pairs to use for establishing the initial connection to the Kafka cluster. The client will make use of all servers irrespective of which servers are specified here for bootstrapping—this list only impacts the initial hosts used to discover the full set of servers. This list should be in the form host1:port1,host2:port2,.... Since these servers are just used for the initial connection to discover the full cluster membership (which may change dynamically), this list need not contain the full set of servers (you may want more than one, though, in case a server is down).
    BootstrapHosts: KafkaHost list

    // The minimum amount of data (in bytes) the server should return for a fetch request. If insufficient data is available the request will wait for that much data to accumulate before answering the request. The default setting of 1 byte means that fetch requests are answered as soon as a single byte of data is available or the fetch request times out waiting for data to arrive. Setting this to something greater than 1 will cause the server to wait for larger amounts of data to accumulate which can improve server throughput a bit at the cost of some additional latency.
    FetchMinSize: int

    // A unique string that identifies the consumer group this consumer belongs to. This property is required if the consumer uses either the group management functionality by using subscribe(topic) or the Kafka-based offset management strategy.
    GroupId: string

    // The expected time between heartbeats to the consumer coordinator when using Kafka's group management facilities. Heartbeats are used to ensure that the consumer's session stays active and to facilitate rebalancing when new consumers join or leave the group. The value must be set lower than session.timeout.ms, but typically should be set no higher than 1/3 of that value. It can be adjusted even lower to control the expected time for normal rebalances.
    HeartbeatIntervalMs: int

    // The maximum amount of data per-partition the server will return. Records are fetched in batches by the consumer. If the first record batch in the first non-empty partition of the fetch is larger than this limit, the batch will still be returned to ensure that the consumer can make progress. The maximum record batch size accepted by the broker is defined via message.max.bytes (broker config) or max.message.bytes (topic config). See fetch.max.bytes for limiting the consumer request size.
    FetchPartitionMaxSize: int
    
    // The timeout used to detect consumer failures when using Kafka's group management facility. The consumer sends periodic heartbeats to indicate its liveness to the broker. If no heartbeats are received by the broker before the expiration of this session timeout, then the broker will remove this consumer from the group and initiate a rebalance. Note that the value must be in the allowable range as configured in the broker configuration by group.min.session.timeout.ms and group.max.session.timeout.ms.
    SessionTimeoutMs: int

    // What to do when there is no initial offset in Kafka or if the current offset does not exist any more on the server (e.g. because that data has been deleted):
    // earliest: automatically reset the offset to the earliest offset
    // latest: automatically reset the offset to the latest offset
    // none: throw exception to the consumer if no previous offset is found for the consumer's group
    OffsetAutoReset: KafkaConsumerOffsetAutoReset

    // Close idle connections after the number of milliseconds specified by this config.
    ConnectionMaxIdleMs: int

    // If true the consumer's offset will be periodically committed in the background.
    AutoCommitEnabled: bool

    // The maximum amount of data the server should return for a fetch request. Records are fetched in batches by the consumer, and if the first record batch in the first non-empty partition of the fetch is larger than this value, the record batch will still be returned to ensure that the consumer can make progress. As such, this is not a absolute maximum. The maximum record batch size accepted by the broker is defined via message.max.bytes (broker config) or max.message.bytes (topic config). Note that the consumer performs multiple fetches in parallel.
    FetchMaxSize: int

    // Controls how to read messages written transactionally. If set to read_committed, consumer.poll() will only return transactional messages which have been committed. If set to read_uncommitted' (the default), consumer.poll() will return all messages, even transactional messages which have been aborted. Non-transactional messages will be returned unconditionally in either mode.
    // Messages will always be returned in offset order. Hence, in read_committed mode, consumer.poll() will only return messages up to the last stable offset (LSO), which is the one less than the offset of the first open transaction. In particular any messages appearing after messages belonging to ongoing transactions will be withheld until the relevant transaction has been completed. As a result, read_committed consumers will not be able to read up to the high watermark when there are in flight transactions.
    // Further, when in read_committed the seekToEnd method will return the LSO
    IsolationLevel: KafkaConsumerIsolationLevel

    // The maximum delay between invocations of poll() when using consumer group management. This places an upper bound on the amount of time that the consumer can be idle before fetching more records. If poll() is not called before expiration of this timeout, then the consumer is considered failed and the group will rebalance in order to reassign the partitions to another member.
    PollIntervalMaxMs: int

    // The maximum number of records returned in a single call to poll().
    PollRecordMaxCount: int
    
    // The class name of the partition assignment strategy that the client will use to distribute partition ownership amongst consumer instances when group management is used
    GroupPartitioner: obj

    // The size of the TCP receive buffer (SO_RCVBUF) to use when reading data. If the value is -1, the OS default will be used.
    ReceiveBufferSize: int

    // The configuration controls the maximum amount of time the client will wait for the response of a request. If the response is not received before the timeout elapses the client will resend the request if necessary or fail the request if retries are exhausted.
    RequestTimeoutMs: int

    // The size of the TCP send buffer (SO_SNDBUF) to use when sending data. If the value is -1, the OS default will be used.
    SendBufferSize: int

    // The frequency in milliseconds that the consumer offsets are auto-committed to Kafka if enable.auto.commit is set to true.
    AutoCommitIntervalMs: int

    // Automatically check the CRC32 of the records consumed. This ensures no on-the-wire or on-disk corruption to the messages occurred. This check adds some overhead, so it may be disabled in cases seeking extreme performance.
    CrcCheckEnabled: bool

    // An id string to pass to the server when making requests. The purpose of this is to be able to track the source of requests beyond just ip/port by allowing a logical application name to be included in server-side request logging.
    ClientId: string

    // The maximum amount of time the server will block before answering the fetch request if there isn't sufficient data to immediately satisfy the requirement given by fetch.min.bytes.
    FetchMaxWaitMs: int

    // The period of time in milliseconds after which we force a refresh of metadata even if we haven't seen any partition leadership changes to proactively discover any new brokers or partitions.
    MetadataMaxAgeMs: int

    // The maximum amount of time in milliseconds to wait when reconnectng to a broker that has repeatedly failed to connect. If provided, the backoff per host will increase exponentially for each consecutive connection failure, up to this maximum. After calculating the backoff increase, 20% random jitter is added to avoid connection storms.
    ReconnectionBackoffMaxMs: int

    // The base amount of time to wait before attempting to reconnect to a given host. This avoids repeatedly connecting to a host in a tight loop. This backoff applies to all connection attempts by the client to a broker.
    ReconnectionBackoffMinMs: int

    // The amount of time to wait before attempting to retry a failed request to a given topic partition. This avoids repeatedly sending requests in a tight loop under some failure scenarios.
    RetryBackoffMs: int
} with 
    static member Default:KafkaConsumerConfig =
        // https://kafka.apache.org/documentation/#consumerconfigs
        {
            BootstrapHosts = List.empty
            FetchMinSize = 1
            GroupId = ""
            HeartbeatIntervalMs = 3000
            FetchPartitionMaxSize = 1048576
            SessionTimeoutMs = 10000
            OffsetAutoReset = KafkaConsumerOffsetAutoReset.None // custom (default is Latest)
            ConnectionMaxIdleMs = 540000
            AutoCommitEnabled = false   // custom (default is true)
            FetchMaxSize = 52428800
            IsolationLevel = KafkaConsumerIsolationLevel.ReadCommitted // custom (default is ReadUncommitted)
            PollIntervalMaxMs = 300000
            PollRecordMaxCount = 500
            GroupPartitioner = null
            ReceiveBufferSize = 65536
            RequestTimeoutMs = 305000
            SendBufferSize = 131072
            AutoCommitIntervalMs = 5000
            CrcCheckEnabled = true
            ClientId = ""
            FetchMaxWaitMs = 500
            MetadataMaxAgeMs = 300000
            ReconnectionBackoffMaxMs = 1000
            ReconnectionBackoffMinMs = 50
            RetryBackoffMs = 100
        }

[<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
module KafkaConsumerConfig =
    let toKafkaConfig
        (config: KafkaConsumerConfig)
        : System.Collections.Generic.IDictionary<string, obj> =
        ([
            "bootstrap.servers", 
                config.BootstrapHosts
                |> List.map KafkaHost.toString
                |> String.concat ","
                :> obj

            //"key.deserializer", upcast "org.apache.kafka.common.serialization.StringSerializer"
            //"value.deserializer", upcast "org.apache.kafka.common.serialization.StringSerializer"

            "fetch.min.bytes", upcast config.FetchMinSize

            "group.id", upcast config.GroupId

            "heartbeat.interval.ms", upcast config.HeartbeatIntervalMs

            "max.partition.fetch.bytes", upcast config.FetchPartitionMaxSize

            "session.timeout.ms", upcast config.SessionTimeoutMs

            //"auto.offset.reset", upcast (config.OffsetAutoReset |> KafkaConsumerOffsetAutoReset.toString)

            //"connections.max.idle.ms", upcast config.ConnectionMaxIdleMs

            "enable.auto.commit", upcast config.AutoCommitEnabled

            //"exclude.internal.topics", upcast true

            //"fetch.max.bytes", upcast config.FetchMaxSize

            //"isolation.level", upcast (config.IsolationLevel |> KafkaConsumerIsolationLevel.toString)

            //"max.poll.interval.ms", upcast config.PollIntervalMaxMs
            //"max.poll.records", upcast config.PollRecordMaxCount

            //"partition.assignment.strategy", upcast config.GroupPartitioner

            //"receive.buffer.bytes", upcast config.ReceiveBufferSize

            "request.timeout.ms", upcast config.RequestTimeoutMs

            //"send.buffer.bytes", upcast config.SendBufferSize

            "auto.commit.interval.ms", upcast config.AutoCommitIntervalMs

            "check.crcs", upcast config.CrcCheckEnabled

            "client.id", upcast config.ClientId

            //"fetch.max.wait.ms", upcast config.FetchMaxWaitMs

            "metadata.max.age.ms", upcast config.MetadataMaxAgeMs

            //"reconnect.backoff.max.ms", upcast config.ReconnectionBackoffMaxMs
            //"reconnect.backoff.ms", upcast config.ReconnectionBackoffMinMs

            "retry.backoff.ms", upcast config.RetryBackoffMs

        ] : List<string * obj>)
        |> dict