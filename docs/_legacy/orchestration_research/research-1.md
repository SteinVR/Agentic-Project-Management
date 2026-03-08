# Оркестрация мультиагентных систем: Sequential vs Parallel Workflows

## Обзор

Мультиагентная оркестрация — архитектурный паттерн, при котором несколько специализированных LLM-агентов координируются для решения задач, превышающих возможности одного агента. Два фундаментальных паттерна — **sequential** (последовательный пайплайн) и **parallel** (параллельный fan-out/fan-in) — представляют собой противоположные подходы к координации, и выбор между ними определяет латентность, надёжность и качество результата системы. В контексте CLI-инструментов (Codex CLI, OpenCode CLI, Claude Code CLI) оркестратором выступает центральный агент (main session), который делегирует подзадачи субагентам через механизм Task/subagent.

***

## 1. Sequential Workflow: когда и как

### Суть паттерна

Sequential orchestration выстраивает агентов в **детерминированную линейную цепочку**: каждый агент обрабатывает выход предыдущего, формируя пайплайн прогрессивной трансформации. Маршрутизация предопределена — ни один агент в цепочке не принимает решение о следующем шаге самостоятельно. Общее состояние (shared state) накапливается и передаётся вдоль пайплайна.

### Когда использовать

Sequential workflow эффективен в задачах, где присутствуют **чёткие линейные зависимости** между шагами:

- **Прогрессивное уточнение** — циклы draft → review → polish, где каждый шаг улучшает предыдущий артефакт.
- **Трансформационные пайплайны** — каждый этап добавляет ценность, от которой зависит следующий (например, extraction → analysis → generation).
- **Dependency chains в коде** — Schema → API → Frontend (структура данных должна существовать до интерфейсов), Research → Planning → Implementation, Implementation → Testing → Security.
- **Предсказуемость** — когда требуется детерминированный, воспроизводимый результат при известных характеристиках каждого агента.

### Когда избегать

- Стадии «embarrassingly parallel» — можно параллелизировать без ущерба для качества.
- Ранние стадии склонны к ошибкам, и нет механизма предотвращения каскадного распространения ошибочного вывода.
- Требуется backtracking, итерация или динамическая маршрутизация.

### Пример: генерация контракта

```
Input → [Template Selection Agent] → [Clause Customization Agent]
      → [Regulatory Compliance Agent] → [Risk Assessment Agent] → Result
                    ↕ Common Document State ↕
```

Каждый агент специализирован: выбор шаблона → кастомизация клауз → проверка на соответствие регуляциям → оценка рисков.

***

## 2. Parallel Workflow: когда и как

### Суть паттерна

Concurrent (parallel) orchestration запускает **несколько агентов одновременно** на одном и том же входе. Агенты работают независимо, продуцируя intermediate results, которые затем агрегируются инициатором. Также известен как fan-out/fan-in, scatter-gather, map-reduce.

### Когда использовать

Параллельный подход оптимален при:

- **Независимые перспективы** — задача выигрывает от нескольких точек зрения (технической, бизнес-, креативной).
- **Снижение латентности** — параллельная обработка сокращает общее время выполнения.
- **Ensemble reasoning** — голосование, кворум, brainstorming, консенсус.
- **Multi-source research** — одновременный поиск по нескольким источникам данных.

### Когда избегать

- Между агентами есть зависимости — один нуждается в выходе другого.
- Нет чёткой стратегии агрегации или разрешения конфликтов.
- Агенты модифицируют общее состояние (shared state contention).
- Ресурсные ограничения делают параллельный запуск неэффективным.

### Критическое правило для CLI-агентов

В среде Claude Code / Codex CLI параллелизм работает **только когда агенты работают с разными файлами**. Центральный агент должен понимать границы доменов, чтобы корректно маршрутизировать задачи. При перекрытии файлов возникают merge-конфликты и inconsistent state.

### Пример: анализ акций

```
Ticker Symbol → [Stock Analysis Orchestrator]
                    ├── [Fundamental Analysis Agent] → Intermediate Result
                    ├── [Technical Analysis Agent]   → Intermediate Result
                    ├── [Sentiment Analysis Agent]   → Intermediate Result
                    └── [ESG Analysis Agent]         → Intermediate Result
                                        ↓ Aggregation
                    Combined Investment Recommendation
```

