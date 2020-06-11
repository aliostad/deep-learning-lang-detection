package ungp.sampleng.backend.util;

import org.springframework.context.ApplicationContext;
import org.springframework.data.mongodb.core.MongoOperations;

import ungp.sampleng.backend.repository.CondutorRepository;
import ungp.sampleng.backend.repository.InfracaoRepository;
import ungp.sampleng.backend.repository.LogradouroRepository;
import ungp.sampleng.backend.repository.VeiculoRepository;

public class Application {

    private static ApplicationContext applicationContext;

    public static ApplicationContext getApplicationContext() {
        if( applicationContext == null ) {
            applicationContext = ApplicationContextProvider.getApplicationContext();
        }
        return applicationContext;
    }

    public static <T> T getRepository(Class<T> repoClass) {
        return getApplicationContext().getBean(repoClass);
    }

    public static VeiculoRepository getVeiculoRepository() {
        return getRepository(VeiculoRepository.class);
    }

    public static CondutorRepository getCondutorRepository() {
        return getRepository(CondutorRepository.class);
    }
    
    public static InfracaoRepository getInfracaoRepository() {
        return getRepository(InfracaoRepository.class);
    }

    public static LogradouroRepository getLogradouroRepository() {
        return getRepository(LogradouroRepository.class);
    }
    
    public static MongoOperations getMongoOperations() {

        return (MongoOperations) getApplicationContext().getBean("mongoTemplate");

    }

}
