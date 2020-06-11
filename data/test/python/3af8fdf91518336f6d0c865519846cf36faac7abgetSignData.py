__author__ = 'qianfunian'

import MySQLdb
import time
import thread

timeFile = open('time.log', 'a+')
start = int(time.time())


mobileDbConnection = MySQLdb.connect(user="anjuke_triger", passwd="anjuke_triger", host='10.20.3.80', db="mobile_db")
mobileCursor = mobileDbConnection.cursor()

globalBrokerIds = {}
pageCount = 10


def generate_data(brokerIds):
    for brokerId in brokerIds:
        if (globalBrokerIds.has_key(brokerId[0])):
            continue
        globalBrokerIds[brokerId[0]] = ''

        sql = "select *,count(*) as count from (select distinct `broker_id`,`community_id`,DATE_FORMAT(sign_time,'%m%d') " \
              "as sign_time from broker_community_sign_201410  where broker_id = " + str(brokerId[0]) + \
              " union all select distinct `broker_id`,`community_id`,DATE_FORMAT(sign_time,'%m%d') as sign_time " \
              "from broker_community_sign_201411  where broker_id = " + str(brokerId[0]) + \
              " ) temp group by sign_time,broker_id order by sign_time asc"

        mobileCursor.execute(sql)
        sign_data = mobileCursor.fetchall()

        anjukeDbConnection = MySQLdb.connect(user="anjuke_triger", passwd="anjuke_triger", host='10.20.3.80',
                                             db="anjuke_db")

        sql = 'select ajk_brokerextend.BrokerId,ajk_brokerextend.TrueName,ajk_brokerextend.UserMobile,' \
              'ajk_brokerextend.BelongCom,ajk_citytype.CityName from ajk_brokerextend ' \
              'left join ajk_citytype on ajk_brokerextend.CityId=ajk_citytype.CityId where BrokerId= ' + str(
            brokerId[0])

        anjukeCursor = anjukeDbConnection.cursor()
        anjukeCursor.execute(sql)
        brokerInfo = anjukeCursor.fetchall()
        line_text = ''

        for info in brokerInfo[0]:
            line_text += str(info) + ','

        for info in sign_data:
            line_text += str(info[2]) + "(" + str(info[3]) + "),"

        file_object.write(line_text + '\n')


pass

file_object = open('sign.csv', 'a+')

for db in ['broker_community_sign_201410', 'broker_community_sign_201411']:
    page = 1
    while True:
        offset = (page - 1) * pageCount
        sql = 'select distinct broker_id from ' + db + ' order by broker_id desc limit ' + offset.__str__() + ',10'
        mobileCursor.execute(sql)
        brokerIds = mobileCursor.fetchall()
        if (brokerIds == ()):
            break
        generate_data(brokerIds)
        page += 1

file_object.close()
end = int(time.time())
val = end - start
timeFile.write(str(val))
timeFile.close()