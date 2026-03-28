#!/bin/bash
# ============================================================
# Script de build — injecte les variables Supabase dans le HTML
# Les valeurs viennent des variables d'environnement Netlify,
# jamais du code source.
# ============================================================

set -e  # Arrête le script si une commande échoue

echo "🔧 Injection des variables d'environnement..."

# Vérifie que les variables sont bien définies
if [ -z "$SUPABASE_URL" ]; then
  echo "❌ Erreur : SUPABASE_URL n'est pas définie dans les variables d'environnement Netlify."
  exit 1
fi

if [ -z "$SUPABASE_ANON_KEY" ]; then
  echo "❌ Erreur : SUPABASE_ANON_KEY n'est pas définie dans les variables d'environnement Netlify."
  exit 1
fi

# Injecte les valeurs dans dashboard.html
sed -i "s|REMPLACE_PAR_TON_URL|$SUPABASE_URL|g" dashboard.html
sed -i "s|REMPLACE_PAR_TA_ANON_KEY|$SUPABASE_ANON_KEY|g" dashboard.html

echo "✅ Variables injectées avec succès."
