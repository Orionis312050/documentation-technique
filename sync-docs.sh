#!/usr/bin/env bash
# sync-docs.sh — assemble docs/<language>/ in this repo from the per-language llmstxt repos.
# Usage: bash sync-docs.sh   (run from the root of the documentation-technique clone)
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

fetch() { # $1 = repo, $2 = target dir under docs/
  local repo="$1" dest="docs/$2"
  echo "-> $repo -> $dest"
  git clone --depth 1 "https://github.com/Orionis312050/$repo.git" "$TMP/$repo"
  mkdir -p "$dest"
  cp -r "$TMP/$repo/docs/." "$dest/"
}

fetch dotnet-llmstxt dotnet
fetch typescript-llmstxt typescript
fetch angular-llmstxt angular

# category roots for the 3 languages (kept if already present, created otherwise)
for lang in dotnet typescript angular; do
  [ -f "docs/$lang/_category_.json" ] || case "$lang" in
    dotnet)     printf '{\n  "label": "C# (.NET)",\n  "position": 1,\n  "collapsed": false\n}\n' ;;
    typescript) printf '{\n  "label": "TypeScript",\n  "position": 2,\n  "collapsed": false\n}\n' ;;
    angular)    printf '{\n  "label": "Angular",\n  "position": 3,\n  "collapsed": false\n}\n' ;;
  esac > "docs/$lang/_category_.json"
done

echo "Done. docs/ now contains: $(find docs -name '*.md' | wc -l) pages, $(find docs -name '_category_.json' | wc -l) _category_.json"
echo "Commit and push: git add -A && git commit -m 'Add docs/ for C#, TypeScript and Angular' && git push"
