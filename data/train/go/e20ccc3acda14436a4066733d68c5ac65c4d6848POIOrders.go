// POIOrders
package models

import (
	"POIWolaiWebService/utils"
	"time"

	"github.com/astaxie/beego/orm"
	"github.com/cihub/seelog"
)

var (
	OrderTypeDict = map[int64]string{
		1: "general_instant",
		2: "general_appointment",
		3: "personal_instant",
		4: "personal_appointment",
	}

	OrderTypeRevDict = map[string]int64{
		"general_instant":      1,
		"general_appointment":  2,
		"personal_instant":     3,
		"personal_appointment": 4,
	}
)

type POIOrderDispatchSlave struct {
	SlaveId   int64
	TimeStamp int64
}

type POIOrderDispatchMaster struct {
	MasterId int64
	Slaves   []POIOrderDispatchSlave
}

type POIMonitorOrders struct {
	OrderDispatchInfo        []POIOrderDispatchMaster
	TeacherOrderDispatchInfo []POIOrderDispatchMaster
	UserOrderDispatchInfo    []POIOrderDispatchMaster
}

type POIOrder struct {
	Id                int64     `json:"id" orm:"pk"`
	Creator           *POIUser  `json:"creatorInfo" orm:"-"`
	GradeId           int64     `json:"gradeId"`
	SubjectId         int64     `json:"subjectId"`
	Date              string    `json:"date"`
	PeriodId          int64     `json:"periodId"`
	Length            int64     `json:"length"`
	Type              int64     `json:"orderType" orm:"-"`
	Status            string    `json:"-"`
	Created           int64     `json:"-" orm:"column(creator)"`
	CreateTime        time.Time `json:"-" orm:"auto_now_add;type(datetime)"`
	LastUpdateTime    time.Time `json:"-"`
	OrderType         string    `json:"-" orm:"column(type)"`
	PricePerHour      int64     `json:"pricePerHour"`
	RealPricePerHour  int64     `json:"realPricePerHour"`
	TeacherId         int64     `json:"teacherId"` //一对一辅导时导师的用户id
	DispatchdTeachers string
}

type POIOrderDispatch struct {
	Id           int64     `json:"id" orm:"pk"`
	Order        *POIOrder `json:"orderInfo" orm:"-"`
	Teacher      *POIUser  `json:"teacherInfo" orm:"-"`
	OrderId      int64     `json:"-"`
	TeacherId    int64     `json:"-"`
	DispatchTime time.Time `json:"dispatchTime" orm:"auto_now_add;type(datetime)"`
	ReplyTime    time.Time `json:"replyTime"`
	PlanTime     string    `json:"planTime"`
	Result       string    `json:"result"`
}

type POIOrderDispatchs []*POIOrderDispatch

func (order *POIOrder) TableName() string {
	return "orders"
}

func (od *POIOrderDispatch) TableName() string {
	return "order_dispatch"
}

func init() {
	orm.RegisterModel(new(POIOrder), new(POIOrderDispatch))
}

type POIOrders []*POIOrder

func QueryOrderById(orderId int64) *POIOrder {
	order := POIOrder{}
	o := orm.NewOrm()
	db, _ := orm.NewQueryBuilder(utils.DB_TYPE)
	db.Select("id,creator,grade_id,subject_id,date,period_id,length,type,status,price_per_hour,real_price_per_hour,teacher_id").
		From("orders").Where("id = ?")
	sql := db.String()
	err := o.Raw(sql, orderId).QueryRow(&order)
	if err != nil {
		seelog.Error("orderId:", orderId, " ", err.Error())
		return nil
	}
	order.Type = OrderTypeRevDict[order.OrderType]
	creator := QueryUserById(order.Created)
	order.Creator = creator
	return &order
}

func QueryOrders(start, pageCount int) POIOrders {
	orders := make(POIOrders, 0)
	o := orm.NewOrm()
	db, _ := orm.NewQueryBuilder(utils.DB_TYPE)
	db.Select("orders.id,orders.creator,orders.grade_id,orders.subject_id,orders.date,orders.period_id,orders.create_time," +
		"orders.length,orders.type,orders.status,orders.price_per_hour,orders.real_price_per_hour,orders.teacher_id").
		From("orders").InnerJoin("users").On("orders.creator = users.id").OrderBy("orders.id").Desc().Limit(pageCount).Offset(start)
	sql := db.String()
	_, err := o.Raw(sql).QueryRows(&orders)
	if err != nil {
		return nil
	}
	for _, order := range orders {
		order.Type = OrderTypeRevDict[order.OrderType]
		creator := QueryUserById(order.Created)
		order.Creator = creator
	}
	return orders
}

func GetOrdersCount() int64 {
	o := orm.NewOrm()
	count, _ := o.QueryTable("orders").Count()
	return count
}

func QueryOrderDispatchByOrderId(orderId int64) POIOrderDispatchs {
	o := orm.NewOrm()
	qb, _ := orm.NewQueryBuilder(utils.DB_TYPE)
	qb.Select("id,order_id,teacher_id,dispatch_time,reply_time,plan_time,result").From("order_dispatch").
		Where("order_id = ?")
	sql := qb.String()
	orderDispatchs := make(POIOrderDispatchs, 0)
	_, err := o.Raw(sql, orderId).QueryRows(&orderDispatchs)
	for _, orderDispatch := range orderDispatchs {

		orderDispatch.Order = QueryOrderById(orderDispatch.OrderId)
		orderDispatch.Teacher = QueryUserById(orderDispatch.TeacherId)
	}
	if err != nil {
		seelog.Error("orderId:", orderId, " ", err.Error())
		return nil
	}
	return orderDispatchs
}