Четыре специализированных агента анализируют один тикер параллельно, результаты синтезируются в рекомендацию.

***

## 3. Критерии выбора парадигмы оркестратором

Оркестратор должен принимать решение о парадигме на основе анализа задачи **до начала делегации**. Ниже — дерево решений и ключевые критерии.

### Дерево решений

```
1. Есть ли чёткие зависимости между подзадачами?
   ├── ДА → Подзадачи образуют линейную цепочку?
   │         ├── ДА → SEQUENTIAL
   │         └── НЕТ → HYBRID (sequential каркас + parallel внутри)
   └── НЕТ → Подзадачи можно выполнить независимо?
              ├── ДА → PARALLEL
              └── НЕТ → Требуется дискуссия/консенсус → GROUP CHAT
```

### Сравнительная таблица критериев

| Критерий | Sequential | Parallel |
|----------|-----------|----------|
| **Зависимости** | Сильные, каждый шаг зависит от предыдущего | Нет или минимальные |
| **Латентность** | Высокая (суммируется) | Низкая (макс. из параллельных) |
| **Детерминизм** | Высокий, предсказуемый поток | Требует стратегии агрегации |
| **Устойчивость к ошибкам** | Ошибка на ранней стадии каскадирует | Частичный отказ одного агента не блокирует остальных |
| **Стоимость** | Предсказуемая, последовательная | Пиковое потребление выше |
| **Shared state** | Кумулятивное, передаётся по цепочке | Независимое для каждого агента |
| **Сложность реализации** | Простой пайплайн | Требует агрегации и conflict resolution |
| **Перекрытие файлов (CLI)** | Безопасно — один агент за раз | Опасно при перекрытии → merge-конфликты |

### Практические рекомендации для CLI-оркестратора

В `CLAUDE.md` / конфигурации оркестратора стоит явно описать routing rules:

- Если подзадачи затрагивают **разные домены/файлы** → parallel.
- Если выход одного шага — вход для следующего → sequential.
- Если задача сочетает оба типа → hybrid (например, параллельный research, затем последовательный synthesis).

***

## 4. Делегация задач: Sequential Workflow

### Принципы делегации

В sequential pipeline оркестратор определяет **фиксированный порядок вызова субагентов** и передаёт контекст вдоль цепочки. Каждый субагент получает output предыдущего как свой input.

### Ключевые аспекты

**Context handoff.** Решите, что передавать следующему агенту: полный raw-контекст, компактную summary, или только необходимую инструкцию. Контекстные окна растут с каждым переходом — используйте compaction (суммаризацию) между агентами.

**Quality gates.** Между последовательными шагами встраивайте проверки качества. Паттерн maker-checker (producer → reviewer) позволяет отправить результат на доработку при несоответствии критериям.

**Error propagation prevention.** Ошибка на ранней стадии каскадирует вниз по пайплайну. Каждый агент должен валидировать входящий payload и при обнаружении проблем — либо исправить, либо прервать с информативным сообщением (fail closed).

**Invocation quality.** Большинство ошибок субагентов — это ошибки вызова, а не выполнения. Субагент получает размытые инструкции и делает лучшее из плохого ввода. Плохо: `"Fix authentication"`. Хорошо: `"Fix OAuth redirect loop where successful login redirects to /login instead of /dashboard. Reference auth middleware in src/lib/auth.ts."`.

### Delegation contract для sequential

```json
{
  "schemaVersion": "1.0.0",
  "trace_id": "uuid-v4",
  "task_id": "step-2-clause-customization",
  "step_index": 2,
  "total_steps": 4,
  "from_agent": "TemplateSelectionAgent",
  "to_agent": "ClauseCustomizationAgent",
  "input": {
    "selected_template": "...",
    "client_specifications": "..."
  },
  "output_contract": {
    "required_fields": ["customized_clauses", "modification_log"],
    "definition_of_done": "All negotiated terms reflected in clauses",
    "quality_threshold": { "min_clauses_modified": 3 }
  },
  "constraints": {
    "max_tokens": 4096,
    "timeout_seconds": 120,
    "allowed_tools": ["file_read", "file_write"],
    "forbidden_actions": ["delete_file", "execute_shell"]
  },
  "error_handling": {
    "on_validation_failure": "repair_and_retry",
    "max_retries": 2,
    "on_max_retries_exceeded": "escalate_to_human"
  },
  "previous_step_summary": "Template X selected for jurisdiction Y"
}
```

