namespace PANOS
{
    public class CommitApiCommandFactory : ICommitCommandFactory
    {
        private readonly ApiUriFactory apiUriFactory;
        private readonly CommitApiPostKeyValuePairFactory apiPostKeyValuePairFactory;

        public CommitApiCommandFactory(
            ApiUriFactory apiUriFactory,
            CommitApiPostKeyValuePairFactory apiPostKeyValuePairFactory)
        {
            this.apiUriFactory = apiUriFactory;
            this.apiPostKeyValuePairFactory = apiPostKeyValuePairFactory;  
        }

        public ICommand<ApiEnqueuedResponse> CreateCommit(bool force) => 
            new Command<ApiEnqueuedResponse>(apiUriFactory.Create(), apiPostKeyValuePairFactory.CreateCommit(true)); 
    }
}
