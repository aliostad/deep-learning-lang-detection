import csv
import CurveFit
import fetchSqlData
from sys import stdout
from datetime import date,datetime,timedelta
import initDB

#================================================#
#===================== INIT =====================#
#================================================#

# Initialization occurs getting Bank money and stocks
CONNECTION = initDB.dbLogin()
BROKERNAME = "Broker1"

# ================================================#
# ============= FUNCTION DEFINITIONS =============#
# ================================================#


def printOwnedStocks(broker, connection):
    """
    printOwnedStocks: prints stocks owned by broker
    broker - broker name to query
    connection - database connection object
    return: none only prints stocks
    """
    stocks = fetchSqlData.queryAllOwned(broker, connection)
    for stock in stocks:
        print(stock[0] + ": " + stock[2])

def printLog(broker, connection):
    """
    printLog: prints log entries for broker
    brooker - string name of broker
    connection - database connection object
    return: none only prints logs
    """
    logs = fetchSqlData.queryLog(broker, connection)
    for log in logs:
        printString = ""
        for items in log:
            printString += str(items) + " "
        print(printString)

def incrementDay(broker, connection):
    """
    incrementDay: increments day for broker
    broker - string broker name to increment day for
    return: True if day was incremented or False if end of range
    """
    # fetch current date
    currInfo = fetchSqlData.fetchBrokerInfo(broker, connection)
    date = currInfo[2]
    newDate = date + timedelta(days=1)
    today = datetime.today().date()
    doneDate = fetchSqlData.dateExists(newDate, connection)
    # run until next trading day
    while not doneDate:
        print(newDate)
        # done if day is >= today
        if newDate >= today:
            return False
        newDate = newDate + timedelta(days=1)
        doneDate = fetchSqlData.dateExists(newDate, connection)
    # set new date for broker
    return fetchSqlData.setBrokerInfo(currInfo[0],currInfo[1],newDate,CONNECTION)

def buyStock(broker, symbol, shares, connection):
    """
    buyStock: buys shares of the stock symbol for broker
    broker - database return array of brokerinfo
    symbol - string symbol of stock
    shares - int number of shares to buy
    connection - database connection object
    return: boolean of success
    """
    currPrice = fetchSqlData.priceQuery(symbol, broker[2], connection)
    newBank = (broker[1] - (shares * currPrice)) - 9
    # check if bankroll is high enough
    if newBank >= 0:
        # check if sql transaction goes through
        if fetchSqlData.sqlTransaction(broker[2], broker[0], "BUY", symbol,  shares, currPrice, connection):
            # update broker info
            return fetchSqlData.setBrokerInfo(broker[0], newBank, broker[2], connection)
    # return false if any checks fail
    return False

def sellStock(broker, symbol, shares, connection):
    """
    sellStock: sell shares of the stock symbol for broker
    broker - database return array of brokerinfo
    symbol - string symbol of stock
    shares - int number of shares to sell
    connection - database connection object
    return: boolean of success
    """
    currPrice = fetchSqlData.priceQuery(symbol, broker[2], connection)
    newBank = (broker[1] + (shares * currPrice)) - 9
    newShares = fetchSqlData.queryOwnedStock(broker[0], symbol, connection) - shares
    # check if number of shares is high enough
    if newShares >= 0:
        # check if sql transaction goes through
        if fetchSqlData.sqlTransaction(broker[2], broker[0], "SELL", symbol, shares, currPrice, connection):
            # update broker info
            return fetchSqlData.setBrokerInfo(broker[0], newBank, broker[2], connection)
    # return false if any checks fail
    return False

def valueStocks(broker, date, connection):
    """
    valueStocks: gets value for all stocks owned by broker
    broker - database return array of brokerinfo
    connection - database connection object
    return: float value of all stocks
    """
    stockValue = 0.0
    ownedList = fetchSqlData.queryAllOwned(broker, connection)
    # for all stocks owned total value
    for stocks in ownedList:
        # get price for stock
        stockPrice = fetchSqlData.priceQuery(stocks[0], date, connection)
        # increment value
        stockValue += (stocks[1] * stockPrice)
    # return total value
    return stockValue

def loadingBar(fraction):
    numPounds = fraction
    printString = "Scoring["
    for x in range(0,numPounds):
        printString += "."
    for x in range(numPounds, 51):
        printString += " "
    printString += "]"
    stdout.write("\r")
    stdout.write(printString)
    stdout.flush()

