using PlayGen.SUGAR.Core.Authorization;
using PlayGen.SUGAR.Core.Controllers;
using DbControllerLocator = PlayGen.SUGAR.Data.EntityFramework.UnitTests.ControllerLocator;

namespace PlayGen.SUGAR.Core.UnitTests
{
    public abstract class ControllerLocator
    {
        private static AccountController _accountController;
        private static AccountSourceController _accountSourceController;
		private static ActorClaimController _actorClaimController;
		private static ActorRoleController _actorRoleController;
        private static ClaimController _claimController;
        private static EvaluationController _evaluationController;
        private static GameController _gameController;
        private static EvaluationDataController _evaluationDataController;
        private static GroupController _groupController;
        private static GroupMemberController _groupMemberController;
        private static LeaderboardController _leaderboardController;
        private static ResourceController _resourceController;
        private static RewardController _rewardController;
        private static RoleController _roleController;
        private static RoleClaimController _roleClaimController;
        private static UserController _userController;
        private static UserFriendController _userFriendController;
        private static MatchController _matchController;
        private static ActorController _actorController;
        private static GameDataController _gameDataController;

        public static AccountController AccountController
            => _accountController ?? (_accountController = new AccountController(DbControllerLocator.AccountController, AccountSourceController, UserController, ActorRoleController));

        public static AccountSourceController AccountSourceController
            => _accountSourceController ?? (_accountSourceController = new AccountSourceController(DbControllerLocator.AccountSourceController));

		public static ActorClaimController ActorClaimController
			=> _actorClaimController ?? (_actorClaimController = new ActorClaimController(DbControllerLocator.ActorClaimController, ActorRoleController, RoleClaimController, GroupMemberController));

		public static ActorRoleController ActorRoleController
            => _actorRoleController ?? (_actorRoleController = new ActorRoleController(DbControllerLocator.ActorRoleController, DbControllerLocator.RoleController));

        public static ClaimController ClaimController
            => _claimController ?? (_claimController = new ClaimController(DbControllerLocator.ClaimController, DbControllerLocator.RoleController, DbControllerLocator.RoleClaimController));

        public static EvaluationController EvaluationController
            => _evaluationController ?? (_evaluationController= new EvaluationController(DbControllerLocator.EvaluationController, GroupMemberController, UserFriendController, ActorController, RewardController, DbControllerLocator.ContextFactory));

        public static GameController GameController
            => _gameController ?? (_gameController = new GameController(DbControllerLocator.GameController, ActorClaimController, ActorRoleController));
        
        public static GroupController GroupController
            => _groupController ?? (_groupController = new GroupController(DbControllerLocator.GroupController, DbControllerLocator.ActorController, ActorClaimController, ActorRoleController, GroupMemberController));

        public static GroupMemberController GroupMemberController
            => _groupMemberController ?? (_groupMemberController = new GroupMemberController(DbControllerLocator.GroupRelationshipController));

        public static LeaderboardController LeaderboardController
            => _leaderboardController ?? (_leaderboardController = new LeaderboardController(GroupMemberController, UserFriendController, DbControllerLocator.ActorController, DbControllerLocator.GroupController, DbControllerLocator.UserController, DbControllerLocator.ContextFactory));

        public static ResourceController ResourceController
            => _resourceController ?? (_resourceController = new ResourceController(DbControllerLocator.ContextFactory));

        public static RewardController RewardController
            => _rewardController ?? (_rewardController = new RewardController(DbControllerLocator.ContextFactory, GroupMemberController, UserFriendController));

        public static RoleController RoleController
            => _roleController ?? (_roleController = new RoleController(DbControllerLocator.RoleController, ActorRoleController));

        public static RoleClaimController RoleClaimController
            => _roleClaimController ?? (_roleClaimController = new RoleClaimController(DbControllerLocator.RoleClaimController));

        public static UserController UserController
            => _userController ?? (_userController = new UserController(DbControllerLocator.UserController, DbControllerLocator.ActorController, ActorRoleController));

        public static UserFriendController UserFriendController
            => _userFriendController ?? (_userFriendController = new UserFriendController(DbControllerLocator.UserRelationshipController));

        public static MatchController MatchController
            => _matchController ?? (_matchController = new MatchController(DbControllerLocator.ContextFactory, DbControllerLocator.MatchController));

        public static ActorController ActorController
            => _actorController ?? (_actorController = new ActorController(DbControllerLocator.ActorController));

        public static GameDataController GameDataController =>
            _gameDataController ?? (_gameDataController = new GameDataController(DbControllerLocator.ContextFactory, ActorController));
    }
}
