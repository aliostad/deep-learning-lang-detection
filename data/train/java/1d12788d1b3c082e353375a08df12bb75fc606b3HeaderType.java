package com.odc.pdfextractor.enumeration;

import java.awt.Color;

import com.odc.pdfextractor.table.cloumn.handler.AmountHandler;
import com.odc.pdfextractor.table.cloumn.handler.BalanceHandler;
import com.odc.pdfextractor.table.cloumn.handler.CheckNumberHandler;
import com.odc.pdfextractor.table.cloumn.handler.ColumnHandler;
import com.odc.pdfextractor.table.cloumn.handler.CreditHandler;
import com.odc.pdfextractor.table.cloumn.handler.DateHandler;
import com.odc.pdfextractor.table.cloumn.handler.DebitHandler;
import com.odc.pdfextractor.table.cloumn.handler.DescriptionHandler;
import com.odc.pdfextractor.table.cloumn.handler.UnknownHandler;

public enum HeaderType {
    DATE(new DateHandler(), Color.DARK_GRAY),
    CHECK_NUMBER(new CheckNumberHandler(), Color.orange),
    DEBIT(new DebitHandler(), Color.red),
    CREDIT(new CreditHandler(), Color.blue),
    BALANCE(new BalanceHandler(), Color.cyan),
    DESCRIPTION(new DescriptionHandler(), Color.pink), 
    AMOUNT(new AmountHandler(),Color.GREEN),
    UNKOWN(new UnknownHandler(), Color.LIGHT_GRAY);
    private ColumnHandler handler;
    private Color headerColor;
    
    HeaderType(ColumnHandler handler, Color color) {
      this.setHandler(handler);
      this.headerColor = color;
    }

	public ColumnHandler getHandler() {
		return handler;
	}

	public void setHandler(ColumnHandler handler) {
		this.handler = handler;
	}

	public Color getColor() {
		return headerColor;
	}
  }