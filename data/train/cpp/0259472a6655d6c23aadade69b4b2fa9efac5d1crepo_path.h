//
//  repo_path.h
//  xqiv-cmd
//
//  Created by smrt on 5/24/13.
//  Copyright (c) 2013 smrt. All rights reserved.
//

#ifndef xqiv_cmd_repo_path_h
#define xqiv_cmd_repo_path_h

#include <string>
#include "sha1.h"


namespace rep {
    class path_t {
    public:
        path_t(const std::string &repoPath) :
        repoPath(repoPath)
        {}
        std::string lock_file() const { return repoPath + "/lock"; }
        std::string data_dir() const { return repoPath + "/data"; }
        std::string tags_dir() const { return repoPath + "/tags"; }
        std::string temp_dir() const { return repoPath + "/tmp"; }
        std::string repo() const { return repoPath; }


        std::string data_file_dir(sha1_t checksum) const {
            std::string hex = checksum.hex();
            std::string p1 = hex.substr(0, 2);
            std::string p2 = hex.substr(2, 2);
            return data_dir() + "/" + p1 + "/" + p2;
        }

        std::string data_file(sha1_t checksum) const {
            std::string hex = checksum.hex();
            std::string p3 = hex.substr(4);
            return data_file_dir(checksum) + "/" + p3;
        }

    private:
        const std::string repoPath;
    };
}

#endif
