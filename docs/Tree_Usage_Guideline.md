# Tree Usage Guideline

## Context
The repository contains a `claude-code-proxy` directory with a deep `src` hierarchy. Developers often run `tree` to visualize the project structure.

## Decision
Use the following command to display the tree up to depth 3 while omitting Python source and compiled files:

```bash
cd claude-code-proxy
# Show directories/files up to three levels deep, hide *.py and *.pyc files, prune empty directories

tree -L 3 -I "*.py|*.pyc" --prune
```

## Rationale
- **Depth 3** provides a concise overview of top‑level packages (`api`, `conversion`, etc.) without overwhelming detail.
- **`-I "*.py|*.pyc"`** prevents clutter from implementation files that are not needed for structural inspection.
- **`--prune`** removes empty directories that would otherwise appear due to the ignore pattern.

## Impact / Next Steps
- Save this guideline in the `docs/` folder for team reference.
- Encourage developers to copy‑paste the command when exploring the repository.
- Update any internal scripts that generate tree outputs to use these flags.
