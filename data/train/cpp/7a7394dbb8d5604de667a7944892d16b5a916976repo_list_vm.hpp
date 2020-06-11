//
//  repo_list_vm.hpp
//  mx3
//
//  Created by Joey Wessel on 5/19/15.
//
//

#pragma once
#include "../interface/user_list_vm.hpp"
#include "../interface/user_list_vm_cell.hpp"
#include "../interface/user_list_vm_handle.hpp"
#include "../interface/user_list_vm_observer.hpp"
#include "../interface/repo_list_vm.hpp"
#include "../interface/repo_list_vm_cell.hpp"
#include "../interface/repo_list_vm_handle.hpp"
#include "../interface/repo_list_vm_observer.hpp"
#include "../http.hpp"
#include "stl.hpp"
#include <atomic>
#include "../sqlite/sqlite.hpp"
#include "../sqlite_query/query_monitor.hpp"
#include "../github/types.hpp"
#include <string>

namespace mx3 {
    
    class RepoListVmHandle;
    
    class RepoListVm final : public mx3_gen::RepoListVm {
    public:
        RepoListVm(const vector<sqlite::Row> &rows, const std::weak_ptr<RepoListVmHandle> &handle/*, const string repo_url*/);
        virtual int32_t count() override;
        virtual optional<mx3_gen::RepoListVmCell> get(int32_t index) override;
    private:
        const vector<sqlite::Row> m_rows;
        const std::weak_ptr<RepoListVmHandle> m_handle;
        const string m_repo_url;
    };
    
    class RepoListVmHandle final : public mx3_gen::RepoListVmHandle, public std::enable_shared_from_this<RepoListVmHandle> {
    public:
        RepoListVmHandle(
                         shared_ptr<sqlite::Db> db,
                         const mx3::Http &http,
                         string repo_url,
                         int64_t owner_id,
                         const shared_ptr<SingleThreadTaskRunner> &ui_thread,
                         const shared_ptr<SingleThreadTaskRunner> &bg_thread
                         );
        virtual void start(const shared_ptr<mx3_gen::RepoListVmObserver> &observer) override;
        virtual void stop() override;
    private:
        void _notify_new_data();
        
        const shared_ptr<sqlite::Db> m_db;
        const shared_ptr<sqlite::QueryMonitor> m_monitor;
        const shared_ptr<sqlite::Stmt> m_list_stmt;
        optional<vector<sqlite::Row>> m_prev_rows;
        mx3::Http m_http;
        string m_repo_url;
        int64_t m_owner_id;
        shared_ptr<mx3_gen::RepoListVmObserver> m_observer;
        const shared_ptr<SingleThreadTaskRunner> m_ui_thread;
        const shared_ptr<SingleThreadTaskRunner> m_bg_thread;
    };
}
