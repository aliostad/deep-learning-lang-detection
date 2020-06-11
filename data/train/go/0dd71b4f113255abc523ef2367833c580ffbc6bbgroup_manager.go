package main

import "sync"
import "strconv"
import "strings"
import "time"
import "fmt"
import "math/rand"
import "database/sql"
import "github.com/garyburd/redigo/redis"
import _ "github.com/go-sql-driver/mysql"
import log "github.com/golang/glog"

//同redis的长链接保持5minute的心跳
const SUBSCRIBE_HEATBEAT = 30

type GroupObserver interface {
	OnGroupMemberAdd(g *Group, uid int64)
	OnGroupMemberRemove(g *Group, uid int64)
}

type GroupManager struct {
	mutex  sync.Mutex
	groups map[int64]*Group
	observer GroupObserver
	ping     string
}

func NewGroupManager() *GroupManager {
	fmt.Println("群管理1")
	now := time.Now().Unix()
	r := fmt.Sprintf("ping_%d", now)
	fmt.Println("群管理2")
	for i := 0; i < 4; i++ {
		n := rand.Int31n(26)
		fmt.Println(n)
		r = r + string('a' + n)
	}
	fmt.Println("群管理3")
	m := new(GroupManager)
	m.groups = make(map[int64]*Group)
	fmt.Println("群管理4")
	m.ping = r
	fmt.Println("r: ", r)
	fmt.Println("m: ", m)
	return m
}
// 获取所有群的数组
func (group_manager *GroupManager) GetGroups() []*Group{
	group_manager.mutex.Lock()
	defer group_manager.mutex.Unlock()

	groups := make([]*Group, 0, len(group_manager.groups))
	for _, group := range(group_manager.groups) {
		groups = append(groups, group)
	}
	return groups
}
// 查找群
func (group_manager *GroupManager) FindGroup(gid int64) *Group {
	group_manager.mutex.Lock()
	defer group_manager.mutex.Unlock()
	if group, ok := group_manager.groups[gid]; ok {
		return group
	}
	return nil
}
// 根据appid和uid查找群
func (group_manager *GroupManager) FindUserGroups(appid int64, uid int64) []*Group {
	group_manager.mutex.Lock()
	defer group_manager.mutex.Unlock()

	groups := make([]*Group, 0, 4)
	for _, group := range group_manager.groups {
		if group.appid == appid && group.IsMember(uid) {
			groups = append(groups, group)
		}
	}
	return groups
}
// 处理创建群
func (group_manager *GroupManager) HandleCreate(data string) {
	arr := strings.Split(data, ",")
	if len(arr) != 3 {
		log.Info("message error:", data)
		return
	}
	gid, err := strconv.ParseInt(arr[0], 10, 64)
	if err != nil {
		log.Info("error:", err)
		return
	}
	appid, err := strconv.ParseInt(arr[1], 10, 64)
	if err != nil {
		log.Info("error:", err)
		return
	}
	super, err := strconv.ParseInt(arr[2], 10, 64)
	if err != nil {
		log.Info("error:", err)
		return
	}

	group_manager.mutex.Lock()
	defer group_manager.mutex.Unlock()

	if _, ok := group_manager.groups[gid]; ok {
		log.Infof("group:%d exists\n", gid)
	}
	log.Infof("create group:%d appid:%d", gid, appid)
	if super != 0 {
		group_manager.groups[gid] = NewSuperGroup(gid, appid, nil)
	} else {
		group_manager.groups[gid] = NewGroup(gid, appid, nil)
	}
}
// 处理解散群
func (group_manager *GroupManager) HandleDisband(data string) {
	gid, err := strconv.ParseInt(data, 10, 64)
	if err != nil {
		log.Info("error:", err)
		return
	}

	group_manager.mutex.Lock()
	defer group_manager.mutex.Unlock()
	if _, ok := group_manager.groups[gid]; ok {
		log.Info("disband group:", gid)
		delete(group_manager.groups, gid)
	} else {
		log.Infof("group:%d nonexists\n", gid)
	}
}
// 处理添加群成员
func (group_manager *GroupManager) HandleMemberAdd(data string) {
	arr := strings.Split(data, ",")
	if len(arr) != 2 {
		log.Info("message error")
		return
	}
	gid, err := strconv.ParseInt(arr[0], 10, 64)
	if err != nil {
		log.Info("error:", err)
		return
	}
	uid, err := strconv.ParseInt(arr[1], 10, 64)
	if err != nil {
		log.Info("error:", err)
		return
	}

	group := group_manager.FindGroup(gid)
	if group != nil {
		group.AddMember(uid)
		if group_manager.observer != nil {
			group_manager.observer.OnGroupMemberAdd(group, uid)
		}
		log.Infof("add group member gid:%d uid:%d", gid, uid)
	} else {
		log.Infof("can't find group:%d\n", gid)
	}
}
// 处理成员移除
func (group_manager *GroupManager) HandleMemberRemove(data string) {
	arr := strings.Split(data, ",")
	if len(arr) != 2 {
		log.Info("message error")
		return
	}
	gid, err := strconv.ParseInt(arr[0], 10, 64)
	if err != nil {
		log.Info("error:", err)
		return
	}
	uid, err := strconv.ParseInt(arr[1], 10, 64)
	if err != nil {
		log.Info("error:", err)
		return
	}

	group := group_manager.FindGroup(gid)
	if group != nil {
		group.RemoveMember(uid)
		if group_manager.observer != nil {
			group_manager.observer.OnGroupMemberRemove(group, uid)
		}
		log.Infof("remove group member gid:%d uid:%d", gid, uid)
	} else {
		log.Infof("can't find group:%d\n", gid)
	}
}
// 重新加载群
func (group_manager *GroupManager) ReloadGroup() bool {
	log.Info("reload group...")
	db, err := sql.Open("mysql", config.mysqldb_datasource)
	if err != nil {
		log.Info("error:", err)
		return false
	}
	defer db.Close()

	groups, err := LoadAllGroup(db)
	if err != nil {
		log.Info("error:", err)
		return false
	}

	group_manager.mutex.Lock()
	defer group_manager.mutex.Unlock()
	group_manager.groups = groups

	return true
}

