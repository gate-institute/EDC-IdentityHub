MAKEFLAGS += --always-make
SHELL := /bin/bash

help:
	@echo "Tasks:"
	@grep -E '^[a-zA-Z][a-zA-Z0-9_.-]*:.*?' $(MAKEFILE_LIST) \
		| awk -F':' '{printf "  \033[36m%-20s\033[0m\n", $$1}' \
		| uniq

###############################################################################
### build
###############################################################################

build:
	./gradlew :launcher:identityhub:shadowJar \
		--no-daemon \
		--warning-mode=none \
		--parallel \
		--max-workers 3 \
		-P "skip.signing" \
		-Dorg.gradle.jvmargs="-Xmx2g"


###############################################################################
### run
###############################################################################

export WEB_HTTP_CREDENTIALS_PORT := 10001
export WEB_HTTP_CREDENTIALS_PATH := /api/credentials
export WEB_HTTP_PORT := 8181
export WEB_HTTP_PATH := /api
export WEB_HTTP_IDENTITY_PORT := 8182
export WEB_HTTP_IDENTITY_PATH := /api/identity

JAR_PATH := launcher/identityhub/build/libs/identity-hub.jar
JAR_OPTS := --log-level=DEBUG

debug:
	java \
		-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=*:5005 \
		-jar $(JAR_PATH) $(JAR_OPTS)

run:
	java \
		-jar $(JAR_PATH) $(JAR_OPTS)
