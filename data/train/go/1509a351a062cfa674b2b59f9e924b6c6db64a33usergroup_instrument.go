package models

import (
	"errors"
	"fmt"
	"reflect"
	"strings"
	"time"

	"github.com/astaxie/beego/orm"
)

type UsergroupInstrument struct {
	Id             int        `orm:"column(id);auto"`
	UsergroupId    *Usergroup `orm:"column(usergroup_id);rel(fk)"`
	InstrumentName string     `orm:"column(instrument_name);size(100)"`
	InstrumentType string     `orm:"column(instrument_type);size(45)"`
	Status         string     `orm:"column(status);size(45);null"`
	Note           string     `orm:"column(note);size(200);null"`
	UserCreated    *User      `orm:"column(user_created);rel(fk)"`
	UserUpdated    *User      `orm:"column(user_updated);rel(fk)"`
	UpdatedAt      time.Time  `orm:"column(updatedAt);type(timestamp);auto_now"`
	CreatedAt      time.Time  `orm:"column(createdAt);type(timestamp);auto_now_add"`
}

func (t *UsergroupInstrument) TableName() string {
	return "usergroup_instrument"
}

func init() {
	orm.RegisterModel(new(UsergroupInstrument))
}

// AddUsergroupInstrument insert a new UsergroupInstrument into database and returns
// last inserted Id on success.
func AddUsergroupInstrument(m *UsergroupInstrument) (id int64, err error) {
	o := orm.NewOrm()
	id, err = o.Insert(m)
	return
}

// GetUsergroupInstrumentById retrieves UsergroupInstrument by Id. Returns error if
// Id doesn't exist
func GetUsergroupInstrumentById(id int) (v *UsergroupInstrument, err error) {
	o := orm.NewOrm()
	v = &UsergroupInstrument{Id: id}
	if err = o.Read(v); err == nil {
		return v, nil
	}
	return nil, err
}

// GetAllUsergroupInstrument retrieves all UsergroupInstrument matches certain condition. Returns empty list if
// no records exist
func GetAllUsergroupInstrument(query map[string]string, fields []string, sortby []string, order []string,
	offset int64, limit int64) (ml []interface{}, err error) {
	o := orm.NewOrm()
	qs := o.QueryTable(new(UsergroupInstrument))
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

	var l []UsergroupInstrument
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

// UpdateUsergroupInstrument updates UsergroupInstrument by Id and returns error if
// the record to be updated doesn't exist
func UpdateUsergroupInstrumentById(m *UsergroupInstrument) (err error) {
	o := orm.NewOrm()
	v := UsergroupInstrument{Id: m.Id}
	// ascertain id exists in the database
	if err = o.Read(&v); err == nil {
		var num int64
		if num, err = o.Update(m); err == nil {
			fmt.Println("Number of records updated in database:", num)
		}
	}
	return
}

// DeleteUsergroupInstrument deletes UsergroupInstrument by Id and returns error if
// the record to be deleted doesn't exist
func DeleteUsergroupInstrument(id int) (err error) {
	o := orm.NewOrm()
	v := UsergroupInstrument{Id: id}
	// ascertain id exists in the database
	if err = o.Read(&v); err == nil {
		var num int64
		if num, err = o.Delete(&UsergroupInstrument{Id: id}); err == nil {
			fmt.Println("Number of records deleted in database:", num)
		}
	}
	return
}
