#! ../env/bin/python
# -*- coding: utf-8 -*-

import manage
from hearthstone import mongo, create_app
import os
import test_base
import pytest

class TestManage:

    @pytest.mark.slow
    def test_fetch_url(self):
        heros = manage.fetch_main_index()
        assert len(heros) > 5
        
        hero = heros[0]
        assert hero['name']
        assert hero['decks']
        
        deck = hero['decks'][0]
        assert deck['desc']
        assert deck['_id']
        card = deck['cards'][0]
        assert card['count']
        assert card['id'] is not None

    @pytest.mark.slow
    @pytest.mark.single
    def test_fetch_decks(self):
        mongo.db.deck.remove()
        assert mongo.db.deck.find().count() == 0
        heros = manage.fetch_main_index()
        for t in [x['name'] for x in heros]:
            print t
            
        assert u'德鲁伊' in [x['name'] for x in heros]
        assert len(heros[0]['decks'][0]['cards']) > 1
        
        manage.import_cards_decks()
        assert mongo.db.deck.find({'name': u'德鲁伊'}).count()

    @pytest.mark.slow
    def test_detail_card_url(self):
        url = manage.parse_detail_cards_url('http://ls.duowan.com/1401/254491496703.html')
        assert url.find(r'#^')
        assert len(manage.parse_url(url))
        
