(ns veemon
    (use veemon.jvm-stat-wrap))

; to get started, we need a MonitoredHost instance - a VM running on some server
; the one on our local host is
; (vhmost)
; let's store it
(def my-host (vmhost))

; we should also be able to specify the host name
; my machine is called ubuntu-desktop
; WONT WORK
; (vmhost "ubuntu-desktop")
; that won't work unless we start the rmi registry (and probably jstatd); we'll leave
; that alone for now
;
; so, i can get a reference to my own machine which is hosting 0-n JVMs
; let's get the proc ids for those JVMs
; (vm-proc-ids-for (vmhost))
(def pids (vm-proc-ids-for my-host))

; we have a process with (OS) process id 5793
; the apis generally want to hide this, so request a VmIdentifier; we can create one using
; (vmid <some process id>)
; or using the value we got via lookup
; (vmid (first (vm-proc-ids-for (vmhost))))
; note of course vm-proc-ids-for may return more than 1, so you may need to select between
; them (TBD)
; let's store this vmid
(def vid (vmid (first pids)))

; since we have a host and a process id, we can request a MonitoredVm, which is out
; direct access to communicating with the VM
; (monitored-vm <mhost> <vmid>)
(def mvm (monitored-vm my-host vid))

; the JVM produces instrumentation countes which we call instruments. each instrument
; is a single value -- how many times gc has run, for example -- and each has a name
; to list all property names in this vm, use
; (instrument-names mvm)
; we'll pull out the ones that seem to do with threads
(def pnlist (for [n (sort (instrument-names mvm)) :when (.contains n "java.thread")] n))

; finally, we can get the current value for any property; we can either call
; (instrument-value <mvm> <name>)
; but that returns a MonitoredValue object; to get the value as a String, use
; (string-value-for (instrument-value <mvm> <name>))
; which returns just the value, or use 
; (desc-value-for mvm iname)
; which prints a string like "name=val"
(for [prop pnlist] (desc-value-for mvm prop))
