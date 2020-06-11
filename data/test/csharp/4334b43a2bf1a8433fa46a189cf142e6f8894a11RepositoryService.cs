// --------------------------------------------------------------------------------------------------------------------
// <copyright file="RepositoryService.cs" company="">
//   Copyright (c) 2010/2011 All Right Reserved
// </copyright>
// <summary>
//   Contains RepositoryService class declaration.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

using iBupro2Model.Repositories.Classes;
using iBupro2Model.Repositories.Interfaces;

namespace iBupro2Model.Repositories
{
	/// <summary>
	///   Implements IRepositoryService interface
	/// </summary>
	public class RepositoryService : IRepositoryService
	{
		#region IRepositoryService Members

		IStudentFieldRepository IRepositoryService.StudentFieldRepositoryCreateInstance()
		{
			return new StudentFieldRepository();
		}

		ISubjectRepository IRepositoryService.SubjectRepositoryCreateInstace()
		{
			return new SubjectRepository();
		}

		IProjectRepository IRepositoryService.ProjectRepositoryCreateInstance()
		{
			return new ProjectRepository();
		}

		public IDiplomProjectRepository DiplomProjectRepositoryCreateInstance()
		{
			return new DiplomProjectRepository();
		}

		public IUserRepository UserRepositoryCreateInstance()
		{
			return new UserRepository();
		}

		public IRoleRepository RoleRepositoryCreateInstance()
		{
			return new RoleRepository();
		}

		public IDepartmentRepository DepartmentRepositoryCreateInstance()
		{
			return new DepartmentRepository();
		}

		public ITagRepository TagRepositoryCreateInstance()
		{
			return new TagRepository();
		}

		IStudentPlanRepository IRepositoryService.StudentPlanRepositoryCreateInstance()
		{
			return new StudentPlanRepository();
		}

		public IHistoryRepository HistoryRepositoryCreateInstance()
		{
			return new HistoryRepository();
		}

		public IOwnerRequestRepository OwnerRequestRepositoryCreateInstance()
		{
			return new OwnerRequestRepository();
		}

		public IProjectSourceRepository ProjectSourceRepositoryCreateInstance()
		{
			return new ProjectSourceRepository();
		}

		public ISemesterRepository SemesterRepositoryCreateInstance()
		{
			return new SemesterRepository();
		}

		public IEnrollmentRepository EnrollmentRepositoryCreateInstance()
		{
			return new EnrollmentRepository();
		}

		public ITagCategoryRepository TagCategoryRepositoryCreateInstance()
		{
			return new TagCategoryRepository();
		}

		public IConfigurationRepository ConfigurationRepositoryCreateInstance()
		{
			return new ConfigurationRepository();
		}

		#endregion
	}
}