#!/bin/bash
# Setup script to connect Firebase and Supabase

set -e

echo "=== Firebase & Supabase Connection Setup ==="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Load environment variables
if [ -f .env ]; then
    source .env
    echo -e "${GREEN}✓${NC} Environment variables loaded"
else
    echo -e "${RED}✗${NC} .env file not found"
    exit 1
fi

# Check Firebase CLI
if ! command -v firebase &> /dev/null; then
    echo -e "${RED}✗${NC} Firebase CLI not installed"
    exit 1
fi
echo -e "${GREEN}✓${NC} Firebase CLI installed ($(firebase --version))"

# Check Supabase CLI
if ! npx supabase --version &> /dev/null; then
    echo -e "${RED}✗${NC} Supabase CLI not installed"
    exit 1
fi
echo -e "${GREEN}✓${NC} Supabase CLI installed ($(npx supabase --version | head -1))"

# Set Firebase credentials
export GOOGLE_APPLICATION_CREDENTIALS="$(pwd)/firebase-service-account.json"

# Check Firebase project
echo ""
echo -e "${BLUE}Firebase Project:${NC}"
firebase projects:list

# Check Supabase connection
echo ""
echo -e "${BLUE}Supabase Configuration:${NC}"
echo "URL: $EXPO_PUBLIC_SUPABASE_URL"
echo "Project Ref: $(echo $EXPO_PUBLIC_SUPABASE_URL | sed 's|https://||' | sed 's|.supabase.co||')"

# Link Supabase project (you'll need to authenticate)
echo ""
echo -e "${BLUE}Linking Supabase project...${NC}"
PROJECT_REF=$(echo $EXPO_PUBLIC_SUPABASE_URL | sed 's|https://||' | sed 's|.supabase.co||')
echo "Project Reference: $PROJECT_REF"

# Create firestore rules if they don't exist
if [ ! -f firestore.rules ]; then
    echo ""
    echo -e "${BLUE}Creating Firestore rules...${NC}"
    cat > firestore.rules << 'RULES'
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow authenticated users to read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Default deny all
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
RULES
    echo -e "${GREEN}✓${NC} Firestore rules created"
fi

# Create firestore indexes if they don't exist
if [ ! -f firestore.indexes.json ]; then
    echo ""
    echo -e "${BLUE}Creating Firestore indexes...${NC}"
    cat > firestore.indexes.json << 'INDEXES'
{
  "indexes": [],
  "fieldOverrides": []
}
INDEXES
    echo -e "${GREEN}✓${NC} Firestore indexes created"
fi

# Create storage rules if they don't exist
if [ ! -f storage.rules ]; then
    echo ""
    echo -e "${BLUE}Creating Storage rules...${NC}"
    cat > storage.rules << 'STORAGE'
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
STORAGE
    echo -e "${GREEN}✓${NC} Storage rules created"
fi

echo ""
echo -e "${GREEN}=== Setup Complete! ===${NC}"
echo ""
echo "Next steps:"
echo "1. Deploy Firebase rules: firebase deploy --only firestore:rules,storage"
echo "2. Link Supabase: npx supabase link --project-ref $PROJECT_REF"
echo "3. Pull Supabase schema: npx supabase db pull"
echo "4. Test connection with: npm run dev"
echo ""
echo "Integration points:"
echo "- Firebase handles: Authentication"
echo "- Supabase handles: Database, Storage, Realtime subscriptions"
echo "- Both CLIs are now configured and ready to use"
