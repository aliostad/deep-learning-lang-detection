package com.redhat.samples.esb.ws;

import javax.activation.DataHandler;
import javax.xml.bind.annotation.XmlMimeType;
import javax.xml.bind.annotation.XmlType;

@XmlType
public class DataResponse {
  private DataHandler dataHandler;

  public DataResponse() {}

  public DataResponse(DataHandler dataHandler) {
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
