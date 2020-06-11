import psycopg2
import datetime

def dbLogin():
    """
    dbLogin: logs into database for stock market program
    return: sql connection object or failure boolean
    """
    try:
        return psycopg2.connect("dbname=StockMarket user=postgres password=mathmatician3")
    except:
        return False

def createTables(connection):
    """
    createTables: creates tables in database connection for stockmarket
    connection - sql connection object
    return: boolean success or fail
    """
    DBcurr = connection.cursor()
    success = True
    # try to create all database tables
    try:
        DBcurr.execute("CREATE TABLE StockInfo (Symbol varchar, EndDate date, Usable boolean);")
        # Unique index on Symbol to lookup
        DBcurr.execute("CREATE UNIQUE INDEX SymUIndex ON StockInfo (Symbol);")
        DBcurr.execute("CREATE INDEX EndIndex ON StockInfo (EndDate);")
        DBcurr.execute("CREATE TABLE StockPoints (Symbol varchar, Date date, Open float, High float, Low float, Close float, Volume float, AdjClose float);")
        # Index on Date and Symbol to lookup Symbol and filter on date
        DBcurr.execute("CREATE INDEX DateIndex ON StockPoints (Date);")
        DBcurr.execute("CREATE INDEX SymIndex ON StockPoints (Symbol);")
        connection.commit()
    except:
        connection.rollback()
        success = False
    # close cursor
    DBcurr.close()
    return success

def dropTables(connection):
    """
    dropTables: drops all tables that createTables creates
    connection - sql connection object
    return: boolean success or fail
    """
    DBcurr = connection.cursor()
    success = True
    # try to drop all database tables
    try:
        DBcurr.execute("DROP TABLE StockInfo;")
        DBcurr.execute("DROP TABLE StockPoints;")
        connection.commit()
    except:
        connection.rollback()
        success = False
    # close cursor
    DBcurr.close()
    return success

def createBrokerTables(connection):
    """
    createBrokerTable: creates table to keep track of broker info
    connection - database connection object
    return: boolean of success
    """
    DBcurr = connection.cursor()
    try:
        print("1")
        DBcurr.execute("CREATE TABLE StockBroker (Name varchar, Bank float, Date date);")
        DBcurr.execute("CREATE TABLE OwnedStocks (Broker varchar, Symbol varchar, Shares integer);")
        print("2")
        DBcurr.execute("CREATE INDEX BrokerIndex ON OwnedStocks (Broker);")
        DBcurr.execute("CREATE TABLE TransLog (Date date, Broker varchar, Symbol varchar, Shares integer, Price float, BuySell varchar);")
        print("3")
        DBcurr.execute("CREATE INDEX BrokerLogIndex ON TransLog (Broker);")
        connection.commit()
    except:
        connection.rollback()
        return False
    DBcurr.close()
    return True

def dropBrokerTables(connection):
    """
    dropBrokerTables: drop broker tables
    connection - database connection object
    return: boolean success
    """
    DBcurr = connection.cursor()
    try:
        DBcurr.execute("DROP TABLE StockBroker;")
        DBcurr.execute("DROP TABLE OwnedStocks;")
        DBcurr.execute("DROP TABLE TransLog;")
        connection.commit()
    except:
        connection.rollback()
        return False
    DBcurr.close()
    return True

def createBroker(name, bank, date, connection):
    """
    createBroker: creates broker with Name Bankroll and Date on connection
    name - string name of broker
    bank - float doller amount to give broker
    date - date for broker to start on
    connection - db conneciton object
    return: boolean success
    """
    DBcurr = connection.cursor()
    try:
        sqlString = "INSERT INTO StockBroker (Name, Bank, Date) VALUES (%s,%s,%s);"
        sqlItems = [name,bank,date]
        DBcurr.execute(sqlString,sqlItems)
        connection.commit()
    except:
        connection.rollback()
        return False
    DBcurr.close()
    return True

#conn = dbLogin()
#dropBrokerTables(conn)
#createBrokerTables(conn)
#createBroker("Broker1", 100000.0, datetime.date(1990, 1, 1), conn)