***

## 5. Делегация задач: Parallel Workflow

### Принципы делегации

В parallel workflow оркестратор выполняет **fan-out** — одновременно отправляет подзадачи нескольким субагентам, затем **fan-in** — собирает и агрегирует результаты. Каждый субагент работает в **изолированном контексте** и не разделяет conversation history с другими параллельными агентами.

### Ключевые аспекты

**Domain-based splitting.** Оркестратор должен разбить задачу на домены, обеспечивая отсутствие перекрытий. В CLI-среде это означает: каждый агент работает с собственным набором файлов или данных.

**Spawn → Delegate → Collect.** Типичный цикл: создать субагентов с уникальными идентификаторами → делегировать задачи → дождаться всех результатов → агрегировать. Пример из OpenHands:

```json
{
  "command": "spawn",
  "ids": ["research", "implementation", "testing"]
}
{
  "command": "delegate",
  "tasks": {
    "research": "Find best practices for async patterns",
    "implementation": "Refactor MyClass for async",
    "testing": "Write unit tests for the refactored code"
  }
}
```


**Timeout и partial failures.** Параллельные агенты должны иметь timeout-механизмы. При отказе одного агента остальные продолжают работу; оркестратор обрабатывает partial results.

**Structured output.** Все параллельные агенты должны возвращать результаты в унифицированном формате (JSON Schema) для корректной агрегации.

### Delegation contract для parallel

```json
{
  "schemaVersion": "1.0.0",
  "trace_id": "uuid-v4",
  "task_id": "parallel-analysis-001",
  "orchestration_mode": "parallel",
  "subtasks": [
    {
      "agent_id": "FundamentalAnalyst",
      "input": { "ticker": "AAPL", "focus": "financials" },
      "output_contract": {
        "required_fields": ["valuation_score", "risk_factors", "confidence"],
        "format": "json"
      },
      "constraints": {
        "timeout_seconds": 90,
        "allowed_tools": ["web_search", "calculator"]
      }
    },
    {
      "agent_id": "TechnicalAnalyst",
      "input": { "ticker": "AAPL", "focus": "price_patterns" },
      "output_contract": {
        "required_fields": ["trend_signal", "support_resistance", "confidence"],
        "format": "json"
      },
      "constraints": {
        "timeout_seconds": 90,
        "allowed_tools": ["web_search", "chart_analysis"]
      }
    }
  ],
  "aggregation": {
    "strategy": "llm_synthesis",
    "fallback": "confidence_weighted_merge",
    "conflict_resolution": "highest_confidence_wins"
  },
  "error_handling": {
    "partial_failure_policy": "continue_with_available",
    "min_successful_agents": 2,
    "on_below_minimum": "escalate"
  }
}
```

***

## 6. Delegation Contract: полная спецификация

Delegation contract — это формальный **интерфейсный контракт между оркестратором и субагентом**, аналогичный API-контракту. Свободно-текстовые handoffs — главный источник потери контекста; каждая передача должна быть структурированной и валидируемой.

### Компоненты контракта

| Компонент | Описание | Пример |
|-----------|----------|--------|
| **Input Schema** | Типизированное описание входных данных | `{ "ticker": "string", "period": "enum[1d,1w,1m]" }` |
| **Output Schema** | Обязательные поля результата | `{ "required_fields": ["summary", "confidence"] }` |
| **Definition of Done** | Чёткие критерии завершения задачи | `"All regulatory clauses validated against 2025 regulations"` |
| **Constraints** | Ограничения ресурсов и прав | `timeout`, `max_tokens`, `allowed_tools`, `forbidden_actions` |
| **Confidence** | Требуемый/возвращаемый уровень уверенности | `{ "min_confidence": 0.8, "report_if_below": true }` |
| **Error/Status Reporting** | Формат отчёта об ошибках | `{ "status": "enum[success,partial,failed]", "error": "string|null" }` |
| **Retries** | Политика повторных попыток | `{ "max_retries": 2, "on_failure": "repair_and_retry" }` |
| **Idempotency** | Ключ идемпотентности для безопасных повторов | `{ "idempotency_key": "uuid-v4" }` |
| **Tool Permissions** | Явный список разрешённых инструментов | `["file_read", "web_search"]` — никаких `execute_shell` |
| **Versioning** | Версия схемы контракта | `{ "schemaVersion": "1.2.0" }` (semver) |
| **Provenance** | Трассировка и аудит | `trace_id`, `citations[]`, `tool_state` |

