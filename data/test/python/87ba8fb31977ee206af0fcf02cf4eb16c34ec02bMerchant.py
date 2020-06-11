#!/usr/bin/env python
# -*- coding:utf-8 -*-

class IMerchantRepository:

    pass


class MerchantService:

    def __init__(self, merchant_repository):
        self.merchantRepository = merchant_repository

    def get_merchant_by_page(self, start, rows):

        count = self.merchantRepository.fetch_merchant_count()
        merchant_list = self.merchantRepository.fetch_merchant_by_page(start, rows)

        return count, merchant_list

    def get_merchant_detail_by_nid(self, merchant_id):
        result = self.merchantRepository.fetch_merchant_detail_by_nid(merchant_id)
        return result

    def create_merchant_by_kwargs(self, **kwargs):
        result = self.merchantRepository.add_merchant(**kwargs)
        return result

    def update_merchant_by_kwargs(self, nid, **kwargs):
        result = self.merchantRepository.update_merchant(nid, **kwargs)
        return result
