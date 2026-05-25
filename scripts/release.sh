#!/usr/bin/env bash
# release.sh — bump version, update CHANGELOG, commit, tag, and push.
#
# Usage:
#   ./scripts/release.sh <new_version> "<changelog entry>"
#
# Example:
#   ./scripts/release.sh 1.0.8 "fix: resolve null pointer on iOS"

set -euo pipefail

NEW_VERSION="${1:-}"
CHANGELOG_ENTRY="${2:-}"

# ── Validation ──────────────────────────────────────────────────────────────
if [[ -z "$NEW_VERSION" || -z "$CHANGELOG_ENTRY" ]]; then
  echo "Usage: $0 <new_version> \"<changelog entry>\""
  echo "Example: $0 1.0.8 \"fix: resolve null pointer on iOS\""
  exit 1
fi

if ! echo "$NEW_VERSION" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+(\+[0-9]+)?$'; then
  echo "❌ Invalid version format: $NEW_VERSION  (expected e.g. 1.0.8 or 1.0.8+1)"
  exit 1
fi

PUBSPEC="pubspec.yaml"
CHANGELOG="CHANGELOG.md"

CURRENT_VERSION=$(grep '^version:' "$PUBSPEC" | awk '{print $2}')
echo "Current version : $CURRENT_VERSION"
echo "New version     : $NEW_VERSION"

# ── Check working tree is clean ───────────────────────────────────────────
if [[ -n "$(git status --porcelain)" ]]; then
  echo "❌ Working tree is not clean. Commit or stash changes first."
  exit 1
fi

# ── Install dependencies and run checks ──────────────────────────────────
echo ""
echo "🔍 Installing dependencies..."
flutter pub get

echo "🔍 Analyzing source..."
flutter analyze

echo "🔍 Running tests..."
flutter test

echo "🔍 Checking publish readiness..."
dart pub publish --dry-run

# ── Bump version in pubspec.yaml ─────────────────────────────────────────
echo ""
echo "✏️  Bumping version in $PUBSPEC..."
if sed --version 2>/dev/null | grep -q GNU; then
  sed -i "s/^version: .*$/version: ${NEW_VERSION}/" "$PUBSPEC"
else
  sed -i.bak "s/^version: .*$/version: ${NEW_VERSION}/" "$PUBSPEC"
  rm -f "${PUBSPEC}.bak"
fi

# ── Prepend entry to CHANGELOG.md ────────────────────────────────────────
echo "✏️  Updating $CHANGELOG..."
TMPFILE=$(mktemp)
{
  echo "## $NEW_VERSION"
  echo "- $CHANGELOG_ENTRY"
  echo ""
  cat "$CHANGELOG"
} > "$TMPFILE"
mv "$TMPFILE" "$CHANGELOG"

# ── Commit, tag, push ────────────────────────────────────────────────────
echo ""
echo "📝 Committing changes..."
git add "$PUBSPEC" "$CHANGELOG"
git commit -m "chore: release v$NEW_VERSION"

echo "🏷️  Creating tag v$NEW_VERSION..."
git tag "v$NEW_VERSION"

echo "🚀 Pushing commit and tag..."
git push
git push origin "v$NEW_VERSION"

echo ""
echo "✅ Released v$NEW_VERSION — the publish workflow will now run on GitHub Actions."
