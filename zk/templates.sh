#!/bin/bash
# Template-Setup für zk

# Verzeichnis erstellen
mkdir -p ~/.config/zk/templates

# Default Template
cat > ~/.config/zk/templates/default.md << 'EOF'
# {{title}}

**Created:** {{format-date now}}
**Tags:**

## Content

EOF

# Daily Template
cat > ~/.config/zk/templates/daily.md << 'EOF'
# Daily Notes - {{title}}

**Date:** {{format-date now}}
**Tags:** #daily

## Today's Focus
- [ ]

## Notes

## Tomorrow's Priorities
- [ ]

EOF

# Weekly Template
cat > ~/.config/zk/templates/weekly.md << 'EOF'
# Weekly Review - {{title}}

**Week of:** {{format-date now "2006-01-02"}} - {{format-date (date-add now "6 days") "2006-01-02"}}
**Tags:** #weekly #review

## This Week's Goals
- [ ]
- [ ]
- [ ]

## Accomplishments
### Monday
-

### Tuesday
-

### Wednesday
-

### Thursday
-

### Friday
-

### Weekend
-

## Key Insights & Learnings

## Challenges Faced

## Next Week's Priorities
- [ ]
- [ ]
- [ ]

## Metrics/Stats
- Hours worked:
- Key projects advanced:
- Meetings attended:

EOF

# Meeting Template
cat > ~/.config/zk/templates/meeting.md << 'EOF'
# Meeting: {{title}}

**Date:** {{format-date now}}
**Participants:**
**Duration:**
**Tags:** #meeting

## Agenda
- [ ]

## Discussion Notes

## Decisions Made

## Action Items
- [ ] [@person] Task description [Due: date]

## Follow-up
- [ ] Schedule next meeting
- [ ] Send meeting notes

EOF

# Project Template
cat > ~/.config/zk/templates/project.md << 'EOF'
# Project: {{title}}

**Status:** Planning | In Progress | On Hold | Completed
**Priority:** High | Medium | Low
**Start Date:** {{format-date now}}
**Due Date:**
**Tags:** #project

## Project Overview

### Goals
-

### Success Criteria
-

## Tasks
- [ ] Task 1
- [ ] Task 2

## Resources & Links
-

## Notes

EOF

# Idea Template
cat > ~/.config/zk/templates/idea.md << 'EOF'
# 💡 {{title}}

**Date:** {{format-date now}}
**Category:**
**Tags:** #idea

## The Idea

## Why This Matters

## Next Steps
- [ ]

## Related Ideas
-

EOF

# Research Template
cat > ~/.config/zk/templates/research.md << 'EOF'
# Research: {{title}}

**Topic:**
**Date:** {{format-date now}}
**Status:** Initial | In Progress | Complete

## Research Question

## Key Findings

## Sources
-

## Methodology

## Conclusions

## Further Research Needed
- [ ]

---
Tags: #research
EOF

echo "Templates created in ~/.config/zk/templates/"
