'''
Created on 17 nov. 2016

@author: Henrik
@author: Alejandro P. Hernandez

'''
import cherrypy
import random
import string
import sqlite3
import pymysql
from checkout import Checkout
from book import Book
from index import Index
from login import Login
from addCredit import AddCredit
from bookPage import BookPage
from ticket import TicketPage
from shoppingCart import ShoppingCart
from deleteShoppingCart import DeleteShoppingCart
from search import SearchResult
from loginpage import UserLogin
from loginresult import LoginResult
from logoutpage import Logout
from addShoppingCart import AddShoppingCart
from allBooks import AllBooks
from loginregister import RegisterPage
from registered import Register
from tickets import Tickets
from sales import Sales
from totalsales import TotalSales
from bookCircle import BookCircle
from credit import CreditPage
from bookCirclePage import BookCirclePage

##conn = sqlite3.connect('C:/Users/Henrik/test.db')
##c=conn.cursor()



if __name__ == '__main__':
    
    
    
    config = {
    '/': {
        'tools.encode.debug': True,
        'tools.encode.text_only': False,
        'tools.encode.encoding': 'utf8'
    },
}

    cherrypy.tree.mount(
        Checkout(), '/api/checkout',
        {'/':
            {'request.dispatch': cherrypy.dispatch.MethodDispatcher()}
        }
    )
    
    cherrypy.tree.mount(
        Book(), '/api/book',
        {'/':
            {'request.dispatch': cherrypy.dispatch.MethodDispatcher()}
        }
    )
    
    
    cherrypy.tree.mount(
        Index(), '/api',
        {'/':
            {'request.dispatch': cherrypy.dispatch.MethodDispatcher()}
        }
    )
    
    
    cherrypy.tree.mount(
        UserLogin(), '/api/login',
        {'/':
            {'request.dispatch': cherrypy.dispatch.MethodDispatcher()}
        }
    )
    
    
    cherrypy.tree.mount(
        RegisterPage(), '/api/register',
        {'/':
            {'request.dispatch': cherrypy.dispatch.MethodDispatcher()}
        }
    )
    
    
    cherrypy.tree.mount(
        Register(), '/api/registersend',
        {'/':
            {'request.dispatch': cherrypy.dispatch.MethodDispatcher()}
        }
    )
    
    
    
    cherrypy.tree.mount(
        LoginResult(), '/api/loginresult',
        {'/':
            {'request.dispatch': cherrypy.dispatch.MethodDispatcher()}
        }
    )
    
    cherrypy.tree.mount(
        Logout(), '/api/logoutpage',
        {'/':
            {'request.dispatch': cherrypy.dispatch.MethodDispatcher()}
        }
    )
    
    cherrypy.tree.mount(
        TicketPage(), '/api/ticket',
        {'/':
            {'request.dispatch': cherrypy.dispatch.MethodDispatcher()}
        }
    )
    
    
    cherrypy.tree.mount(
        BookPage(), '/api/bookPage',
        {'/':
            {'request.dispatch': cherrypy.dispatch.MethodDispatcher()}
        }
    )
    
    cherrypy.tree.mount(
        ShoppingCart(), '/api/shoppingCart',
        {'/':
            {'request.dispatch': cherrypy.dispatch.MethodDispatcher()}
        }
    )
    
    
    cherrypy.tree.mount(
        DeleteShoppingCart(), '/api/deleteshoppingCart',
        {'/':
            {'request.dispatch': cherrypy.dispatch.MethodDispatcher()}
        }
    )
    
    
    cherrypy.tree.mount(
        AddShoppingCart(), '/api/addshoppingCart',
        {'/':
            {'request.dispatch': cherrypy.dispatch.MethodDispatcher()}
        }
    )
    
    cherrypy.tree.mount(
        SearchResult(), '/api/search',
        {'/':
            {'request.dispatch': cherrypy.dispatch.MethodDispatcher()}
        }
    )
    
    cherrypy.tree.mount(
        AllBooks(), '/api/allBooks',
        {'/':
            {'request.dispatch': cherrypy.dispatch.MethodDispatcher()}
        }
    )

    cherrypy.tree.mount(
        Tickets(), '/api/tickets',
        {'/':
            {'request.dispatch': cherrypy.dispatch.MethodDispatcher()}
        }
    )
    
    cherrypy.tree.mount(
        Sales(), '/api/sales',
        {'/':
            {'request.dispatch': cherrypy.dispatch.MethodDispatcher()}
        }
    )
    
    
    cherrypy.tree.mount(
        AddCredit(), '/api/addcredit',
        {'/':
            {'request.dispatch': cherrypy.dispatch.MethodDispatcher()}
        }
    )
    
    cherrypy.tree.mount(
        TotalSales(), '/api/totalsales',
        {'/':
            {'request.dispatch': cherrypy.dispatch.MethodDispatcher()}
        }
    )
    
    cherrypy.tree.mount(
        BookCircle(), '/api/bookCircle',
        {'/':
            {'request.dispatch': cherrypy.dispatch.MethodDispatcher()}
        }
    )

    
    cherrypy.tree.mount(
        CreditPage(), '/api/credit',
        {'/':
            {'request.dispatch': cherrypy.dispatch.MethodDispatcher()}
        }
    )
        
    cherrypy.tree.mount(
        BookCirclePage(), '/api/bookCirclePage',
        {'/':
            {'request.dispatch': cherrypy.dispatch.MethodDispatcher()}
        }
    )
    
    cherrypy.engine.start()
    cherrypy.engine.block()
                        
