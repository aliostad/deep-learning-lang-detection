BROKER_REL = 5
FACT_ST = 3.44
CORP_ST = 4.62

def broker_fee (broker_rel, fact_st, corp_st):
    return (1.000 - 0.050 * broker_rel) / 2 ** (0.1400 * fact_st + 0.06000 * corp_st)


BROKER_FEE = broker_fee(BROKER_REL, FACT_ST, CORP_ST)/100
SELL_TAX= 0.75/100


def tax (buy, sell, vol, broker_fee = BROKER_FEE, sell_tax=SELL_TAX):
    return vol*(sell*(broker_fee+sell_tax) + buy*broker_fee)

def profit_after_tax (buy, sell, vol, broker_fee = BROKER_FEE, sell_tax=SELL_TAX):
    return vol*(sell - buy) - tax(buy,sell,vol,broker_fee,sell_tax)



MIN_INVESTMENT = 100000000
MAX_PROFIT_OVER_INVESTMENT = 1000

def good_deal(PAT, INV, TOP, POI):
    if INV < MIN_INVESTMENT:
        return False
    if POI > MAX_PROFIT_OVER_INVESTMENT:
        return False
    return True


def rank(PAT, INV, TOP, POI):
    return POI*INV
