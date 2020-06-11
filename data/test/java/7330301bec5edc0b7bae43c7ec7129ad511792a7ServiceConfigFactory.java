package me.ellios.hedwig.rpc.core;


import com.google.common.base.Preconditions;
import me.ellios.hedwig.rpc.core.ServiceConfig;
import me.ellios.hedwig.rpc.core.ServiceSchema;
import me.ellios.hedwig.rpc.core.ServiceType;
import org.apache.commons.lang3.StringUtils;

import javax.annotation.Nullable;

/**
 * Author: ellios
 * Date: 12-11-1 Time: 下午5:02
 *
 * @deprecated please use {@link me.ellios.hedwig.rpc.core.ServiceConfig.Builder} instead.
 */
public class ServiceConfigFactory {


    /**
     * 创建pb的服务配置
     *
     * @param serviceFace
     * @param serviceImpl
     * @return
     */
    public static ServiceConfig createPbServiceConfig(Class serviceFace, Class serviceImpl) {
        return createPbServiceConfig(serviceFace, serviceImpl, ServiceConfig.DEFAULT_SERVICE_PORT);
    }

    /**
     * 创建pb的服务配置
     *
     * @param serviceFace
     * @param serviceImpl
     * @param port
     * @return
     */
    public static ServiceConfig createPbServiceConfig(Class serviceFace, Class serviceImpl, int port) {
        Preconditions.checkNotNull(serviceFace, "serviceFace is null");
        Preconditions.checkNotNull(serviceImpl, "serviceImpl is null");
        return ServiceConfig.newBuilder()
                .port(port)
                .type(ServiceType.PROTOBUF)
                .serviceFace(serviceFace)
                .serviceImpl(serviceImpl)
                .build();
    }

    /**
     * 创建thrift的服务配置
     *
     * @param serviceFace
     * @param serviceImpl
     * @return
     */
    public static ServiceConfig createThriftServiceConfig(Class serviceFace, Class serviceImpl) {
        return createThriftServiceConfig(serviceFace, serviceImpl, ServiceConfig.DEFAULT_SERVICE_PORT);
    }

    /**
     * 创建thrfit的服务配置
     *
     * @param serviceFace
     * @param serviceImpl
     * @return
     */
    public static ServiceConfig createThriftServiceConfig(Class serviceFace, Class serviceImpl, int port) {
        Preconditions.checkNotNull(serviceFace, "serviceFace is null");
        Preconditions.checkNotNull(serviceImpl, "serviceImpl is null");
        return ServiceConfig.newBuilder()
                .serviceFace(serviceFace)
                .serviceImpl(serviceImpl)
                .type(ServiceType.THRIFT)
                .port(port)
                .build();
    }


    public static ServiceConfig createServiceConfig(String serviceName, int port,
                                                    ServiceSchema schema, ServiceType type,
                                                    Class serviceFace, Class serviceImpl) {
        return createServiceConfig(serviceName, port,
                schema, type, ServiceConfig.DEFAULT_SERVICE_GROUP,
                serviceFace, serviceImpl);
    }

    public static ServiceConfig createServiceConfig(String serviceName, int port,
                                                    ServiceSchema schema, ServiceType type,
                                                    @Nullable String serviceGroup,
                                                    Class serviceFace, Class serviceImpl) {
        Preconditions.checkArgument(StringUtils.isNotEmpty(serviceName), "serviceName is empty.");
        Preconditions.checkNotNull(schema, "schema is null");
        Preconditions.checkNotNull(type, "type is null");
        Preconditions.checkNotNull(serviceFace, "serviceFace is null");
        Preconditions.checkNotNull(serviceImpl, "serviceImpl is null");
        return ServiceConfig.newBuilder()
                .name(serviceName)
                .port(port)
                .schema(schema)
                .type(type)
                .serviceFace(serviceFace)
                .serviceImpl(serviceImpl)
                .serviceGroup(serviceGroup)
                .build();
    }
}
