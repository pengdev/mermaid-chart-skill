---
name: mermaid-chart
description: "Create flow charts, architecture diagrams, or sequence diagrams using Mermaid and render them as PNG. Use when the user asks to visualise a pipeline, architecture, flow, or process."
argument-hint: "[description of the chart to create, or existing Mermaid definition]"
---

# Mermaid Chart Generator

Design a Mermaid diagram, write it to a `.mmd` file, and render it to PNG via the tools in this skill.

**SKILL_DIR**: The base directory for this skill shown above when loaded. Use it to resolve tool paths below.

## Workflow

1. **Design** — choose the right diagram type for the content (see below)
2. **Write** the `.mmd` file to `/tmp/mermaid-chart/<name>.mmd`
3. **Render** to PNG using the render script
4. **View** the output with the Read tool — you are multimodal and can inspect the rendered image
5. **Iterate** — check for overlapping nodes, cramped labels, or awkward layout and refine until the diagram is clean and readable

## Tools

**Render a diagram:**
```bash
"$SKILL_DIR/tools/render.sh" -i /tmp/mermaid-chart/<name>.mmd
# Output path is printed to stdout (same path with .png extension by default)
```

**Render with custom options:**
```bash
"$SKILL_DIR/tools/render.sh" \
  -i /tmp/mermaid-chart/<name>.mmd \
  -o /tmp/mermaid-chart/<name>.png \
  -w 1800          # wider image for complex diagrams
  -b white         # background colour
```

`setup.sh` is called automatically by `render.sh` — it finds a global `mmdc` install or installs `@mermaid-js/mermaid-cli` locally inside the skill's `tools/` directory. No manual setup needed.

Save all output under `/tmp/mermaid-chart/` (the render script creates the directory automatically).

## Diagram Types

### Flow chart / pipeline
```
flowchart TD
    A["Input"] --> B["Process"]
    B --> C["Output"]
```
Use `TD` (top-down) for linear pipelines, `LR` (left-right) for branching ones.

### Sequence diagram
```
sequenceDiagram
    participant A as Client
    participant B as Server
    A->>B: Request
    B-->>A: Response
```

### Architecture / component diagram
```
graph LR
    subgraph Backend
        API["API Server"]
        DB[(Database)]
    end
    Client --> API --> DB
```
Use `subgraph` to group related components visually.

### Class diagram
```
classDiagram
    class Animal {
        +String name
        +speak()
    }
    Animal <|-- Dog
```

## Styling

Apply colour to individual nodes:
```
style NodeId fill:#4A90D9,color:#fff,stroke:#2c6fad
```

Consistent colour palette:
| Role              | Fill      | Stroke    |
|-------------------|-----------|-----------|
| Input / source    | `#4A90D9` | `#2c6fad` |
| Tool / process    | `#7B68EE` | `#5a4ec4` |
| Artifact / file   | `#5BA85A` | `#3d7a3c` |
| Merge / combine   | `#E8943A` | `#c4712a` |
| Final output      | `#E05C5C` | `#b83c3c` |

## Labels

- Use `<br/>` for line breaks inside labels (not `\n`)
- Wrap labels in `["..."]` to allow special characters and spaces
- Keep labels to two lines max per node

## Tips

- Always Read the PNG after rendering to verify the result looks correct
- If nodes overlap or the graph is too tall, switch `TD` → `LR`
- For wide sequence diagrams (many participants), pass `-w 1800` or `-w 2000`
- `render.sh` prints the output path on success — pass that path to the Read tool

## Recommended Permissions

Add these to `~/.claude/settings.json` under `permissions.allow` to avoid permission prompts when using this skill:

```json
"permissions": {
  "allow": [
    "Bash(*/skills/mermaid-chart/tools/render.sh*)",
    "Bash(*/skills/mermaid-chart/tools/setup.sh*)",
    "Read(/tmp/mermaid-chart/)"
  ]
}
```
