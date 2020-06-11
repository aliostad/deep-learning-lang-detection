#ifndef _LOAD_MANAGER_H_
#define _LOAD_MANAGER_H_

#include <string>
#include <vector>

enum ResTypeTag
{
    TAG_SURFACE,
    TAG_SPRITE,
    TAG_TILEMAP
};

struct LoadItem
{
    ResTypeTag  m_Type;
    std::string m_LoadPath;
};

class LoadManager;

class LoadList
{
friend class LoadManager;

public:
    void addLoadItem(ResTypeTag type, const std::string& path);
private:
    std::vector<LoadItem> m_LoadList;
};

class LoadManager
{
public:
    static LoadManager* getInstance();

    void setLoadList(LoadList* pList, int startIndex = 0);
    bool loadProcessing();

private:
    LoadManager();

    static LoadManager* s_Instance;

    size_t      m_CurrItem;
    LoadList*   m_pList;
};

#endif // _LOAD_MANAGER_H_
