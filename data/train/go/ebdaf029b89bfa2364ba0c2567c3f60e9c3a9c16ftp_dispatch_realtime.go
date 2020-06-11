package ftp

import (
	"encoding/json"
	"ftpProject/dbobj"
	"ftpProject/logs"

	"strings"
)

type FtpDispatchRealt struct {
	DispatchId     string
	DispatchName   string
	DispatchDate   string
	DispatchStatus string
	CurRows        string
	AllRows        string
	ErrMsg         string
	InPutSourceCd  string
	OutPutResultCd string
	DomainId       string
	StartOffset    string
}
type FtpDispatchRealtCtl struct {
	RouteControl
}

var rsql = FTP_DISPATCHREAL_G

func (this *FtpDispatchRealtCtl) Get() {
	w := this.Ctx.ResponseWriter
	doName := this.Domainid
	if doName == "" {
		logs.Error("session中域名为空")
		return
	}

	sql := FTP_DISPATCHREALT_GET
	rows, err := dbobj.Default.Query(sql, doName)
	if err != nil {
		logs.Error("查询实时批次计算失败")
		return
	}
	defer rows.Close() //9.13 add
	var one FtpDispatchRealt
	var all []FtpDispatchRealt
	for rows.Next() {
		err := rows.Scan(&one.DispatchId, &one.DispatchName, &one.DispatchDate, &one.DispatchStatus, &one.CurRows, &one.AllRows, &one.ErrMsg, &one.InPutSourceCd, &one.OutPutResultCd, &one.DomainId, &one.StartOffset)
		if err != nil {
			logs.Error(err)
			logs.Error("取值实时批次计算失败")
			continue
		}
		all = append(all, one)
	}
	//step 2:查出总行数
	for i, val := range all {
		if val.DispatchStatus == "11" {
			sql = `select count(*) from ` + val.OutPutResultCd + ` where as_of_date=to_date(:1,'YYYY-MM-DD') and domain_id=:2`
			rows, err := dbobj.Default.Query(sql, val.DispatchDate, doName)
			if err != nil {
				logs.Error("查询总行数失败")
				continue
			}
			var sumrow []byte
			var sumrows string
			for rows.Next() {
				err := rows.Scan(&sumrow)
				if err != nil {
					logs.Error("取值总行数失败")
					continue
				}
			}
			rows.Close() //9.13 add
			sumrows = string(sumrow)
			if val.DispatchStatus == "1" {
				all[i].CurRows = sumrows
			}
		} else if val.DispatchStatus == "33" {
			//
			sql = strings.Replace(rsql, "IINNPPUUTT", val.InPutSourceCd, -1)
			sql = strings.Replace(sql, "OOUUTTPPUUTT", val.OutPutResultCd, -1)
			rows, err := dbobj.Default.Query(sql, val.DispatchDate, doName, val.StartOffset, val.AllRows)
			//fmt.Println("sql:", sql)
			//fmt.Println("PARA:", val.DispatchDate, doName, val.StartOffset, val.AllRows)

			if err != nil {
				logs.Error(err)
				return
			}
			var (
				//date   string
				//accnum string
				errnum string = "0"
			)
			for rows.Next() {
				err := rows.Scan(&errnum)
				if err != nil {
					logs.Error("查询错误批次状态失败")
					return
				}
				break
			}
			//计算引擎已完成
			var err_msg = "错误条数" + errnum
			//fmt.Println("ooo", val.DispatchName, err_msg, errnum)
			if errnum == "0" {
				sql = FTP_DISPATREAL_G1
				err := dbobj.Default.Exec(sql, "5", val.DispatchId, val.DispatchDate, doName)
				if err != nil {
					logs.Error("写完成批次状态失败")
					return
				}
				all[i].DispatchStatus = "5"
				all[i].CurRows = val.AllRows
			} else {
				sql = FTP_DISPATREAL_G2
				err := dbobj.Default.Exec(sql, "2", err_msg, val.DispatchId, val.DispatchDate, doName)
				if err != nil {
					logs.Error("写错误批次状态失败")
					return
				}
				all[i].DispatchStatus = "2"
				all[i].CurRows = val.AllRows
				all[i].ErrMsg = err_msg
			}
		}
	}
	ojs, err := json.Marshal(all)
	if err != nil {
		logs.Error(err)
	}
	w.Write(ojs)

}

func (this *FtpDispatchRealtCtl) Put() {
	r := this.Ctx.Request
	w := this.Ctx.ResponseWriter
	sql := FTP_DISPATCHREALT_PUT1
	dispatchid := r.FormValue("DispatchId")
	dispatchdate := r.FormValue("DispatchDate")
	doName := this.Domainid
	if doName == "" {
		logs.Error("session中域名为空")
		return
	}
	var errmsg ReturnMsg
	err := dbobj.Default.Exec(sql, "4", "批次被停止", dispatchid, dispatchdate, doName)
	if err != nil {
		logs.Error(err)
		errmsg.ErrorCode = "0"
		errmsg.ErrorMsg = "停止批次失败,请联系管理员"
		ojs, err := json.Marshal(errmsg)
		if err != nil {
			logs.Error(err)
		}
		w.Write(ojs)
		return
	}
	//
	opcontent := "停止批次,批次编码为:" + dispatchid
	this.InsertLogToDB(batchstop, opcontent, myapp)
	//
	errmsg.ErrorCode = "1"
	errmsg.ErrorMsg = "停止批次成功"
	ojs, err := json.Marshal(errmsg)
	if err != nil {
		logs.Error(err)
	}
	w.Write(ojs)

}
func (this *FtpDispatchRealtCtl) Delete() {
	r := this.Ctx.Request
	w := this.Ctx.ResponseWriter
	doName := this.Domainid
	if doName == "" {
		logs.Error("session中域名为空")
		return
	}
	var all []FtpDispatchRealt
	mjson := []byte(r.FormValue("JSON"))

	var errmsg ReturnMsg
	err := json.Unmarshal(mjson, &all)
	if err != nil {
		logs.Error(err)
		errmsg.ErrorCode = "0"
		errmsg.ErrorMsg = "json解析失败，,请联系管理员"
		ojs, err := json.Marshal(errmsg)
		if err != nil {
			logs.Error(err)
		}
		w.Write(ojs)
		return
	}
	sql := FTP_DISPATCHREALT_DELETE1
	for _, val := range all {
		err := dbobj.Default.Exec(sql, val.DispatchId, val.DispatchDate, doName)
		if err != nil {
			logs.Error(err)
			errmsg.ErrorCode = "0"
			errmsg.ErrorMsg = "删除失败,请联系管理员"
			ojs, err := json.Marshal(errmsg)
			if err != nil {
				logs.Error(err)
			}
			w.Write(ojs)
			return
		}
		opcontent := "删除已完成批次,批次编码为:" + val.DispatchId
		this.InsertLogToDB(batchclear, opcontent, myapp)
	}
	//

	//
	errmsg.ErrorCode = "1"
	errmsg.ErrorMsg = "删除成功"
	ojs, err := json.Marshal(errmsg)
	if err != nil {
		logs.Error(err)
	}
	w.Write(ojs)
}
