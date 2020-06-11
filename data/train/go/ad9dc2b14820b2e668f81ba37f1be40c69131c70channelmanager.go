package middleware

import (
	base "core/base"
	"errors"
	"fmt"
	"sync"
)

// 被用来表示通道管理器状态的类型
type MKChannelManagerStatus uint8

const (
	CHANNEL_MANAGER_STATUS_UNINITIALIZED MKChannelManagerStatus = 0 // 未初始化状态
	CHANNEL_MANAGER_STATUS_INITIALIZED   MKChannelManagerStatus = 1 // 已初始化状态
	CHANNEL_MANAGER_STATUS_CLOSED        MKChannelManagerStatus = 2 // 已关闭状态
)

// 表示状态代码与状态名称之间的映射关系表
var statusNameMap = map[MKChannelManagerStatus]string{
	CHANNEL_MANAGER_STATUS_UNINITIALIZED: "uninitialized",
	CHANNEL_MANAGER_STATUS_INITIALIZED:   "initialized",
	CHANNEL_MANAGER_STATUS_CLOSED:        "closed",
}

// 通道管理器接口
type MKChannelManager interface {

	// 初始化通道管理器
	// 参数channelArguments代表通道参数的容器
	// 参数reset指明是否重新初始化通道管理器
	Init(channelArguments base.ChannelArguments, reset bool) bool

	// 关闭通道管理器
	Close() bool

	// 获取请求传输通道
	RequestChannel() (chan base.MKRequest, error)

	// 获取响应传输通道
	ResponseChannel() (chan base.MKResponse, error)

	// 获取条目传输通道
	ItemChannel() (chan base.MKItem, error)

	// 获取错误传输通道
	ErrorChannel() (chan error, error)

	// 获取通道管理器状态
	Status() MKChannelManagerStatus

	// 获取摘要信息
	Summary() string
}

// 创建通道管理器
func NewChannelManager(channelArguments base.ChannelArguments) MKChannelManager {
	chanman := &mk_channelManager{}
	chanman.Init(channelArguments, true)
	return chanman
}

// 通道管理器的实现类型
type mk_channelManager struct {
	channelArguments base.ChannelArguments  // 通道参数的容器
	requestChannel   chan base.MKRequest    // 请求通道
	responseChannel  chan base.MKResponse   // 响应通道
	itemChannel      chan base.MKItem       // 条目通道
	errorChannel     chan error             // 错误通道
	status           MKChannelManagerStatus // 通道管理器的状态
	mutex            sync.RWMutex           // 读写锁
}

func (manager *mk_channelManager) Init(arguments base.ChannelArguments, reset bool) bool {
	if err := arguments.Check(); err != nil {
		panic(err)
	}

	manager.mutex.Lock()
	defer manager.mutex.Unlock()

	if manager.status == CHANNEL_MANAGER_STATUS_INITIALIZED && !reset {
		return false
	}

	manager.channelArguments = arguments
	manager.requestChannel = make(chan base.MKRequest, arguments.RequestChannelLength())
	manager.responseChannel = make(chan base.MKResponse, arguments.ResponseChannelLength())
	manager.itemChannel = make(chan base.MKItem, arguments.ItemChannelLength())
	manager.errorChannel = make(chan error, arguments.ErrorChannelLength())
	manager.status = CHANNEL_MANAGER_STATUS_INITIALIZED

	return true
}

func (manager *mk_channelManager) Close() bool {
	manager.mutex.Lock()
	defer manager.mutex.Unlock()

	if manager.status != CHANNEL_MANAGER_STATUS_INITIALIZED {
		return false
	}

	close(manager.requestChannel)
	close(manager.responseChannel)
	close(manager.itemChannel)
	close(manager.errorChannel)

	manager.status = CHANNEL_MANAGER_STATUS_CLOSED

	return true
}

func (manager *mk_channelManager) RequestChannel() (chan base.MKRequest, error) {

	manager.mutex.Lock()
	defer manager.mutex.Unlock()

	if err := manager.checkStatus(); err != nil {
		return nil, err
	}

	return manager.requestChannel, nil
}

func (manager *mk_channelManager) ResponseChannel() (chan base.MKResponse, error) {

	manager.mutex.Lock()
	defer manager.mutex.Unlock()

	if err := manager.checkStatus(); err != nil {
		return nil, err
	}

	return manager.responseChannel, nil
}

func (manager *mk_channelManager) ItemChannel() (chan base.MKItem, error) {

	manager.mutex.Lock()
	defer manager.mutex.Unlock()

	if err := manager.checkStatus(); err != nil {
		return nil, err
	}

	return manager.itemChannel, nil
}

func (manager *mk_channelManager) ErrorChannel() (chan error, error) {

	manager.mutex.Lock()
	defer manager.mutex.Unlock()

	if err := manager.checkStatus(); err != nil {
		return nil, err
	}

	return manager.errorChannel, nil
}

// 检查状态
// 在获取通道的时候，通道管理器应处于已初始化状态。
// 如果通道管理器未处于已初始化状态，那么本方法将会返回一个非nil的错误
func (manager *mk_channelManager) checkStatus() error {
	if manager.status == CHANNEL_MANAGER_STATUS_INITIALIZED {
		return nil
	}

	statusName, ok := statusNameMap[manager.status]
	if !ok {
		statusName = fmt.Sprintf("%d", manager.status)
	}

	errMsg := fmt.Sprintf("通道管理器的不可取状态: %s\n", statusName)

	return errors.New(errMsg)
}

func (manager *mk_channelManager) Status() MKChannelManagerStatus {
	return manager.status
}

var summaryTemplate = "status: %s " +
	"requestChannel: %d/%d, " +
	"responseChannel: %d/%d, " +
	"itemChannel: %d/%d, " +
	"errorChannel: %d/%d"

func (manager *mk_channelManager) Summary() string {
	summary := fmt.Sprintf(summaryTemplate,
		statusNameMap[manager.status],
		len(manager.requestChannel), cap(manager.requestChannel),
		len(manager.responseChannel), cap(manager.responseChannel),
		len(manager.itemChannel), cap(manager.itemChannel),
		len(manager.errorChannel), cap(manager.errorChannel))

	return summary
}
