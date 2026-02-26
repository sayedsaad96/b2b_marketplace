---
description: Create or update the project constitution from interactive or provided principle inputs, ensuring all dependent templates stay in sync.
---

# SpecKit Constitution Workflow

This workflow creates or updates the **project constitution** — a foundational document that defines the project's core principles, coding standards, architecture decisions, and guidelines that all subsequent specs, plans, and tasks must follow.

## Steps

1. **Check for existing constitution**
   - Look for `.speckit/constitution.md` in the project root.
   - If it exists, load it for editing. If not, proceed to create a new one.

2. **Gather principle inputs**
   - If the user provides principles inline, use those directly.
   - If no principles are provided, ask the user interactively about:
     - State management approach
     - Architecture pattern
     - Navigation strategy
     - Backend / API integration
     - Localization requirements
     - Target platforms
     - Design system preferences
     - Testing requirements
     - Naming conventions & coding standards
     - Any other project-specific principles

3. **Generate the constitution**
   - Create `.speckit/constitution.md` with the following sections:
     - **Project Overview**: Name, description, purpose
     - **Tech Stack**: Framework, language, SDK version, key dependencies
     - **Architecture**: Pattern, folder structure, layering rules
     - **State Management**: Chosen approach and usage guidelines
     - **Navigation**: Router choice and routing conventions
     - **Data Layer**: Backend, API patterns, data models
     - **UI/UX Standards**: Design system, theming, responsive design
     - **Localization**: Supported languages, i18n approach
     - **Testing**: Unit, widget, integration test requirements
     - **Code Style**: Naming conventions, file organization, lint rules
     - **Platform Targets**: Supported platforms and platform-specific notes
     - **Dependencies**: Approved packages and version policies

4. **Sync dependent templates**
   - Ensure `.speckit/templates/spec.md`, `.speckit/templates/plan.md`, and `.speckit/templates/tasks.md` reference the constitution.
   - Create template files if they don't exist.

5. **Present for review**
   - Show the constitution to the user for approval.
   - Incorporate feedback and finalize.
