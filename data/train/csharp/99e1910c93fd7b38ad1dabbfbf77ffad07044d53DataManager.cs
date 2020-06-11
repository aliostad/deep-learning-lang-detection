using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BusinessLogic.Interfaces;

namespace BusinessLogic
{
    public class DataManager
    {
        private ICityRepository cityRepository;
        private ICountryRepository countryRepository;
        private IFriendRequestRepository friendRequestRepository;
        private IGroupNewseRepository groupNewseRepository;
        private IGroupProfileRepository groupProfileRepository;
        private IGroupRepository groupRepository;
        private IGroupRequestRepository groupRequestRepository;
        private IGroupTypeRepository groupTypeRepository;
        private IMemberRoleRepository memberRoleRepository;
        private IMessageRepository messagesRepository;
        private IRegionRepository regionRepository;
        private IApplicationUserRepository userRepository;
        private IUserProfileRepository userProfileRepository;
        private IWallOfUserRepository wallOfUserRepository;

        public DataManager(
            ICityRepository cityRepository,
            ICountryRepository countryRepository,
            IFriendRequestRepository friendRequestRepository,
            IGroupNewseRepository groupNewseRepository,
            IGroupProfileRepository groupProfileRepository,
            IGroupRepository groupRepository,
            IGroupRequestRepository groupRequestRepository,
            IGroupTypeRepository groupTypeRepository,
            IMemberRoleRepository memberRoleRepository,
            IMessageRepository messageRepository,
            IRegionRepository regionRepository,
            IApplicationUserRepository userRepository,
            IUserProfileRepository userProfileRepository,
            IWallOfUserRepository wallOfUserRepository
            )
        {
            this.cityRepository = cityRepository;
            this.countryRepository = countryRepository;
            this.friendRequestRepository = friendRequestRepository;
            this.groupNewseRepository = groupNewseRepository;
            this.groupProfileRepository = groupProfileRepository;
            this.groupRepository = groupRepository;
            this.groupRequestRepository = groupRequestRepository;
            this.groupTypeRepository = groupTypeRepository;
            this.memberRoleRepository = memberRoleRepository;
            this.messagesRepository = messageRepository;
            this.regionRepository = regionRepository;
            this.userRepository = userRepository;
            this.userProfileRepository = userProfileRepository;
            this.wallOfUserRepository = wallOfUserRepository;
        }

        public ICityRepository Cities { get { return cityRepository; } }
        public ICountryRepository Countries { get { return countryRepository; } }
        public IFriendRequestRepository FriendRequests { get { return friendRequestRepository; } }
        public IGroupNewseRepository GroupNewses { get { return groupNewseRepository; } }
        public IGroupProfileRepository GroupProfiles { get { return groupProfileRepository; } }
        public IGroupRepository Groups { get { return groupRepository; } }
        public IGroupRequestRepository GroupRequests { get { return groupRequestRepository; } }
        public IGroupTypeRepository GroupTypes { get { return groupTypeRepository; } }
        public IMemberRoleRepository MemberRoles { get { return memberRoleRepository; } }
        public IMessageRepository Messages { get { return messagesRepository; } }
        public IRegionRepository Regions { get { return regionRepository; } }
        public IApplicationUserRepository Users { get { return userRepository; } }
        public IUserProfileRepository UserProfiles { get { return userProfileRepository; } }
        public IWallOfUserRepository WallOfUsers { get { return wallOfUserRepository; } }
    }
}
