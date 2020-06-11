(defproject example "1.0.0-SNAPSHOT"
  :description "lein-js example project"
  :dev-dependencies [[lein-js "0.1.1-SNAPSHOT"]]

  ;; Many options are included with their default values, purely for illustration
  :js {:src "src/js"
       :deploy "war/js"
       :bundles ["foobar.js" ["foo.js"
			      "bar.js"]
		 "foobazquux.js" ["foo.js"
				  "baz.js"
				  "quux/quux.js"]]
       :options {:process-closure-primitives true
		 :manage-closure-deps true}
       :devel-options {:compilation-level :whitespace-only
		       :warning-level :verbose
		       :pretty-print true
		       :print-input-delimiter true
		       :coding-convention :default
		       :summary-detail :always-print
		       :compilation-errors ["DEPRECATED" "INVALID_CASTS" "UNDEFINED_VARIABLES"]
		       :charset "US-ASCII"}
       :prod-options {:compilation-level :advanced-optimizations
		      :warning-level :default
		      :summary-detail :never-print}})