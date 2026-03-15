# Git Workflow Notes

## Merging Codex-CLI into main (squash)

### Что нужно знать

Ветки `Codex-CLI` и `main` имеют разный состав файлов:

| Файл/папка | Codex-CLI | main |
|------------|-----------|------|
| `docs/` | отслеживается | игнорируется (`.gitignore`) |
| `external/` | отслеживается | игнорируется (`.gitignore`) |
| `APM_ARCHITECTURE.md` | отслеживается | игнорируется (`.gitignore`) |

Используется `--squash`, чтобы история `main` оставалась линейной: один атомарный коммит на каждое обновление, промежуточные коммиты `Codex-CLI` не попадают в `main`.

### Процедура

```bash
# 1. Squash-merge в main
git checkout main
git merge --squash Codex-CLI
git rm -r --cached docs/ external/ APM_ARCHITECTURE.md 2>/dev/null
rm -rf docs/ external/ APM_ARCHITECTURE.md 2>/dev/null
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
git rm -r --cached docs/ external/ APM_ARCHITECTURE.md 2>/dev/null
rm -rf docs/ external/ APM_ARCHITECTURE.md 2>/dev/null
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
