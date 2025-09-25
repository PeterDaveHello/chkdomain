# Repository Guidelines

## Dos and Don'ts

- **Do:** Run the existing Make targets for linting (`make test-shellcheck`, `make test-echint`) before proposing changes; install their dependencies first so they succeed.
- **Do:** Keep edits focused on the touched logic inside `chkdm`; mirror surrounding indentation and quoting instead of reformatting large blocks.
- **Do:** Validate changes with a real domain only when you need runtime verification and the environment allows outbound DNS traffic.
- **Don't:** Introduce new dependencies, rename `chkdm`, or change install paths without prior confirmation because downstream scripts and CI expect the current layout.
- **Don't:** Commit generated marker files (`.shellcheck.test-marker`, `.echint.test-marker`) or other runtime artifacts.

## Project Structure and Module Organization

`chkdomain` is a single-file Bash utility that probes well-known DNS resolvers and prints intelligence links for a domain.

- **chkdm**: Primary Bash script executed by users and tests; optional `CustomDNS.txt` lives alongside it when present.
- **Makefile**: Provides install (`sudo make install`), uninstall, and lint targets with marker files to skip repeated runs.
- **README.md**: Source of user-facing instructions, DNS resolver lists, and dependency overview.
- **.editorconfig**: Enforces UTF-8, trailing newline, and two-space indentation for `chkdm`, Markdown, and YAML files.
- **.travis.yml**: Canonical CI definition covering shellcheck, echint, and runtime smoke tests on Linux and macOS.
- **.github/FUNDING.yml**, **LICENSE**, **chkdomain.png**, **.gitignore**: Ancillary funding metadata, licensing, screenshot asset, and ignored marker files.

## Build, Test, and Development Commands

Run commands from the repository root; the `Makefile` is the single source of truth.

- **Prerequisites:** Install `shellcheck` (e.g., `apt-get install shellcheck`) and `echint` (`npm install -g echint`). If a dependency is missing, the corresponding `make` target will fail (for example, `make test-shellcheck` exits with `shellcheck: Command not found`).
- **Static lint:** `make test-shellcheck` runs `shellcheck chkdm`; remove `.shellcheck.test-marker` if you need to rerun after a successful pass.
- **EditorConfig lint:** `make test-echint` executes `echint chkdm`; delete `.echint.test-marker` to force a fresh run.
- **All lint:** `make test` chains the two targets and prints `Tests passed` on success.
- **Manual runtime check:** `./chkdm example.com` exercises the script against live DNS resolvers; create `CustomDNS.txt` or set `CustomDNSFile=/path` when testing custom resolver lists.
- **Install/uninstall:** `sudo make install` copies `chkdm` into `/usr/local/bin`; `sudo make uninstall` removes it, mirroring the CI install tests.

## Coding Style and Naming Conventions

- **Language:** Bash 4+ script with `function name()` declarations and lowercase function names; keep helper names (`echo.Red`, `checkNofilterDNS`) consistent.
- **Indentation:** Spaces only; `.editorconfig` specifies two-space indents for `chkdm`, Markdown, and YAML, but preserve nearby depth (two spaces for simple statements, four for nested blocks).
- **Quoting and tests:** Follow the existing preference for double quotes around variables, `[[ ... ]]` conditionals, and `case` statements for result classification.
- **Data structures:** Maintain associative array literals for DNS resolvers with the same key casing and spacing; new resolvers should be grouped with peers and keep human-readable names.
- **Comments:** Use `#` comments with sentence case descriptions, matching the header block and inline notes already in `chkdm`.

## Testing Guidelines

- **Static linting:** Always rerun `make test-shellcheck` and `make test-echint` (or `make test`) after modifying `chkdm` once the required tools are installed.
- **Targeted lint:** For quick checks, you can run `shellcheck chkdm` or `echint chkdm` directly; these mirror the Make targets.
- **Runtime verification:** Validate behavior with `./chkdm <domain>` when altering query logic, domain validation, or DNS lists. Be aware that it issues real DNS queries and may require external network access.
- **Custom DNS paths:** When changing the custom DNS handling, reuse `CustomDNS.txt` in the repo root or point `CustomDNSFile` at a test file to cover those branches.

## Commit and Pull Request Guidelines

- **Commit style:** Follow the existing imperative, capitalized subject format with a blank line before the body (e.g., `Add Bash version check for better compatibility and error handling`). Wrap body lines at 72 characters and explain the what/why.
- **Scope:** Keep each commit focused on a single concern; avoid combining feature work with formatting or cleanup.
- **Verification:** Include a short note about the lint or runtime commands you ran; ensure all relevant Make targets pass before opening a PR.
- **Pull requests:** Reference related issues when applicable and note any runtime testing or environment constraints (especially when DNS access was unavailable).

## Safety and Permissions

- **Allowed without approval:** Read/list files, edit `chkdm` or documentation with minimal diffs, and run the lint targets after ensuring prerequisites are installed.
- **Ask before proceeding:** Adding dependencies, altering CI (`.travis.yml`), modifying install paths, or running privileged commands beyond the documented `sudo make install` / `sudo make uninstall` flow.
- **Never do:** Remove production assets, mass-rename files, or commit local artifacts/credentials. Avoid speculative bulk refactors; discuss larger structural ideas first.
- **Operational caution:** Runtime tests send live DNS queries; confirm the environment permits it and avoid hammering resolvers unnecessarily.
