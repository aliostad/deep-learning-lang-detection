package dao.systemmanage.slick

import dao.systemmanage.DepartmentDaoComponent
import models.slick.systemmanage.SystemManage
import models.systemmanage.{DepartmentQueryCondition, Department}
import play.api.db
import util.Page
import play.api.Play.current
import com.typesafe.slick.driver.oracle.OracleDriver.simple._

/**
 * Created by hooxin on 15-1-26.
 */
trait DepartmentDaoComponentImpl extends DepartmentDaoComponent {

  class DepartmentDaoImpl extends DepartmentDao {
    private def selectForPage(params: DepartmentQueryCondition, sort: String="id", dir: String="asc") = {
      SystemManage.departments.filter(d => {
        val l = List(params.id.map(d.id === _),
          params.departcode.map(d.departcode === _),
          params.departname.map(d.departname === _),
          params.parentDepartid.map(d.parentDepartid === _)
        ).flatten
        l.reduceOption(_ && _) getOrElse(LiteralColumn(true))
      }
      )
    }

    def maxDepartmentOrder(parentdepartid: Long): Int = db.slick.DB.withSession {
      implicit session =>
        SystemManage.departments.filter(d => d.parentDepartid === parentdepartid).size.run
    }

    /**
     * 分页总数查询
     * @param params 分页查询条件

     * @return 结果数
     */
    def count(params: DepartmentQueryCondition): Int = db.slick.DB.withSession {
      implicit session =>
       selectForPage(params).size.run
    }

    /**
     * 修改
     * @param m 实体

     * @return
     */
    def update(m: Department): Unit = db.slick.DB.withSession {
      implicit session =>
        SystemManage.departments.update(m).run
    }

    /**
     * 插入
     * @param m 实体

     * @return 插入后的实体
     */
    def insert(m: Department): Department = db.slick.DB.withSession {
      implicit session =>

        val x=SystemManage.departments.insert(m).run
        m
    }

    /**
     * 删除
     * @param m 实体

     * @return
     */
    def delete(m: Department): Unit = db.slick.DB.withSession {
      implicit session =>
      SystemManage.departments.filter(_.id === m.id).delete
    }

    /**
     * 通过主键删除
     * @param id 主键

     * @return
     */
    def deleteById(id: Long): Unit = db.slick.DB.withSession {
      implicit session =>
        SystemManage.departments.filter(_.id === id).delete
    }



    /**
     * 分页查询
     * @param pageno 页码
     * @param pagesize 每页显示数
     * @param params 分页查询条件
     * @param sort 排序字段
     * @param dir 升降序

     * @return 分页结果
     */
    def page(pageno: Int, pagesize: Int, params: DepartmentQueryCondition, sort: String, dir: String): Page[Department] =
      db.slick.DB.withSession {
        implicit session =>
      val page = Page[Department](pageno,pagesize,count(params))
      if(page.total==0)
        page
      else{
        val data=selectForPage(params,sort,dir).drop(page.start).take(page.limit).list
        page.copy(data=data)
      }
    }

    /**
     * 非分页查询
     * @param params 查询条件

     * @return 结果列表
     */
    def list(params: DepartmentQueryCondition): List[Department] =  db.slick.DB.withSession  { implicit session => selectForPage(params).list}

    /**
     * 通过主键获取单个实体
     * @param id 主键

     * @return 实体
     */
    def getById(id: Long): Option[Department] =
      db.slick.DB.withSession {
        implicit session =>
          SystemManage.departments.filter(_.id === id).firstOption
      }
  }



}
