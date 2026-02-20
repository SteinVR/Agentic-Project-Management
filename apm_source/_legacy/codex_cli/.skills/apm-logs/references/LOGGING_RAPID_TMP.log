# RAPID Logging Template (Example)

**Primary log file:** `logs/prototype.log`
**Format:** `[YYYY-MM-DD HH:MM:SS] [LEVEL] - Message`

## Recommended events
- Start/stop of main command or workflow
- User input summary (sanitized)
- Major decisions (feature flags, modes, fallback paths)
- External I/O (files read/written, network calls)
- Errors with context and resolution

## Example log lines
```
[2026-01-30 10:14:05] [INFO] - App started (mode=cli)
[2026-01-30 10:14:06] [INFO] - Loaded config from config.json
[2026-01-30 10:14:07] [INFO] - Command: create-task title="Fix login"
[2026-01-30 10:14:08] [WARN] - Missing optional field: due_date
[2026-01-30 10:14:10] [INFO] - Task created id=task_014
[2026-01-30 10:14:12] [ERROR] - Failed to write tasks.json (permission denied)
```

## Checklist
- [ ] Log start and end
- [ ] Log key inputs and outputs
- [ ] Log errors with context
- [ ] Keep format consistent

