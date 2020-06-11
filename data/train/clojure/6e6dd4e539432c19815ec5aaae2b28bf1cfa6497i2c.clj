(ns pi4clj.i2c

  "Everything related to I2C.

   Open a bus and simply use the fns."

  (:import java.io.RandomAccessFile
           com.pi4j.io.file.LinuxFile))




;;;;;;;;;;


(defn- -coll->byte-array

  "Convert a collections of integers into an array of bytes
   
   (pi4clj.i2c/-coll->byte-array [0xac 0x0c])"

  [coll]

  (byte-array (map unchecked-byte
                   coll)))




(defn- -byte-array->seq

  "Convert an array of bytes into a collection of 'unsigned' integers"

  [byts]

  (map #(bit-and %
                 0xff)
       byts))




;;;;;;;;;;


(defn open-bus

  "Given a path, open a I2C bus. This bus can then be used in the fns provided by this namespace.

   Returns nil in case of failure.

   <!> A bus is basically a file handle and is NOT thread-safe by itself !
       For concurrency, the user must manage the access using locks or a prefered method.

   ex.
     (open-bus \"/dev/i2c-1\")"

  ^LinuxFile

  [bus-path]

  (try (LinuxFile. bus-path
                   "rw")
    (catch Throwable _
      nil)))




(defn close-bus

  "Cleanly close an I2C bus"

  [^LinuxFile bus]

  (when bus
    (.close ^LinuxFile bus)))




(defn select-slave

  "Select a slave device on the given I2C bus.

   ex.
     (select-slave bus
                   0x48)"

  [^LinuxFile bus slave-address]

  (.ioctl bus
          0x0703 ; slave commmand
          (bit-and slave-address
                   0xff)))




(defn wr

  "Given an I2C bus, write something a single byte or a collection of them.

   In this context, a byte is simply an integer.

   Returns true for success and false for failure.
  
   ex.
     (wr bus
         [0xac 0x0c])"

  [^RandomAccessFile bus byte+]

  (try (if (coll? byte+)
         (.write bus
                 (-coll->byte-array byte+))
         (.writeByte bus
                     byte+))
       true
    (catch Throwable _
      (println :error _)
      false)))




(defn wr-reg

  "Prior to writing, select a registry.

   Cf. wr
  
   ex.
     (wr bus
         0xaa
         [0xac 0x0c])"

  [bus register byte+]

  (wr bus
      (if (coll? byte+)
        (concat [register]
                byte+)
        [register byte+])))




(defn wr+

  "Write chunks of byte(s) sequentially and not at once.
   
   Useful for configuration and such things.

   Cf. wr

   ex.
     (wr+ bus
          [0xac         ;; stop device
           [0xac 0x0c]  ;; 2 bytes config
           0x51])       ;; restart device"
  
  [bus coll-byte+]

  (if (seq coll-byte+)
    (if (wr bus
            (first coll-byte+))
      (recur bus
             (rest coll-byte+))
      false)
    true))




(defn rd

  "Given an I2C bus, read 1 or n bytes.

   Returns nil if something goes wrong.
  
   ex.
     (rd bus
         2)"

  ([^RandomAccessFile bus]

   (try (.readUnsignedByte bus)
     (catch Throwable _
       nil)))


  ([^RandomAccessFile bus n]

   (try (let [ba (byte-array n)]
          (.read bus
                 ba)
          (-byte-array->seq ba))
     (catch Throwable _
       nil))))




(defn rd-reg

  "Prior to reading, select a registry.

   Cf. rd

   ex.
     (rd-reg bus
             0xaa
             2)"

  ([bus reg]

   (when (wr bus
             reg)
     (rd bus)))


  ([bus reg n]

   (when (wr bus
             reg)
     (rd bus
         n))))
