---
name: docker-build-run
description: Build the addressbook Docker image from the repo-root `dockerfile` and run it locally. Use when the user asks to build, rebuild, or run the addressbook Docker container, or to test the app in Docker/Tomcat.
---

The `dockerfile` at the repo root is a two-stage build: `maven:3.8.4-openjdk-11-slim` compiles the
WAR (`mvn package`), then the WAR is copied into `tomcat:8.5.78-jdk11-openjdk-slim` and served on
port 8080 via `catalina.sh run`. The image name/tag and container name aren't fixed by convention
here — pick sensible defaults (e.g. `addressbook:latest`, container name `addressbook`) unless the
user specifies otherwise.

## Steps

1. Confirm Docker is available and the daemon is running: `docker info` (surface the error and stop
   if it isn't — don't try to start Docker yourself unless asked).
2. Build the image from the repo root (the `dockerfile` has no extension, so pass `-f` explicitly):
   ```
   docker build -f dockerfile -t addressbook:latest .
   ```
   This runs the full Maven build inside the container — expect it to take a while on a cold cache
   (dependency download + `mvn package`). Surface build failures (compile errors, test failures if
   any run during `package`) rather than retrying blindly.
3. If a container from a previous run is already using the target name or port, ask before removing
   it (`docker rm -f addressbook`) — don't silently kill another container.
4. Run the container, mapping host port 8080 (or a user-specified port) to the container's 8080:
   ```
   docker run -d --name addressbook -p 8080:8080 addressbook:latest
   ```
5. Confirm it came up: `docker ps --filter name=addressbook` and/or `docker logs addressbook` (Tomcat
   startup can take a few seconds). Tell the user the app is reachable at
   `http://localhost:8080/addressbook/` (the WAR's finalName is `addressbook`, so it deploys under
   that context path — not the root path).
6. Do **not** push the image to any registry unless the user explicitly asks — this skill only
   covers local build + run.
