#!/usr/bin/env bash
# sync-docs.sh — assemble docs/<language>/ in this repo from the per-language llmstxt projects.
#
# Offline usage (environnement fermé, projets déjà en local) :
#   bash sync-docs.sh /chemin/vers/dotnet-llmstxt /chemin/vers/typescript-llmstxt /chemin/vers/angular-llmstxt
#   # or via env vars:
#   DOTNET_REPO=/chemin/vers/dotnet-llmstxt TS_REPO=/chemin/vers/typescript-llmstxt ANGULAR_REPO=/chemin/vers/angular-llmstxt bash sync-docs.sh
#
# Online fallback (only when no local path is given for a language):
#   bash sync-docs.sh        # clones https://github.com/Orionis312050/<repo>.git
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

DOTNET_SRC="${1:-${DOTNET_REPO:-}}"
TS_SRC="${2:-${TS_REPO:-}}"
NG_SRC="${3:-${ANGULAR_REPO:-}}"

fetch() { # $1 = local path or empty, $2 = repo name (for online fallback), $3 = target dir under docs/
  local src="$1" repo="$2" dest="docs/$3"
  if [ -n "$src" ]; then
    [ -d "$src/docs" ] || { echo "ERREUR: $src ne contient pas de dossier docs/" >&2; exit 1; }
    echo "-> local $src -> $dest"
    mkdir -p "$dest"
    cp -r "$src/docs/." "$dest/"
    return
  fi
  echo "-> clone https://github.com/Orionis312050/$repo.git -> $dest"
  local tmp; tmp="$(mktemp -d)"
  git clone --depth 1 "https://github.com/Orionis312050/$repo.git" "$tmp/$repo"
  mkdir -p "$dest"
  cp -r "$tmp/$repo/docs/." "$dest/"
  rm -rf "$tmp"
}

fetch "$DOTNET_SRC" dotnet-llmstxt dotnet
fetch "$TS_SRC" typescript-llmstxt typescript
fetch "$NG_SRC" angular-llmstxt angular

# ---- link fixups (pages llms-ignored / cross-repo links that don't exist in the offline edition) ----
fixups() {
  # DevTools (deprecated, page not in offline edition) -> Agents Playground page
  for f in docs/dotnet/developer-tools.md docs/typescript/developer-tools.md docs/angular/developer-tools.md; do
    [ -f "$f" ] && sed -i 's|\[DevTools\](\./devtools)|[DevTools](./developer-tools/microsoft-365-agents-playground.md)|' "$f" 2>/dev/null || true
  done
  # C# page linking to the TypeScript edition: fix depth + target file
  [ -f docs/dotnet/in-depth-guides/tabs/functions.md ] && \
    sed -i 's|../../../../typescript/in-depth-guides/tabs/functions/function-calling|../../../typescript/in-depth-guides/tabs/functions/executing-functions.md|' docs/dotnet/in-depth-guides/tabs/functions.md || true
  # migration guide page not in offline edition -> plain text
  [ -f docs/typescript/essentials/graph-api-client.md ] && \
    sed -i 's|\[migration guide\](../migrations/v2-previews)|migration guide (page `migrations/v2-previews`, non incluse dans l'\''édition offline)|' docs/typescript/essentials/graph-api-client.md || true
  # angular contributing sub-pages not in offline edition -> plain text
  [ -f docs/angular/others/contributingmd.md ] && \
    sed -i -e 's|\[\([^]]*\)\](\./contributing-docs/\([^)]*\))|[\1]|g' docs/angular/others/contributingmd.md || true
}
fixups

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
