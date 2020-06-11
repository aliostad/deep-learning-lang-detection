using Cats.Areas.Logistics.Models;
using Cats.Models;
using System.Collections.Generic;
using System.Linq;

namespace Cats.ViewModelBinder
{
    public class ProcessTemplateViewModelBinder
    {
        public static IEnumerable<BusinessProcessState> BindProcessTemplateViewModel(
            List<ProcessTemplateViewModel> processTemplatesViewModel)
        {
            List<BusinessProcessState> processTemplates = new List<BusinessProcessState>();

            if (processTemplatesViewModel.Any())
            {
                foreach (var processTemplate in processTemplatesViewModel)
                {
                    processTemplates.Add(new BusinessProcessState()
                                               {
                                                   ParentBusinessProcessID = processTemplate.ParentBusinessProcessID,
                                                   StateID = processTemplate.StateID,
                                                   PerformedBy = processTemplate.PerformedBy,
                                                   DatePerformed = processTemplate.Date
                                               }
                                          );
                }
            }

            return processTemplates;
        }
    }
}