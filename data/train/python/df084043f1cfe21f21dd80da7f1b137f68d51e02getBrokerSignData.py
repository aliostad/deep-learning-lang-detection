__author__ = 'qianfunian'

import MySQLdb
import time

connection = MySQLdb.connect(user="readonly_v2", passwd="aNjuKe9dx1Pdw", host='10.10.8.128', db="mobile_db")
cursor = connection.cursor()

globalBrokerIds = {}
pageCount = 10

timeFile = open('time.log', 'a+')
start = int(time.time())


def generateData(brokerIds):
    for brokerId in brokerIds:
        if (globalBrokerIds.has_key(brokerId[0])):
            continue
        globalBrokerIds[brokerId[0]] = ''

        sql = 'select count(*) from (select  community_id from broker_community_sign_201410 where broker_id=' \
              + str(
            brokerId[0]) + ' union select  community_id from broker_community_sign_201411 where broker_id=' + str(
            brokerId[0]) + ' )as tmp'

        cursor.execute(sql)
        data = cursor.fetchall()

        AJKDBConnection = MySQLdb.connect(user="readonly_v2", passwd="aNjuKe9dx1Pdw", host='10.10.8.80',
                                          db="anjuke_db")

        sql = 'select ajk_brokerextend.BrokerId,ajk_brokerextend.TrueName,ajk_brokerextend.UserMobile,' \
              'ajk_brokerextend.CityId,ajk_brokerextend.BelongCom,ajk_citytype.CityName from ajk_brokerextend ' \
              'left join ajk_citytype on ajk_brokerextend.CityId=ajk_citytype.CityId where BrokerId= ' + str(
            brokerId[0])
        AJKCursor = AJKDBConnection.cursor()
        AJKCursor.execute(sql)
        brokerInfo = AJKCursor.fetchall()

        for info in brokerInfo[0]:
            file_object.write(str(info) + ',')

        file_object.write(str(data[0][0]) + '\n')
    pass


for db in ['broker_community_sign_201410', 'broker_community_sign_201411']:
    page = 1
    while True:
        offset = (page - 1) * pageCount
        sql = 'select distinct broker_id from ' + db + ' order by broker_id desc limit ' + offset.__str__() + ',10'
        cursor.execute(sql)
        brokerIds = cursor.fetchall()

        if (brokerIds == ()):
            break
        file_object = open('thefile.csv', 'a+')

        generateData(brokerIds)

        page += 1
        file_object.close()

end = int(time.time())
val = end - start
timeFile.write(str(val))
timeFile.close()