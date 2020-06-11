#include "repocollection.h"

RepoCollection* RepoCollection::instance = NULL;

RepoCollection::RepoCollection() {
    repo_names = new std::vector<std::string>();
}

RepoCollection::~RepoCollection() {
    delete repo_names;
}

RepoCollection* RepoCollection::getInstance() {
    if(instance==NULL) {
        instance = new RepoCollection();
    }
    return instance;
}

void RepoCollection::add(const char* name, const char* filepath) {
    repo_names->push_back(name);
}

void RepoCollection::print() {
    for(int i = 0; i<repo_names->size(); i++) {
        std::cout << repo_names->at(i) << std::endl;
    }
}
