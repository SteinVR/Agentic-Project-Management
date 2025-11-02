# Lightweight Project Architecture: [Project Name]

> **Note:** This document is a high-level guide for rapid prototyping. It defines the core rules and direction to ensure consistency and focus. It is not an exhaustive blueprint.

---

## 1. Overview & Core Goal (MVP)

> A brief, one-paragraph summary of the project. What is the core problem this prototype aims to solve?

[Provide a high-level summary of the prototype's mission. For example: "This project is an MVP for a command-line task management tool. The core goal is to allow a user to add, list, and complete tasks directly from the terminal."]

---

## 2. High-Level Architecture

> This section describes the conceptual flow and interaction of the system's main components.

The application operates as a command-line interface (CLI) tool. The execution flow is as follows:
1.  The user runs the application via the main script (`main.py`).
2.  The `Orchestrator` in `main.py` loads necessary settings from `config.py`.
3.  It then parses the user's input (e.g., 'add', 'list') using a dedicated utility.
4.  Based on the command, the `Orchestrator` calls the appropriate method in the core `Service` module (e.g., `TaskManager`), which contains all the business logic.
5.  The `Service` performs the operation (e.g., adding a task to a list, reading from a file).
6.  The result is returned to the `Orchestrator`, which then formats and prints the output to the user's console.

### AI-Friendly Diagram (ASCII Flowchart)

This diagram illustrates the flow of control and data within the application. It is the primary reference for component interaction.

```
     [ User (Terminal) ]
             |
             | 1. Executes command (e.g., `python main.py add "Buy milk"`)
             v
+---------------------------+
|   main.py (Orchestrator)  |
+---------------------------+
| 2. Reads settings         |   +----------------+
|--------------------------->|   config.py      |
| 3. Parses user input      |   +----------------+
|--------------------------->|   utils/parser.py  |
| 4. Invokes business logic |   +----------------+
|--------------------------->|   services/        |
| 6. Formats output         |   | TaskManager.py |
|<---------------------------|   +----------------+
| 7. Prints to console      |
v
     [ User (Terminal) ]
```

---

## 3. Technology Stack

> The non-negotiable list of core technologies. All code must adhere to this stack.

-   **Language:** [e.g., Python 3.11]
-   **Key Libraries:** [e.g., Typer for CLI arguments, Pydantic for data models]
-   **Data Storage:** [e.g., JSON file (`tasks.json`)]

---

## 4. Code Organization Pattern

> The mandatory file and code structure within the `src/` directory. This pattern promotes a clear separation of concerns.

-   `main.py`: **The Entrypoint & Orchestrator.** This is the only file that should be directly executed. It is responsible for parsing command-line arguments, initializing services, and coordinating the overall application flow. It should contain minimal business logic.

-   `config.py`: **Configuration.** Stores all static configuration, constants, file paths (e.g., `DATABASE_FILE = "tasks.json"`), and settings.

-   `services/`: **Business Logic Directory.** This directory contains the core logic of the application, encapsulated in classes (the "reusable objects" you mentioned).
    -   Example: `TaskManager.py` would contain a `TaskManager` class with methods like `add_task()`, `get_all_tasks()`, `complete_task()`.

-   `utils/`: **Utilities Directory.** Contains specific, reusable helper functions that are not part of the core business logic.
    -   Example: `parser.py` for validating user input, or `formatter.py` for creating styled console output.

---

## 5. Core Data Models (Optional)

> A brief description of the main data entities.

-   **[Model 1: e.g., Task]**
    -   **Purpose:** Represents a single to-do item with an ID, title, and completion status. Will be modeled as a Pydantic class.

---

## 6. Key Conventions

> A few simple rules to maintain code quality and consistency.

-   **Simplicity:** Always prefer the simplest solution and syntax that works.
-   **Clarity:** Variable and function names should be self-explanatory.
-   **Styling:** [e.g., All Python code must be formatted with Black and follow PEP 8.]
-   **Documentation:** Public functions and methods should have a simple docstring explaining their purpose, arguments, and return value.
-   **Logging:** The application MUST implement simple, human-readable text logging.
    - **Location:** All logs must be written to a single file at `logs/prototype.log`. The `logs/` directory should be in the project root.
    - **Format:** Each log entry must follow the format: `[YYYY-MM-DD HH:MM:SS] [LEVEL] - Message`.
    - **Usage:**
        - **INFO:** Log the start and successful completion of major user actions.
        - **ERROR:** Log any exception or failure that occurs.