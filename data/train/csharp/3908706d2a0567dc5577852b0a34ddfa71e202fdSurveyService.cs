using Gestmank.Interfaces.IRepositories;

namespace Gestmank.Services
{
    public class SurveyService
    {
        private readonly ISurveyRepository _surveyRepository;
        private readonly ISurveyCategoryRepository _categoryRepository;
        private readonly ISurveyOptionRepository _optionRepository;
        private readonly ISurveyUserChoiceRepository _userChoiceRepository;

        public SurveyService(ISurveyRepository surveyRepository, 
            ISurveyCategoryRepository categoryRepository, 
            ISurveyOptionRepository optionRepository, 
            ISurveyUserChoiceRepository userChoiceRepository)
        {
            _surveyRepository = surveyRepository;
            _userChoiceRepository = userChoiceRepository;
            _optionRepository = optionRepository;
            _categoryRepository = categoryRepository;
        }
    }
}