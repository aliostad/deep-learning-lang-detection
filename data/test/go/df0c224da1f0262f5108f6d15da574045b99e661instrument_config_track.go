package models

import (
	"errors"
	"fmt"
	"reflect"
	"strings"
	"time"

	"github.com/astaxie/beego/orm"
)

type InstrumentConfigTrack struct {
	Id                     int               `orm:"column(id);auto"`
	InstrumentConfigId     *InstrumentConfig `orm:"column(instrument_config_id);rel(fk)"`
	InstrumentId           *Instrument       `orm:"column(instrument_id);rel(fk)"`
	Status                 string            `orm:"column(status);size(45);null"`
	Remark                 string            `orm:"column(remark);size(100);null"`
	UpdatedAt              time.Time         `orm:"column(updatedAt);type(timestamp);auto_now"`
	CreatedAt              time.Time         `orm:"column(createdAt);type(timestamp);auto_now_add"`
	UserCreated            *User             `orm:"column(user_created);rel(fk)"`
	UserUpdated            *User             `orm:"column(user_updated);rel(fk)"`
	CharacterName          string            `orm:"column(character_name);size(100);null"`
	InstrumentName         string            `orm:"column(instrument_name);size(100);null"`
	ConfigSn               string            `orm:"column(config_sn);size(45);null"`
	StartDate              time.Time         `orm:"column(start_date);type(date);null"`
	EndDate                time.Time         `orm:"column(end_date);type(date);null"`
	InstrumentType         string            `orm:"column(instrument_type);size(45);null"`
	ComputerName           string            `orm:"column(computer_name);size(45);null"`
	ThermalChuckSn         string            `orm:"column(thermal_chuck_sn);size(45);null"`
	ThermalChuckType       string            `orm:"column(thermal_chuck_type);size(45);null"`
	AtsVersion             string            `orm:"column(ats_version);size(45);null"`
	HcsVersion             string            `orm:"column(hcs_version);size(45);null"`
	RtdPairParamTopSlope1  float32           `orm:"column(rtd_pair_param_top_slope1);null"`
	RtdPairParamTopOffset1 float32           `orm:"column(rtd_pair_param_top_offset1);null"`
	RtdPairParamTopSlope2  float32           `orm:"column(rtd_pair_param_top_slope2);null"`
	RtdPairParamTopOffset2 float32           `orm:"column(rtd_pair_param_top_offset2);null"`
	RtdPairParamTopSlope3  float32           `orm:"column(rtd_pair_param_top_slope3);null"`
	RtdPairParamTopOffset3 float32           `orm:"column(rtd_pair_param_top_offset3);null"`
	FcHoldDown             string            `orm:"column(fc_hold_down);size(45);null"`
	ManifestSpringSpacer   string            `orm:"column(manifest_spring_spacer);size(45);null"`
	ManifoldCamShaftType   string            `orm:"column(manifold_cam_shaft_type);size(45);null"`
	SolenoidValveUpgrade   string            `orm:"column(solenoid_valve_upgrade);size(45);null"`
	CoolantLineRouting     string            `orm:"column(coolant_line_routing);size(45);null"`
	ExternalVacuumGauge    string            `orm:"column(external_vacuum_gauge);size(45);null"`
	TemporaryConfig        string            `orm:"column(temporary_config);size(45);null"`
}

func (t *InstrumentConfigTrack) TableName() string {
	return "instrument_config_track"
}

func init() {
	orm.RegisterModel(new(InstrumentConfigTrack))
}

// AddInstrumentConfigTrack insert a new InstrumentConfigTrack into database and returns
// last inserted Id on success.
func AddInstrumentConfigTrack(m *InstrumentConfigTrack) (id int64, err error) {
	o := orm.NewOrm()
	id, err = o.Insert(m)
	return
}

// GetInstrumentConfigTrackById retrieves InstrumentConfigTrack by Id. Returns error if
// Id doesn't exist
func GetInstrumentConfigTrackById(id int) (v *InstrumentConfigTrack, err error) {
	o := orm.NewOrm()
	v = &InstrumentConfigTrack{Id: id}
	if err = o.Read(v); err == nil {
		return v, nil
	}
	return nil, err
}

// GetAllInstrumentConfigTrack retrieves all InstrumentConfigTrack matches certain condition. Returns empty list if
// no records exist
func GetAllInstrumentConfigTrack(query map[string]string, fields []string, sortby []string, order []string,
	offset int64, limit int64) (ml []interface{}, err error) {
	o := orm.NewOrm()
	qs := o.QueryTable(new(InstrumentConfigTrack))
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

	var l []InstrumentConfigTrack
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

// UpdateInstrumentConfigTrack updates InstrumentConfigTrack by Id and returns error if
// the record to be updated doesn't exist
func UpdateInstrumentConfigTrackById(m *InstrumentConfigTrack) (err error) {
	o := orm.NewOrm()
	v := InstrumentConfigTrack{Id: m.Id}
	// ascertain id exists in the database
	if err = o.Read(&v); err == nil {
		var num int64
		if num, err = o.Update(m); err == nil {
			fmt.Println("Number of records updated in database:", num)
		}
	}
	return
}

// DeleteInstrumentConfigTrack deletes InstrumentConfigTrack by Id and returns error if
// the record to be deleted doesn't exist
func DeleteInstrumentConfigTrack(id int) (err error) {
	o := orm.NewOrm()
	v := InstrumentConfigTrack{Id: id}
	// ascertain id exists in the database
	if err = o.Read(&v); err == nil {
		var num int64
		if num, err = o.Delete(&InstrumentConfigTrack{Id: id}); err == nil {
			fmt.Println("Number of records deleted in database:", num)
		}
	}
	return
}
