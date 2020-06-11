#ifndef MSVSERVERMESSAGE_H
#define MSVSERVERMESSAGE_H
#include <QObject>
#include "src/model/AuthInfoModel.h"
#include "src/model/ServerInfoModel.h"
#include "src/model/JoinTableInfoModel.h"
#include "src/model/PlayerJoinChairModel.h"
#include "src/model/game_engine/PokerRoomModel.h"

class MsvServerMessage : public QObject
{
	Q_OBJECT
public:
	MsvServerMessage(QObject *parent = 0);

	bool isAuthentication() const;
	bool isServerInfo() const;
	bool isJoinTable() const;
	bool isPlayerJoinChair() const;
	bool isGameAction() const;
	bool isYourTurn() const;
	bool isAuthFailed() const;

	AuthInfoModel* getAuthInfoModel() const;
	ServerInfoModel* getServerInfoModel() const;
	JoinTableInfoModel* getJoinTableInfoModel() const;
	PlayerJoinChairModel* getPlayerJoinChairModel() const;
	PokerRoomModel* getPokerRoomModel() const;

	void setAuthInfoModel(AuthInfoModel* model);
	void setServerInfoModel(ServerInfoModel* model);
	void setJoinTableInfoModel(JoinTableInfoModel* model);
	void setPlayerJoinChairModel(PlayerJoinChairModel* model);
	void setPokerRoomModel(PokerRoomModel* model);

	void setType(QString* type);
	QString* getType() const;
private:
	QString* type;
	AuthInfoModel* authModel;
	ServerInfoModel* serverInfoModel;
	JoinTableInfoModel* joinTableInfoModel;
	PlayerJoinChairModel* joinChairInfo;
	PokerRoomModel* room;
};
#endif
