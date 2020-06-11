from stocks import db
from stocks.rest import api as stock_api
from stocks import app
from flask import render_template
from flask_restful import Api

api = Api(app)
api.add_resource(stock_api.HelloWorld, '/api')
api.add_resource(stock_api.ListStockResource, '/api/stocks')
api.add_resource(stock_api.StockReportResource, '/api/stocks/<string:symbol>/report')
api.add_resource(stock_api.FilteredStockReportResource, '/api/stocks/filtered_reports')
api.add_resource(stock_api.RealTimeStockResource, '/api/stocks/<string:symbol>/realtime')
api.add_resource(stock_api.HistoricalStockResource, '/api/stocks/<string:symbol>/history')
api.add_resource(stock_api.IndexesResource, '/api/stocks/indexes')
api.add_resource(stock_api.SettingsResource, '/api/settings')
api.add_resource(stock_api.EmailResource, '/api/emails')
api.add_resource(stock_api.DeleteEmailResource, '/api/emails/<string:email>')


@app.route('/')
def index():
    return render_template("index.html")
