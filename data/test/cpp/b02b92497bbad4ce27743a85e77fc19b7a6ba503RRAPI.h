#ifndef RRAPI_H
#define RRAPI_H

#include "Global.h"

class Request;
class AdminAPI;
class FriendsAPI;
class InvitationsAPI;
class NotificationsAPI;
class PagesAPI;
class PayAPI;
class PhotosAPI;
class StatusAPI;
class UsersAPI;

class  RenRenAPI
{
public:
    RenRenAPI();
    ~RenRenAPI();

public:
    AdminAPI            *m_adminAPI;
    FriendsAPI          *m_friendsAPI;
    InvitationsAPI      *m_invitationsAPI;
    NotificationsAPI    *m_notificationsAPI;
    PagesAPI            *m_pagesAPI;
    PayAPI              *m_payAPI;
    PhotosAPI           *m_photosAPI;
    StatusAPI           *m_statusAPI;
    UsersAPI            *m_usersAPI;

private:
    Request *m_request;
};

#endif	//RRAPI_H