### Валидация и repair

Каждый контракт валидируется строго (Pydantic, JSON Schema). При ошибке валидации запускается «repair prompt» — модели показывают ошибку валидатора и просят исправить вывод. После N неудачных попыток — reject (fail closed) и эскалация к человеку.

### Versioning

Включайте поле `schemaVersion` и следуйте semver. Это позволяет эволюционировать контракты без поломки обратной совместимости. При обновлении схемы — добавляйте новые поля как optional, не удаляя существующие.

***

## 7. Предотвращение конфликтов и управление Shared State

### Терминология

- **Context** — то, что видит один агент во время инференса.
- **Memory** — то, что один агент хранит и извлекает для собственного использования.
- **State** — то, чем **несколько агентов делятся** для координации.

### Паттерны управления shared state

**Blackboard (Доска).** Общее рабочее пространство, куда агенты публикуют находки и читают вклады друг друга. Подходит для collaborative analysis и research synthesis, где решения формируются инкрементально. Вариации: Pub/Sub (публикация в топики), Observer (подписка на изменения конкретных полей).

**Event Log (Журнал событий).** Append-only запись событий и действий. Агенты подписываются на типы событий и реагируют на них. Обеспечивает порядок, избегает конфликтов обновления, даёт встроенный audit trail. Вариации: Message Queue (exactly-once), Event Sourcing (полная реконструкция состояния).

**Structured State (Типизированное состояние).** Typed JSON-объект с определёнными полями и чёткими владельцами каждого поля. Предсказуемость и ясность, но требует проектирования схемы заранее. Вариации: Orchestrator State (центральный координатор), Hierarchical State (вложенные области).

### Сравнение паттернов

| Паттерн | Гибкость | Предсказуемость | Аудитируемость | Лучше для |
|---------|----------|-----------------|----------------|-----------|
| Blackboard | Высокая | Низкая | Средняя | Collaborative research, brainstorming |
| Event Log | Средняя | Средняя | Высокая | Audit-sensitive domains, workflow coordination |
| Structured State | Низкая | Высокая | Средняя | Typed pipelines, production handoffs |

### Предотвращение конфликтов

**Isolation first.** Agent isolation защищает рабочую память каждого агента. Информация передаётся только через явные shared state механизмы. В CLI-контексте: каждый параллельный субагент работает в своей ветке контекста и не видит контекст других.

**Write governance.** Определите, какие агенты могут записывать в какие части состояния. Агент, пишущий в shared state, влияет на всех читающих. Защитите write path валидацией и логированием.

**Conflict resolution policy.** Решите заранее: last-write-wins, merge logic, reject-and-retry, или central arbitration. Для параллельных workflow при конфликтах результатов — используйте merge policies (timestamp-based или authority-based) или CRDT-подобные структуры.

**Race conditions.** В concurrent workflow — типичная проблема. Симптом: last-write-wins перезаписи, inconsistent merges. Решение: сериализовать merge-шаг или использовать timestamp/authority-based merge.

***

## 8. Агрегация, Merge и Arbitration результатов

### Стратегии агрегации

После параллельного выполнения оркестратор должен объединить intermediate results в финальный ответ. Выбор стратегии зависит от типа задачи:

| Тип задачи | Стратегия агрегации | Описание |
|-------------|---------------------|----------|
| Классификация | **Voting / Majority rule** | Агенты голосуют, побеждает большинство |
| Рейтинг / Scoring | **Weighted merge** | Результаты взвешиваются по confidence или экспертизе агента |
| Нарративные ответы | **LLM-based synthesis** | LLM синтезирует результаты в связный текст |
| Независимые действия | **No aggregation** | Каждый агент выполняет свою часть; агрегация не нужна |
| High-stakes decisions | **Confidence-weighted voting** | Вес голоса пропорционален уверенности агента |

