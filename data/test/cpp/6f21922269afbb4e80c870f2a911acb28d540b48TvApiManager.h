#ifndef TV_API_MANAGER_H
#define TV_API_MANAGER_H

#include "../api/ITvApiPictureControl.h"

class TvApiManager
{
public:
    ITvApiPictureControl* GetTVApiPictureControl();
    static TvApiManager& GetInstance();

protected:
    TvApiManager();
    virtual ~TvApiManager();
    void ApiInit();
    void RegPictureControlService(ITvApiPictureControl* service);
    void ApiPrepare();
    static TvApiManager* sTvApiManager;

private:
    //Client API
    ITvApiPictureControl* mTvApiPictureControl;
};
#endif /* TV_API_MANAGER_H */