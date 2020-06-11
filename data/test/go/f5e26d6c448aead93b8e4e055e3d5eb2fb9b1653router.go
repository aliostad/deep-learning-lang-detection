package routes

import (
	"net/http"

	"github.com/Sirupsen/logrus"
	"github.com/maleck13/scm-go/config"
	"github.com/gorilla/mux"
	"github.com/prometheus/client_golang/prometheus"
)

func SetUpRoutes(logger *logrus.Logger, config *config.Config) *mux.Router {
	//TODO delete keys after use. Should we keep using backups?
	/*use('/fhgithub/trigger', this.trigger_handler). done
	  use(this.check_repo_exists_for_command).
	  use('/fhgithub/push', this.push_handler). (nothing seems to use this)
	  use('/fhgithub/mirror', this.mirror_handler). (used for openshift2 todo)
	  use('/fhgithub/create_tag', this.create_tag_handler). (nothing seems to use this)
	  use('/fhgithub/list_tags', this.list_tags_handler). (nothing seems to use this)
	  use('/fhgithub/list_branches', this.list_branches_handler). (nothing seems to use this)
	  use('/fhgithub/zip', this.zip_handler). does not seem to be used called from millicore but the method in millicore is not used

	  use('/fhgithub/listfiles', this.listfiles_handler). done
	  use('/fhgithub/list_remote', this.list_remote_handler). done
	  use('/fhgithub/archive', this.archive_handler). done
	  use('/fhgithub/createfile', this.create_handler). done
	  use('/fhgithub/updatefile', this.update_handler). done
	  use('/fhgithub/deletefile', this.delete_handler). done but cant delete files from ngui so pretty sure this is not used
	  use('/fhgithub/getfile', this.get_handler). done
	  use(connect.static(config.get('fileserver.path'))); done
	  use('/fhgithub/delete_app', this.delete_app_handler).
	  use('/fhgithub/check_commit', this.check_commit_handler).
	  use('/sys', this.sys_handler).
	  use(this.check_repo_exists).

	*/

	router := mux.NewRouter()
	router.StrictSlash(true)

	router.HandleFunc("/health", Health).Methods("GET")
	router.HandleFunc("/sys/info/ping", Ping).Methods("GET")
	router.HandleFunc("/fhgithub/trigger", prometheus.InstrumentHandlerFunc("/fhgithub/trigger", PullCloneCheckout)).Methods("POST")
	router.HandleFunc("/fhgithub/listfiles/{repo}", prometheus.InstrumentHandlerFunc("/fhgithub/listfiles/{repo}", ListFiles)).Methods("GET")
	router.HandleFunc("/fhgithub/listfiles/{repo}", prometheus.InstrumentHandlerFunc("/fhgithub/listfiles/{repo}", ListFilesForRef)).Methods("POST")
	router.HandleFunc("/fhgithub/archive", prometheus.InstrumentHandlerFunc("/fhgithub/archive", Archive)).Methods("POST")
	router.HandleFunc("/fhgithub/check_commit", prometheus.InstrumentHandlerFunc("/fhgithub/check_commit", CheckReference)).Methods("POST")
	router.HandleFunc("/fhgithub/list_remote", prometheus.InstrumentHandlerFunc("/fhgithub/list_remote", ListRemotes)).Methods("POST")
	router.HandleFunc("/fhgithub/getfile", prometheus.InstrumentHandlerFunc("/fhgithub/getfile", GetFile)).Methods("POST")
	router.HandleFunc("/fhgithub/createfile", prometheus.InstrumentHandlerFunc("/fhgithub/createfile", CreateUpdateFile)).Methods("POST")
	router.HandleFunc("/fhgithub/updatefile", prometheus.InstrumentHandlerFunc("/fhgithub/updatefile", CreateUpdateFile)).Methods("POST")
	router.HandleFunc("/fhgithub/deletefile", prometheus.InstrumentHandlerFunc("/fhgithub/deletefile", DeleteFile)).Methods("POST")
	router.HandleFunc("/fhgithub/delete_app", prometheus.InstrumentHandlerFunc("/fhgithub/delete_app", DeleteRepo)).Methods("POST")
	router.Handle("/metrics", prometheus.Handler()).Methods("GET")
	router.PathPrefix("/").Handler(http.FileServer(http.Dir(config.Fileserver.Path)))
	return router
}
