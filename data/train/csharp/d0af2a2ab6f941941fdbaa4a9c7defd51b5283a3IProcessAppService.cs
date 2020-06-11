using Cben.Application.Services;
using Cben.Application.Services.Dto;
using System.Threading.Tasks;

namespace Erp.Application.Process
{
    public interface IProcessAppService : IApplicationService
    {

        Task AddProcess(AddProcessInput input);

        Task UpdateProcess(UpdateProcessInput input);

        Task RemoveProcess(int processId);

        Task<ListResultDto<ProcessListDto>> GetAllProcess();

        Task<ProcessListDto> GetProcessById(int id);

        Task AddProcessCategory(AddProcessCategoryInput input);

        Task UpdateProcessCategory(UpdateProcessCategoryInput input);

        Task RemoveProcessCategory(int categoryId);

        Task<ListResultDto<ProcessCategoryListDto>> GetAllProcessCategory();

        Task<ProcessCategoryListDto> GetProcessCategoryById(int id);

    }
}