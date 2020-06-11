namespace au.id.cxd.Math.Http

open System
open System.Configuration
open System.Web
open System.Runtime.Caching
open System.Collections.Specialized
open System.Collections.Generic

(** application module **)

module Cache =

    
    (*
     values readable for memory limit include
     - cacheMemoryLimitMegabytes integer value specifying the maximum amount of memory available for caching before items are removed.
   The default is zero, which indicates that MemoryCache instances manage their own memory based 
       on the amount of memory that is installed on the computer.
          
     - physicalMemoryLimitPercentage integer value between 1 and 100 that specifies the percentage of physical memory
      available for caching before items are removed.
       The default is zero, which indicates that MemoryCache instances manage their own memory based 
       on the amount of memory that is installed on the computer.
    
    - pollingInterval a timespan string hh:mm:ss
    The time interval after which the cache implementation compares the current memory load against the absolute and 
    percentage-based memory limits that are set for the cache instance. 
    The default is two minutes.
    *)

    let configKeys = ConfigurationManager.AppSettings.AllKeys

    let fromConfig (key:string) =
        match (Array.Exists (configKeys, (fun item -> item.Equals(key))) ) with
        | false -> None
        | true -> Some (ConfigurationManager.AppSettings.Get(key))

    let cacheMemoryLimitMegabytes =
        match (fromConfig "cacheMemoryLimitMegabytes") with
        | Some item -> Convert.ToInt32(item)
        | _ -> 0
        
    let physicalMemoryLimitPercentage =
        match (fromConfig "physicalMemoryLimitPercentage") with
        | Some item -> Convert.ToInt32(item)
        | _ -> 0
        
    let pollingInterval =
        match (fromConfig "pollingInterval") with
        | Some item -> item
        | _ -> "00:02:00"

    let cache = 
        let cacheConfig = new System.Collections.Specialized.NameValueCollection()
        cacheConfig.Add("cacheMemoryLimitMegabytes", cacheMemoryLimitMegabytes.ToString())
        cacheConfig.Add("physicalMemoryLimitPercentage", physicalMemoryLimitPercentage.ToString())
        cacheConfig.Add("pollingInterval", pollingInterval)
        new MemoryCache ("mathui_cache", cacheConfig)
       
    let invalidatorList = new List<InvalidationChangeMonitor>()
       
    let invalidationMonitorList () = 
        let newMonitor = new InvalidationChangeMonitor(Guid.NewGuid())
        invalidatorList.Insert(0, newMonitor)
        invalidatorList
       
    /// a default caching policy
    let makeDefaultCachePolicy () =
        let policy = CacheItemPolicy ()
        policy.SlidingExpiration <- TimeSpan(0,30, 0)
        policy.ChangeMonitors.Add(invalidationMonitorList().[0])
        policy 
        
    /// store an item in cache with the defined policy
    let storeWithPolicy policy (name:string) (item:Object) = 
        let cacheItem = CacheItem (name, item)
        cache.Set (cacheItem, policy)
    
    /// store an item in cache using the default policy 
    let store (name:string) (item:Object) = storeWithPolicy (makeDefaultCachePolicy()) name item
                
    /// read an item from cache
    let read name = cache.GetCacheItem (name, null)
        
    /// read an item from the cache and return it as an option
    let maybeRead name = 
        let item = read name
        if item.Value = null then None
        else Some item.Value    
        
    /// remove an item from cache
    let remove name = cache.Remove(name, null)
    
    /// invalidate the cache
    let invalidate () =
        invalidationMonitorList().ToArray()
        |> Array.iter (fun item -> item.Dispose())
        
        
    
