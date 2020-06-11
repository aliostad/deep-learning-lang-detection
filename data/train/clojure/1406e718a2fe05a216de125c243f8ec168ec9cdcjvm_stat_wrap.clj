(ns veemon.jvm-stat-wrap
    "Provides wrapper functions for working with Sun's jvmstat API; jvmstat is not a public API, which means Sun
    can change it at any time, for any reason, between any two releases. The jvmstat API allows you to discover
    JVMs running on a given host, connect to them, and ask them for information about their internal state, e.g.
    number of current threads, etc. To a certain extent some of this information can also be retrieved via the
    standard JMX APIs which are actually part of a standard. The difference is that jvmstat gives you some lower-
    level details about the JVM. You can find the JavaDocs for the jvmstat APIs online at
    http://openjdk.java.net/groups/serviceability/jvmstat/index.html.
    Note that when you are done gathering information from a host, it is a best practice to call detach-from-host
    as part of cleanup."

    (:import [sun.jvmstat.monitor MonitoredHost 
                                  HostIdentifier 
                                  MonitoredVm 
                                  StringMonitor LongMonitor IntegerMonitor ByteArrayMonitor 
                                  VmIdentifier]))


; TODO write convenience fns for different HI constructors   
(defn localhost-identifier 
      "Returns the HostIdentifier for the vms on localhost"
      []
      (HostIdentifier. "localhost"))

(defn vmhost
      "Returns a MonitoredHost; if no parameters given, uses localhost, otherwise, 
      returns a host for the given URI; see MH javadocs for URI syntax"
      ([] (vmhost "localhost"))
      ([host-uri] (MonitoredHost/getMonitoredHost host-uri)))

(defn vm-proc-ids-for 
      "Returns seq of process id of vms on a monitored host; assume these are currently active vms"
      [vmhost] 
      (seq (.activeVms vmhost)))

(defn vmid 
      "Returns a new VmIdentifier for a given vm proc id"
      [vm-proc-id]
      (VmIdentifier. (format "//%d?mode=r" vm-proc-id)))

(defn host-id-for
      "Returns the HostIdentifier for a given VmIdentifier"
      [vmid]
      (.getHostIdentifier vmid))

(defn monitored-vm
      "Returns a MonitoredVm for a given VmIdentifier"
      [mhost vmid]
      (.getMonitoredVm mhost vmid))

(defn detach-from-host
      "Detaches from the monitored host vmhost; best practice to do this when done"
      [vmhost]
      (.detach vmhost))

(defn instruments-for
      "For a monitored vm mvm returns either a list of all instruments, or all instruments matching the
      name regex."
      ([mvm] (instruments-for mvm ".*"))
      ([mvm regex] (.findByPattern mvm regex)))

(defn instrument-names
      "Lists the names of all monitored instruments in the vm; you can pass these string names to find-value to
      retrieve the current value for the instrument. an instrument captures one value for one very specific aspect
      of vm operation, like 'number of times gc ran since start'. with one argument mvm, returns all instrument
      names; with arguments mvm regex returns all whose name matches regex"
      ([mvm] (map #(.getName %) (instruments-for mvm)))
      ([mvm regex] (map #(.getName %) (instruments-for mvm regex))))

(defn instrument-value
      "Returns the value for a instrument named iname for a monitored vm mvm. the return type is one of the monitor
      types in the jmvstat API: LongMonitor, IntegerMonitor, StringMonitor or ByteArrayMonitor. These don't
      automatically convert to e.g. strings; to convert to a string, call the multi-method string-value-for
      passing in the result of instrument-value"
      [mvm iname] 
      (.findByName mvm iname))

; monitored values are one of several types, which have different method calls to extract their
; values as e.g. a long, a byte array, etc. use a defmulti to convert whichever value to a string
; the types xxxMonitor are part of the jvmstat Java API
(defmulti string-value-for class)
(defmethod string-value-for LongMonitor [mval] (String/valueOf (.longValue mval)))
(defmethod string-value-for IntegerMonitor [mval] (String/valueOf (.intValue mval)))
(defmethod string-value-for StringMonitor [mval] (.stringValue mval))
(defmethod string-value-for ByteArrayMonitor [mval] (String/valueOf (.byteArrayValue mval)))
(prefer-method string-value-for StringMonitor ByteArrayMonitor)

(defn desc-value-for
      "Returns the value, as string, in the form '<base name>:<name>=<value>' for an instrument named iname for a
      monitored vm mvm; if you already have a monitored value, pass that in instead"
      ([mvm iname] (desc-value-for (instrument-value mvm iname)))
      ([mval] (format "%s:%s=%s" (.getBaseName mval) (.getName mval) (string-value-for mval))))

