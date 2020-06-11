using System.Web.Mvc;
using DB.DAL;

namespace Web.Controllers {
	public class SliderController : Controller {
		private readonly ISliderRepository _SliderRepository;
		private readonly ILanguageRepository _LanguageRepository;

		public SliderController(ISliderRepository sliderRepository, ILanguageRepository langRepository) {
			_SliderRepository = sliderRepository;
			_LanguageRepository = langRepository;
		}

		public PartialViewResult RenderSlider() {
			return PartialView(_SliderRepository.GetAll(_LanguageRepository.GetCurrentLanguage()));
		}
	}
}
