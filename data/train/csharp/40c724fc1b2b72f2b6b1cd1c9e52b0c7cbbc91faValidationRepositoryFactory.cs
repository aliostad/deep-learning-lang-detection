namespace Validate
{
    public interface IValidationRepositoryFactory
    {
        IValidationRepository GetValidationRepository();
    }

    public class ValidationRepositoryFactory : IValidationRepositoryFactory
    {
        private static IValidationRepository _validationRepository = new ValidationRepository();
        
        /// <summary>
        /// The value of ValidationRepository can be set for using a custom implementation of IValidationRepository
        /// </summary>
        public static IValidationRepository ValidationRepository
        {
            get { return _validationRepository; } 
            set { _validationRepository = value; }
        }

        public virtual IValidationRepository GetValidationRepository()
        {
            return ValidationRepository;
        }
    }
}