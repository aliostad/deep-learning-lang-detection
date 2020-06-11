using BusinessLogic.Interfaces;

namespace BusinessLogic
{
    public class DataManager
    {
        private IDictionaryRepository dictionaryRepository;
        private IWordRepository wordRepository;
        private IUserRepository userRepository;
        private IMessageRepository messageRepository;
        private ILanguageRepository languageRepository;
       

        public DataManager(ILanguageRepository languageRepository, IDictionaryRepository dictionaryRepository, IWordRepository wordRepository, IUserRepository userRepository, IMessageRepository messageRepository)
        {
            this.dictionaryRepository = dictionaryRepository;
            this.wordRepository = wordRepository;
            this.userRepository = userRepository;
            this.messageRepository = messageRepository;
            this.languageRepository = languageRepository;
        }

        //св-ва через которые будет происх вызов
        public ILanguageRepository LanguageRepository
        {
            get { return languageRepository; }
        }
        public IDictionaryRepository DictionaryRepository
        {
            get { return dictionaryRepository; }
        }
        public IWordRepository WordRepository
        {
            get { return wordRepository; }
        }
        public IUserRepository UserRepository
        {
            get { return userRepository; }
        }
        public IMessageRepository MessageRepository
        {
            get { return messageRepository; }
        }
    }
}
