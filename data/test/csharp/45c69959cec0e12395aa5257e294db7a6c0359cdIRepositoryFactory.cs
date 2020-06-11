namespace ART.Aquaculture.Repository
{
    public interface IRepositoryFactory
    {
        /// <summary>
        /// Production method repository.
        /// </summary>
        IProductionMethodRepository ProductionMethodRepository { get; }

        /// <summary>
        /// Recommendation repository.
        /// </summary>
        IRecommendationRepository RecommendationRepository { get; }

        /// <summary>
        /// Species repository.
        /// </summary>
        ISpeciesRepository SpeciesRepository { get; }
    }
}