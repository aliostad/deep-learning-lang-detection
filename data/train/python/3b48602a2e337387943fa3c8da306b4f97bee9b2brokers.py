


from functools import partial
from graphviz import Digraph
import graphviz as gv



g = Digraph('loan market', filename='loan_market.gv')


a = Digraph('cluster_a')
a.attr('node', shape='box')
a.body.append('style=filled'); a.body.append('color=white')
arbs = ['Arbitrageur 1', 'Arbitrageur 2', 'Arbitrageur 3', 'Arbitrageur 4',
         'Arbitrageur 5', 'Arbitrageur 6']
for arb in arbs:
    a.node(arb)

a.edge('Arbitrageur 1', 'Arbitrageur 2', style='invis')
a.edge('Arbitrageur 2', 'Arbitrageur 3', style='invis')
a.edge('Arbitrageur 3', 'Arbitrageur 4', style='invis')
a.edge('Arbitrageur 4', 'Arbitrageur 5', style='invis')
a.edge('Arbitrageur 5', 'Arbitrageur 6', style='invis')






b = Digraph('cluster_b')
b.attr('node', shape='ellipse')
b.body.append('style=filled'); b.body.append('color=white')
brokers = ['Broker 1', 'Broker 2', 'Broker 3']
for bro in brokers:
    b.node(bro)
b.edge('Broker 1', 'Broker 2', style='invis')
b.edge('Broker 2', 'Broker 3', style='invis')


l = Digraph('cluster_l')
l.attr('node', shape='box')
l.body.append('style=filled'); l.body.append('color=white')
lenders = ['Lender 1', 'Lender 2', 'Lender 3', 'Lender 4']
for lender in lenders:
    l.node(lender)
l.edge('Lender 1', 'Lender 2', style='invis')
l.edge('Lender 2', 'Lender 3', style='invis')
l.edge('Lender 3', 'Lender 4', style='invis')


g.subgraph(a)
g.subgraph(b)
g.subgraph(l)



# g.edge('Broker 3', 'Arbitrageur 7', style='invis')

# g.edge('Broker 2', 'Arbitrageur 6')
# g.edge('Broker 2', 'Arbitrageur 5')
# g.edge('Broker 2', 'Arbitrageur 4')

# g.edge('Broker 1', 'Arbitrageur 4')
# g.edge('Broker 1', 'Arbitrageur 3')
# g.edge('Broker 1', 'Arbitrageur 2')
# g.edge('Broker 1', 'Arbitrageur 1')


# g.edge('Lender 1', 'Broker 1')


g.render('test-output/loans_market.gv', view=True)


