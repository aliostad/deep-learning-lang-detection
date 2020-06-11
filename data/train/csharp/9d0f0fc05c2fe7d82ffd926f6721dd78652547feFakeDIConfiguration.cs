using Mentorship.Backend.Repositories;

namespace Mentorship
{
    public static class FakeDiConfiguration
    {
        private static AddressRepository _addressRepository;
        private static ChildrenRepository _childrenRepository;
        private static ParentRepository _parentRepository;

        public static void Configure()
        {
            _addressRepository = new AddressRepository();
            _childrenRepository = new ChildrenRepository();
            _parentRepository = new ParentRepository();
        }

        public static AddressRepository GetAddressRepository()
        {
            return _addressRepository;
        }

        public static ChildrenRepository GetChildrenRepository()
        {
            return _childrenRepository;
        }

        public static ParentRepository GetParentRepository()
        {
            return _parentRepository;
        }
    }
}
