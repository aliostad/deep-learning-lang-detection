from carrot.connection import BrokerConnection

from config import BROKER_CONFIG, PRINTER_CONFIG

from pointofsale import printer


if __name__ == '__main__':
    conn = BrokerConnection(**BROKER_CONFIG)
    
    registry = printer.PrinterRegistry(PRINTER_CONFIG['registry'], PRINTER_CONFIG['auth_token'])
    p = printer.TestPrinter(PRINTER_CONFIG['name'], registry, conn)
    pm_handler = printer.PrinterMessageThread(p)
    
    pm_handler.start()
    while True:
        pm_handler.join(1)
        if not pm_handler.is_alive():
           break
