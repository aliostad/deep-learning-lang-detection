package models

import (
	"errors"
	"fmt"
	"reflect"
	"strings"
	"time"

	"github.com/astaxie/beego/orm"
)

type UserInstrument struct {
	Id           int         `orm:"column(id);auto"`
	UserId       *User       `orm:"column(user_id);rel(fk)"`
	InstrumentId *Instrument `orm:"column(instrument_id);rel(fk)"`
	Status       string      `orm:"column(status);size(45);null"`
	Description  string      `orm:"column(description);size(200);null"`
	UpdatedAt    time.Time   `orm:"column(updatedAt);type(timestamp);auto_now"`
	CreatedAt    time.Time   `orm:"column(createdAt);type(timestamp);auto_now_add"`
	Tags         string      `orm:"column(tags);size(200);null"`
}

func (t *UserInstrument) TableName() string {
	return "user_instrument"
}

func init() {
	orm.RegisterModel(new(UserInstrument))
}

// AddUserInstrument insert a new UserInstrument into database and returns
// last inserted Id on success.
func AddUserInstrument(m *UserInstrument) (id int64, err error) {
	o := orm.NewOrm()
	id, err = o.Insert(m)
	return
}

// GetUserInstrumentById retrieves UserInstrument by Id. Returns error if
// Id doesn't exist
func GetUserInstrumentById(id int) (v *UserInstrument, err error) {
	o := orm.NewOrm()
	v = &UserInstrument{Id: id}
	if err = o.Read(v); err == nil {
		return v, nil
	}
	return nil, err
}

// GetAllUserInstrument retrieves all UserInstrument matches certain condition. Returns empty list if
// no records exist
func GetAllUserInstrument(query map[string]string, fields []string, sortby []string, order []string,
	offset int64, limit int64) (ml []interface{}, err error) {
	o := orm.NewOrm()
	qs := o.QueryTable(new(UserInstrument))
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

	var l []UserInstrument
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

// UpdateUserInstrument updates UserInstrument by Id and returns error if
// the record to be updated doesn't exist
func UpdateUserInstrumentById(m *UserInstrument) (err error) {
	o := orm.NewOrm()
	v := UserInstrument{Id: m.Id}
	// ascertain id exists in the database
	if err = o.Read(&v); err == nil {
		var num int64
		if num, err = o.Update(m); err == nil {
			fmt.Println("Number of records updated in database:", num)
		}
	}
	return
}

// DeleteUserInstrument deletes UserInstrument by Id and returns error if
// the record to be deleted doesn't exist
func DeleteUserInstrument(id int) (err error) {
	o := orm.NewOrm()
	v := UserInstrument{Id: id}
	// ascertain id exists in the database
	if err = o.Read(&v); err == nil {
		var num int64
		if num, err = o.Delete(&UserInstrument{Id: id}); err == nil {
			fmt.Println("Number of records deleted in database:", num)
		}
	}
	return
}
