package models

import (
	"errors"
	"fmt"
	"reflect"
	"strings"
	"time"

	"github.com/astaxie/beego/orm"
)

type Instrument struct {
	Id               int       `orm:"column(id);auto"`
	UpdatedAt        time.Time `orm:"column(updatedAt);type(timestamp);auto_now"`
	CreatedAt        time.Time `orm:"column(createdAt);type(timestamp);auto_now_add"`
	UserCreated      *User     `orm:"column(user_created);rel(fk)"`
	UserUpdated      *User     `orm:"column(user_updated);rel(fk)"`
	Name             string    `orm:"column(name);size(100)"`
	Status           string    `orm:"column(status);size(45)"`
	Platform         string    `orm:"column(platform);size(45)"`
	Remark           string    `orm:"column(remark);size(100);null"`
	Alias            string    `orm:"column(alias);size(45);null"`
	AmmsState        string    `orm:"column(amms_state);size(45);null"`
	AmmsEqname       string    `orm:"column(amms_eqname);size(45);null"`
	AmmsEqmodel      string    `orm:"column(amms_eqmodel);size(45);null"`
	AmmsEqsystem     string    `orm:"column(amms_eqsystem);size(45);null"`
	AmmsEqdepartment string    `orm:"column(amms_eqdepartment);size(45);null"`
	AmmsEqroomnumber string    `orm:"column(amms_eqroomnumber);size(45);null"`
	AmmsEqnumber     string    `orm:"column(amms_eqnumber);size(45);null"`
}

func (t *Instrument) TableName() string {
	return "instrument"
}

func init() {
	orm.RegisterModel(new(Instrument))
}

// AddInstrument insert a new Instrument into database and returns
// last inserted Id on success.
func AddInstrument(m *Instrument) (id int64, err error) {
	o := orm.NewOrm()
	id, err = o.Insert(m)
	return
}

// GetInstrumentById retrieves Instrument by Id. Returns error if
// Id doesn't exist
func GetInstrumentById(id int) (v *Instrument, err error) {
	o := orm.NewOrm()
	v = &Instrument{Id: id}
	if err = o.Read(v); err == nil {
		return v, nil
	}
	return nil, err
}

// GetAllInstrument retrieves all Instrument matches certain condition. Returns empty list if
// no records exist
func GetAllInstrument(query map[string]string, fields []string, sortby []string, order []string,
	offset int64, limit int64) (ml []interface{}, err error) {
	o := orm.NewOrm()
	qs := o.QueryTable(new(Instrument))
	// query k=v
	for k, v := range query {
		// rewrite dot-notation to Object__Attribute
		k = strings.Replace(k, ".", "__", -1)
		if strings.Contains(k, "isnull") {
			qs = qs.Filter(k, (v == "true" || v == "1"))
		} else {
			qs = qs.Filter(k, v)
		}
	}
	// order by:
	var sortFields []string
	if len(sortby) != 0 {
		if len(sortby) == len(order) {
			// 1) for each sort field, there is an associated order
			for i, v := range sortby {
				orderby := ""
				if order[i] == "desc" {
					orderby = "-" + v
				} else if order[i] == "asc" {
					orderby = v
				} else {
					return nil, errors.New("Error: Invalid order. Must be either [asc|desc]")
				}
				sortFields = append(sortFields, orderby)
			}
			qs = qs.OrderBy(sortFields...)
		} else if len(sortby) != len(order) && len(order) == 1 {
			// 2) there is exactly one order, all the sorted fields will be sorted by this order
			for _, v := range sortby {
				orderby := ""
				if order[0] == "desc" {
					orderby = "-" + v
				} else if order[0] == "asc" {
					orderby = v
				} else {
					return nil, errors.New("Error: Invalid order. Must be either [asc|desc]")
				}
				sortFields = append(sortFields, orderby)
			}
		} else if len(sortby) != len(order) && len(order) != 1 {
			return nil, errors.New("Error: 'sortby', 'order' sizes mismatch or 'order' size is not 1")
		}
	} else {
		if len(order) != 0 {
			return nil, errors.New("Error: unused 'order' fields")
		}
	}

	var l []Instrument
	qs = qs.OrderBy(sortFields...)
	if _, err = qs.Limit(limit, offset).All(&l, fields...); err == nil {
		if len(fields) == 0 {
			for _, v := range l {
				ml = append(ml, v)
			}
		} else {
			// trim unused fields
			for _, v := range l {
				m := make(map[string]interface{})
				val := reflect.ValueOf(v)
				for _, fname := range fields {
					m[fname] = val.FieldByName(fname).Interface()
				}
				ml = append(ml, m)
			}
		}
		return ml, nil
	}
	return nil, err
}

// UpdateInstrument updates Instrument by Id and returns error if
// the record to be updated doesn't exist
func UpdateInstrumentById(m *Instrument) (err error) {
	o := orm.NewOrm()
	v := Instrument{Id: m.Id}
	// ascertain id exists in the database
	if err = o.Read(&v); err == nil {
		var num int64
		if num, err = o.Update(m); err == nil {
			fmt.Println("Number of records updated in database:", num)
		}
	}
	return
}

// DeleteInstrument deletes Instrument by Id and returns error if
// the record to be deleted doesn't exist
func DeleteInstrument(id int) (err error) {
	o := orm.NewOrm()
	v := Instrument{Id: id}
	// ascertain id exists in the database
	if err = o.Read(&v); err == nil {
		var num int64
		if num, err = o.Delete(&Instrument{Id: id}); err == nil {
			fmt.Println("Number of records deleted in database:", num)
		}
	}
	return
}
