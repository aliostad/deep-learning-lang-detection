# Dennis McDaid
# Intro. to Computer Programming
# 09.18.2014
# Exercise 10: Stock Transaction Program

# This program will calculate and display the following:
# The amount of money Joe paid for the stock.
# The amount of commission Joe paid his broker when he bought the stock.
# The amount that Joe sold the stock for.
# The amount of commission Joe paid his broker when he sold the stock.
# The amount of money that Joe had left when he sold the stock and paid
# his broker (both times) and whether or not he made a profit.

# First we'll establish our known facts about the transaction.

BUYING_VALUE = 32.87
SELLING_VALUE = 33.92

SHARES = 1000
COMMISSION = .02

# Then, we'll calculate how much Joe paid in total for the stock.
    
BOUGHT_FOR = SHARES * BUYING_VALUE
PAID_BROKER = BOUGHT_FOR * COMMISSION
JOE_PAID = BOUGHT_FOR + PAID_BROKER

# Then his net total and how much the broker made.

SOLD_FOR = SHARES * SELLING_VALUE
BROKER_MADE = SOLD_FOR * COMMISSION

# Lastly, we'll see how much Joe finally made after
# purchasing and selling the stock.

JOE_MADE = SOLD_FOR - JOE_PAID - BROKER_MADE

# We will now print our results
    
print('Joe purchased ', SHARES, ' shares at $', BUYING_VALUE,\
      ' per share for a total of $', format(BOUGHT_FOR, '.2f'), sep='')

print('Joe paid his broker a 2% commission fee, which equates to $',\
      format(PAID_BROKER, '.2f'), sep='')

print('Joe paid $', format(JOE_PAID, '.2f'),\
      ' for the shares along with the commission fee.', sep='')
print()

print('Joe sold ', SHARES, ' shares at $', SELLING_VALUE,\
      ' per share for a total of $', format(SOLD_FOR, '.2f'), sep='')

print('Joe paid his broker a 2% commission fee again, which totaled to $',
      format(BROKER_MADE, '.2f'), sep='')

print("For Joe's final income of $", format(JOE_MADE, '.2f'), sep='')
print()

# And display one of the following messages
# contingent upon Joe's final income.

if JOE_MADE > 0:
    print('Joe made a profit!')

if JOE_MADE < 0:
    print('Joe lost money through this transaction.')