func (group_manager *GroupManager) Reload() {
	//循环直到成功
	fmt.Println("开始循环.....")
	for {
		r := group_manager.ReloadGroup()
		if r {
			break
		}
		time.Sleep(1 * time.Second)
		fmt.Println("循环了一次")
	}
}
// 执行一次
func (group_manager *GroupManager) RunOnce() bool {
	t := redis.DialReadTimeout(time.Second*SUBSCRIBE_HEATBEAT)
	c, err := redis.Dial("tcp", config.redis_address, t)
	if err != nil {
		log.Info("dial redis error:", err)
		return false
	}

	password := config.redis_password
	if len(password) > 0 {
		if _, err := c.Do("AUTH", password); err != nil {
			c.Close()
			return false
		}
	}

	psc := redis.PubSubConn{c}
	psc.Subscribe("group_create", "group_disband", "group_member_add", "group_member_remove", group_manager.ping)
	group_manager.Reload()
	for {
		switch v := psc.Receive().(type) {
		case redis.Message:
			if v.Channel == "group_create" {
				group_manager.HandleCreate(string(v.Data))
			} else if v.Channel == "group_disband" {
				group_manager.HandleDisband(string(v.Data))
			} else if v.Channel == "group_member_add" {
				group_manager.HandleMemberAdd(string(v.Data))
			} else if v.Channel == "group_member_remove" {
				group_manager.HandleMemberRemove(string(v.Data))
			} else {
				log.Infof("%s: message: %s\n", v.Channel, v.Data)
			}
		case redis.Subscription:
			log.Infof("%s: %s %d\n", v.Channel, v.Kind, v.Count)
		case error:
			log.Info("error:", v)
			return true
		}
	}
}

func (group_manager *GroupManager) Run() {
	nsleep := 1
	for {
		connected := group_manager.RunOnce()
		if !connected {
			nsleep *= 2
			if nsleep > 60 {
				nsleep = 60
			}
		} else {
			nsleep = 1
		}
		time.Sleep(time.Duration(nsleep) * time.Second)
	}
}

func (group_manager *GroupManager) Ping() {
	conn := redis_pool.Get()
	defer conn.Close()

	_, err := conn.Do("PUBLISH", group_manager.ping, "ping")
	if err != nil {
		log.Info("ping error:", err)
	}
}

// PING的循环
func (group_manager *GroupManager) PingLoop() {
	for {
		group_manager.Ping()
		time.Sleep(time.Second*(SUBSCRIBE_HEATBEAT-10))
	}
}

func (group_manager *GroupManager) Start() {
	group_manager.Reload()
	fmt.Println("群管理重载")
	go group_manager.Run()
	fmt.Println("群管理启动")
	go group_manager.PingLoop()
	fmt.Println("群管理pingloop")
}
