Общая архитектура проекта.

Примерный шаблон:
# Project Architecture: [Project Name]

## 1. Overview

> A brief, one-paragraph summary of the project. What is its purpose/What core problem does it solve?

[Provide a high-level summary of the project's mission and goals.]

---

## 2. Goals and Non-Goals

> Define the specific, measurable objectives of the project and explicitly state what is out of scope. This helps to focus development efforts.

### Goals
- [Primary goal 1, e.g., "Develop an MVP for a task management system with user authentication."]
### Non-Goals
- [Feature or functionality that will NOT be implemented, e.g., "Real-time collaboration features are out of scope for the MVP."]
- [Constraint, e.g., "This project will not support databases other than PostgreSQL."]

---

## 3. Overall Architecture and Components

### Architecture
> A view of the system's structure. Decompose the system into its logical modules. Describe the main components and how they interact.

[e.g., "This project is a monolithic web application built with a Vue.js Single Page Application (SPA) frontend that communicates with a Python/FastAPI backend via a REST API. Data is persisted in a PostgreSQL database."]

### Component/Blocks Breakdown

>  For each module, describe its responsibilities and its primary interface or contract.

#### 6.1. [Component 1: e.g., Frontend Application]
- **Responsibility:** [e.g., "Render the user interface, manage client-side state, and communicate with the Backend API."]
- **Key Directories:** [e.g., `/frontend/src/components`, `/frontend/src/views`]

#### 6.2. [Component 2: e.g., Backend API]
- **Responsibility:** [e.g., "Handle business logic, process incoming HTTP requests, interact with the database, and manage user authentication."]
- **Key Modules:** [e.g., `app/routers`, `app/models`, `app/services`]

#### 6.3. [Component 3: e.g., Database]
- **Responsibility:** [e.g., "Persist all application data, including users, tasks, and projects."]
- **Schema Location:** [e.g., "SQLAlchemy models are defined in `app/database/models.py`."]

**Include an ASCII diagram**

---

## 4. Technology Stack

> List all major languages, frameworks, libraries, and databases. Justify the choice for each, especially in the context of AI-driven development (e.g., stability, large training set).

- **Language:** [e.g., Python 3.11]
- **Frontend:** [e.g., Vue.js 3 with Vite]
- **Backend:** [e.g., FastAPI with Pydantic]
- **Database:** [e.g., PostgreSQL 15]
- **Testing:** [e.g., Pytest for backend, Playwright for E2E]
- **Infrastructure:** [e.g., Docker, GitHub Actions]

---

## 5. Data Model* (If Exists)

> Describe the core data structures and their relationships. This can be a description of database tables or primary API data objects.

- **[Model 1: e.g., User]**
  - `id`: (PK)
  - `email`: (String, Unique)
  - `hashed_password`: (String)
- **[Model 2: e.g., Task]**
  - `id`: (PK)
  - `title`: (String)
  - `completed`: (Boolean)
  - `owner_id`: (FK to User.id)

---

## 6. Coding Conventions

> Specify the code style and formatting rules to ensure consistency.

-   **Simplicity:** Always prefer simple, clear, and maintainable solutions.
-   **Consistency:** Strictly adhere to the existing code style, formatting, and architectural patterns of the project.
-   **DRY (Don't Repeat Yourself):** Before writing new code, search the codebase for existing functionality that can be reused.
-   **Focused Changes:** Don't touch not related for the task code
-   **Documentation:** Write clear, complete docstrings (using the project's specified format) for all public functions, methods, and classes. Do not use comments anywhere else.
-   **Error Handling:** Implement robust error handling using try-except blocks for operations that can fail.
-   **Feedback:** Use Agent Feedback Protocol. !ONLY FOR TEAM LEAD OR SYSTEM ARCHITECT!
  - **Logging:** All modules MUST implement structured, machine-readable (JSON) logging.
    - **Location:** Logs for each block must be written to `PROJECT/BLOCK_NAME/logs/`.
    - **Format:** Each log entry must be a JSON object containing at least these fields:
      - `timestamp`: ISO 8601 format.
      - `level`: One of `INFO`, `WARNING`, `ERROR`.
      - `message`: A descriptive string of the event.
      - `source_block`: The name of the block generating the log (e.g., "AuthService").
      - `correlation_id`: A unique identifier (e.g., UUID) to trace a request across multiple blocks.
    - **Usage:**
      - **INFO:** For significant, successful events (e.g., user login, process completion).
      - **WARNING:** For non-critical issues that should be noted (e.g., deprecated function call, configuration fallback).
      - **ERROR:** For any failure, exception, or unexpected behavior that prevents an operation from completing.
      
### Agent Feedback Protocol
This protocol is the official method for inter-agent communication, primarily used by the Team Lead for reviews.

-   `// FOR-[AGENT_ROLE]-TODO: [Actionable task]`
    -   **Purpose:** Assign a corrective task to a specific agent role.
    -   **Example:** `// FOR-DEVELOPER-TODO: This logic must be extracted into a separate utility function.`

-   `// [AGENT_ROLE]-NOTE: [Contextual observation]`
    -   **Purpose:** To leave a note for other agents explaining a decision or providing context.
    -   **Example:** `// SYSTEM-ARCHITECT-NOTE: This interface is temporary and will be replaced in BLOCK3.`

## 7. Ubiquitous Language (Domain Glossary) *

> A glossary of key terms and their meanings within the project's domain to ensure all agents and the Manager operate with a shared understanding.

-   **[Term 1]**: [Clear, unambiguous definition].
-   **[Term 2]**: [Clear, unambiguous definition].


---

" * " - means optional