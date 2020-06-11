using kCura.Relativity.Client.DTOs;
using kCura.Relativity.Client.Repositories;

namespace AdminMigrationUtility.Helpers.Rsapi.Interfaces
{
	public interface IRsapiRepositoryGroup
	{
		IGenericRepository<Batch> BatchRepository { get; set; }
		IGenericRepository<BatchSet> BatchSetRepository { get; set; }
		IGenericRepository<Choice> ChoiceRepository { get; set; }
		IGenericRepository<Client> ClientRepository { get; set; }
		IGenericRepository<Document> DocumentRepository { get; set; }
		IGenericRepository<Error> ErrorRepository { get; set; }
		IGenericRepository<Field> FieldRepository { get; set; }
		IGenericRepository<Group> GroupRepository { get; set; }
		IGenericRepository<Layout> LayoutRepository { get; set; }
		IGenericRepository<MarkupSet> MarkupSetRepository { get; set; }
		IGenericRepository<ObjectType> ObjectTypeRepository { get; set; }
		IGenericRepository<RDO> RdoRepository { get; set; }
		IGenericRepository<RelativityApplication> RelativityApplicationRepository { get; set; }
		IGenericRepository<RelativityScript> RelativityScriptRepository { get; set; }
		IGenericRepository<Tab> TabRepository { get; set; }
		IGenericRepository<User> UserRepository { get; set; }
		IGenericRepository<View> ViewRepository { get; set; }
		IGenericRepository<Workspace> WorkspaceRepository { get; set; }
	}
}