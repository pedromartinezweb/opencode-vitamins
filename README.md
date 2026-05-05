# OpenCode Vitamins

OpenCode Vitamins is a reusable multi-agent skeleton for OpenCode projects.

It gives any repository a clean agent setup for planning, implementation, testing, review, and autonomous iteration. Copy it into a project and start working with a coordinated team of specialized OpenCode agents.

## Motivation

Modern AI coding works better when responsibilities are explicit. A single agent can plan, code, test, and review, but quality improves when those jobs are separated.

OpenCode Vitamins provides a small, practical structure:

- GPT-5.5 focuses on planning.
- DeepSeek V4 Pro coordinates, implements, and reviews.
- LM Studio handles lower-cost local testing work.
- The lead agent keeps the loop moving until the task is verified.

The goal is not to create a heavy framework. It is a lightweight project skeleton that adds enough process to make autonomous coding more reliable while staying easy to copy, inspect, and modify.

## What It Adds

- A primary `lead` agent that coordinates the full workflow.
- A GPT-5.5 `planner` agent for technical planning.
- DeepSeek V4 Pro agents for review, backend code, and frontend code.
- A local LM Studio/Qwen `tester` agent for low-cost validation.
- Project-level OpenCode commands: `/plan`, `/orchestrate`, and `/verify`.
- Shared engineering rules in `AGENTS.md`.
- A concise workflow guide in `docs/agents/workflow.md`.
- A neutral example task in `docs/tasks/example-task.md`.

## Install In An Existing Project

Run this from the root of your project:

```bash
tmp="$(mktemp -d)" && git clone --depth 1 https://github.com/pedromartinezweb/opencode-vitamins.git "$tmp/opencode-vitamins" && bash "$tmp/opencode-vitamins/install.sh" && rm -rf "$tmp"
```

To overwrite existing skeleton files:

```bash
tmp="$(mktemp -d)" && git clone --depth 1 https://github.com/pedromartinezweb/opencode-vitamins.git "$tmp/opencode-vitamins" && FORCE=1 bash "$tmp/opencode-vitamins/install.sh" && rm -rf "$tmp"
```

## Use As A Starting Template

Clone this repository and use it as the base for a new project:

```bash
git clone https://github.com/pedromartinezweb/opencode-vitamins.git my-project
cd my-project
rm -rf .git
git init
```

Then start OpenCode:

```bash
opencode
```

## Agents

| Agent | Role | Default model |
| --- | --- | --- |
| `lead` | Coordinates planning, delegation, verification, and iteration | `deepseek/deepseek-v4-pro` |
| `planner` | Creates the technical plan without editing files | `openai/gpt-5.5` |
| `reviewer` | Reviews quality, architecture, risks, and acceptance criteria | `deepseek/deepseek-v4-pro` |
| `backend-coder` | Implements backend, domain, APIs, persistence, and services | `deepseek/deepseek-v4-pro` |
| `frontend-coder` | Implements UI, components, client state, styles, and UX | `deepseek/deepseek-v4-pro` |
| `tester` | Runs tests, writes focused tests, and reports evidence | `lmstudio/qwen/qwen3.6-27b` |

## Commands

Inside OpenCode:

```text
/plan describe your task here
/orchestrate describe your task here
/verify describe the acceptance criteria here
```

From the terminal:

```bash
opencode run \
  --agent lead \
  --command orchestrate \
  --print-logs \
  --log-level INFO \
  "describe your task here"
```

For trusted disposable workspaces, you can allow autonomous edits and commands:

```bash
opencode run \
  --agent lead \
  --command orchestrate \
  --dangerously-skip-permissions \
  --print-logs \
  --log-level INFO \
  "describe your task here"
```

## Example Task

This repository includes a neutral example task:

```text
docs/tasks/example-task.md
```

Run it from the terminal:

```bash
opencode run \
  --agent lead \
  --command orchestrate \
  --dangerously-skip-permissions \
  --print-logs \
  --log-level INFO \
  "$(cat docs/tasks/example-task.md)"
```

## Expected Model Setup

The skeleton assumes these model IDs are available in OpenCode:

```text
openai/gpt-5.5
deepseek/deepseek-v4-pro
lmstudio/qwen/qwen3.6-27b
```

You can change them in:

```text
opencode.jsonc
.opencode/agents/*.md
```

## Generated Files

The installer creates or updates:

```text
AGENTS.md
opencode.jsonc
docs/agents/workflow.md
docs/tasks/example-task.md
.opencode/agents/backend-coder.md
.opencode/agents/frontend-coder.md
.opencode/agents/lead.md
.opencode/agents/planner.md
.opencode/agents/reviewer.md
.opencode/agents/tester.md
.opencode/.gitignore
```

It also appends common build artifacts to `.gitignore` when missing.

## Workflow

1. `lead` receives the task.
2. `planner` creates the technical plan.
3. `lead` delegates implementation to backend and frontend agents.
4. `tester` runs checks and reports evidence.
5. `reviewer` validates architecture, quality, and acceptance criteria.
6. `lead` sends concrete fixes back to the responsible agent when needed.
7. The loop continues until tests and review pass or a clear blocker is found.

## License

MIT
