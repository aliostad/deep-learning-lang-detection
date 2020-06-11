package hu.sztaki.ilab.reflecsv;

import java.util.HashMap;
import java.util.Map;

class TypeManager {

  private IntHandler intHandler =
    new DefaultPrimitiveHandlers.DefaultIntHandler();

  private DoubleHandler doubleHandler =
    new DefaultPrimitiveHandlers.DefaultDoubleHandler();

  private BooleanHandler booleanHandler =
    new DefaultPrimitiveHandlers.DefaultBooleanHandler();

  private ByteHandler byteHandler =
    new DefaultPrimitiveHandlers.DefaultByteHandler();

  private FloatHandler floatHandler =
    new DefaultPrimitiveHandlers.DefaultFloatHandler();

  private LongHandler longHandler =
    new DefaultPrimitiveHandlers.DefaultLongHandler();

  private ShortHandler shortHandler =
    new DefaultPrimitiveHandlers.DefaultShortHandler();

  private CharHandler charHandler =
    new DefaultPrimitiveHandlers.DefaultCharHandler();

  private Map<Class, FieldHandler> fieldHandlers =
    new HashMap<Class, FieldHandler>();

  private Map<Class, ObjectHandler> objectHandlers =
    new HashMap<Class, ObjectHandler>();

  public TypeManager() {
    createObjectHandlers();
  }

  private void createObjectHandlers() {
    objectHandlers.put(String.class,
        new DefaultObjectHandlers.StringHandler());
    objectHandlers.put(Integer.class,
        new DefaultObjectHandlers.IntHandler());
    objectHandlers.put(Double.class,
        new DefaultObjectHandlers.DoubleHandler());
    objectHandlers.put(Boolean.class,
        new DefaultObjectHandlers.BooleanHandler());
    objectHandlers.put(Byte.class,
        new DefaultObjectHandlers.ByteHandler());
    objectHandlers.put(Float.class,
        new DefaultObjectHandlers.FloatHandler());
    objectHandlers.put(Long.class,
        new DefaultObjectHandlers.LongHandler());
    objectHandlers.put(Short.class,
        new DefaultObjectHandlers.ShortHandler());
    objectHandlers.put(Character.class,
        new DefaultObjectHandlers.CharHandler());
  }

  public void setIntHandler(IntHandler intHandler) {
    this.intHandler = intHandler;
  }

  public void setDoubleHandler(DoubleHandler doubleHandler) {
    this.doubleHandler = doubleHandler;
  }

  public void setBooleanHandler(BooleanHandler booleanHandler) {
    this.booleanHandler = booleanHandler;
  }

  public void setByteHandler(ByteHandler byteHandler) {
    this.byteHandler = byteHandler;
  }

  public void setFloatHandler(FloatHandler floatHandler) {
    this.floatHandler = floatHandler;
  }

  public void setLongHandler(LongHandler longHandler) {
    this.longHandler = longHandler;
  }

  public void setShortHandler(ShortHandler shortHandler) {
    this.shortHandler = shortHandler;
  }

  public void setCharHandler(CharHandler charHandler) {
    this.charHandler = charHandler;
  }

  public void setObjectHandler(Class cls, ObjectHandler objectHandler) {
    objectHandlers.put(cls, objectHandler);
  }

  public void createFieldHandlers() {
    createPrimitiveFieldHandlers();
    createObjectFieldHandlers();
  }

  private void createPrimitiveFieldHandlers() {
    fieldHandlers.put(Integer.TYPE,
        new PrimitiveHandlers.IntFieldHandler(intHandler));
    fieldHandlers.put(Double.TYPE,
        new PrimitiveHandlers.DoubleFieldHandler(doubleHandler));
    fieldHandlers.put(Boolean.TYPE,
        new PrimitiveHandlers.BooleanFieldHandler(booleanHandler));
    fieldHandlers.put(Byte.TYPE,
        new PrimitiveHandlers.ByteFieldHandler(byteHandler));
    fieldHandlers.put(Float.TYPE,
        new PrimitiveHandlers.FloatFieldHandler(floatHandler));
    fieldHandlers.put(Long.TYPE,
        new PrimitiveHandlers.LongFieldHandler(longHandler));
    fieldHandlers.put(Short.TYPE,
        new PrimitiveHandlers.ShortFieldHandler(shortHandler));
    fieldHandlers.put(Character.TYPE,
        new PrimitiveHandlers.CharFieldHandler(charHandler));
  }

  private void createObjectFieldHandlers() {
    for (Map.Entry<Class, ObjectHandler> entry : objectHandlers.entrySet()) {
      Class cls = entry.getKey();
      ObjectHandler objectHandler = entry.getValue();
      fieldHandlers.put(cls, new ObjectFieldHandler(objectHandler));
    }
  }

  public FieldHandler createFieldHandler(Class cls) {
    if (fieldHandlers.containsKey(cls)) {
      return fieldHandlers.get(cls);
    } else {
      throw new RuntimeException("Not found handler");
    }
  }
 
}
