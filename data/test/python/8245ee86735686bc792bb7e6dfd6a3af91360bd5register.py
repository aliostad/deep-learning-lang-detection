def register_django_town_social(manager, exclude=None):
    from django_town.social.apis.post import PostApiView, PostsApiView, PostCommentsApiView, PostLikesApiView
    from django_town.social.apis.user import UsersApiView, UserApiView, UserMeApiView, UserLikesPagesApiView, \
        UserMeLikesPagesApiView, DevicesApiView, UserMeDeviceApiView
    from django_town.social.apis.place import PlaceApiView, PlacesApiView
    from django_town.social.apis.photo import PhotoApiView, PhotosApiView
    from django_town.social.apis.page import PageApiView, PagesApiView, PageLikesApiView, PageFeedsApiView, \
        PagePostsApiView
    from django_town.social.apis.feed import FeedApiView, FeedFollowersApiView, FeedPostsApiView, FeedsApiView, \
        FeedTokenApiView
    from django_town.social.apis.session import SessionsApiView
    from django_town.social.apis.link import LinkApiView, LinksApiView, LinksSearchApiView
    from django_town.social.apis.client import ClientApiView

    # manager.register_rest_api_view(PostApiView)
    # manager.register_rest_api_view(PostsApiView)
    # manager.register_rest_api_view(PostCommentsApiView)
    # manager.register_rest_api_view(PostLikesApiView)

    # manager.register_rest_api_view(UserApiView)
    manager.register_rest_api_view(UserMeApiView)
    manager.register_rest_api_view(UsersApiView)
    # manager.register_rest_api_view(UserLikesPagesApiView)
    # manager.register_rest_api_view(UserMeLikesPagesApiView)
    manager.register_rest_api_view(DevicesApiView)
    manager.register_rest_api_view(UserMeDeviceApiView)

    # manager.register_rest_api_view(LinksSearchApiView)
    # manager.register_rest_api_view(LinkApiView)
    # manager.register_rest_api_view(LinksApiView)

    # manager.register_rest_api_view(PlaceApiView)
    # manager.register_rest_api_view(PlacesApiView)

    # manager.register_rest_api_view(PhotoApiView)
    # manager.register_rest_api_view(PhotosApiView)

    # manager.register_rest_api_view(PageApiView)
    # manager.register_rest_api_view(PagesApiView)
    # manager.register_rest_api_view(PageLikesApiView)
    # manager.register_rest_api_view(PageFeedsApiView)
    # manager.register_rest_api_view(PagePostsApiView)

    # manager.register_rest_api_view(FeedApiView)
    # manager.register_rest_api_view(FeedsApiView)
    # manager.register_rest_api_view(FeedPostsApiView)
    # manager.register_rest_api_view(FeedTokenApiView)
    # manager.register_rest_api_view(FeedFollowersApiView)

    # manager.register_rest_api_view(SessionsApiView)

    manager.register_rest_api_view(ClientApiView)
