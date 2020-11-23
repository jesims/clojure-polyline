#!/usr/bin/env bash
#shellcheck disable=2215
cd "$(realpath "$(dirname "$0")")" &&
source bindle/project.sh
if [ $? -ne 0 ];then
	exit 1
fi

## clean:
## Cleans up the compiled and generated sources
clean () {
	lein clean
	rm -rf .shadow-cljs/
}

## deps:
## Installs all required dependencies for Clojure and ClojureScript
deps () {
	-deps
}

## test:
## Runs the Clojure unit tests
test () {
	clean
	-test-clj "$@"
	abort-on-error 'Clojure tests failed'
}

## test-cljs:
## Runs the ClojureScript unit tests
test-cljs () {
	clean
	-test-cljs "$@"
	abort-on-error 'ClojureScript tests failed'
}

is-snapshot () {
	version=$(cat VERSION)
	[[ "$version" == *SNAPSHOT ]]
}

deploy () {
	if [[ -n "$CIRCLECI" ]];then
		lein deploy clojars &>/dev/null
		abort-on-error
	else
		lein deploy clojars
		abort-on-error
	fi
}

## snapshot:
## args: [-l]
## Pushes a snapshot to Clojars
## [-l] local
snapshot(){
	-snapshot "$@"
}

## release:
## Pushes a release to Clojars
release () {
	-release
}

deploy(){
	deploy-clojars
}

deploy-snapshot(){
	deploy-clojars
}

## lint:
lint () {
	-lint
}

## outdated:
outdated () {
	-outdated
}

script-invoke "$@"