def autoDayLoop(broker, connection):
    """
    autoDayLoop: automatically buys and sells for the day
    broker - broker name to run as
    connection - database connection object
    return: none
    """
    # fetch broker info [name, bank, date] and owned stocks
    brokerInfo = fetchSqlData.fetchBrokerInfo(broker, connection)
    ownedStocks = fetchSqlData.queryAllOwned(broker, connection)
    today = brokerInfo[2]
    quarterDate = brokerInfo[2] - timedelta(days=90)
    yearDate = brokerInfo[2] - timedelta(days=365)
    # check to sell
    if ownedStocks:
        # get 90 days ago
        for stocks in ownedStocks:
            # get 60 day pointset
            points = fetchSqlData.getPointsDateRange(quarterDate, today, stocks[0], ["Date", "AdjClose"], connection)
            kmeans = CurveFit.getKmean(points)
            # if its above high kmean sellall
            if points[-1][1] > kmeans[0]:
                sellStock(brokerInfo, stocks[0], stocks[1], connection)
                print(stocks, "SOLD")
    # get stock list
    stockList = fetchSqlData.getStockList(connection)
    highScores = []
    totalNumStocks = len(stockList)
    onStockNum = 0
    oldfraction = 0
    loadingBar(0)
    # score all stocks
    for stocks in stockList:
        onStockNum += 1
        #print(stocks[0])
        # if stock exists on dates
        if fetchSqlData.stockDateExists(today, stocks[0], connection) and fetchSqlData.stockDateExists(yearDate, stocks[0], connection):
            # load pointests
            pointSet = fetchSqlData.getPointsDateRange(yearDate, today, stocks[0], ["Date","AdjClose"], connection)
            secondSet = fetchSqlData.getPointsDateRange(quarterDate, today, stocks[0], ["Date","AdjClose"], connection)
            # score and append if higher
            score = CurveFit.compositeScore(pointSet, secondSet)
            CurveFit.appendHigher([stocks, score[0], score[1], score[2], pointSet[-1][1]] , highScores, 10)
            fraction = int((onStockNum / totalNumStocks) * 50)
            if oldfraction != fraction:
                loadingBar(fraction)
            oldfraction = fraction
    stdout.write("\r")
    stdout.flush()
    # check for which stock to buy
    for goodStocks in highScores:
        #newSet = fetchSqlData.getPointsDateRange(quarterDate, today, goodStocks[0][0], ["Date","AdjClose"], connection)
        #newPoly = CurveFit.polyFit(newSet,9)
        #CurveFit.drawPoints(newSet,newPoly)
        #newKmean = CurveFit.getKmean(newSet)
        # buy if below kmean
        if goodStocks[2] > goodStocks[4] and goodStocks[3] > goodStocks[4]:
            # check bank for how much to buy
            brokerInfo = fetchSqlData.fetchBrokerInfo(broker, connection)
            totalMoney = (valueStocks(broker, brokerInfo[2], connection) + brokerInfo[1]) / 10
            toBuy = int(totalMoney / goodStocks[4])
            if toBuy > 1000:
                toBuy = 1000
            # Buy stock
            if toBuy > 0:
                if buyStock(brokerInfo, goodStocks[0][0], toBuy, connection):
                    print(goodStocks, toBuy)
                    # Done if stock was bought
                    break

#================================================#
#===================== MAIN =====================#
#================================================#
connection = initDB.dbLogin()
#brokerInfo = fetchSqlData.fetchBrokerInfo("Broker1", connection)
#sellStock(brokerInfo, "NAV", 273, connection)
while True:
    brokerInfo = fetchSqlData.fetchBrokerInfo("Broker1", connection)
    holdings = valueStocks(brokerInfo[0], brokerInfo[2], connection)
    total = brokerInfo[1] + holdings
    print("\nDay: " + str(brokerInfo[2]))
    print("Bank: " + ("%.2f" % brokerInfo[1]))
    print("Stocks Value: " + ("%.2f" % holdings))
    print("Total assets: " + ("%.2f" % total))
    print(fetchSqlData.queryAllOwned(brokerInfo[0], connection))
    autoDayLoop(brokerInfo[0], connection)
    #input("Contine?")
    incrementDay(brokerInfo[0], connection)