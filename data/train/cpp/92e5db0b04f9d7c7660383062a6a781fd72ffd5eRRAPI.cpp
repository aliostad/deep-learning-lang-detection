#define RRAPI_LIB_MAIN
#include "../../include/RRAPI.h"
#include "../../include/AdminAPI.h"
#include "../../include/FriendsAPI.h"
#include "../../include/InvitationsAPI.h"
#include "../../include/NotificationsAPI.h"
#include "../../include/PagesAPI.h"
#include "../../include/PayAPI.h"
#include "../../include/PhotosAPI.h"
#include "../../include/StatusAPI.h"
#include "../../include/UsersAPI.h"
#include "../libhttp/Http.h"
#include <assert.h>

RenRenAPI::RenRenAPI()
{
    m_request = new Request;
    assert(m_request);

    m_adminAPI = new AdminAPI(m_request);
    assert(m_adminAPI);
    m_friendsAPI = new FriendsAPI(m_request);
    assert(m_friendsAPI);
    m_invitationsAPI = new InvitationsAPI(m_request);
    assert(m_invitationsAPI);
    m_notificationsAPI = new NotificationsAPI(m_request);
    assert(m_notificationsAPI);
    m_pagesAPI = new PagesAPI(m_request);
    assert(m_pagesAPI);
    m_payAPI = new PayAPI(m_request);
    assert(m_payAPI);
    m_photosAPI = new PhotosAPI(m_request);
    assert(m_photosAPI);
    m_statusAPI = new StatusAPI(m_request);
    assert(m_statusAPI);
    m_usersAPI = new UsersAPI(m_request);
    assert(m_usersAPI);
}

RenRenAPI::~RenRenAPI()
{
    delete m_adminAPI;
    delete m_friendsAPI;
    delete m_invitationsAPI;
    delete m_notificationsAPI;
    delete m_pagesAPI;
    delete m_payAPI;
    delete m_photosAPI;
    delete m_statusAPI;
    delete m_usersAPI;
    delete m_request;

    m_adminAPI = 0;
    m_friendsAPI = 0;
    m_invitationsAPI = 0;
    m_notificationsAPI = 0;
    m_pagesAPI = 0;
    m_payAPI = 0;
    m_photosAPI = 0;
    m_statusAPI = 0;
    m_usersAPI = 0;

    m_request = 0;
}
