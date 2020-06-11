package controllers

import java.io.File
import javax.inject.Inject

import play.api.mvc.Controller
import play.api.data._
import play.api.data.Forms._
import play.api.mvc._
import play.api.db._
import models._

/**
  * Created by wangyuanyou on 5/15/17.
  */
class JobLibController  @Inject() extends Controller{

  def listJob=Action{
    val jobs= Job.listAllJob()
    val title="All job is here"
    val intro="下面是所有的部件："
    Ok(views.html.jobList(title,intro,jobs))
  }
  def inputJobInfo = Action{
    Ok(views.html.addJob())
  }
  def addJob = Action{implicit request =>
    val jobInfoForm = Form(
      tuple(
        "id" -> number,
        "jobname" -> text,
        "jobpath"->text,
        "jobtype"->text,
        "jobinfo"->text
      )
    )
    jobInfoForm.bindFromRequest().fold(
      errorForm => Ok(errorForm.errors.toString()),
      tupleData =>{
        val (id,jobname,jobpath,jobtype,jobinfo) = tupleData
        val one= new Job(id,jobname,jobpath,jobtype,jobinfo)
        Job.addOneJob(one)
        Redirect("/jobManage")
      }
    )
  }
  def deleteJob(id:Int)=Action{
    Job.deleteOneJob(id)
    Redirect("/jobManage")
  }
  def updateJobinfo(id:Int,name:String,path:String,jobtype:String,info:String) = Action{
    Ok(views.html.updateJob(id,name,path,jobtype,info))
  }
  def updateOneJob= Action{implicit request =>
    val jobupdateForm = Form(
      tuple(
        "id" -> number,
        "jobname" -> text,
        "jobpath"->text,
        "jobtype"->text,
        "jobinfo"->text
      )
    )
    jobupdateForm.bindFromRequest().fold(
      errorForm => Ok(errorForm.errors.toString()),
      tupleData =>{
        val (id,jobname,jobpath,jobtype,jobinfo) = tupleData
        val one= new Job(id,jobname,jobpath,jobtype,jobinfo)
        Job.updateOneJOb(one)
        Redirect("/jobManage")
      }
    )
  }
 def uploadJob= Action(parse.multipartFormData) { request =>
   request.body.file("oneJob").map { oneJob =>
     import java.io.File
     val filename = oneJob.filename
     val contentType = oneJob.contentType
     oneJob.ref.moveTo(new File(s"public/uploadJobs/$filename"))
     Redirect("/inputjobinfo")
   }.getOrElse {
     Redirect("/inputjobinfo").flashing(
       "error" -> "Missing file")
   }
 }
  def jobManage= Action{
    val jobs= Job.listAllJob()
    Ok(views.html.jobManage(jobs))
  }
  def listSelectJob =Action{
    val selectedjobs= Job.selectJobByType("input")
    Ok(views.html.jobManage(selectedjobs))
  }
  def jobConfig(id:Int)=Action{
    val configs=JobConfig.listByJobid(id)
    Ok(views.html.jobconfiglist(configs))
  }
}
