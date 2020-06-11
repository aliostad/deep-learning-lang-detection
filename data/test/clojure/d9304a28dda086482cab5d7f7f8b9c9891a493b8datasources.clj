(ns core.datasources
  "Interface between core application code and external data sources."
  (:require
    [clojure.test :as tst :refer [is with-test]]
    [http.async.client :as http]
    [clojure.data.json :as jsn]
    [clojure.spec :as s]
    [clojure.spec.gen :as gen]
    [clojure.spec.test :as ts :refer [check]]
    [clojure.spec.gen :as gen]
    [core.utils :as u]
    [clojure.core.async :as casy :refer [<!! <! >! go]]
    [stub-http.core :refer :all]))

;#General

(with-test

  (defn http-body-cas 
    "http request that requires a body such as POST and PUT, returns a channel"
    [url headers body method]
    (go 
      (with-open [client (http/create-client)]
        (let [resp (method client
                           url
                           :headers headers 
                           :body (jsn/write-str body))]
          (http/await resp)
          (jsn/read-str (http/string resp) :key-fn keyword))))) 

  (with-routes!
    {"/something" {:status 200 :content-type "application/json"
                   :body   (jsn/write-str {:hello "world"})}}
    (is 
      (= "world" (:hello (<!! (http-body-cas (str uri "/something") {} {} http/POST)))))))

(with-test 

  (defn http-cas 
    "http request that doesn't require a body such as GET, returns a channel"
    [url headers method]
    (with-open [client (http/create-client)]
      (let [resp (method client
                         url
                         :headers headers)]
        (http/await resp)
        (go (jsn/read-str (http/string resp) :key-fn keyword))))) 

  (is 
    (= "world" (u/basic-stub (fn [uri] (http-cas uri {} http/GET))))))


;#Cryptocompare 

