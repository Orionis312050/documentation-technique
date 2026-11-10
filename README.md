# documentation-technique

Édition **offline** de la documentation technique du **Teams SDK** pour les 3 langages — **C# (.NET)**, **TypeScript** et **Angular** — à partir de :

- https://microsoft.github.io/teams-sdk/llms_docs/llms_csharp.txt
- https://microsoft.github.io/teams-sdk/llms_docs/llms_typescript.txt
- https://angular.dev/llms.txt

(+ contenu complet de chaque doc, inline dans les fichiers).

## Structure

- `llms.txt` : index global des 3 documentations (liens relatifs vers `docs/`).
- `docs/<langage>/<categorie>/<feature>.md` : **une feature par fichier**, contenu complet inline.
  - `docs/dotnet/` — édition C# (.NET) (depuis `dotnet-llmstxt`)
  - `docs/typescript/` — édition TypeScript (depuis `typescript-llmstxt`)
  - `docs/angular/` — édition Angular (depuis `angular-llmstxt`)
- Chaque dossier — y compris `docs/<langage>/` — contient un `_category_.json` (compatible **Docusaurus**), donc le site génère 3 grandes sections : C# (.NET), TypeScript, Angular.
- Tous les cross-references sont des liens relatifs intra-dépôt : **aucun fetch externe requis** (environnement fermé).


## Assemblage de `docs/` (une seule fois)

```bash
git clone https://github.com/Orionis312050/documentation-technique.git
cd documentation-technique
bash sync-docs.sh                 # copie docs/dotnet, docs/typescript, docs/angular depuis les 3 dépôts
git add -A && git commit -m "Add docs/ for C#, TypeScript and Angular" && git push
```

`docs/` fait ~1,8 Mo (250 pages) : il est assemblé depuis les dépôts dédiés plutôt que poussé fichier par fichier.

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

Généré depuis `microsoft/teams-sdk` (`teams.md/src/pages/templates` + fragments `<lang>.incl.md`, et `teams.md/docs/main`), même pipeline que `generate-llms-txt.ts`, et depuis `angular/angular` pour Angular. Les llms.txt complets (liens déjà inline) de chaque langage restent disponibles dans les dépôts dédiés `dotnet-llmstxt`, `typescript-llmstxt`, `angular-llmstxt` (dossier `script/`).
