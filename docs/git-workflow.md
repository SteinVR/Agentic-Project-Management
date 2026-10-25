# Git Workflow Notes

## Selective branch synchronization

Use the root [git-branch-sync.sh](../git-branch-sync.sh) helper when tracked files
need to be copied from another branch without transferring branch-local context.
Run from the repository root on a checked-out target branch with a clean tracked
tree.

```bash
./git-branch-sync.sh <source-branch>          # preview
./git-branch-sync.sh <source-branch> --apply  # apply and stage
```

The repository-root `.gitbranchignore` is the exclusion contract:

- One path per line; blank lines and `#` comments are ignored.
- A bare path excludes the item and its subtree, for example `docs` excludes
  both `docs` and `docs/**`.
- `.gitbranchignore` itself is always branch-local and never synchronized.

The helper synchronizes tracked file contents and stages real changes only with
`--apply`; it does not merge branch history. Inspect the preview and staged diff
as part of the requested synchronization.

For new generated projects, `apm-start` prescribes clean `main` and working `dev`
histories. This convention does not rename branches in the APM framework
repository. Check the actual source and target branch names before using the
helper.

## Historical: merging Codex-CLI into main (squash)

The material below records an earlier branch layout and publication process. It
is retained as history, not the current synchronization procedure. The named
branches and file exclusions must not be assumed to describe the current checkout.

### Что нужно знать

Ветки `Codex-CLI` и `main` имеют разный состав файлов:

| Файл/папка | Codex-CLI | main |
|------------|-----------|------|
| `docs/` | отслеживается | игнорируется (`.gitignore`) |
| `external/` | отслеживается | игнорируется (`.gitignore`) |
| `APM_ARCHITECTURE.md` | отслеживается | игнорируется (`.gitignore`) |
| `AGENTS.md` | отслеживается | игнорируется (`.gitignore`) |
| `CLAUDE.md` | отслеживается | игнорируется (`.gitignore`) |

Используется `--squash`, чтобы история `main` оставалась линейной: один атомарный коммит на каждое обновление, промежуточные коммиты `Codex-CLI` не попадают в `main`.

### Процедура

```bash
# 1. Squash-merge в main
git checkout main
git merge --squash Codex-CLI
git rm -r --cached docs/ external/ APM_ARCHITECTURE.md AGENTS.md CLAUDE.md 2>/dev/null
rm -rf docs/ external/ APM_ARCHITECTURE.md AGENTS.md CLAUDE.md 2>/dev/null
git reset HEAD -- .gitignore
git checkout -- .gitignore
git commit -m "squash Codex-CLI into main -- <краткое описание>"

# 2. Обратный merge для поддержания merge-base
git checkout Codex-CLI
git merge main -m "sync merge-base after squash into main"
```

Шаг 2 нужен, потому что `--squash` не записывает факт слияния (нет merge-parent). Без обратного merge следующий squash приведёт к конфликтам от уже применённых изменений.

### Если возникли конфликты

```bash
git checkout main
git merge --squash Codex-CLI                          # могут быть конфликты
# разрешить конфликты, затем:
git rm -r --cached docs/ external/ APM_ARCHITECTURE.md AGENTS.md CLAUDE.md 2>/dev/null
rm -rf docs/ external/ APM_ARCHITECTURE.md AGENTS.md CLAUDE.md 2>/dev/null
git reset HEAD -- .gitignore
git checkout -- .gitignore
git commit -m "squash Codex-CLI into main -- <краткое описание>"

# обратный merge
git checkout Codex-CLI
git merge main -m "sync merge-base after squash into main"
```

### Commit message шаблон

```
squash Codex-CLI into main -- <краткое описание изменений>
```
