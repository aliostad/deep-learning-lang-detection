using Typer.DAL.Repositories;

namespace Typer.DAL.Infrastructure
{
    public class RepositoryFactory
    {

        private static readonly IUsersRepository UsersRepository;
        private static readonly IQuestionsRepository QuestionsRepository;
        private static readonly ILanguageRepository LanguageRepository;
        private static readonly IWordsRepository WordsRepository;
        private static readonly ICategoryRepository CategoryRepository;
        private static readonly IGrammarRepository GrammarRepository;

        static RepositoryFactory()
        {
            UsersRepository = new EFUsersRepository();
            QuestionsRepository = new EFQuestionsRepository();
            LanguageRepository = new EFLanguageRepository();
            WordsRepository = new EfWordsRepository();
            CategoryRepository = new EfCategoriesRepository();
            GrammarRepository = new EfGrammarRepository();
        }


        public static IUsersRepository GetUsersRepository()
        {
            return UsersRepository;
        }

        public static IQuestionsRepository GetQuestionsRepository()
        {
            return QuestionsRepository;
        }

        public static ILanguageRepository GetLanguageRepository()
        {
            return LanguageRepository;
        }

        public static IWordsRepository GetWordsRepository()
        {
            return WordsRepository;
        }

        public static ICategoryRepository GetCategoryRepository()
        {
            return CategoryRepository;
        }

        public static IGrammarRepository GetGrammarRepository()
        {
            return GrammarRepository;
        }

    }
}
