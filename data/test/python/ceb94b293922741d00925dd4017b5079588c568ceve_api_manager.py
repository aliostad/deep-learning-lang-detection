import evelink.api
import evelink.char
import evelink.eve
from evelink.cache.shelf import ShelveCache
from django.conf import settings


class EveApiManager():
    def __init__(self):
        pass

    @staticmethod
    def get_characters_from_api(api_id, api_key):
        chars = []
        try:
            api = evelink.api.API(api_key=(api_id, api_key))
            # Should get characters
            account = evelink.account.Account(api=api)
            chars = account.characters()
        except evelink.api.APIError as error:
            print error

        return chars

    @staticmethod
    def get_corporation_ticker_from_id(corp_id):
        ticker = ""
        try:
            api = evelink.api.API()
            corp = evelink.corp.Corp(api)
            response = corp.corporation_sheet(corp_id)
            ticker = response[0]['ticker']
        except evelink.api.APIError as error:
            print error

        return ticker

    @staticmethod
    def get_alliance_information(alliance_id):
        results = {}
        try:
            api = evelink.api.API()
            eve = evelink.eve.EVE(api=api)
            alliance = eve.alliances()
            results = alliance[0][int(alliance_id)]
        except evelink.api.APIError as error:
            print error

        return results

    @staticmethod
    def get_corporation_information(corp_id, api_id = None, api_key=None):
        results = {}
        try:
            api = evelink.api.API(api_key=(settings.ALLIANCE_EXEC_CORP_ID, settings.ALLIANCE_EXEC_CORP_VCODE))
            corp = evelink.corp.Corp(api=api)
            corpinfo = corp.corporation_sheet(corp_id)
            results = corpinfo[0]
        except evelink.api.APIError as error:
            print error

        return results

    @staticmethod
    def check_api_is_type_account(api_id, api_key):
        try:
            api = evelink.api.API(api_key=(api_id, api_key))
            account = evelink.account.Account(api=api)
            info = account.key_info()
            return info[0]['type'] == "account"

        except evelink.api.APIError as error:
            print error

        return False


    @staticmethod
    def check_api_is_full(api_id, api_key):
        try:
            api = evelink.api.API(api_key=(api_id, api_key))
            account = evelink.account.Account(api=api)
            info = account.key_info()
            return (info[0]['access_mask'] == 268435455) or (info[0]['access_mask'] == 268382671)

        except evelink.api.APIError as error:
            print error

        return False


    @staticmethod
    def get_api_info(api_id, api_key):
        try:
            api = evelink.api.API(api_key=(api_id, api_key))
            account = evelink.account.Account(api=api)
            info = account.key_info()
            return info

        except evelink.api.APIError as error:
            print error

        return False

    @staticmethod
    def api_key_is_valid(api_id, api_key):
        try:
            api = evelink.api.API(api_key=(api_id, api_key))
            account = evelink.account.Account(api=api)
            info = account.key_info()
            return True
        except evelink.api.APIError as error:
            return False

        return False

    @staticmethod
    def check_if_api_server_online():
        try:
            api = evelink.api.API()
            server = evelink.server.Server(api=api)
            info = server.server_status()
            return info.result['online']
        except evelink.api.APIError as error:
            return False

        return False

    @staticmethod
    def check_if_id_is_corp(corp_id):
        try:
            api = evelink.api.API()
            corp = evelink.corp.Corp(api=api)
            corpinfo = corp.corporation_sheet(corp_id=int(corp_id))
            results = corpinfo[0]
            return True
        except evelink.api.APIError as error:
            return False

        return False

    @staticmethod
    def get_corp_kills(api_id, api_key):
        try:
            cache = ShelveCache('kills.dat')
            api = evelink.api.API(api_key=(api_id, api_key), cache=cache)
            corp = evelink.corp.Corp(api=api)
            kill_log = corp.kills()
            return kill_log
        except evelink.api.APIError as error:
            return {}

    @staticmethod
    def get_alliance_standings():
        if settings.ALLIANCE_EXEC_CORP_ID != "":
            try:
                api = evelink.api.API(api_key=(settings.ALLIANCE_EXEC_CORP_ID, settings.ALLIANCE_EXEC_CORP_VCODE))
                corp = evelink.corp.Corp(api=api)
                corpinfo = corp.contacts()
                results = corpinfo[0]
                return results
            except evelink.api.APIError as error:
                pass

        return {}

    @staticmethod
    def check_if_id_is_alliance(alliance_id):
        try:
            api = evelink.api.API()
            eve = evelink.eve.EVE(api=api)
            alliance = eve.alliances()
            results = alliance[0][int(alliance_id)]
            if results:
                return True
        except evelink.api.APIError as error:
            return False

        return False

    @staticmethod
    def check_if_id_is_character(character_id):
        try:
            api = evelink.api.API()
            eve = evelink.eve.EVE(api=api)
            results = eve.character_info_from_id(character_id)
            if results:
                return True
        except evelink.api.APIError as error:
            return False

        return False