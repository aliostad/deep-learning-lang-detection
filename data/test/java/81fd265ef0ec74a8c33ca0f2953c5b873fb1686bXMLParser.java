package ua.goit.alg.xmlparser.parser;


import java.io.File;
import java.io.IOException;
import java.io.InputStream;

import ua.goit.alg.xmlparser.input.StreamReader;
import ua.goit.alg.xmlparser.statemashines.StateMashineTag;

public class XMLParser  implements Parser {

  private Handler openTagHandler;
  private Handler closeTagHandler;
  private Handler textValueHandler;
  private Handler startHandler;
  private Handler endHandler;
  private Handler errHandler;
  private StreamReader reader;
  private StateMashineTag tag;

  public static class Builder {

    private Handler openTagHandler;
    private Handler closeTagHandler;
    private Handler textValueHandler;
    private Handler startHandler;
    private Handler endHandler;
    private Handler errHandler;

    public Builder setOpenTagHandler(Handler openTagHandler) {
      this.openTagHandler = openTagHandler;
      return this;
    }

    public Builder setCloseTagHandler(Handler closeTagHandler) {
      this.closeTagHandler = closeTagHandler;
      return this;
    }

    public Builder setTextValueHandler(Handler textValueHandler) {
      this.textValueHandler = textValueHandler;
      return this;
    }

    public Builder setStartHandler(Handler startHandler) {
      this.startHandler = startHandler;
      return this;
    }

    public Builder setEndHandler(Handler endHandler) {
      this.endHandler = endHandler;
      return this;
    }

    public Builder setErrHandler(Handler errHandler) {
      this.errHandler = errHandler;
      return this;
    }

    public XMLParser build() {
      return new XMLParser(this);
    }
  }

  public XMLParser() {
  }

  private XMLParser(Builder builder) {
    openTagHandler = builder.openTagHandler;
    closeTagHandler = builder.closeTagHandler;
    textValueHandler = builder.textValueHandler;
    startHandler = builder.startHandler;
    endHandler = builder.endHandler;
    errHandler = builder.errHandler;
  }

  public String parse(String string) throws IOException {
    reader = new StreamReader(string);
    return parseReader(reader);
  }

  public String parse(File file) throws IOException {
    reader = new StreamReader(file);
    return parseReader(reader);
  }

  @Override
  public String parse(InputStream inputStream) throws IOException {
    reader = new StreamReader(inputStream);
    return parseReader(reader);
  }

  public void close(){
    reader.close();
  }

  private String parseReader(StreamReader reader) throws IOException {
    tag = new StateMashineTag(this);
    int symbol;
    do {
      try {
        symbol = reader.read();
        tag.next((char) symbol);
      } catch (Exception e) {
        return "";
      }
    } while (symbol != -1);
    return "";
  }


  public void onOpenTag(ParserData parserData) {
    if (openTagHandler != null) {
      openTagHandler.handle(parserData);
    }
    parserData.putTagInStack();
    parserData.clear();
  }

  public void onCloseTag(ParserData parserData) {
    if (closeTagHandler != null) {
      closeTagHandler.handle(parserData);
    }
    if (!parserData.getStackElement().equals(parserData.getTag())) {
      onError(parserData);
    }
    parserData.clear();
  }

  public void onTextValue(ParserData parserData) {
    if (textValueHandler != null) {
      textValueHandler.handle(parserData);
    }
    parserData.setText("");
  }

  public void onStart(ParserData parserData) {
    if (startHandler != null) {
      startHandler.handle(parserData);
    }
    parserData.clear();
  }

  public void onEnd(ParserData parserData) {
    if (endHandler != null) {
      endHandler.handle(parserData);
    }
  }

  public void onError(ParserData parserData) {
    if (errHandler != null) {
      errHandler.handle(parserData);
    }
    reader.close();
  }

  public void onOpenTag(Handler handler) {
    openTagHandler = handler;
  }

  public void onCloseTag(Handler handler) {
    closeTagHandler = handler;
  }

  public void onTextValue(Handler handler) {
    textValueHandler = handler;
  }

  public void onStart(Handler handler) {
    startHandler = handler;
  }

  public void onEnd(Handler handler) {
    endHandler = handler;
  }

  public void onError(Handler handler) {
    errHandler = handler;
  }
}
