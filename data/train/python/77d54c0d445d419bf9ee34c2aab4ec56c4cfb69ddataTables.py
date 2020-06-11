# -*- coding: utf-8 -*-
import asyncio
from app.data import dataTableDispatch


# ====================================================================================================
class DataTableClass():
	def __init__(self, tableName):
		self.tableName = tableName

	@asyncio.coroutine
	def execute(self, requestDict):
		tableDispatch = dataTableDispatch.DataTableDispatchClass(self.tableName)
		result = yield from tableDispatch.execute(requestDict)
		return result
# ====================================================================================================
