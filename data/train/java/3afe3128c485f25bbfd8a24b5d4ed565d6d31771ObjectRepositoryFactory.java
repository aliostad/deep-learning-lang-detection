package com.svashishtha.mocktail.metadata;


import com.svashishtha.mocktail.metadata.repository.YamlDiskRepository;
import com.svashishtha.mocktail.repository.DiskObjectRepository;
import com.svashishtha.mocktail.repository.ObjectRepository;

public class ObjectRepositoryFactory {

    public static ObjectRepository create(String serializerType) {
        if("yaml".equals(serializerType)){
            return new YamlDiskRepository();
        }
        return new DiskObjectRepository();
    }
    
    public static ObjectRepository create() {
        return new DiskObjectRepository();
    }
}
