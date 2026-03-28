# Mb — Dashboard Instagram

Dashboard Instagram privé avec authentification Netlify Identity et base de données Supabase.

---

## Structure du projet

```
mb-instagram-dashboard/
├── index.html        ← Page de connexion (publique)
├── dashboard.html    ← Dashboard principal (protégé)
├── build.sh          ← Script d'injection des variables au build
├── netlify.toml      ← Config Netlify
├── .gitignore        ← Exclut .env du repo
├── .env.example      ← Modèle de .env (safe à pusher)
└── README.md
```

---

## Déploiement — étape par étape

### 1. Configurer les variables localement

Copie `.env.example` en `.env` et remplis tes vraies valeurs :

```bash
cp .env.example .env
```

Édite `.env` :
```
SUPABASE_URL=https://xxxxxxxxxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGci...ta vraie clé...
```

⚠️ `.env` est dans `.gitignore` — il ne sera jamais pushé sur Git.

---

### 2. Créer le repo GitHub

```bash
git init
git add .
git commit -m "Initial commit — Moodborde Dashboard"
git remote add origin https://github.com/TON_USERNAME/moodborde-dashboard.git
git push -u origin main
```

Vérifie que `.env` n'apparaît **pas** dans les fichiers committés.

---

### 3. Connecter Netlify à GitHub

1. Va sur [netlify.com](https://netlify.com) → **Add new site** → **Import from Git**
2. Choisis **GitHub** et sélectionne le repo `moodborde-dashboard`
3. Build settings — Netlify les détecte automatiquement via `netlify.toml` :
   - Build command : `bash build.sh`
   - Publish directory : `.`
4. Clique **Deploy site**

---

### 4. Déclarer les variables d'environnement dans Netlify

C'est ici que tu renseignes tes clés Supabase, côté Netlify (jamais dans le code) :

1. Dans ton site Netlify → **Site settings** → **Environment variables**
2. Clique **Add variable** et ajoute :
   - `SUPABASE_URL` → `https://xxxxxxxxxxxx.supabase.co`
   - `SUPABASE_ANON_KEY` → `eyJhbGci...`
3. **Redéploie** le site (Deploys → Trigger deploy) pour que le build.sh utilise les nouvelles valeurs

---

### 5. Activer Netlify Identity

1. **Site settings** → **Identity** → **Enable Identity**
2. Sous **Registration** → sélectionne **Invite only**
3. Va dans **Identity** → **Invite users** → entre ton email
4. Reçois l'email et crée ton mot de passe

---

### 6. Configurer Supabase

#### Créer le projet
1. Va sur [supabase.com](https://supabase.com) → **New project**
2. Note ta **Project URL** et ta **anon/public key** (Settings → API)

#### Créer la table `posts`
Dans l'éditeur SQL de Supabase :

```sql
create table posts (
  id text primary key,
  title text,
  notes text,
  date text,
  pillar text,
  format text,
  target text,
  status text,
  created_at bigint
);

-- Active le Row Level Security
alter table posts enable row level security;

-- Policy d'accès
create policy "Allow all for anon" on posts
  for all using (true) with check (true);
```

---

## Comment ça marche (sécurité)

```
Git (public)          Netlify build         Navigateur
─────────────         ─────────────         ──────────
dashboard.html   →    build.sh injecte   →  dashboard.html
(placeholders)        $SUPABASE_URL          (valeurs réelles)
                      $SUPABASE_ANON_KEY     en mémoire
```

- ✅ Les clés ne sont **jamais** dans Git
- ✅ Netlify les injecte uniquement au moment du build
- ✅ Netlify Identity : accès **invite only**
- ✅ Supabase RLS : données protégées côté base
- ✅ Clé `anon` uniquement (jamais la `service_role`)

---

## Workflow au quotidien

```bash
# Modifier le dashboard puis :
git add .
git commit -m "Update dashboard"
git push
# Netlify redéploie automatiquement en ~30 secondes
```

## Modifier les couleurs

Toutes les couleurs sont dans le bloc `:root` en haut du CSS dans chaque fichier HTML.
