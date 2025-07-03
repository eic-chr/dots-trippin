#!/usr/bin/env bash
# Setup für Multi-Cluster zk Organisation

echo "Setting up zk cluster organization..."
notes_dir="$HOME/projects/ceickhoff/zettelkasten/"
echo "using $notes_dir as dir"
# Ansatz 1: Separate Notebooks
echo "Creating separate notebook structure..."
mkdir -p $notes_dir/{personal,huk,ewo}

# Unterordner für jeden Cluster
for cluster in personal huk ewo; do
    mkdir -p $notes_dir/$cluster/{daily,weekly,meetings,projects,ideas,checklists,archive}

    # Cluster-spezifische zk config
    cat > $notes_dir/$cluster/config.toml << EOF
[notebook]
dir = "$notes_dir/$cluster"

[note]
default-title = "{{format-date now '%Y-%m-%d %H:%M'}}"
filename = "{{id}}"
extension = "md"
template = "default.md"

[group.daily]
paths = ["daily"]
note.filename = "{{format-date now '%Y-%m-%d %H:%M'}}"
note.template = "daily.md"

[group.weekly]
paths = ["weekly"]
note.filename = "{{format-date now 'year'}}-W{{format-date now 'week-number'}}"
note.template = "weekly.md"

[group.meetings]
paths = ["meetings"]
note.template = "meeting.md"

[alias]
daily = "zk new daily --title '{{format-date now '%Y-%m-%d %H:%M'}}'"
weekly = "zk new weekly --title '{{format-date now 'year'}}-W{{format-date now 'week-number'}}'"
EOF

    # Jedes Notebook initialisieren
    cd $notes_dir/$cluster
    zk init
    echo "Initialized $cluster notebook"
done

# Ansatz 2: Tag-basierte Templates
echo "Creating cluster-specific templates..."
mkdir -p ~/.config/zk/templates

# Personal Templates
cat > ~/.config/zk/templates/personal.md << 'EOF'
# {{title}}

**Date:** {{format-date now '%Y-%m-%d %H:%M'}}
**Context:** Personal

## Content

## Related
-

---
Tags: #personal
EOF

# huk Templates
cat > ~/.config/zk/templates/huk.md << 'EOF'
# {{title}}

**Date:** {{format-date now '%Y-%m-%d %H:%M'}}
**Context:** huk
**Project:**
**Priority:** High | Medium | Low

## Objective

## Details

## Action Items
- [ ]

## Follow-up
- [ ]

---
Tags: #huk
EOF

# Side Project Templates
cat > ~/.config/zk/templates/ewo.md << 'EOF'
# {{title}}

**Date:** {{format-date now '%Y-%m-%d %H:%M'}}
**Context:** Side Project
**Project:**
**Status:** Planning | Development | Testing | Deployed

## Description

## Technical Notes

## Next Steps
- [ ]

## Resources
-

---
Tags: #ewo
EOF

# Cluster-spezifische Daily Templates
cat > ~/.config/zk/templates/personal-daily.md << 'EOF'
# Personal Daily - {{format-date now '%Y-%m-%d %H:%M'}}

## Today's Personal Goals
- [ ]

## Health & Wellness
- Exercise:
- Mood:
- Sleep:

## Learning & Growth
-

## Personal Projects
-

## Reflections

---
Tags: #personal #daily
EOF

cat > ~/.config/zk/templates/huk-daily.md << 'EOF'
# huk Daily - {{format-date now '%Y-%m-%d %H:%M'}}

## Priority Tasks
- [ ]
- [ ]
- [ ]

## Meetings & Calls
-

## Progress Made
-

## Blockers/Issues
-

## Tomorrow's Focus
- [ ]

---
Tags: #huk #daily
EOF

echo "✅ Cluster organization setup complete!"
echo ""
echo "📁 Structure created:"
echo "   $notes_dir/personal/"
echo "   $notes_dir/huk/"
echo "   $notes_dir/ewo/"
echo ""
echo "🏷️  Templates available:"
echo "   - personal.md"
echo "   - huk.md"
echo "   - ewo.md"
echo "   - personal-daily.md"
echo "   - huk-daily.md"
echo ""
echo "⌨️  New keybindings:"
echo "   <leader>zs  - Switch notebook"
echo "   <leader>zsp - Switch to Personal"
echo "   <leader>zsw - Switch to huk"
echo "   <leader>zss - Switch to Side Projects"
echo "   <leader>znp - New personal note"
echo "   <leader>znw - New huk note"
echo "   <leader>zns - New side project note"
echo "   <leader>zfa - Search all notebooks"
