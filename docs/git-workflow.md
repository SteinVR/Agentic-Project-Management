# Git Workflow Notes

## Merging Codex-CLI into main

### Что нужно знать

Ветки `Codex-CLI` и `main` имеют разный состав файлов:

| Файл/папка | Codex-CLI | main |
|------------|-----------|------|
| `docs/` | отслеживается | игнорируется (`.gitignore`) |
| `external/` | отслеживается | игнорируется (`.gitignore`) |
| `APM_ARCHITECTURE.md` | отслеживается | игнорируется (`.gitignore`) |

### Сценарий: modify/delete конфликты

Если в `Codex-CLI` были изменения в `docs/` или `external/`, при мерже в `main` возникнут конфликты вида:
```
CONFLICT (modify/delete): docs/some-file.md deleted in HEAD and modified in Codex-CLI.
```
Это штатная ситуация -- `main` удалял эти файлы, Codex-CLI их менял.

### Процедура мержа

```bash
git checkout main
git merge --no-commit --no-ff Codex-CLI   # мержим без авто-коммита
git rm -r --cached docs/ external/        # убираем из индекса
rm -rf docs/ external/                    # убираем из файловой системы (если осталось)
git commit
```

### Если возникли конфликты вручную

```bash
git checkout main
git merge Codex-CLI                        # будут конфликты
git checkout HEAD -- docs/ external/       # разрешаем в пользу main (удаляем)
git rm -r --cached docs/ external/ 2>/dev/null
git commit
```

### Commit message шаблон

```
merge Codex-CLI into main

<краткое описание изменений из Codex-CLI>
Excluded docs/ and external/ from main (branch-specific content).
```
