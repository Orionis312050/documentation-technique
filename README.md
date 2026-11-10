# documentation-technique

Édition **offline** de la documentation technique du **Teams SDK** pour les 3 langages — **C# (.NET)**, **TypeScript** et **Python** — à partir de :

- https://microsoft.github.io/teams-sdk/llms_docs/llms_csharp.txt
- https://microsoft.github.io/teams-sdk/llms_docs/llms_typescript.txt
- https://microsoft.github.io/teams-sdk/llms_docs/llms_python.txt

(+ contenu complet de chaque doc, inline dans les fichiers).

## Structure

- `llms.txt` : index global des 3 documentations (liens relatifs vers `docs/`).
- `sync-docs.sh` : assemble `docs/<langage>/` depuis les dépôts `dotnet-llmstxt`, `typescript-llmstxt`, `python-llmstxt`.
- `docs/<langage>/<categorie>/<feature>.md` : **une feature par fichier**, contenu complet inline.
- Chaque dossier — y compris `docs/<langage>/` — contient un `_category_.json` (compatible **Docusaurus**), donc le site génère 3 grandes sections : C# (.NET), TypeScript, Python.
- Tous les cross-references sont des liens relatifs intra-dépôt : **aucun fetch externe requis** (environnement fermé).

## Assemblage de `docs/` (une seule fois)

```bash
git clone https://github.com/Orionis312050/documentation-technique.git
cd documentation-technique
bash sync-docs.sh                 # copie docs/dotnet, docs/typescript, docs/python depuis les 3 dépôts
git add -A && git commit -m "Add docs/ for C#, TypeScript and Python" && git push
```

`docs/` fait ~1,3 Mo (239 pages) : il est assemblé depuis les dépôts dédiés plutôt que poussé fichier par fichier.

## Utilisation avec Docusaurus

Pointez simplement votre Docusaurus existant sur ce dossier :

```ts
// docusaurus.config.ts
presets: [
  [
    'classic',
    {
      docs: { path: 'docs', routeBasePath: 'teams-sdk' },
      // ...
    },
  ],
],
```

Ou copiez `docs/` à la racine de votre site Docusaurus. Les `_category_.json` produisent automatiquement la hiérarchie `langage → catégorie → feature`.

## Source

Généré depuis `microsoft/teams-sdk` (`teams.md/src/pages/templates` + fragments `<lang>.incl.md`, et `teams.md/docs/main`), même pipeline que `generate-llms-txt.ts`. Les llms.txt complets (liens déjà inline) de chaque langage restent disponibles dans les dépôts dédiés `dotnet-llmstxt`, `typescript-llmstxt`, `python-llmstxt` (dossier `script/`).
