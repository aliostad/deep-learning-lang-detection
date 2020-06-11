package rule

import (
    "fmt"
    "io/ioutil"
    "strings"
    "gopkg.in/yaml.v2"
    "github.com/mgutz/logxi/v1"
    "encoding/json"
    "util"
)

var Policies map[string]Policy
var DEFAULT = "default"
var MAX_TRY = 10
var CACHE_TTL = 10 //10 second
var policyCache = util.NewCache(CACHE_TTL)

type Target struct{
    Pool string
    Weight int
    Priority int
}

type Policy struct {
    Name string
    DispatchMap map[string][]Target `json:"dispatch"`
}

func findEntriesByRegion(policyName string, region Region, domain string, fromRedis bool)(entries []Entry, match string){
    if fromRedis {
        entries, match = findEntriesByRegionFromRedis(policyName, region, domain)
    }else{
        entries, match = findEntriesByRegionFromEtc(policyName, region, domain)
    }
    return entries, match
}

func findEntriesByRegionFromRedis(policyName string, region Region, domain string)(entries []Entry, match string){
    key := "/policies/" + policyName
    policyInCache, ok := policyCache.Get(key)
    if ok {
        return findEntries(policyInCache.(Policy), region, domain, true)
    }
    //if cache miss
    policyJson, err := client.Get(key).Result()
    if err != nil || policyJson == "" {
        log.Warn("can't find policy in redis", "key", key, "name", policyName, "err", err)
        return
    }
    policy := Policy{}
    json.Unmarshal([]byte(policyJson), &policy)
    policyCache.Put(key, policy)
    if log.IsDebug() {
        log.Debug("find policy in redis", "policy", policy)
    }
    return findEntries(policy, region, domain, true)
}

func findEntriesByRegionFromEtc(policyName string, region Region, domain string)(entries []Entry, match string){
    policy, ok := Policies[policyName]
    if !ok {
        log.Warn("can't find poilcy by name", "name", policyName)
        return
    }
    return findEntries(policy, region, domain, false)
}

func findEntries(policy Policy, region Region, domain string, fromRedis bool)(entries []Entry, match string){
    matchRegion := region.Region
    isp := region.Isp
    noMatch := false
    log.Debug("find entries by region", "region", fmt.Sprintf("%v", region))
    for i:=0;i<MAX_TRY;i++{
        dispatchKey := matchRegion + "@" + isp
        if noMatch {
            dispatchKey = DEFAULT + "@" + isp
            _, ok := policy.DispatchMap[dispatchKey]
            if !ok {
                dispatchKey = DEFAULT + "@" + DEFAULT
            }
        }
        targets, found := policy.DispatchMap[dispatchKey]
        if found{//找到了匹配的策略
            match = dispatchKey
            if log.IsDebug() {
                log.Debug("find match region", "region", dispatchKey, "pools", fmt.Sprintf("%v", targets))
            }
            entries = GetEntriesByTargets(targets, true, domain, region, fromRedis)
            break
        }
        if noMatch{
            break
        }
        l := strings.LastIndex(matchRegion, "/")
        if l < 0 {//-1 means no / exist
            noMatch = true
            continue
        }
        matchRegion = matchRegion[:l]
    }
    return
}

func LoadPolicies(confDir string)(err error){
    defer func(){
        if x := recover(); x != nil{
            fmt.Println("panic:", x)
        }
    }()
    dir, er := ioutil.ReadDir(confDir)
    if er != nil{
        err = er
        return
    }
    allPolices := map[string]Policy{}
    for _, file := range dir {
        if !file.IsDir() {
            if strings.HasSuffix(file.Name(), CONF_SUFFIX) {
                conf, er := ioutil.ReadFile(confDir + "/" + file.Name())
                if er != nil {
                    err = er
                    return
                }
                polices := map[string]map[string][]Target{}
                yaml.Unmarshal(conf, &polices)
                for name, dispatchMap := range polices {
                    policy := Policy{Name: name, DispatchMap: map[string][]Target{}}
                    for dname, dispatch := range dispatchMap {//根据配置生成掷色子队列
                        policy.DispatchMap[dname] = dispatch
                    }
                    allPolices[name] = policy
                }
                log.Info("policy config loaded", "file", file.Name())
                log.Debug("policy config detail", "result", fmt.Sprintf("%v", allPolices))
            }
        }
    }
    Policies = allPolices
    return
}



