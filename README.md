# PruebaOpencode

OpenCode multi-agent configuration for building an ambulance SaaS POC.

## Agents

- `lead`: coordinator, DeepSeek V4 Pro.
- `planner`: planning, GPT-5.5.
- `reviewer`: review, DeepSeek V4 Pro.
- `backend-coder`: backend generation, DeepSeek V4 Pro.
- `frontend-coder`: frontend generation, DeepSeek V4 Pro.
- `tester`: tests, LM Studio Qwen.

## Main Task

The product brief is in:

```text
docs/tasks/ambulance-saas-poc.md
```

## Run

```bash
opencode
```

Inside OpenCode:

```text
/plan create the ambulance SaaS POC
/orchestrate create the ambulance SaaS POC
```

Autonomous terminal run:

```bash
mkdir -p logs

opencode run \
  --agent lead \
  --command orchestrate \
  --dangerously-skip-permissions \
  --print-logs \
  --log-level INFO \
  "$(cat docs/tasks/ambulance-saas-poc.md)" \
  2>&1 | tee "logs/ambulance-saas-$(date +%Y%m%d-%H%M%S).log"
```

Use `--dangerously-skip-permissions` only in a trusted project workspace.
