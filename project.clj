(def VERSION (.trim (slurp "VERSION")))

(defproject io.jesi/clojure-polyline VERSION
  :description "library to encode and decode google polyline algorithm"
  :url "http://github.com/jesims/clojure-polyline"
  :license {:name         "Eclipse Public License"
            :url          "http://www.eclipse.org/legal/epl-v10.html"
            :distribution :repo
            :comments     "same as Clojure"}
  :plugins [[lein-parent "0.3.8"]
            [lein-shell "0.5.0"]]
  :parent-project {:coords  [io.jesi/parent "4.3.0"]
                   :inherit [:plugins
                             :repositories
                             :managed-dependencies
                             :dependencies
                             :exclusions
                             :profiles
                             :global-vars
                             :test-refresh
                             :aliases]}
  :dependencies [[org.clojure/clojure]]
  :profiles {:dev [:parent/dev {:dependencies [[thheller/shadow-cljs]
                                               [org.clojure/clojurescript]
                                               [org.clojure/tools.namespace "0.2.11"]]}]}
  :aliases {"node-test" ["do"
                         "run" "-m" "shadow.cljs.devtools.cli" "release" "test,"
                         "shell" "node" "target/node/test.js"]})
