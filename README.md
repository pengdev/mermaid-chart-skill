# Mermaid Chart Skill for Claude Code

A [Claude Code skill](https://docs.anthropic.com/en/docs/claude-code/skills) that enables Claude to produce **more readable Mermaid diagrams** through a visual feedback loop.

### The problem

When Claude generates Mermaid markdown directly, it can't *see* the result — so overlapping nodes, cramped labels, or awkward layouts go unnoticed.

### How this skill fixes it

This skill closes the feedback loop: Claude renders the Mermaid definition to a **PNG**, reads the image back (Claude is multimodal), and **iterates** on the layout until the diagram actually looks good. The result is a polished `.mmd` file you can drop straight into your GitHub markdown, or you can ask Claude to open the PNG locally for a quick visual check.

```
Write .mmd → Render PNG → Read PNG → Refine → Repeat
```

In short: **Claude sees what you see**, so the diagrams come out right.

## Installation

Clone or copy this skill into your Claude Code skills directory:

```bash
git clone git@github.com:pengdev/mermaid-chart-skill.git ~/.claude/skills/mermaid-chart
```

Or copy manually:

```bash
cp -r path/to/mermaid-chart ~/.claude/skills/mermaid-chart
```

## Requirements

- **Node.js + npm** — required only if `mmdc` is not already on your PATH. `setup.sh` installs `@mermaid-js/mermaid-cli` locally the first time it runs.
- **`mmdc` (optional)** — if already installed globally (`npm install -g @mermaid-js/mermaid-cli`), it will be used directly. Otherwise the skill installs it locally under `tools/node_modules/`.

No other dependencies. No Python. No root.

## Permissions

Add these to `~/.claude/settings.json` under `permissions.allow` to avoid repeated prompts:

```json
"permissions": {
  "allow": [
    "Bash(*/skills/mermaid-chart/tools/render.sh*)",
    "Bash(*/skills/mermaid-chart/tools/setup.sh*)",
    "Read(/tmp/mermaid-chart/)"
  ]
}
```

**What each rule covers:**

| Pattern | Purpose |
|---|---|
| `*/render.sh*` | Write `.mmd` file and invoke `mmdc` to produce PNG |
| `*/setup.sh*` | Detect or install `mmdc` (called automatically by `render.sh`) |
| `Read(/tmp/mermaid-chart/)` | View rendered PNG output |

## Usage Examples

The skill activates automatically when Claude detects a need to visualise a pipeline, architecture, or flow. You can also invoke it explicitly with `/mermaid-chart`.

### Natural prompts (mid-session)

```
Generate a PNG of the deployment pipeline we just described
```

```
Can you draw an architecture diagram of this system?
```

```
Create a sequence diagram showing the auth flow
```

### Explicit invocation

```
/mermaid-chart Draw a flowchart of the SBOM generation pipeline:
  Android deps → spdx-gradle-plugin → SPDX 2.3 JSON
  Native .so → separate tool → SPDX 2.3 JSON
  Both merge → tools-java convert → SPDX 3.0.1
```

## What It Can Do

| Diagram type | Use case |
|---|---|
| **Flowchart** (`flowchart TD/LR`) | Pipelines, processes, decision trees |
| **Sequence diagram** | API flows, auth sequences, inter-service communication |
| **Architecture / component** (`graph LR` + `subgraph`) | System components, layer diagrams |
| **Class diagram** | Object models, inheritance hierarchies |

All diagrams are rendered with consistent colour coding:

| Role | Colour |
|---|---|
| Input / source | Blue |
| Tool / process | Purple |
| Artifact / file | Green |
| Merge / combine | Orange |
| Final output | Red |

## How It Works

1. Claude writes a `.mmd` Mermaid definition to `/tmp/mermaid-chart/`
2. `render.sh` calls `setup.sh` to locate or install `mmdc`
3. `mmdc` renders the diagram to a PNG at the same path
4. Claude reads and displays the PNG (multimodal vision)
5. Claude iterates if layout or labels need adjustment

## File Structure

```
SKILL.md                  # Skill instructions (loaded by Claude Code)
README.md                 # This file
tools/
  setup.sh                # Detect global mmdc or install locally via npm
  render.sh               # Write .mmd → render PNG via mmdc
  node_modules/           # Local mmdc install (created by setup.sh if needed, gitignore this)
```
