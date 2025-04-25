#!/usr/bin/env bash
set -euo pipefail

# 1) Paths to the two files you need to fix
FILE1="src/converter/internal/convertercontroller.cpp"
FILE2="src/converter/internal/compat/backendapi.cpp"

# 2) Make sure we’re in a git repo root
if [ ! -d .git ]; then
  echo "Error: run this from the root of your checkout" >&2
  exit 1
fi

# 3) Apply the fixes via sed (creates .bak backups)
sed -i.bak \
  -E 's/for \(const QJsonValueRef[[:space:]]+obj[[:space:]]*:[[:space:]]*arr\)/for (QJsonValueConstRef obj : arr)/' \
  "$FILE1"

sed -i.bak \
  -E 's/for \(const QJsonValueRef[[:space:]]+colorObj[[:space:]]*:[[:space:]]*colors\)/for (QJsonValueConstRef colorObj : colors)/' \
  "$FILE2"

# 4) Remove backups
rm "$FILE1.bak" "$FILE2.bak"

# 5) Stage, commit, and push
git add "$FILE1" "$FILE2"
git commit -m "Fix converter loops to use QJsonValueConstRef (Qt6 build errors)"
git push

echo "✅ Patches applied, committed, and pushed. Your PR should update automatically."