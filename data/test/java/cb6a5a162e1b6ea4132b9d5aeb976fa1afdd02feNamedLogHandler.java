/**
 * 版权所有(C)，上海海鼎信息工程股份有限公司，2014，所有权利保留。
 * 
 * 项目名：	logmonitor-server
 * 文件名：	NamedLogHandler.java
 * 模块说明：	
 * 修改历史：
 * 2014-6-30 - zhangyanbo - 创建。
 */
package com.hd123.devops.logmonitor.pipeline.spring;

import com.hd123.devops.logmonitor.pipeline.LogHandler;

/**
 * 命名的日志处理器
 * 
 * @author zhangyanbo
 * 
 */
public class NamedLogHandler {

  private String name;
  private LogHandler handler;

  public NamedLogHandler() {
  }

  public NamedLogHandler(String name, LogHandler handler) {
    this.name = name;
    this.handler = handler;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public LogHandler getHandler() {
    return handler;
  }

  public void setHandler(LogHandler handler) {
    this.handler = handler;
  }

}
