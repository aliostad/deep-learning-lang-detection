(ns degree9.boot-semgit.workflow
  (:require [boot.core :as boot]
            [boot.util :as util]
            [degree9.boot-semver :as semver]
            [degree9.boot-semgit :as semgit]))

;; Semgit Workflow Helper Tasks ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(def ^:dynamic *orig-err* nil)
(def ^:dynamic *orig-out* nil)

(boot/deftask mute
  "Hide future task output."
  []
  (fn [next-handler]
    (fn [fileset]
      (binding [*orig-out* *out*
                *orig-err* *err*
                *out* (new java.io.StringWriter)
                *err* (new java.io.StringWriter)]
        (next-handler fileset)))))

(boot/deftask unmute
  "Show future task output."
  []
  (fn [next-handler]
    (fn [fileset]
      (if (and *orig-out* *orig-err*)
        (binding [*out* *orig-out*
                  *err* *orig-err*
                  *orig-out* nil
                  *orig-err* nil]
          (next-handler fileset))
        (next-handler fileset)))))

(defmacro with-quiet [& tasks]
  `(if semgit/*debug* (comp ~@tasks) (comp (mute) ~@tasks (unmute))))

;; Semgit Workflow Helper Fn's ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Semgit Workflow Tasks ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(boot/deftask feature
  "Manage project feature branches."
  [n name       NAME   str  "Feature name which will be appended to 'feature-'."
   c close             bool "Closes a feature branch using 'git-rebase' and 'git-merge'."
   b branch     BRANCH str  "The base or target branch for this feature."
   r remote     REMOTE str  "Remote repository to use as a base for this feature."
   d delete            bool "Delete/Remove a feature without closing it."]
  (assert (:name *opts*) "Feature 'name' was not provided.")
  (assert (if (:close *opts*) (:branch *opts*) true) "Target 'branch' was not provided.")
  (let [bname    (:name *opts*)
        fname    (str "feature-" bname)
        target   (:branch *opts* "master")
        remote   (:remote *opts* "origin")
        close?   (:close *opts*)
        remove?  (:delete *opts*)
        open?    (not (or close? remove?))
        closemsg (str "[close feature] " bname)
        openmsg  (str "[open feature] " bname " from " target)
        mergemsg (str "[merge feature] " bname " into " target)]
    (cond
      open?   (comp
                (boot/with-pass-thru _
                  (util/info (str "Creating branch: " fname " \n")))
                (with-quiet
                  (semgit/git-checkout :branch true :name fname :start target))
                (boot/with-pass-thru _
                  (util/info (str "Updating version... \n")))
                (with-quiet
                  (semver/version :pre-release 'degree9.boot-semgit/get-feature))
                (boot/with-pass-thru _
                  (util/info (str "Saving changes... \n")))
                (with-quiet
                  (semgit/git-commit :all true :message openmsg)))
      close?  (comp
                (boot/with-pass-thru _
                  (util/info (str "Closing branch: " fname " \n"))
                  (util/info (str "Fetching latest changes from: " remote " \n")))
                (with-quiet
                  (semgit/git-fetch :remote remote))
                (boot/with-pass-thru _
                  (util/info (str "Cleaning branch history... \n")))
                (with-quiet
                  (semgit/git-rebase :start target :checkout fname))
                (boot/with-pass-thru _
                  (util/info (str "Syncing version... \n")))
                (with-quiet
                  (semgit/git-checkout :name target :start "version.properties"))
                (boot/with-pass-thru _
                  (util/info (str "Saving changes... \n")))
                (with-quiet
                  (semgit/git-commit :all true :message closemsg))
                (boot/with-pass-thru _
                  (util/info (str "Switching to target: " target " \n")))
                (with-quiet
                  (semgit/git-checkout :name target))
                (boot/with-pass-thru _
                  (util/info (str "Merging feature: " fname "  \n")))
                (with-quiet
                  (semgit/git-merge :branch [fname] :message mergemsg)))
      remove? (comp
                (boot/with-pass-thru _
                  (util/info (str "Switching to target: " target "  \n")))
                (with-quiet
                  (semgit/git-checkout :name target :force true))
                (boot/with-pass-thru _
                  (util/info (str "Removing branch: " fname "  \n")))
                (with-quiet
                  (semgit/git-branch :name fname :delete true :force true))))))

(boot/deftask patch
  "Manage project patch branches."
  [n name       NAME   str  "Patch issue id (github issue, etc.) which will be appended to 'patch-'."
   c close             bool "Closes a patch branch using 'git-rebase' and 'git-merge'."
   b branch     BRANCH str  "The base or target branch for this patch."
   d delete            bool "Delete/Remove a patch without closing it."]
  (let [bname    (:name *opts*)
        fname    (str "patch-" bname)
        target   (:branch *opts* "master")
        close?   (:close *opts*)
        remove?  (:delete *opts*)
        open?    (not (or close? remove?))
        closemsg (str "[close patch] " bname)
        openmsg  (str "[open patch] " bname " from " target)
        mergemsg (str "[merge patch] " bname " into " target)]
    (boot/with-pass-thru _
      ;;branch
      ;;version
      ;;commit
      ;;close
      ;;remove
      )))

(def hotfix patch)

(boot/deftask sync-repo
  "Sync project git repository. (origin/master)"
  []
  (let [branch "origin/master"]
    (comp
      (boot/with-pass-thru _
        (util/info "Syncing git repository with %s...\n" branch))
      (with-quiet
        (semgit/git-pull :branch branch)))))
