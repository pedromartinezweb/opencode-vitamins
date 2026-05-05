# OpenCode Vitamins

Reusable OpenCode multi-agent skeleton.

## Install In A New Project

Run this from the root of any project:

```bash
curl -fsSL https://raw.githubusercontent.com/pedromartinezweb/opencode-vitamins/main/install.sh | bash
```

To overwrite existing skeleton files:

```bash
curl -fsSL https://raw.githubusercontent.com/pedromartinezweb/opencode-vitamins/main/install.sh | FORCE=1 bash
```

## Agents

- `lead`: coordinator, DeepSeek V4 Pro.
- `planner`: planning, GPT-5.5.
- `reviewer`: review, DeepSeek V4 Pro.
- `backend-coder`: backend generation, DeepSeek V4 Pro.
- `frontend-coder`: frontend generation, DeepSeek V4 Pro.
- `tester`: tests, LM Studio Qwen.

## Usage

```bash
opencode
```

Inside OpenCode:

```text
/plan describe your task here
/orchestrate describe your task here
/verify describe the acceptance criteria here
```

Autonomous terminal run:

```bash
opencode run \
  --agent lead \
  --command orchestrate \
  --dangerously-skip-permissions \
  --print-logs \
  --log-level INFO \
  "describe your task here"
```

Use `--dangerously-skip-permissions` only in a trusted project workspace.
