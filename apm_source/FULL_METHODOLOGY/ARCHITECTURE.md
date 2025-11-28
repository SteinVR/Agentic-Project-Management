# Project Architecture: [Project Name]

> Note: This document is the single source of truth for the project's logic, design, and behavior. It describes what we are building and how it works logically.
> 

## 1. Project Idea & Philosophy

> Context: Describe the core essence, need, and vision of the project. What problem does it solve? Why does it exist?
> 

[Example: "The project is an Agentic LLM Evaluation tool. The core need is to automate the tedious process of benchmarking different LLMs against specific business tasks using a multi-agent approach. The philosophy is 'Agent-driven Quality Assurance'."]

---

## 2. Project Body (Form Factor)

> Context: In what form will the project be realized?
> 
- **Type:** [e.g., CLI Application / Python Script / Web Service / Telegram Bot]
- **Interface:** [e.g., Terminal interaction via arguments / REST API / Interactive Chat]

---

## 3. User Workflow (Operational Principle)

> Context: A step-by-step narrative of how the user interacts with the finished product. This defines the flow of the application.
> 

[Example Step-by-Step Description:

1. **User Action:** User inputs a command (e.g., `/start_eval`).
    - **System Reaction:** The system initializes the `TaskAnalyst` agent.
    - **Outcome:** A specification file is generated.
2. **User Action:** User reviews the spec and inputs `/generate_dataset`.
    - **System Reaction:** The system initializes the `DatasetSpecialist` agent.
    - **Outcome:** A JSON dataset is created or fetched.
3. ... (Continue describing the flow)
]

---

## 4 Overall Architecture and Components

### Architecture

> A view of the system's structure. Decompose the system into its logical modules. Describe the main components and how they interact. The project should be divided into isolated functional blocks (Bounded Contexts).
> 

[e.g., "This project is a monolithic web application built with a Vue.js Single Page Application (SPA) frontend that communicates with a Python/FastAPI backend via a REST API. Data is persisted in a PostgreSQL database."]

### Component/Blocks Breakdown

> For each module, describe its responsibilities and its primary interface or contract.
> 

### 4.1. [Component 1: e.g., Frontend Application]

- **Responsibility:** [e.g., "Render the user interface, manage client-side state, and communicate with the Backend API."]
- **Key Directories:** [e.g., `/frontend/src/components`, `/frontend/src/views`]
- **Directory Structure**
    
    {**diagram**}
    

### 4.2. [Component 2: e.g., Backend API]

- **Responsibility:** [e.g., "Handle business logic, process incoming HTTP requests, interact with the database, and manage user authentication."]
- **Key Modules:** [e.g., `app/routers`, `app/models`, `app/services`]
- **Directory Structure**
    
    {**diagram**}
    

### 4.3. [Component 3: e.g., Database]

- **Responsibility:** [e.g., "Persist all application data, including users, tasks, and projects."]
- **Schema Location:** [e.g., "SQLAlchemy models are defined in `app/database/models.py`."]
- **Directory Structure**
    
    {**diagram**}
    

**Include an ASCII diagram**

---

## 5. Technology Stack

> List all major languages, frameworks, libraries, and databases. Justify the choice for each, especially in the context of AI-driven development (e.g., stability, large training set).
> 
- **Language:** [e.g., Python 3.11]
- **Frontend:** [e.g., Vue.js 3 with Vite]
- **Backend:** [e.g., FastAPI with Pydantic]
- **Database:** [e.g., PostgreSQL 15]
- **Testing:** [e.g., Pytest for backend, Playwright for E2E]
- **Infrastructure:** [e.g., Docker, GitHub Actions]

---

## 6. Data Model * (If Exists)

> Describe the core data structures and their relationships. This can be a description of database tables or primary API data objects.
> 
- **[Model 1: e.g., User]**
    - `id`: (PK)
    - `email`: (String, Unique)
    - `hashed_password`: (String)
- **[Model 2: e.g., Task]**
    - `id`: (PK)
    - `title`: (String)
    - `completed`: (Boolean)
    - `owner_id`: (FK to [User.id](http://user.id/))

---

## 7. Key Conventions

- **Modularity:** Code must be logically separated into classes and modules within `src/`.
- **Logging:** All significant events must be logged to `logs/{name}.log`.
    - **Format:** `[YYYY-MM-DD HH:MM:SS] [LEVEL] - Message`
- **Tools:** Reusable scripts created during development should be saved in `TOOLS/`.

---

## 8. Ubiquitous Language (Domain Glossary) *

> A glossary of key terms and their meanings within the project's domain to ensure all agents and the Manager operate with a shared understanding.
> 
- **[Term 1]**: [Clear, unambiguous definition].
- **[Term 2]**: [Clear, unambiguous definition].

---

" * " - means optional