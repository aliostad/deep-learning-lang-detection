package com.redhat.samples.ws;

import javax.activation.DataHandler;
import javax.xml.bind.annotation.XmlMimeType;
import javax.xml.bind.annotation.XmlType;

@XmlType
public class DataRequest {
  private DataHandler dataHandler;

  public DataRequest() {}

  public DataRequest(DataHandler dataHandler) {
    this.dataHandler = dataHandler;
  }

  @XmlMimeType("image/x-png")
  public DataHandler getDataHandler() {
    return dataHandler;
  }

  public void setDataHandler(DataHandler dataHandler) {
    this.dataHandler = dataHandler;
  }

}