(def cryptocompare-syms 
  "All the symbols provided by cryptocompare." 
  #{"MCN" "FRN" "SDP" "DGORE" "HYP" "PAK" "2BACCO" "CPC" "NEOS" "GRN" "TWLV" "MND" "RIPO" "VTA" "HAL" "RCX" "ENRG" "1337" "NUBIS" "LANA" "BEN" "2015" "ZRC" "IOC" "CJ" "CDX" "BST" "SQL" "VPRC" "NRS" "BTCRY" "STEPS" "CNL" "LQD" "DT" "ADZ" "HALLO" "1CR" "DASH" "EQUAL" "MST" "BYC" "BSTY" "XT" "NTC" "XHI" "SOLE" "MINT" "TRIG" "CRW" "LAB" "BAY" "RISE" "RZR" "GEN" "CACH" "CLINT" "WBB" "UIS" "BTCL" "SNRG" "REP" "MOIN" "QTL" "ISL" "XBOT" "ANS" "NEU" "SC" "MOOND" "CYP" "START" "OK" "GP" "BCR" "NRB" "MC" "EDRC" "GAY" "BOTS" "611" "EQM" "VRC" "GRS" "SH" "CRBIT" "KEY" "MIL" "ARG" "RT2" "OC" "GOON" "LXC" "MSC" "GB" "DGD" "ROYAL" "BLC" "LSD" "GAP" "CRX" "FTP" "1ST" "RDD" "ADCN" "LTB" "CHILD" "NXTI" "TAGR" "NEBU" "XPM" "MUE" "AERO" "CRE" "NYAN" "FIRE" "MRP" "UTIL" "NZC" "COC" "UNC" "NAUT" "CRACK" "CMC" "DIME" "CC" "CHOOF" "BLK" "FCT" "TEAM" "FLT" "SBD" "SWEET" "WOLF" "BM" "MAPC" "HZ" "PYC" "ZOOM" "ALF" "42" "XNX" "TELL" "ERC" "TRON" "SWIFT" "NOTE" "DKC" "ANTI" "CKC" "SRC" "AMP" "007" "GIVE" "EMIGR" "TRUST" "MYR" "EKN" "EXCL" "CLR" "CALC" "YOC" "PSEUD" "GRT" "GPU" "DOT" "UNB" "C2" "CBX" "QTZ" "LYC" "XRE" "CTC" "DTC" "ERB" "CHASH" "AMC" "BOB" "SKB" "LC" "LEA" "DB" "NKC" "MI" "XCR" "XMG" "LYB" "ELE" "CRC" "AEC" "WC" "LTC" "QRK" "PKB" "XWT" "DCNT" "TOR" "CHA" "FRC" "CURE" "CIN" "LDOGE" "NSR" "SYNC" "EAGS" "TRI" "SHLD" "SAK" "NANAS" "BNCR" "GLX" "CAM" "VTR" "GMC" "CYT" "SFE" "CARBON" "ZED" "SBC" "AIB" "DEUR" "SCT" "CIRC" "BCN" "NMC" "BITB" "XTC" "TMC" "STO" "QBK" "BCX" "VRM" "AEON" "CSC" "KMD" "VTC" "ALN" "NAV" "LBC" "PEERPLAYS" "ZNY" "JBS" "ROS" "BTC" "VIA" "BURST" "MG" "AND" "XAI" "DLISK" "NKT" "CLUB" "LTH" "UNAT" "DBG" "IBANK" "BYTES" "GSY" "EDC" "EXP" "SPC" "KGC" "XDN" "XUP" "BLU" "ETH" "BTG" "GROW" "GCC" "CINNI" "MMC" "AIR" "EC" "VIP" "STR*" "TEK" "XXX" "GCR" "DGDC" "SLG" "KOBO" "SAT2" "LGBTQ" "UNITY" "BET" "UNIQ" "XCE" "MOON" "FFC" "ASN" "XID" "HODL" "GLOBE" "MAX" "GRC" "SLS" "OCTO" "MNM" "JUDGE" "BTE" "SCRPT" "TRK" "FSC2" "RMS" "VLT" "XPH" "TDFB" "STEEM" "DEM" "PSY" "RUST" "MEME" "CON" "JKC" "BLOCKPAY" "HKG" "ELC" "PXL" "ZCC" "ORB" "RCN" "STHR" "BAC" "XC" "OBITS" "SWING" "DGC" "THC" "FLAP" "MONETA" "XPY" "NTRN" "VAPOR" "APC" "ORLY" "MONA" "NUM" "DSB" "J" "WGC" "JOBS" "CLV" "OPAL" "SPOTS" "BOOM" "ARCH" "MED" "BQC" "TES" "EAC" "KUBO" "SXC" "SSD" "HTC" "PWR" "PINK" "CUBE" "CRYPT" "XVG" "BUK" "VPN" "EVENT" "INV" "SMLY" "PDC" "ACOIN" "INCP" "CRAFT" "GSM" "FOREX" "SEN" "PBC" "BTX" "EMC2" "HILL" "HVC" "UTH" "LSK" "BUCKS" "SUPER" "VTX" "KRAK" "STS" "RYC" "FC2" "LEMON" "DIGS" "XBS" "TX" "SPRTS" "OMNI" "NEC" "MPRO" "BBCC" "OMC" "RPC" "XWC" "BLOCK" "SLING" "ARDR" "XMS" "CF" "GRID" "LFC" "ANC" "CFC" "N7" "COOL" "TCR" "PIZZA" "SDC" "PRE" "TTC" "PRIME" "KARM" "VERSA" "ETC" "DGB" "NAN" "XRP" "X2" "BRK" "TOT" "DISK" "WDC" "TRA" "SMAC" "GDC" "MUDRA" "NBT" "MDC" "JIF" "FLY" "FCN" "EXB" "CHESS" "DVC" "MARV" "BTMI" "2FLAV" "PRM" "DNET" "CLOAK" "PTS" "MIN" "EGO" "BERN" "XRA" "INFX" "REE" "ULTC" "BELA" "SOUL" "LIMX" "VOOT" "GAIA" "XG" "DCR" "HNC" "FX" "JPC" "CAP" "LUX" "VEC2" "SMSR" "GIG" "RING" "GRM" "DRZ" "XAU" "M1" "GBT" "RBIT" "SCRT" "GIZ" "TODAY" "KAT" "TAG" "ZET2" "DROP" "COX" "SPHR" "XAUR" "ZYD" "RBT" "FCS" "BRONZ" "SCN" "SCOT" "QSLV" "B3" "POLY" "INCH" "OMA" "ANTC" "AC" "MMNXT" "SPM" "TUR" "MRS" "COV" "SIGU" "HBN" "TIA" "GHC" "WAY" "CHIP" "DMD" "DES" "FRK" "DIEM" "TAM" "SUP" "PXC" "DRKT" "CANN" "UNIT" "XZC" "CNMT" "CYG" "CTO" "QORA" "GLYPH" "SPX" "GLD" "OLYMP" "BTD" "XMR" "2GIVE" "XDE2" "CAT" "PRC" "LAZ" "TRUMP" "FONZ" "CRNK" "DCC" "KTK" "ENE" "COVAL" "UFO" "RRT" "GRAV" "SMC" "DLC" "FLO" "EGG" "CXC" "ION" "LK7" "GMX" "HMP" "KRB" "PHS" "BTA" "EXIT" "SPORT" "HVCO" "STRAT" "LOG" "LTCD" "RDN" "TKN" "VIOR" "UBIQ" "CSH" "REV" "RIC" "EGC" "BIOS" "HIRE" "BITUSD" "GML" "ICN" "BITCNY" "FRAC" "ACP" "FAIR" "CYC" "MN" "DOGE" "MZC" "NOBL" "AUR" "CASH" "FIBRE" "MARS" "OSC" "FRWC" "BOST" "BUZZ" "EVIL" "CRAIG" "KORE" "SOON" "CESC" "LTCX" "DANK" "KRC" "LKY" "AGS" "GREXIT" "GHS" "XDB" "GLC" "SHF" "GOTX" "ICB" "VIRAL" "NEVA" "PSI" "MAID" "BITS" "PSB" "CLUD" "RBR" "CGA" "VOX" "SLM" "GNJ" "XDP" "MMXIV" "BON" "NBL" "BITZ" "XLB" "GPL" "404" "XFC" "STR" "EZC" "NAS2" "TIT" "FJC" "WINGS" "CLAM" "BTCR" "ZNE" "XQN" "CRAB" "DCK" "BTM" "USDE" "COIN" "XST" "XNA" "MYST" "DSH" "NXS" "XCP" "SNS" "GEO" "DBTC" "SLR" "NVC" "CNC" "TENNET" "ARM" "TRC" "RBY" "XBC" "PIO" "I0C" "ZUR" "BCY" "NKA" "SPACE" "AXR" "32BIT" "FLDC" "HYPER" "BIGUP" "GUE" "EMD" "SANDG" "SPR" "MNE" "POST" "IXC" "NXTTY" "BHC" "WEX" "WAVES" "EDGE" "BTS" "ZEIT" "BSC" "GAME" "NET" "SYS" "IVZ" "KNC" "CCN" "ATM" "SONG" "TAB" "UNO" "STA" "STV" "MWC" "LTBC" "ZET" "HUGE" "DCS." "VMC" "MT" "XCO" "CAIX" "YBC" "RADS" "XEM" "BTQ" "BXT" "LGD" "HEAT" "OLDSF" "COMM" "NLC" "WMC" "GHOUL" "ROOT" "EXE" "METAL" "NODE" "BEATS" "CRAVE" "MRY" "CREVA" "SSTC" "FLX" "XPD" "MOJO" "MARYJ" "MEC" "ARI" "ETHS" "AMS" "VOYA" "SJCX" "SILK" "LIR" "SEC" "CV2" "SYNX" "SIB" "SOIL" "SAR" "DBIC" "TGC" "GBRC" "BLITZ" "DOPE" "BTB" "BLRY" "DOGED" "LYKKE" "POINTS" "U" "CAB" "XDQ" "SPEC" "RBIES" "GAM" "MTR" "ICASH" "SPA" "UTC" "GEMZ" "XVC" "XSI" "FTC" "EMC" "AXIOM" "LTS" "HEDG" "BS" "ENTER" "BBR" "VTY" "ADC" "DPAY" "PEC" "FUZZ" "KR" "UNF" "PUTIN" "BIT16" "POT" "SNGLS" "EPY" "PNK" "CMT" "NMB" "NXT" "FSN" "GSX" "808" "IFC" "OBS" "BFX" "BTCD" "BRAIN" "DUB" "BNT" "VDO" "YAC" "PULSE" "ABY" "ZEC" "BOLI" "MYC" "ADN" "SPT" "YOVI" "RUBIT" "EBS" "HCC" "ARB" "PTC" "ATOM" "FUTC" "QCN" "NXE" "SWARM" "CETI" "NETC" "ANNC" "888" "DRKC" "DRACO" "GRAM" "APEX" "AM" "KDC" "SFR" "XPOKE" "STAR" "HUC" "8BIT" "CELL" "EFL" "TAK" "FST" "SHREK" "SHADE" "EKO" "XCN" "FIT" "PXI" "SSV" "PINKX" "MINE" "XPB" "PIGGY" "URO" "XSEED" "NLG" "JWL" "XPO" "MNC" "PPC" "WARP" "BSD" "XCASH" "XJO" "AMBER"})

(s/def ::cryptocomapre-sym cryptocompare-syms)

(s/def ::fiat-sym #{"USD" "GBP" "EUR"})

(s/def ::timescale #{"histominute" "histohour" "histoday"})

(s/fdef cryptocompare-url-gen
        :args (s/cat :fsym ::cryptocomapre-sym :tsym ::fiat-sym
                     :timescale ::timescale :limit #(> 1001 %  0))
        :ret ::u/url)

(defn cryptocompare-url-gen 
   "Generate url to grab historical data from cryptocompare." 
    [fsym tsym timescale limit & exchange]
      (str
        "https://www.cryptocompare.com/api/data/"
        timescale
        (if (first exchange) (str "/?e=" (first exchange)) "/?e=CCCAGG")
        "&fsym=" fsym
        "&tsym=" tsym
        "&limit=" limit))

(defn cryptocompare-hist 
   "Get crypto compare history nicely processed." 
    [fsym tsym timescale limit & exchange]
      (as-> (cryptocompare-url-gen fsym tsym timescale limit (when exchange (first exchange))) x
            (u/json-get x)
            (:Data x)
            (u/update-all-vals x [:time] long)
            (u/rename-all-keys x :time :unixtimestamp)))

;#Oanda 

(def oanda-api-key (System/getenv "OANDA_API_KEY"))

(def rest-api-base "https://api-fxpractice.oanda.com/v1/")

(def rest-api-base-v3 "https://api-fxpractice.oanda.com/v3/")

(def streaming-api-base "https://stream-fxpractice.oanda.com/v3/")

(def account-no (System/getenv "OANDA_ACCOUNT_NO"))

(s/def ::oanda-instruments #{"EUR_USD"})

(s/def ::highBid number?)
(s/def ::lowBid number?)
(s/def ::openAsk number?)
(s/def ::closeAsk number?)
(s/def ::openBid number?)
(s/def ::highAsk number?)
(s/def ::closeBid number?)
(s/def ::lowAsk number?)
(s/def ::time ::u/timestamp)

(s/def ::oanda-candle (s/keys :req-un [::highBid ::time ::lowBid ::openAsk ::closeAsk ::openBid ::highAsk
                                       ::closeBid ::lowAsk]))

(s/fdef oanda-candle->standard
        :args (s/cat :oanda-candle ::oanda-candle)
        :ret ::u/standard-candle)

(defn oanda-candle->standard 
    "Convert oanda candle to standard candle"
  [oanda-candle]
  (let [{:keys [highBid time lowBid openAsk closeAsk openBid highAsk closeBid lowAsk]} oanda-candle]
    {:unixtimestamp (u/timestamp->unix time)
     :open (u/average openAsk openBid)
     :low (u/average lowBid lowAsk)
     :high (u/average highAsk highBid)
     :close (u/average closeAsk closeBid)}))

    (defn oanda-price-stream-start 
      "Start a stream of real time price data from oanda" 
      [client callback instrument]
      (let [resp (http/stream-seq client
                                  :get (str
                                         "https://stream-fxpractice.oanda.com/v3/"
                                         "accounts/"
                                         account-no
                                         "/pricing"
                                         "/stream")
                                  :headers {:Authorization (str "Bearer " oanda-api-key)}
                                  :query {:instruments instrument})]

        (when-let [err (http/error resp)]
          (println "failed processing request: " err))

        (doseq [s (http/string resp)]
          (callback s))))

(defn oanda-price-stream-chan 
   "Oanda price stream with results placed onto supplied channel." 
    [client instrument chan]
      (go
        (let [resp (http/stream-seq client
                                    :get (str
                                           "https://stream-fxpractice.oanda.com/v3/"
                                           "accounts/"
                                           account-no
                                           "/pricing"
                                           "/stream")
                                    :headers {:Authorization (str "Bearer " oanda-api-key)}
                                    :query {:instruments instrument})]

             (when-let [err (http/error resp)]
                       (println "failed processing request: " err))

             (doseq [s (http/string resp)]
                    (>! chan s)))))

(with-test 

  (defn oanda-historical
    "[EUR_USD 5000 M1]. Converts oanda data to standard candles."
    [instrument count granularity]
    (->>
      (u/json-get
        (str rest-api-base "candles")
        {:headers {:Authorization (str "Bearer " oanda-api-key)}
         :query-params {"instrument" instrument
                        "count" count
                        "granularity" granularity}})
      :candles
      (map oanda-candle->standard))) 

  (is 
    (s/valid? (s/coll-of ::u/standard-candle) (oanda-historical "EUR_USD" "10" "M5"))))

(defn oanda-historical-raw
      "EUR_USD 5000 M1"
      [instrument count granularity]
      (->>
        (u/json-get
          (str rest-api-base "candles")
          {:headers {:Authorization (str "Bearer " oanda-api-key)}
           :query-params {"instrument" instrument
                          "count" count
                          "granularity" granularity}})
        :candles))

(defn order-gen 
  "Order map for placing an order with oanda"
  [units instrument]
  {:order {:units units
           :instrument instrument
           :timeInForce "FOK"
           :type "MARKET"
           :positionFill "DEFAULT"}})

(defn stop-loss-gen
  "Stop loss map for placing a stop loss with an oanda order" 
  [stoploss]
  {:stopLossOnFill {:price stoploss 
                    :timeInForce "GTC"}})

(defn oanda-order-header-gen 
  "Request header map for placing an order with oanda" 

  ([] 
   (oanda-order-header-gen oanda-api-key))

  ([oanda-api-key]
   {:Authorization (str "Bearer " oanda-api-key)
    :Content-type "application/json"}))

(with-test 

  (defn oanda-open-order-cas! 
    "Open oanda order e.g. [EUR_USD 100], optional stop loss and url can be provided. Default url will use ACCOUNT_NO envvar" 

    ([instrument units]
     (oanda-open-order-cas! instrument units :url (str rest-api-base-v3 "accounts/" account-no "/orders")))

    ([instrument units & opts]
     (let [{:keys [url stoploss]} opts]
       (cond
         (and url stoploss) (http-body-cas  
                              url 
                              (oanda-order-header-gen)
                              (update-in (order-gen units instrument) [:order] merge (stop-loss-gen stoploss))
                              http/POST) 

         (and url (not stoploss)) (http-body-cas url (oanda-order-header-gen) (order-gen units instrument) http/POST) 

         (and (not url) stoploss) (http-body-cas  
                                    (str rest-api-base-v3 "accounts/" account-no "/orders")
                                    (oanda-order-header-gen)
                                    (update-in (order-gen units instrument) [:order] merge (stop-loss-gen stoploss))
                                    http/POST) 

         :else (throw (Exception. "oanda-open-order-cas cond failed")))))) 

  (is 
    (with-routes! {"/something" {:status 200 :content-type "text/plain" :body (jsn/write-str {:hi "there"})}}
      (<!! (oanda-open-order-cas! "EUR_USD" 100 :url (str uri "/something") :stoploss 123.233))
      (let [requests (recorded-requests server)
            order (:order (u/mock-req->body-data (first requests)))]
        (contains? order :stopLossOnFill))))

  (is 
    (with-routes! {"/something" {:status 200 :content-type "text/plain" :body (jsn/write-str {:hi "there"})}}
      (<!! (oanda-open-order-cas! "EUR_USD" 100 :url (str uri "/something")))
      (let [requests (recorded-requests server)
            order (:order (u/mock-req->body-data (first requests)))]
        (and 
          (not (contains? order :stopLossOnFill))
          (contains? order :positionFill))))))

(defn oanda-patch-order-cas 
  "Update an order, placing result on provided channel" 
  [chan tradeid stoploss]
  (with-open [client (http/create-client)]
    (let [resp (http/PUT client
                         (str rest-api-base-v3 "accounts/" account-no "/trades/" tradeid "/orders/")
                         :headers {:Authorization (str "Bearer " oanda-api-key)
                                   :Content-type "application/json"}
                         :body (jsn/write-str {:stopLoss {:price stoploss}}))]
      (http/await resp)
      (go (>! chan (jsn/read-str (http/string resp) :key-fn keyword))))))

(defn order-info 
  "Get info on an order by its order id, place the result on provided channel." 
  [chan orderid]
  (with-open [client (http/create-client)]
    (let [resp (http/GET client
                         (str rest-api-base-v3 "accounts/" account-no "/orders/" orderid)
                         :headers {:Authorization (str "Bearer " oanda-api-key)
                                   :Content-type "application/json"})]
      (http/await resp)
      (go (>! chan  (jsn/read-str (http/string resp) :key-fn keyword))))))

(defn get-orders 
  "Get current orders, place result on provided channel." 
  [chan]
  (with-open [client (http/create-client)]
    (let [resp (http/GET client
                         (str rest-api-base-v3 "accounts/" account-no "/orders")
                         :headers {:Authorization (str "Bearer " oanda-api-key)
                                   :Content-type "application/json"})]
      (http/await resp)
      (go (>! chan  (jsn/read-str (http/string resp) :key-fn keyword))))))

(defn acc-info 
  "Get account info, place result on provided chan." 
  [chan]
  (with-open [client (http/create-client)]
    (let [resp (http/GET client
                         (str rest-api-base-v3 "accounts/" account-no)
                         :headers {:Authorization (str "Bearer " oanda-api-key)
                                   :Content-type "application/json"})]
      (http/await resp)
      (go (>! chan  (jsn/read-str (http/string resp) :key-fn keyword))))))

(defn trade-info 
  "Get info on a particular trade, result placed on provided chan." 
  [chan tradeid]
  (with-open [client (http/create-client)]
    (let [resp (http/GET client
                         (str rest-api-base-v3 "accounts/" account-no "/trades/" tradeid)
                         :headers {:Authorization (str "Bearer " oanda-api-key)
                                   :Content-type "application/json"})]
      (http/await resp)
      (go (>! chan  (jsn/read-str (http/string resp) :key-fn keyword))))))

(defn oanda-history-cas 
  "Get historical candle data from oands, result placed on provided chan." 
  [chan instrument count timeframe]
  (with-open [client (http/create-client)]
    (let [resp (http/GET client (str rest-api-base "candles")
                         :query {:instrument instrument :count count :granularity timeframe})]
      (http/await resp)
      (go
        (>! chan
            (->>
              (jsn/read-str (http/string resp) :key-fn keyword)
              :candles
              (map oanda-candle->standard)))))))

(defn oanda-hist->standard-candle 
  "Convert a series of oanda historical candles into standard candles." 
  [candles]
  (->
    candles
    (u/update-all-vals [:time] u/timestamp->unix)
    (u/rename-all-keys :time :unixtimestamp)))

;#Kraken
    
(def kraken-api-base "api.kraken.com")

(defn kraken-hist
      "XBTUSD 1440"
      [curr-pair interval]
      (:result (u/json-get
                 "https://api.kraken.com/0/public/OHLC"
                 {:query-params {:pair curr-pair :interval interval}})))

(defn kraken-hist->standard [kraken-candles]
      (map
        (fn [[time open high low close vwap volume count]]
            {:unixtimestamp (* 1000 time)
             :open (read-string open)
             :high (read-string high)
             :low (read-string low)
             :close (read-string close)})
        kraken-candles))

