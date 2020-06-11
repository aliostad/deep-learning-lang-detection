package xyz.uvwvu.service

import xyz.uvwvu.common.ServerResponse
import java.util

import com.github.pagehelper.PageInfo
import xyz.uvwvu.vo.OrderVo

/**
  * Created by aurevoirxavier on 5/30/17.
  */
trait IOrderService {
    def pay(orderNo: Long, userId: Integer, path: String): ServerResponse[_]

    def aliCallback(params: util.Map[String, String]): ServerResponse[_]

    def queryOrderPayStatus(userId: Integer, orderNo: Long): ServerResponse[_]

    def createOrder(userId: Integer, shippingId: Integer): ServerResponse[_]

    def getOrderCartProduct(userId: Integer): ServerResponse[_]

    def getOrderDetail(userId: Integer, orderNo: Long): ServerResponse[_]

    def getOrderList(userId: Integer, pageNum: Int, pageSize: Int): ServerResponse[_]

    def cancel(userId: Integer, orderNo: Long): ServerResponse[String]

    def manageSendGoods(orderNo: Long): ServerResponse[String]

    def manageList(pageNum: Int, pageSize: Int): ServerResponse[PageInfo[_]]

    def manageDetail(orderNo: Long): ServerResponse[OrderVo]

    def manageSearch(orderNo: Long, pageNum: Int, pageSize: Int): ServerResponse[PageInfo[_]]
}