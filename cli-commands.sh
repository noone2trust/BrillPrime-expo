#!/bin/bash
# Quick reference for Firebase & Supabase CLI commands

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Firebase & Supabase CLI Quick Reference              ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${GREEN}FIREBASE COMMANDS${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "export GOOGLE_APPLICATION_CREDENTIALS=\"\$(pwd)/firebase-service-account.json\""
echo ""
echo "firebase projects:list                    # List all projects"
echo "firebase use brillprimefirebase           # Switch to project"
echo "firebase deploy                           # Deploy everything"
echo "firebase deploy --only firestore:rules    # Deploy Firestore rules"
echo "firebase deploy --only storage            # Deploy Storage rules"
echo "firebase emulators:start                  # Start all emulators"
echo "firebase emulators:start --only auth      # Start auth emulator only"
echo ""

echo -e "${GREEN}SUPABASE COMMANDS${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "npx supabase link --project-ref lkfprjjlqmtpamukoatl  # Link to remote"
echo "npx supabase status                                    # Check local status"
echo "npx supabase start                                     # Start local services"
echo "npx supabase stop                                      # Stop local services"
echo "npx supabase db pull                                   # Pull remote schema"
echo "npx supabase db push                                   # Push local migrations"
echo "npx supabase db reset                                  # Reset local database"
echo "npx supabase migration new <name>                      # Create new migration"
echo "npx supabase gen types typescript --local > types/supabase.ts  # Generate types"
echo ""

echo -e "${GREEN}COMBINED WORKFLOWS${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "# Full local development"
echo "npx supabase start && firebase emulators:start && npm run dev"
echo ""
echo "# Deploy to production"
echo "export GOOGLE_APPLICATION_CREDENTIALS=\"\$(pwd)/firebase-service-account.json\""
echo "firebase deploy --only firestore:rules,storage && npx supabase db push"
echo ""
echo "# Generate types and sync schema"
echo "npx supabase db pull && npx supabase gen types typescript --local > types/supabase.ts"
echo ""

echo -e "${GREEN}PROJECT INFO${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Firebase Project:  brillprimefirebase"
echo "Supabase Ref:      lkfprjjlqmtpamukoatl"
echo "Supabase URL:      https://lkfprjjlqmtpamukoatl.supabase.co"
echo ""

echo -e "${YELLOW}TIP: Run './setup-firebase-supabase-connection.sh' for full setup${NC}"
echo ""
