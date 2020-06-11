/**
 * 把data.txt中的数据导入到Financial_Company中
 * Tp
 **/
package main

import (
	"database/sql"
	"fmt"
	_ "github.com/go-sql-driver/mysql"
	"github.com/leonco/pinyin4go"
	"github.com/yinshuwei/utils"
	"io/ioutil"
	"strings"
)

const (
	brokerCompanyId = "1"
	processStatus   = "2"
	status          = "1"
	createTime      = "2014-05-01 00:00:00"
	isInternal      = "2"
	isFee           = "2"
)

var levelMap = map[string]string{"总行": "1", "一级分行": "2", "二级分行": "3", "一级支行": "4"}
var f = pinyin4go.Format{pinyin4go.U_UNICODE, pinyin4go.LOWER_CASE, pinyin4go.NO_TONE}

func main() {

	db, err := sql.Open("mysql", "artogrid:artogrid@tcp(10.10.2.4:3306)/idb_mm_offline?charset=utf8")
	checkErr(err)

	defer db.Close()

	//删除数据
	stmt, err := db.Prepare("delete from mm_trader_broker_relation where trader_account_id not in (select id from mm_temp_account)")
	checkErr(err)
	_, err = stmt.Exec()
	checkErr(err)

	brokerDataByte, _ := ioutil.ReadFile("broker.txt")
	brokerData := string(brokerDataByte)
	brokerLines := strings.Split(brokerData, "\r\n")

	brokerNameIdMap := make(map[string]string)
	for _, line := range brokerLines {
		brokerNameAndBroker := strings.Split(line, ",")
		name := brokerNameAndBroker[0]
		email := brokerNameAndBroker[1]
		var id []byte
		row := db.QueryRow("select id from idb_center.idb_account where username=?", email)
		row.Scan(&id)
		brokerNameIdMap[name] = string(id)
	}

	companyNameIdMap := make(map[string]string)

	rows, err := db.Query("select name,id from mm_temp_financial_company where broker_company_id=?", brokerCompanyId)
	checkErr(err)

	for rows.Next() {
		var name []byte
		var id []byte
		err = rows.Scan(&name, &id)
		checkErr(err)
		companyNameIdMap[string(name)] = string(id)
	}

	companyNameBrokerIdTraderId := make(map[string]string)
	rows, err = db.Query(`select c.name,r.broker_account_id,t.id 
		from mm_temp_financial_company c,mm_temp_account t,mm_trader_broker_relation r 
		where c.id=t.company_id
		and t.id=r.trader_account_id
		and c.broker_company_id=t.broker_company_id
		and r.broker_company_id=t.broker_company_id
		and c.broker_company_id=?`, brokerCompanyId)
	checkErr(err)

	for rows.Next() {
		var name []byte
		var brokerId []byte
		var traderId []byte
		err = rows.Scan(&name, &brokerId, &traderId)
		checkErr(err)
		companyNameBrokerIdTraderId[string(name)+"_"+string(brokerId)] = string(traderId)
	}

	tx, err := db.Begin()
	checkErr(err)

	//插入机构数据
	insertTemp, err := tx.Prepare(`INSERT mm_temp_financial_company
										SET ID=?,NAME=?,fullname_cn_front=?,CREATE_TIME=?,MODIFY_TIME=?,STATUS=?,PROCESS_STATUS=?,BROKER_COMPANY_ID=?,bank_level=?`)
	checkErr(err)

	insertExtend, err := tx.Prepare(`INSERT mm_extend_financial_company
										SET id=?,company_id=?,level=?,display_name=?,is_fee=?,description=?,is_internal=?,broker_company_id=?,create_time=?,status=?,pinyin=?`)
	checkErr(err)

	//插入trader数据
	insertTraderTemp, err := tx.Prepare(`INSERT mm_temp_account
										SET ID=?,COMPANY_ID=?,COMPANY_NAME=?,ACCOUNT_CODE=?,USERNAME=?,PASSWORD=?,DISPLAY_NAME=?,
										ACCOUNT_TYPE=?,IS_FORBIDDEN=?,CREATE_TIME=?,MODIFY_TIME=?,STATUS=?,process_status=?,broker_company_id=?,pinyin_keyword=?`)
	checkErr(err)

	insertTraderExtend, err := tx.Prepare(`INSERT mm_extend_trader
										SET id=?,account_id=?,display_name=?,broker_company_id=?,create_time=?,status=?`)
	checkErr(err)

	//插入关系数据
	insertRelation, err := tx.Prepare(`INSERT INTO mm_trader_broker_relation 
										(id, trader_account_id, broker_account_id, level, is_temp, create_time, status, broker_company_id) 
										VALUES (?, ?, ?, ?, ?, ?, ?, ?)`)
	checkErr(err)

	dataByte, _ := ioutil.ReadFile("data.txt")
	fileContent := string(dataByte)

	lines := strings.Split(fileContent, "\r\n")

	brokerNameLine := lines[1]
	brokerNamess := strings.Split(brokerNameLine, ",")
	brokerNames := make([]string, len(brokerNamess)/2+1)
	for i, brokerName := range brokerNamess {
		if i%2 == 0 {
			brokerNames[i/2] = brokerName
		}
	}

	n := 30000
	ccc := 0

	for r, line := range lines {
		if r < 3 {
			continue
		}

		nameLevels := strings.Split(line, ",")

		for i := 0; i < len(nameLevels); i = i + 2 {
			cnData := ""
			if i < len(nameLevels) {
				cnData = strings.Trim(nameLevels[i], " ")
			}
			bankLevelCN := ""
			if i+1 < len(nameLevels) {
				bankLevelCN = strings.Trim(nameLevels[i+1], " ")
			}
			if cnData == "" {
				continue
			}

			id, ok := companyNameIdMap[cnData]
			if !ok {

				bankLevel := levelMap[bankLevelCN]

				id, err = utils.GenUUID()
				checkErr(err)

				_, err = insertTemp.Exec(id, cnData, cnData, createTime, createTime, status, processStatus, brokerCompanyId, bankLevel)
				checkErr(err)

				_, err = insertExtend.Exec(id, id, 1, cnData, isFee, cnData, isInternal, brokerCompanyId, createTime, status, toPinyin(cnData))
				checkErr(err)

				companyNameIdMap[cnData] = id

				fmt.Println(cnData, bankLevelCN)
			}

			brokerName := brokerNames[i/2]
			brokerId := brokerNameIdMap[brokerName]
			_, ok = companyNameBrokerIdTraderId[cnData+"_"+brokerId]
			if !ok {
				traderId, err := utils.GenUUID()
				checkErr(err)
				traderName := fmt.Sprintf("trader%v", n)
				n++

				_, err = insertTraderTemp.Exec(traderId, id, cnData, traderName, traderName, "123456", traderName, "2", "1", createTime, createTime, status, processStatus, brokerCompanyId, traderName)
				checkErr(err)

				_, err = insertTraderExtend.Exec(traderId, traderId, traderName, brokerCompanyId, createTime, "1")
				checkErr(err)

				relationId, err := utils.GenUUID()
				checkErr(err)

				_, err = insertRelation.Exec(relationId, traderId, brokerId, 0, "", createTime, status, brokerCompanyId)
				checkErr(err)

				fmt.Println(cnData, bankLevelCN, brokerName)

				ccc++
			}
		}
	}

	tx.Commit()

	fmt.Println(ccc)
}

