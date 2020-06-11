/* Copyright 2013 Lieven Govaerts
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef __ufj_svnrepo_daemon__SvnRepoUpdater__
#define __ufj_svnrepo_daemon__SvnRepoUpdater__

#include <string>
#include <boost/make_shared.hpp>
#include "svn_client.h"
#include "svn_pools.h"

#include "SvnRepo.h"
#include "SvnRepoDAO.h"
#include "SvnRepoItemDAO.h"

using boost::shared_ptr;

class SvnRepoUpdater {
public:
    // has to be public for make_shared, should not be used directly.
    SvnRepoUpdater(std::string url);
//    SvnRepoUpdater(shared_ptr<SvnRepo> svnrepo);

    void update_repo();

private:
    apr_pool_t *pool;
    svn_client_ctx_t *ctx;

    long start_rev;

    shared_ptr<SvnRepoItemDAO> repoItemDAO;
    shared_ptr<SvnRepoDAO> repoDAO;

    shared_ptr<SvnRepo> repo;

    /* Static member function for the C api */
    static svn_error_t * log_entry_receiver_wrapper(void *baton,
                                                    svn_log_entry_t *log_entry,
                                                    apr_pool_t *pool);

    svn_error_t *log_entry_receiver(svn_log_entry_t *log_entry,
                                    apr_pool_t *pool);
};

#endif /* defined(__ufj_svnrepo_daemon__SvnRepoUpdater__) */
