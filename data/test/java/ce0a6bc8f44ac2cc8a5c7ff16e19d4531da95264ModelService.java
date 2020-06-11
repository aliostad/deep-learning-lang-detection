package org.workcraft.interop;

import org.workcraft.dom.math.MathModel;
import org.workcraft.dom.visual.VisualModel;

/**
 * ServiceHandle specialised for ModelScope
 */
public final class ModelService<T> {
	@Deprecated
	public static final ModelService<MathModel> LegacyMathModelService = createNewService(MathModel.class, "A legacy service representing a math. model");
	@Deprecated
	public static final ModelService<VisualModel> LegacyVisualModelService = createNewService(VisualModel.class, "A legacy service representing a visual model");
	
	final ServiceHandle<ModelScope, T> handle;

	public ModelService(ServiceHandle<ModelScope, T> handle) {
		this.handle = handle;
	}

	public static <T> ModelService<T> createNewService(Class<T> type, String serviceName) {
		ServiceHandle<ModelScope, T> newService = ServiceHandle.createNewService(type, serviceName);
		return new ModelService<T>(newService);
	}

	public static <T> ModelService<T> createServiceUnchecked(String serviceName) {
		ServiceHandle<ModelScope, T> newService = ServiceHandle.createServiceUnchecked(serviceName);
		return new ModelService<T>(newService);
	}
}
