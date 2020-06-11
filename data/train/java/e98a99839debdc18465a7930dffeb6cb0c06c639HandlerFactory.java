package eu.modelwriter.visualization.editor.handler;

import eu.modelwriter.visualization.editor.handler.StaticHandlerManager.BoundType;

public class HandlerFactory {
  public static ChangeAtomTypeHandler changeAtomTypeHandler() {
    return new ChangeAtomTypeHandler();
  }

  public static CreateAtomHandler createAtomHandler() {
    return new CreateAtomHandler();
  }

  public static CreateMappingHandler createMappingHandler() {
    return new CreateMappingHandler();
  }

  public static MoveToHandler moveToHandler(final BoundType bound) {
    return new MoveToHandler(bound);
  }

  public static RemoveCellHandler removeCellHandler() {
    return new RemoveCellHandler();
  }

  public static SwitchEdgeColorsHandler switchEdgeColorsHandler() {
    return new SwitchEdgeColorsHandler();
  }
}
