
#ifndef mds_repoinfo_h
#define mds_repoinfo_h

class RepoInfo {
public:
    RepoInfo() {
    }
    RepoInfo(const std::string &repoId, const std::string &path) {
        this->repoId = repoId;
        this->path = path;
    }
    ~RepoInfo() {
    }
    std::string getRepoId() {
        return repoId;
    }
    void updateHead(const std::string &head) {
        this->head = head;
    }
    std::string getHead() {
        return head;
    }
    std::string getPath() {
        return path;
    }
    void getKV(const KVSerializer &kv, const std::string &prefix) {
        repoId = kv.getStr(prefix + ".id");
        head = kv.getStr(prefix + ".head");
        path = kv.getStr(prefix + ".path");
    }
    void putKV(KVSerializer &kv, const std::string &prefix) const {
        kv.putStr(prefix + ".id", repoId);
        kv.putStr(prefix + ".head", head);
        kv.putStr(prefix + ".path", path);
    }
private:
    std::string repoId;
    std::string head;
    std::string path;
};

#endif

