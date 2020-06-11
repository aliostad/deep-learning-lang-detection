;; This is a bunch of functions that provides the foundamentals to
;; administer a local/remote machine and exchange files through SSH.
;;
;; The idea is to provide a set of foundamental operations to
;; implement *recipes* to do something that involves the local machine
;; and eventually one or more remote ones. The primary use-case is the
;; compilation and deploy of software artifacts.
;;
;; A complete foundation for this kind of administration has to
;; provide means to:
;;
;; - execute commands (local and remote)
;; - managing local and remote filesystem
;; - exchange files between local and remote machines
(ns gino.core
  (:import [org.apache.commons.io FileUtils IOUtils]
           [java.io File BufferedReader InputStreamReader]
           [java.util.concurrent TimeUnit]
           [org.apache.commons.exec CommandLine DefaultExecutor]
           [net.schmizz.sshj SSHClient]
           [net.schmizz.sshj.xfer FileSystemFile]
           [net.schmizz.sshj.xfer.scp SCPFileTransfer]
           [net.schmizz.sshj.transport.verification PromiscuousVerifier]))

;; ## Local primitives ##
;; Here are the basic operations to manage a local machine.

(defn build-cmd
  "Build a `CommandLine`."
  [cmd args]
  (loop [cmdline (new CommandLine cmd)
         args args]
    (if (empty? args)
      cmdline
      (recur (. cmdline addArgument (first args))
             (rest args)))))

(defn execute-cmd
  "Execute on the local machin the given `CommandLine`."
  [cmdline]
  (. (new DefaultExecutor) execute cmdline))

(defn remove-dir
  "Remove a local directory recursively."
  [directory]
  (. FileUtils deleteDirectory (File. directory)))

(defn copy-to-dir
  "Copy a file from a directory to another one (it can be the same)."
  [file to-dir]
  (. FileUtils copyFileToDirectory (File. file) (File. to-dir)))

(defn copy-to-file
  "Copy a file to another directory specifying the complete
  destination path, so that you can change the destination filename."
  [file to-file]
  (. FileUtils copyFile (File. file) (File. to-file)))

;; ## Remote primitives ##
;; Here are basic operations to manage a remote machine.

(defn remote-copy
  "Copy a local file to a remote machine using SSH."
  [file host username password dest]
  (let [ssh (new SSHClient)]
    (do (. ssh loadKnownHosts)
        (. ssh connect host)
        (. ssh authPassword username password)
        (. ssh useCompression)
        (. (. ssh newSCPFileTransfer) upload (new FileSystemFile file) dest))))

(defn read-cmd-output [is]
  (.readLine (new BufferedReader (new InputStreamReader is))))

;; `PromiscuousVerifier` is for [verifying
;; succesfully](https://gist.github.com/1321719#gistcomment-62366) the
;; local fingerprints.
(defn remote-cmd
  "Execute a command in a remote machine."
  [host username password cmd]
  (let [ssh (new SSHClient)]
    (do (.addHostKeyVerifier ssh (new PromiscuousVerifier))
        (.connect ssh host)
        (.authPassword ssh username password)
        (.useCompression ssh)
        (.addHostKeyVerifier ssh "08:19:b9:c1:0b:33:71:bc:6e:24:db:45:3d:f4:a6:7b")
        (read-cmd-output (.getInputStream (.exec (.startSession ssh) cmd))))))
