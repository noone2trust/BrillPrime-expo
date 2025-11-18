#!/bin/bash

# Supabase Setup Deployment Script
# This script helps you apply all SQL files to your Supabase instance

echo "🚀 BrillPrime Supabase Setup Script"
echo "===================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if .env file exists
if [ ! -f .env ]; then
    echo -e "${RED}❌ Error: .env file not found${NC}"
    echo "Please create a .env file with your Supabase credentials:"
    echo "  EXPO_PUBLIC_SUPABASE_URL=https://your-project.supabase.co"
    echo "  EXPO_PUBLIC_SUPABASE_ANON_KEY=your_anon_key"
    exit 1
fi

# Load environment variables
export $(grep -v '^#' .env | xargs)

if [ -z "$EXPO_PUBLIC_SUPABASE_URL" ] || [ -z "$EXPO_PUBLIC_SUPABASE_ANON_KEY" ]; then
    echo -e "${RED}❌ Error: Supabase credentials not found in .env${NC}"
    exit 1
fi

echo "✅ Supabase URL: $EXPO_PUBLIC_SUPABASE_URL"
echo ""

# SQL files in order of execution
SQL_FILES=(
    "supabase/schema.sql"
    "supabase/cart-items-table.sql"
    "supabase/driver-locations.sql"
    "supabase/privacy-settings.sql"
    "supabase/transactions.sql"
    "supabase/reviews-enhancements.sql"
    "supabase/nearby-merchants-function.sql"
    "supabase/rls-policies.sql"
    "supabase/realtime.sql"
    "supabase/storage-setup.sql"
)

echo "📋 SQL Files to Apply:"
echo "====================="
for file in "${SQL_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "  ${GREEN}✓${NC} $file"
    else
        echo -e "  ${RED}✗${NC} $file (missing)"
    fi
done
echo ""

# Check if user wants to proceed
read -p "Do you want to proceed with the setup? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Setup cancelled."
    exit 0
fi

echo ""
echo "📝 Instructions for Manual Setup:"
echo "================================="
echo ""
echo "Since we cannot directly execute SQL via REST API, please follow these steps:"
echo ""
echo "1. Open your Supabase Dashboard"
echo "2. Navigate to the SQL Editor"
echo "3. Copy and paste the content of each file below IN ORDER:"
echo ""

for i in "${!SQL_FILES[@]}"; do
    file="${SQL_FILES[$i]}"
    if [ -f "$file" ]; then
        echo -e "${YELLOW}Step $((i+1)):${NC} Apply $file"
        echo "   - Open: $file"
        echo "   - Copy all contents"
        echo "   - Paste into Supabase SQL Editor"
        echo "   - Click 'Run'"
        echo ""
    fi
done

echo ""
echo "🔍 Verification Steps:"
echo "====================="
echo ""
echo "After applying all SQL files, run this verification query in SQL Editor:"
echo ""
echo "--- Copy from here ---"
cat << 'EOF'
-- Quick verification query
SELECT 'Tables' as type, count(*) as count FROM information_schema.tables WHERE table_schema = 'public'
UNION ALL
SELECT 'Indexes', count(*) FROM pg_indexes WHERE schemaname = 'public'
UNION ALL
SELECT 'RLS Policies', count(*) FROM pg_policies WHERE schemaname = 'public'
UNION ALL
SELECT 'Functions', count(*) FROM information_schema.routines WHERE routine_schema = 'public'
UNION ALL
SELECT 'Triggers', count(*) FROM information_schema.triggers WHERE trigger_schema = 'public'
UNION ALL
SELECT 'Storage Buckets', count(*) FROM storage.buckets
UNION ALL
SELECT 'Realtime Tables', count(*) FROM pg_publication_tables WHERE pubname = 'supabase_realtime';
EOF
echo "--- Copy until here ---"
echo ""

echo "Expected results:"
echo "  - Tables: 21+"
echo "  - Indexes: 35+"
echo "  - RLS Policies: 50+"
echo "  - Functions: 5+"
echo "  - Triggers: 11+"
echo "  - Storage Buckets: 4"
echo "  - Realtime Tables: 16+"
echo ""

echo "📦 Edge Functions Deployment:"
echo "============================"
echo ""
echo "After SQL setup, deploy edge functions using Supabase CLI:"
echo ""
echo "1. Install Supabase CLI:"
echo "   npm install -g supabase"
echo ""
echo "2. Login to Supabase:"
echo "   supabase login"
echo ""
echo "3. Link your project:"
echo "   supabase link --project-ref YOUR_PROJECT_REF"
echo ""
echo "4. Deploy all functions:"
echo "   supabase functions deploy cart-add"
echo "   supabase functions deploy cart-delete"
echo "   supabase functions deploy cart-get"
echo "   supabase functions deploy cart-update"
echo "   supabase functions deploy create-order"
echo "   supabase functions deploy merchants-nearby"
echo "   supabase functions deploy payment-process"
echo ""
echo "Or deploy all at once:"
echo "   cd supabase/functions && for dir in */; do supabase functions deploy \${dir%/}; done"
echo ""

echo "📚 Additional Resources:"
echo "======================="
echo ""
echo "- Full checklist: SUPABASE_VERIFICATION_CHECKLIST.md"
echo "- Verification script: check-supabase-setup.sql"
echo "- Architecture docs: SUPABASE_ARCHITECTURE.md"
echo ""

echo -e "${GREEN}✨ Setup guide complete!${NC}"
echo ""
