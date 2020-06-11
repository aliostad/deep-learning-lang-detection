/**
 * Factoria de repositorios
 * @author David Diaz Garcia
 * @date 24-04-2015
 */
package david.model.factory;

import david.model.provider.DProvider;
import david.model.repository.AddressRepository;
import david.model.repository.ChapterRepository;
import david.model.repository.CourseRepository;
import david.model.repository.CourseSchoolRepository;
import david.model.repository.CycleRepository;
import david.model.repository.FunctionalityRepository;
import david.model.repository.ModuleRepository;
import david.model.repository.PersonRepository;
import david.model.repository.RoleFunctionalityRepository;
import david.model.repository.RoleRepository;
import david.model.repository.SchoolRepository;
import david.model.repository.SessionRepository;
import david.model.repository.SubtypeRepository;
import david.model.repository.TypeRepository;
import david.model.repository.UserModuleRepository;
import david.model.repository.UserRepository;

public class RepositoryFactory {

	/**
	 * Atributo que almacena la instancia del provider local y MySql
	 */
	private final static DProvider PROVIDER_LOCAL_MYSQL = ProviderFactory.createMysqlProvider();

	/**
	 * Método que fabrica un UserRepository
	 * 
	 * @return UserRepository
	 */
	public static UserRepository createUserRepository() {
		return new UserRepository(PROVIDER_LOCAL_MYSQL);
	}

	/**
	 * Método que fabricca un PersonRepository
	 * 
	 * @return PersonRepository
	 */
	public static PersonRepository createPersonRepository() {
		return new PersonRepository(PROVIDER_LOCAL_MYSQL);
	}

	/**
	 * Método que fabrica un AddressRepository
	 * 
	 * @return AddressRepository
	 */
	public static AddressRepository createAddressRepository() {
		return new AddressRepository(PROVIDER_LOCAL_MYSQL);
	}

	/**
	 * Método que fabrica un RoleRepository
	 * 
	 * @return RoleRepository
	 */
	public static RoleRepository createRoleRepository() {
		return new RoleRepository(PROVIDER_LOCAL_MYSQL);
	}

	/**
	 * Método que fabrica un SchoolRepository
	 * 
	 * @return SchoolRepository
	 */
	public static SchoolRepository createSchoolRepository() {
		return new SchoolRepository(PROVIDER_LOCAL_MYSQL);
	}

	/**
	 * Método que fabrica un CourseRepository
	 * 
	 * @return CourseRepository
	 */
	public static CourseRepository createCourseRepository() {
		return new CourseRepository(PROVIDER_LOCAL_MYSQL);
	}

	/**
	 * Método que fabrica un CourseSchoolRepository
	 * 
	 * @return CourseSchoolRepository
	 */
	public static CourseSchoolRepository createCourseSchoolRepository() {
		return new CourseSchoolRepository(PROVIDER_LOCAL_MYSQL);
	}

	/**
	 * Método que fabrica un CycleRepository
	 * 
	 * @return CycleRepository
	 */
	public static CycleRepository createCycleRepository() {
		return new CycleRepository(PROVIDER_LOCAL_MYSQL);
	}

	/**
	 * Método que fabrica un ModuleRepository
	 * 
	 * @return ModuleRepository
	 */
	public static ModuleRepository createModuleRepository() {
		return new ModuleRepository(PROVIDER_LOCAL_MYSQL);
	}

	/**
	 * Método que fabrica un TypeRepository
	 * 
	 * @return TypeRepository
	 */
	public static TypeRepository createTypeRepository() {
		return new TypeRepository(PROVIDER_LOCAL_MYSQL);
	}

	/**
	 * Método que fabriva un SubtypeRepository
	 * 
	 * @return SubtypeRepository
	 */
	public static SubtypeRepository createSubtypeRepository() {
		return new SubtypeRepository(PROVIDER_LOCAL_MYSQL);
	}

	/**
	 * Método que fabrica un ChpaterRepository
	 * 
	 * @return ChapterRepository
	 */
	public static ChapterRepository createChapterRepository() {
		return new ChapterRepository(PROVIDER_LOCAL_MYSQL);
	}

	/**
	 * Método que fabrica un SessionRepository
	 * 
	 * @return SessionRepository
	 */
	public static SessionRepository createSessionRepository() {
		return new SessionRepository(PROVIDER_LOCAL_MYSQL);
	}

	/**
	 * Método que fabrica un UserModuleRepository
	 * 
	 * @return UserModuleRepository
	 */
	public static UserModuleRepository createUserModuleRepository() {
		return new UserModuleRepository(PROVIDER_LOCAL_MYSQL);
	}

	/**
	 * Método que fabrica un FunctionalityRepository
	 * 
	 * @return FunctionalityRepository
	 */
	public static FunctionalityRepository createFunctionalityRepository() {
		return new FunctionalityRepository(PROVIDER_LOCAL_MYSQL);
	}

	/**
	 * Método que fabrica un RoleFunctionalityRepository
	 * 
	 * @return RoleFunctionalityRepository
	 */
	public static RoleFunctionalityRepository createRoleFunctionalityRepository() {
		return new RoleFunctionalityRepository(PROVIDER_LOCAL_MYSQL);
	}
}
