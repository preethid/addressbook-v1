# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

Vaadin 8 (compatibility mode) "Addressbook" tutorial app — a Java 8 / Maven `war` project used as a
CI/CD teaching sandbox (Jenkins, Docker, AWS CodeDeploy/CodeBuild). The application logic itself is
intentionally small; most of the interesting content is in the build/quality tooling wired around it.

## Commands

Run all commands from the repository root (where `pom.xml` lives).

- Build: `mvn package` (produces `target/addressbook.war`, finalName is fixed to `addressbook`)
- Run locally: `mvn jetty:run` then open http://localhost:8080/
- Run all tests: `mvn test`
- Run a single test class: `mvn test -Dtest=TestGenericComparator`
- Run a single test method: `mvn test -Dtest=TestGenericComparator#testSortEmpNameAsc`
- Full verify with coverage report: `mvn verify` (JaCoCo report is written to `target/site/jacoco`)
- PMD static analysis (only active under the `metrics` profile): `mvn -Pmetrics pmd:pmd`

Notes on the build:
- Surefire only picks up classes matching `**/Test*.java`, `**/Test.java`, `**/TestCase.java`, and
  excludes `**/*Abstract*Test.java` (see `pom.xml`). New test classes must follow this naming pattern
  or they will silently not run.
- Tests run in parallel (`methods`, threadCount 10) — avoid shared mutable static state in tests.
- `distributionManagement` points at an Artifactory instance (`devopsdemotrial.jfrog.io`) — `mvn deploy`
  will attempt to publish there.

## Architecture

Two independent layers live side by side in `src/main/java/com/preethidevops/`:

1. **`tutorial/addressbook/`** — the actual Vaadin application.
   - `AddressbookUI.java` — the `@WebServlet`/`UI` entry point (`MyUIServlet` inner class). Wires up
     the filter `TextField`, the `Grid` of contacts, and the `ContactForm`, and owns the single
     `ContactService` instance for the UI session.
   - `ContactForm.java` — a `FormLayout` bound to a `Contact` bean via `BeanFieldGroup`
     (buffered/commit-on-save). Calls back into `AddressbookUI` via `getUI()` to persist and refresh.
   - `backend/ContactService.java` — an in-memory, synchronized fake DAO (`HashMap<Long, Contact>`)
     that stands in for a real persistence layer. `createDemoService()` is a singleton that seeds 100
     random contacts on first call — treat this as a shared, stateful fixture, not a fresh instance
     per test/run.
   - `backend/Contact.java` — the POJO/bean bound throughout the UI and service layer.

2. **`utilities/` and `helper/`** — a grab-bag of generic, UI-unrelated helpers (string/hex utilities,
   generic + case-insensitive comparators via reflection, property loading, logging/stack-trace
   helpers). These are exercised by the JUnit 3/4-style tests under `src/test/java/com/preethidevops/utilities/`
   and are not wired into the Vaadin UI at all — treat them as a separate, self-contained module.

`src/main/pmd/` holds custom PMD rulesets (`ruleset_basics.xml`, `ruleset_j2ee.xml`,
`ruleset_security.xml`) used by the `metrics` Maven profile.

### CI/CD context

Pipeline config files (Jenkinsfile variants, `dockerfile`, `buildspec.yml`/`appspec.yml` for AWS
CodeDeploy, `server-script.sh`, `application-start-hook.sh`, `settings.xml`) are tracked in git history
but currently removed from the working tree — this repo doubles as a live demo of a Jenkins → Docker →
EC2/CodeDeploy pipeline, evolving branch by branch (see commit history on `devops-ai`). The Dockerfile
is a two-stage build: `maven:3.8.4-openjdk-11-slim` compiles the WAR, then it's copied into
`tomcat:8.5.78-jdk11-openjdk-slim` and served on port 8080. When working on pipeline files, check
`git log` / `git show HEAD:<file>` first since they may exist in history even when absent locally.
