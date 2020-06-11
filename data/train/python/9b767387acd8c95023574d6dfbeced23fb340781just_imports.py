from config import (KAYAKO_API_URL,
                    KAYAKO_API_KEY,
                    KAYAKO_SECRET_KEY,
                    HF_API_URL,
                    HF_API_KEY,
                    HF_AUTH_KEY)
from kayako import (KayakoAPI,
                    User,
                    Staff,
                    Department,
                    Ticket,
                    TicketPost,
                    TicketAttachment,
                    TicketNote,
                    TicketStatus,
                    TicketPriority)
import requests
import shelve


k_api = KayakoAPI(KAYAKO_API_URL, KAYAKO_API_KEY, KAYAKO_SECRET_KEY)
h_api = (HF_API_KEY, HF_AUTH_KEY)


