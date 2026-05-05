# Multi-Agent Workflow

This project uses OpenCode with one primary lead agent and five specialized subagents.

## Models

- Lead: `deepseek/deepseek-v4-pro`
- Planner: `openai/gpt-5.5`
- Reviewer: `deepseek/deepseek-v4-pro`
- Backend coder: `deepseek/deepseek-v4-pro`
- Frontend coder: `deepseek/deepseek-v4-pro`
- Tester: `lmstudio/qwen/qwen3.6-27b`

## Usage

From the project root:

```bash
opencode
```

Inside OpenCode:

```text
/orchestrate create a task API with a simple frontend and tests
```

Plan only:

```text
/plan create a test project with backend and frontend
```

Verify current state:

```text
/verify implemented functionality must meet the plan criteria
```

## Loop

1. @lead receives the task.
2. @lead asks @planner for a plan.
3. @lead delegates implementation to @backend-coder and @frontend-coder.
4. @lead asks @tester for tests.
5. @lead asks @reviewer for final review.
6. If issues exist, @lead sends exact fixes to the responsible agent.
7. The loop ends when tests and review pass.

## Visible Board

Use `docs/tasks/current.md` to track long tasks or audit progress.

@lead should keep:

- Goal.
- Acceptance criteria.
- Tasks by agent.
- Task state.
- Verification commands.
- Pending issues.
- Final decision.

## Limits

OpenCode supports primary agents, subagents, and commands. Automated iteration depends on @lead following the loop and invoking the responsible subagent again when @tester or @reviewer fails.

For efficiency:

- Use GPT-5.5 for planning.
- Use DeepSeek V4 Pro as the default coordinator, reviewer, and complex code generator.
- Use LM Studio for tests, local exploration, and low-cost tasks.
- Keep tasks small so each agent uses limited context.