### Результаты исследования M1-Parallel

Исследование M1-Parallel показало, что **LLM-based aggregation превосходит majority voting** в большинстве случаев, так как LLM может использовать информацию из execution logs для принятия решений. Однако разрыв с best-of-k (оракульным выбором лучшего) остаётся — скрытые ошибки рассуждения в логах сложно идентифицировать. Эффективная стратегия: использовать малые модели для параллельных команд и большую модель для агрегации.

### Паттерны реализации

**Collect and Merge.** Все результаты собираются, затем объединяются в один объект: `totalTests`, `passed`, `failed`, `duration = max(...)`, `coverage = avg(...)`.

**Map-Reduce.** Результаты обрабатываются в два этапа: map (параллельная обработка) → reduce (агрегация).

**Arbitration (арбитраж).** При конфликте результатов вызывается специальный агент-арбитр или применяется rule-based prioritization: предопределённые политики диктуют, чьё решение приоритетнее.

***

## 9. Idempotency, Retries и Error Handling

### Идемпотентность

LLM-агенты не являются naturally idempotent: temperature > 0 порождает разные выходы при повторах, а вызовы внешних API создают side effects. Стратегии обеспечения идемпотентности:

- **Idempotency key.** Каждый запрос снабжается уникальным ID. Принимающая сторона распознаёт повторный запрос и возвращает кешированный результат.
- **Two-phase operations.** Фаза 1: validate and plan (идемпотентна). Фаза 2: execute side effects (с idempotency key).
- **Request deduplication.** Каждый workflow execution получает unique ID; дубликаты отклоняются автоматически.
- **Temperature=0** для критических агентов, чтобы обеспечить воспроизводимость.

### Retries и Saga Pattern

Если агент выполнил 3 из 5 операций и упал, retry повторит все 5 — первые 3 выполнятся дважды. **Saga pattern** решает это: каждый шаг записывает своё завершение и определяет compensation action для отката. При partial failure — откатываются только завершённые шаги, а workflow возобновляется с точки останова.

### Failure modes и mitigation

| Failure Mode | Симптом | Решение |
|-------------|---------|---------|
| Schema drift | Тихое несовпадение полей, потеря контекста | Versioned schemas, strict validators, contract tests |
| Race conditions | Last-write-wins перезаписи | Merge policies, сериализация merge-шага |
| Hallucinated tool calls | Невалидные API-вызовы | Typed tool interfaces, allowlists, sandboxed execution |
| Runaway loops | Бесконечное ре-планирование, раздувание стоимости | Hard caps на шаги/стоимость, termination criteria |
| Reviewer rubber-stamp | QA пропускает низкокачественные результаты | Ротация reviewer'ов, judge-based comparison |
| Duplicate operations (retry) | Двойная оплата, дублирование записей | Idempotency tokens, deduplication |

***

## 10. Эталонные Workflow-схемы

### Схема 1: Sequential Pipeline

```
┌─────────┐     ┌────────────┐     ┌───────────┐     ┌──────────┐     ┌────────┐
│  Input   │────▶│  Research   │────▶│  Planning  │────▶│  Impl.   │────▶│ Review │
│ (Task)   │     │  Agent      │     │  Agent     │     │  Agent   │     │ Agent  │
└─────────┘     └────────────┘     └───────────┘     └──────────┘     └────────┘
                      │                  │                  │               │
                 [Model +           [Model +           [Model +       [Model +
                  Search]            Context]          Code Tools]     Linter]
                                                                          │
                              ◄──── Common Accumulating State ────►       ▼
                                                                      Result
```

**Контекст применения:** задачи с чёткой линейной зависимостью — code generation pipeline (research → plan → implement → review), document generation, ETL-обработка.

### Схема 2: Parallel Fan-Out / Fan-In

