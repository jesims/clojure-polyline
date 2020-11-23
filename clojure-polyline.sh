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
	echo-message 'Installing dependencies'
	lein deps
	abort-on-error
}

## unit-test:
## Runs the Clojure unit tests
unit-test () {
	clean
	lein test
	abort-on-error 'Clojure tests failed'
}

## unit-test-cljs:
## Runs the ClojureScript unit tests
unit-test-cljs () {
	clean
	lein node-test
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
## Pushes a snapshot to Clojars
snapshot () {
	if is-snapshot;then
		echo-message 'SNAPSHOT suffix already defined... Aborting'
		exit 1
	else
		version=$(cat VERSION)
		snapshot="$version-SNAPSHOT"
		echo "${snapshot}" > VERSION
		echo-message "Snapshotting $snapshot"
		deploy
		echo "$version" > VERSION
	fi
}

## release:
## Pushes a release to Clojars
release () {
	version=$(cat VERSION)
	if ! is-snapshot;then
		version=$(cat VERSION)
		echo-message "Releasing $version"
		deploy
	else
		echo-message 'SNAPSHOT suffix already defined... Aborting'
		exit 1
	fi
}

## lint:
lint () {
	-lint
}

script-invoke "$@"
