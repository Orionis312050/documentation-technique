# documentation-technique

Édition **offline** de la documentation technique — **Teams SDK** (C# .NET, TypeScript, Python) et **Angular** — à partir de :

- https://microsoft.github.io/teams-sdk/llms_docs/llms_csharp.txt
- https://microsoft.github.io/teams-sdk/llms_docs/llms_typescript.txt
- https://microsoft.github.io/teams-sdk/llms_docs/llms_python.txt
- https://angular.dev/llms.txt

(+ contenu complet de chaque doc, inline dans les fichiers).

## Structure

- `llms.txt` : index global des 4 documentations (liens relatifs vers `docs/`).
- `docs/<langage>/<categorie>/<feature>.md` : **une feature par fichier**, contenu complet inline.
  - `docs/dotnet/` — édition C# (.NET) (depuis `dotnet-llmstxt`)
  - `docs/typescript/` — édition TypeScript (depuis `typescript-llmstxt`)
  - `docs/angular/` — édition Angular (depuis `angular-llmstxt`)
  - `docs/python/` — édition Python (depuis `python-llmstxt`)
- Chaque dossier — y compris `docs/<langage>/` — contient un `_category_.json` (compatible **Docusaurus**), donc le site génère 4 grandes sections : C# (.NET), TypeScript, Angular, Python.
- Tous les cross-references sont des liens relatifs intra-dépôt : **aucun fetch externe requis** (environnement fermé).


## Assemblage de `docs/` (une seule fois)

En **ligne** (clone depuis GitHub) :

```bash
git clone https://github.com/Orionis312050/documentation-technique.git
cd documentation-technique
bash sync-docs.sh                 # clone les 4 dépôts puis copie docs/dotnet, docs/typescript, docs/angular, docs/python
git add -A && git commit -m "Add docs/ for C#, TypeScript, Angular and Python" && git push
```

En **environnement fermé** (projets déjà présents en local, aucun fetch) :

```bash
git clone https://github.com/Orionis312050/documentation-technique.git   # ou copie locale du dépôt
cd documentation-technique
bash sync-docs.sh /chemin/vers/dotnet-llmstxt /chemin/vers/typescript-llmstxt /chemin/vers/angular-llmstxt /chemin/vers/python-llmstxt
# ou : DOTNET_REPO=... TS_REPO=... ANGULAR_REPO=... PYTHON_REPO=... bash sync-docs.sh
git add -A && git commit -m "Add docs/ for C#, TypeScript, Angular and Python" && git push
```

`docs/` fait ~2,2 Mo (327 pages) : il est assemblé depuis les dépôts dédiés plutôt que poussé fichier par fichier.

## Utilisation avec Docusaurus

Pointez simplement votre Docusaurus existant sur ce dossier :

```ts
// docusaurus.config.ts
presets: [
  [
    'classic',
    {
      docs: { path: 'docs', routeBasePath: 'docs' },
      // ...
    },
  ],
],
```

Ou copiez `docs/` à la racine de votre site Docusaurus. Les `_category_.json` produisent automatiquement la hiérarchie `langage → catégorie → feature`.

## Source

Généré depuis `microsoft/teams-sdk` (`teams.md/src/pages/templates` + fragments `<lang>.incl.md`, et `teams.md/docs/main`), même pipeline que `generate-llms-txt.ts`, et depuis `angular/angular` pour Angular. Les llms.txt complets (liens déjà inline) de chaque projet restent disponibles dans les dépôts dédiés `dotnet-llmstxt`, `typescript-llmstxt`, `angular-llmstxt`, `python-llmstxt` (dossier `script/`).
