using PlayGen.SUGAR.Data.EntityFramework.Controllers;

namespace PlayGen.SUGAR.Data.EntityFramework.UnitTests
{
	public abstract class ControllerLocator
	{
		// Pooling needs to be set to false due to a MySQL bug that reports "Nested transactions are not supported"
		// See: 
		// http://stackoverflow.com/questions/26320679/asp-net-web-forms-and-mysql-entity-framework-nested-transactions-are-not-suppo
		// http://bugs.mysql.com/bug.php?id=71502
		public const string ConnectionString = "Server=localhost;Port=3306;Database=sugarunittests;Uid=root;Pwd=t0pSECr3t;Convert Zero Datetime=true;Allow Zero Datetime=true;Pooling=false";
		public static readonly SUGARContextFactory ContextFactory = new SUGARContextFactory(ConnectionString);

		private static AccountController _accountController;
		private static AccountSourceController _accountSourceController;
		private static ActorController _actorController;
		private static ActorClaimController _actorClaimController;
		private static ActorRoleController _actorRoleController;
		private static ClaimController _claimController;
		private static GameController _gameController;
		private static EvaluationDataController _evaluationDataController;
		private static GroupController _groupController;
		private static GroupRelationshipController _groupRelationshipController;
		private static LeaderboardController _leaderboardController;
		private static EvaluationController _evaluationController;
		private static RoleController _roleController;
		private static RoleClaimController _roleClaimController;
		private static UserController _userController;
		private static UserRelationshipController _userRelationshipController;
		private static MatchController _matchController;

		public static AccountController AccountController
			=> _accountController ?? (_accountController = new AccountController(ContextFactory));

		public static AccountSourceController AccountSourceController
			=> _accountSourceController ?? (_accountSourceController = new AccountSourceController(ContextFactory));

		public static EvaluationController EvaluationController
			=> _evaluationController ?? (_evaluationController = new EvaluationController(ContextFactory));

		public static ActorController ActorController
			=> _actorController ?? (_actorController = new ActorController(ContextFactory));

		public static ActorClaimController ActorClaimController
			=> _actorClaimController ?? (_actorClaimController = new ActorClaimController(ContextFactory));

		public static ActorRoleController ActorRoleController
			=> _actorRoleController ?? (_actorRoleController = new ActorRoleController(ContextFactory));

		public static ClaimController ClaimController
			=> _claimController ?? (_claimController = new ClaimController(ContextFactory));

		public static GameController GameController
			=> _gameController ?? (_gameController = new GameController(ContextFactory));

		public static EvaluationDataController EvaluationDataController
			=> _evaluationDataController ?? (_evaluationDataController = new EvaluationDataController(ContextFactory));

		public static GroupController GroupController
			=> _groupController ?? (_groupController = new GroupController(ContextFactory));

		public static GroupRelationshipController GroupRelationshipController
			=> _groupRelationshipController ?? (_groupRelationshipController = new GroupRelationshipController(ContextFactory));

		public static LeaderboardController LeaderboardController
			=> _leaderboardController ?? (_leaderboardController = new LeaderboardController(ContextFactory));

		public static RoleController RoleController
			=> _roleController ?? (_roleController = new RoleController(ContextFactory));

		public static RoleClaimController RoleClaimController
			=> _roleClaimController ?? (_roleClaimController = new RoleClaimController(ContextFactory));

		public static UserController UserController
			=> _userController ?? (_userController = new UserController(ContextFactory));

		public static UserRelationshipController UserRelationshipController
			=> _userRelationshipController ?? (_userRelationshipController = new UserRelationshipController(ContextFactory));

		public static MatchController MatchController
			=> _matchController ?? (_matchController = new MatchController(ContextFactory));
	}
}