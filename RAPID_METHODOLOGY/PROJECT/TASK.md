# Task Log: [Project Name] Prototype

---

<!-- Filled and maintained by the Manager -->
## 1. Overall MVP Goal

> **Purpose:** A single, clear statement of what this prototype must achieve to be considered successful. This is our North Star.

**Goal:** To create a command-line tool that allows a user to add, list, and complete tasks, storing the data in a local JSON file.

---

<!-- Managed by Manager (adding tasks) and Lead Engineer (checking them off) -->
## 2. Feature Backlog

> **Purpose:** A running checklist of all features, enhancements, and chores required to reach the MVP goal. The Manager adds items here; the Lead Engineer marks them as done.

-   [x] Setup the basic project structure and dependencies.
-   [x] Implement the ability to add a new task.
-   [ ] Implement the ability to list all tasks.
-   [ ] Implement the ability to mark a task as complete by its ID.
-   [ ] Add color-coding to the terminal output for better readability.
-   [ ] Implement basic error handling for file not found.

---

<!-- Updated by the Manager to direct the Lead Engineer's focus -->
## 3. Current Task in Focus

> **Purpose:** Clearly indicates what the Lead Engineer should be working on RIGHT NOW.

**Current Task:** Implement the ability to list all tasks. The output should be a numbered list showing the task ID, its completion status `[x]` or `[ ]`, and its title.

---

<!-- Owned and constantly updated by the Lead Engineer for the current task -->
## 4. Implementation Plan (Current TO-DO)

> **Purpose:** The Lead Engineer's dynamic plan for the **Current Task in Focus**. This section will be cleared and re-written for each new task from the backlog.

-   [ ] Create a `get_all_tasks()` method in the `TaskManager` service.
-   [ ] This method should read and parse the `tasks.json` file.
-   [ ] Add a new command `list` to `main.py`.
-   [ ] When the `list` command is called, it should invoke `get_all_tasks()`.
-   [ ] Format the returned list of tasks into a user-friendly string.
-   [ ] Print the formatted string to the console.