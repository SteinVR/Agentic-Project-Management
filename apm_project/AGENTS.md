# Configuration and delivery

This directory creates project scaffolds and installs environment packs.
[README.md](../README.md#quick-start) describes the user entry points;
the [compatibility review](../docs/framework-status.md) records known gaps.

## Local map

```text
apm_project/
├── apm.sh     — Bash configurator with interactive and non-interactive modes
├── scripts/   — environment installers in Bash and PowerShell
└── tests/     — configurator E2E suite and broader validation runner
```

For delivery changes, follow the configurator or selected installer into its
`apm_source/` inputs. Inspect both shell variants when behavior is meant to be
shared across platforms.

For validation, choose the existing entry point appropriate to the change:

- `bash apm_project/tests/e2e_tests.sh` checks generated scaffolds and local pack
  output in temporary projects.
- `bash apm_project/tests/validate_all.sh` adds Bash syntax checks, interactive
  scenarios, and a local/global installer matrix; `--with-tty` adds a TTY check.

These commands validate delivery artifacts. They do not prove that a live
environment discovers a skill, accepts a role config, or can use a configured
model. The broader runner also covers legacy Cursor installer output.
