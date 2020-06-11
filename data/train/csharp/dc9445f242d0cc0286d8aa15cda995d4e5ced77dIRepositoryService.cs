// --------------------------------------------------------------------------------------------------------------------
// <copyright file="IRepositoryService.cs" company="">
//   Copyright (c) 2010/2011 All Right Reserved
// </copyright>
// <summary>
//   Contains IRepositoryService class declaration.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

using iBupro2Model.Repositories.Interfaces;

namespace iBupro2Model.Repositories
{
	/// <summary>
    /// Interface for repository service.
    /// </summary>
    public interface IRepositoryService
    {
        IStudentPlanRepository StudentPlanRepositoryCreateInstance();
        IStudentFieldRepository StudentFieldRepositoryCreateInstance();
        ISubjectRepository SubjectRepositoryCreateInstace();
        IProjectRepository ProjectRepositoryCreateInstance();
        IDiplomProjectRepository DiplomProjectRepositoryCreateInstance();
        IUserRepository UserRepositoryCreateInstance();
        IRoleRepository RoleRepositoryCreateInstance();
        IDepartmentRepository DepartmentRepositoryCreateInstance();
        ITagRepository TagRepositoryCreateInstance();
        IHistoryRepository HistoryRepositoryCreateInstance();
        IOwnerRequestRepository OwnerRequestRepositoryCreateInstance();
        IProjectSourceRepository ProjectSourceRepositoryCreateInstance();
		ISemesterRepository SemesterRepositoryCreateInstance();
		IEnrollmentRepository EnrollmentRepositoryCreateInstance();
		ITagCategoryRepository TagCategoryRepositoryCreateInstance();
		IConfigurationRepository ConfigurationRepositoryCreateInstance();
    }
}