func toPinyin(str string) string {
	n := []rune(str)
	var fullPinyin map[string]bool
	var prefixPinyin map[string]bool
	for _, v := range n {
		newFullPyinyin := make(map[string]bool)
		newPrefixPyinyin := make(map[string]bool)

		pinyinAll, err := pinyin4go.PinyinF(v, f)
		if err != nil {
			panic(err)
		}
		ppp := make(map[string]bool)
		for _, py := range pinyinAll {
			ppp[py] = true
		}

		for py, _ := range ppp {
			if py == "" {
				continue
			}
			if len(fullPinyin) == 0 {
				newFullPyinyin[py] = true
			} else {
				for p, _ := range fullPinyin {
					newFullPyinyin[p+py] = true
				}
			}
			if len(prefixPinyin) == 0 {
				newPrefixPyinyin[py[0:1]] = true
			} else {

				for p, _ := range prefixPinyin {
					newPrefixPyinyin[p+py[0:1]] = true
				}
			}
		}

		fullPinyin = newFullPyinyin
		prefixPinyin = newPrefixPyinyin
	}

	result := ""
	for key, _ := range fullPinyin {
		if result == "" {
			result = key
		} else {
			result += "_" + key
		}
	}
	for key, _ := range prefixPinyin {
		result += "_" + key
	}

	return result
}

func checkErr(err error) {
	if err != nil {
		panic(err)
	}
}
