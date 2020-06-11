using System;
using DoorofSoul.Database.DatabaseElements.Repositories;
using DoorofSoul.Database.DatabaseElements.Repositories.NatureRepositories;
using DoorofSoul.Database.MySQL.DatabaseElements.Repositories.NatureRepositories;

namespace DoorofSoul.Database.MySQL.DatabaseElements.Repositories
{
    class MySQLNatureRepositoryList : NatureRepositoryList
    {
        private MySQLWorldRepository worldRepository;
        private MySQLSceneRepository sceneRepository;
        private MySQLContainerRepository containerRepository;
        private MySQLEntityRepository entityRepository;

        private MySQLContainerElementsRepositoryList containerElementsRepositoryList;
        private MySQLEntityElementsRepositoryList entityElementsRepositoryList;
        private MySQLSceneElementsRepositoryList sceneElementsRepositoryList;

        public override WorldRepository WorldRepository { get { return worldRepository; } }
        public override SceneRepository SceneRepository { get { return sceneRepository; } }
        public override ContainerRepository ContainerRepository { get { return containerRepository; } }
        public override EntityRepository EntityRepository { get { return entityRepository; } }

        public override ContainerElementsRepositoryList ContainerElementsRepositoryList { get { return containerElementsRepositoryList; } }
        public override EntityElementsRepositoryList EntityElementsRepositoryList { get { return entityElementsRepositoryList; } }
        public override SceneElementsRepositoryList SceneElementsRepositoryList { get { return sceneElementsRepositoryList; } }

        public MySQLNatureRepositoryList()
        {
            worldRepository = new MySQLWorldRepository();
            sceneRepository = new MySQLSceneRepository();
            containerRepository = new MySQLContainerRepository();
            entityRepository = new MySQLEntityRepository();

            containerElementsRepositoryList = new MySQLContainerElementsRepositoryList();
            entityElementsRepositoryList = new MySQLEntityElementsRepositoryList();
            sceneElementsRepositoryList = new MySQLSceneElementsRepositoryList();
        }
    }
}
