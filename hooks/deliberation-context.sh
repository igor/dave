#!/usr/bin/env bash
# deliberation-context.sh — Session-start hook for deliberation state
# Walks up from cwd looking for .deliberation/questions.jsonl
# Outputs a brief nudge about open questions. Silent when nothing found.

set -euo pipefail

# Require jq
command -v jq >/dev/null 2>&1 || exit 0

# Read hook input from stdin
INPUT=$(cat)
CWD=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('cwd',''))" 2>/dev/null)

[ -z "$CWD" ] && exit 0

# Walk up directory tree looking for .deliberation/questions.jsonl
JSONL=""
DIR="$CWD"
while [ "$DIR" != "/" ]; do
  if [ -f "$DIR/.deliberation/questions.jsonl" ]; then
    JSONL="$DIR/.deliberation/questions.jsonl"
    break
  fi
  DIR=$(dirname "$DIR")
done

[ -z "$JSONL" ] && exit 0
[ ! -s "$JSONL" ] && exit 0

# Compute stats from JSONL using jq
# Outputs: open question count, recent activity, stale questions
NOW_EPOCH=$(date +%s)
SEVEN_DAYS_AGO=$((NOW_EPOCH - 604800))
FOURTEEN_DAYS_AGO=$((NOW_EPOCH - 1209600))

STATS=$(jq -rn --argjson seven "$SEVEN_DAYS_AGO" --argjson fourteen "$FOURTEEN_DAYS_AGO" '
# Read all events
[inputs] as $events |

# Find all opened question IDs
[$events[] | select(.type == "question_opened") | .id] as $opened |

# Find closed question IDs (crystallized or dissolved)
[$events[] | select(.type == "question_crystallized" or .type == "question_dissolved") | .id] as $closed |

# Open questions = opened minus closed
[$opened[] | select(. as $id | $closed | index($id) | not)] as $open_ids |

# For each open question, get text and activity info
[
  $open_ids[] | . as $qid |
  # Get question text (most recent reframe, or original)
  ([$events[] | select(.type == "question_reframed" and .id == $qid) | .new_text] | last) //
  ([$events[] | select(.type == "question_opened" and .id == $qid) | .text] | first) |
  . as $text |
  # Count recent evidence
  ([$events[] | select(.question == $qid and .type == "evidence_added") |
    (.ts | split("T")[0] | strptime("%Y-%m-%d") | mktime) |
    select(. >= $seven)] | length) as $recent_evidence |
  # Last activity timestamp
  ([$events[] | select((.question == $qid) or (.id == $qid)) |
    (.ts | split("T")[0] | strptime("%Y-%m-%d") | mktime)] | max) as $last_ts |
  {
    text: $text,
    recent_evidence: $recent_evidence,
    stale: ($last_ts < $fourteen),
    days_inactive: (((now - $last_ts) / 86400) | floor)
  }
] |

# Format output
if length == 0 then empty
else
  "DELIBERATION: \(length) open question\(if length > 1 then "s" else "" end) in this directory.",
  (.[] |
    if .recent_evidence > 0 then
      "\"\(.text)\" has \(.recent_evidence) new evidence item\(if .recent_evidence > 1 then "s" else "" end) since last week."
    elif .stale then
      "\"\(.text)\" is stale (\(.days_inactive) days, no activity)."
    else
      empty
    end
  )
end
' "$JSONL" 2>/dev/null) || exit 0

[ -n "$STATS" ] && echo "$STATS"
exit 0