```
                              ┌──────────────┐
                         ┌───▶│  Agent A      │───┐
                         │    │  (Domain 1)   │   │
┌─────────┐    Fan-out   │    └──────────────┘   │   Fan-in    ┌─────────────┐
│  Input   │─────────────┤    ┌──────────────┐   ├────────────▶│  Aggregator │──▶ Result
│ (Task)   │    Orchestr. │───▶│  Agent B      │───┤  Collect   │  Agent      │
└─────────┘              │    │  (Domain 2)   │   │            └─────────────┘
                         │    └──────────────┘   │
                         │    ┌──────────────┐   │
                         └───▶│  Agent C      │───┘
                              │  (Domain 3)   │
                              └──────────────┘

  [Каждый агент работает изолированно, без shared state между ветками]
```

**Контекст применения:** multi-source research, мульти-перспективный анализ, broad data retrieval, brainstorming.

### Схема 3: Hybrid (Parallel Research → Sequential Synthesis)

```
                              ┌───────────────────┐
                         ┌───▶│  Researcher A      │──┐
                         │    │  (Renewable Energy) │  │
                         │    └───────────────────┘  │
┌─────────┐   Parallel   │    ┌───────────────────┐  │  Sequential  ┌──────────┐  ┌──────────┐
│  Input   │─────────────┤───▶│  Researcher B      │──┼────────────▶│ Synthesis │─▶│ Review   │──▶Result
│          │  (Phase 1)  │    │  (EV Technology)   │  │  (Phase 2)  │ Agent    │  │ Agent    │
└─────────┘              │    └───────────────────┘  │              └──────────┘  └──────────┘
                         │    ┌───────────────────┐  │
                         └───▶│  Researcher C      │──┘
                              │  (Carbon Capture)  │
                              └───────────────────┘
                                  ↓ output_key → state
```

**Контекст применения:** наиболее распространённый в продакшене паттерн. Параллельный сбор данных (Phase 1) с последующим последовательным синтезом и рецензированием (Phase 2). Google ADK реализует это через `ParallelAgent` + `SequentialAgent`: результаты параллельных агентов записываются в state через `output_key`, а merger agent читает их из state-переменных.

***

## 11. Практические рекомендации для CLI-среды

### Конфигурация CLAUDE.md / orchestrator config

Центральный агент CLI-инструмента читает routing rules из конфигурации (`CLAUDE.md`, `.claude/agents/`). Добавьте в конфигурацию:

- **Routing decision framework** — правила, когда использовать parallel vs sequential.
- **Chain definitions** — явные описания dependency chains, чтобы оркестратор не параллелизировал последовательные задачи.
- **Domain boundaries** — какие файлы/директории принадлежат каким доменам.
- **Invocation protocol** — минимальные требования к каждому вызову субагента: scope, file references, success criteria, expected output format.

### Модель субагентов

Установите `CLAUDE_CODE_SUBAGENT_MODEL` для контроля модели субагентов. Распространённый паттерн: main session на мощной модели (Opus) для complex reasoning, субагенты на быстрой (Sonnet) для focused tasks — сокращение стоимости без потери качества на хорошо scoped подзадачах.

### Типичные ошибки

**Over-parallelizing** — запуск 10 параллельных агентов для простой фичи тратит токены и создаёт координационный overhead. Группируйте связанные микрозадачи.

**Under-parallelizing** — последовательное выполнение четырёх независимых анализов, которые могли бы быть параллельными.

**Vague invocations** — отправка субагенту `"implement the feature"` вместо конкретного scope с файловыми ссылками и ожидаемым output.

***

## 12. Чеклист для имплементации

### Перед началом работы

- Определите паттерн оркестрации для каждого этапа; задокументируйте trade-offs.
- Определите delegation contracts с JSON Schema; включите `schemaVersion` и `trace_id`.
- Реализуйте валидацию и auto-repair; эскалируйте к человеку после N неудач.

### Shared State и Memory

- Разделите short-term (текущий план/state) и long-term (reusable knowledge) memory.
- Сохраняйте provenance (trace_id, citations) во всех handoffs.
- Определите политику разрешения конфликтов до начала работы: last-write-wins, merge, или arbitration.

### Quality и Reliability

- Добавьте Producer → Reviewer → Publisher loops для high-risk шагов.
- Реализуйте idempotency keys для всех операций с side effects.
- Установите hard caps на количество шагов и стоимость для предотвращения runaway loops.
- Настройте timeout для каждого субагента; определите partial failure policy.

