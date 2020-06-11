using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using PaintballTournaments.Core.DataInterfaces;
using PaintballTournaments.Core.Tournaments;

namespace PaintballTournaments.Web.Controllers
{
    [HandleError]
    public class LayoutController : Controller
    {
        private ILayoutRepository layoutRepository;
        private IBunkerRepository bunkerRepository;
        private IBunkerPositionRepository bunkerPositionRepository;
        private IFieldRepository fieldRepository;
        private ILayoutTemplateRepository layoutTemplateRepository;
        
        public LayoutController(ILayoutRepository layoutRepository, IBunkerRepository bunkerRepository, IBunkerPositionRepository bunkerPositionRepository, IFieldRepository fieldRepository, ILayoutTemplateRepository layoutTemplateRepository)
        {
            this.layoutRepository = layoutRepository;
            this.bunkerRepository = bunkerRepository;
            this.bunkerPositionRepository = bunkerPositionRepository;
            this.fieldRepository = fieldRepository;
            this.layoutTemplateRepository = layoutTemplateRepository;
        }

        [AcceptVerbs(HttpVerbs.Get)]
        public ViewResult Index()
        {
            ViewData["Bunkers"] = bunkerRepository.GetAll();
            ViewData["Fields"] = fieldRepository.GetAll();
            ViewData["LayoutTemplates"] = layoutTemplateRepository.GetAll();
            
            Layout layout = new Layout();

            return View(layout);
        }
    }
}
