# 🔍 Supabase Missing Items Report

**Generated:** $(date)
**Status:** Analysis Complete ✅

---

## Executive Summary

I've analyzed all your Supabase SQL files and compared them against what a complete setup should have. Here's what you need to verify and potentially add to your connected Supabase instance.

## ✅ Files Analyzed

- ✓ supabase/schema.sql
- ✓ supabase/cart-items-table.sql
- ✓ supabase/driver-locations.sql
- ✓ supabase/privacy-settings.sql
- ✓ supabase/transactions.sql
- ✓ supabase/reviews-enhancements.sql
- ✓ supabase/rls-policies.sql
- ✓ supabase/realtime.sql
- ✓ supabase/storage-setup.sql
- ✓ 7 Edge Functions in supabase/functions/

---

## 🎯 Critical Missing Items to Add

### 1. ⚠️ Missing Database Function
**nearby_merchants() - PostGIS geospatial query function**

**Why it's critical:** The merchants-nearby edge function calls this but it's not defined in any SQL file.

**Solution:** I created `supabase/nearby-merchants-function.sql` - apply this file.

**File:** supabase/nearby-merchants-function.sql

---

## 📋 Complete Setup Checklist

### Database Tables (21 Required)

| Table | Source File | Purpose |
|-------|------------|---------|
| users | schema.sql | User accounts (Firebase sync) |
| merchants | schema.sql | Merchant profiles |
| products | schema.sql | Product catalog |
| orders | schema.sql | Customer orders |
| order_items | schema.sql | Order line items |
| notifications | schema.sql | Push notifications |
| conversations | schema.sql | Chat conversations |
| messages | schema.sql | Chat messages |
| payment_methods | schema.sql | Saved payment methods |
| addresses | schema.sql | Delivery addresses |
| kyc_documents | schema.sql | KYC verification |
| reviews | schema.sql | Product reviews |
| cart_items | cart-items-table.sql | Shopping cart |
| driver_locations | driver-locations.sql | Real-time driver tracking |
| user_privacy_settings | privacy-settings.sql | Privacy preferences |
| data_deletion_requests | privacy-settings.sql | GDPR deletion |
| data_export_requests | privacy-settings.sql | GDPR export |
| transactions | transactions.sql | Financial transactions |
| wallet_balances | transactions.sql | User wallets |
| withdrawal_requests | transactions.sql | Payout requests |
| review_votes | reviews-enhancements.sql | Review voting |
| review_responses | reviews-enhancements.sql | Merchant responses |

### Indexes (35+ Required)

**Performance-critical indexes defined in:**
- schema.sql (11 indexes)
- cart-items-table.sql (2 indexes)
- driver-locations.sql (2 indexes)
- privacy-settings.sql (5 indexes)
- transactions.sql (9 indexes)
- reviews-enhancements.sql (4 indexes)

### RLS Policies (50+ Required)

**Security policies defined in:**
- rls-policies.sql (core policies)
- cart-items-table.sql (cart-specific)
- driver-locations.sql (location-specific)
- privacy-settings.sql (privacy-specific)
- transactions.sql (financial-specific)
- reviews-enhancements.sql (review-specific)

### Functions (5 Required)

| Function | Purpose | Defined In |
|----------|---------|------------|
| update_updated_at_column() | Auto-update timestamps | schema.sql |
| update_driver_location_timestamp() | Driver location updates | driver-locations.sql |
| update_privacy_settings_updated_at() | Privacy settings updates | privacy-settings.sql |
| update_review_helpful_count() | Review vote counting | reviews-enhancements.sql |
| **nearby_merchants()** | **Find nearby merchants** | **nearby-merchants-function.sql** ⚠️ |

### Triggers (11 Required)

All triggers are defined in their respective table files to auto-update timestamps.

### Storage Buckets (4 Required)

| Bucket | Public | Size Limit | Purpose |
|--------|--------|------------|---------|
| product-images | ✅ Yes | 5MB | Product photos |
| profile-images | ✅ Yes | 2MB | User avatars |
| attachments | ✅ Yes | 10MB | Chat attachments |
| kyc-documents | ❌ No | 10MB | KYC verification (private) |

**Defined in:** storage-setup.sql

### Realtime Tables (16 Required)

Tables enabled for real-time subscriptions in realtime.sql:
- users, orders, order_items, notifications
- messages, conversations, products, cart_items
- driver_locations, merchants
- user_privacy_settings, data_deletion_requests, data_export_requests
- transactions, wallet_balances, withdrawal_requests

### Edge Functions (7 Required)

All functions exist in supabase/functions/:
- ✅ cart-add
- ✅ cart-delete
- ✅ cart-get
- ✅ cart-update
- ✅ create-order
- ✅ merchants-nearby (requires nearby_merchants() function ⚠️)
- ✅ payment-process

---

## 🚀 Deployment Steps

### Step 1: Apply All SQL (Choose One Method)

**Method A: All-in-One (Recommended)**
```
1. Open Supabase Dashboard → SQL Editor
2. Open: supabase/COMPLETE_SETUP.sql (1180 lines)
3. Copy entire file contents
4. Paste into SQL Editor
5. Click "Run"
```

**Method B: Individual Files**
Apply in this exact order:
1. schema.sql
2. cart-items-table.sql
3. driver-locations.sql
4. privacy-settings.sql
5. transactions.sql
6. reviews-enhancements.sql
7. nearby-merchants-function.sql ⚠️ **Important!**
8. rls-policies.sql
9. realtime.sql
10. storage-setup.sql

### Step 2: Verify Database Setup

Run this in Supabase SQL Editor:
```sql
SELECT 'Tables' as type, count(*) as count 
FROM information_schema.tables 
WHERE table_schema = 'public'
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
```

**Expected results:**
- Tables: 21+
- Indexes: 35+
- RLS Policies: 50+
- Functions: 5+
- Triggers: 11+
- Storage Buckets: 4
- Realtime Tables: 16+

### Step 3: Deploy Edge Functions

```bash
# Install Supabase CLI
npm install -g supabase

# Login
supabase login

# Link your project
supabase link --project-ref YOUR_PROJECT_REF

# Deploy all functions at once
cd supabase/functions
for dir in */; do 
  echo "Deploying ${dir%/}..."
  supabase functions deploy ${dir%/}
done
```

Or deploy individually:
```bash
supabase functions deploy cart-add
supabase functions deploy cart-delete
supabase functions deploy cart-get
supabase functions deploy cart-update
supabase functions deploy create-order
supabase functions deploy merchants-nearby
supabase functions deploy payment-process
```

---

## 🔍 What to Check in Your Connected Instance

### Using Supabase Dashboard

1. **Database → Tables**
   - Count should be 21+
   - Check: users, merchants, products, orders, cart_items, etc.

2. **Database → Indexes**
   - Count should be 35+
   - Check critical ones: idx_users_firebase_uid, idx_merchants_location

3. **Database → Policies**
   - RLS should be enabled on all 21 tables
   - Count should be 50+

4. **Database → Extensions**
   - ✅ uuid-ossp (for UUID generation)
   - ✅ postgis (for geolocation)

5. **Database → Functions**
   - Look for: update_updated_at_column, nearby_merchants, etc.

6. **Storage**
   - 4 buckets: product-images, profile-images, attachments, kyc-documents
   - Each should have appropriate RLS policies

7. **Database → Replication**
   - Check supabase_realtime publication
   - Should include 16 tables

8. **Edge Functions (in Supabase Dashboard)**
   - Should show 7 deployed functions
   - Each should have "Deployed" status

---

## ⚡ Quick Tests

After deployment, test these queries in SQL Editor:

```sql
-- Test 1: Check tables exist
SELECT tablename FROM pg_tables WHERE schemaname = 'public' ORDER BY tablename;

-- Test 2: Check extensions
SELECT * FROM pg_extension WHERE extname IN ('uuid-ossp', 'postgis');

-- Test 3: Test nearby merchants function
SELECT * FROM nearby_merchants(37.7749, -122.4194, 10);

-- Test 4: Check realtime tables
SELECT tablename FROM pg_publication_tables 
WHERE pubname = 'supabase_realtime' 
ORDER BY tablename;

-- Test 5: Check RLS is enabled
SELECT tablename, rowsecurity 
FROM pg_tables t
JOIN pg_class c ON t.tablename = c.relname
WHERE schemaname = 'public'
ORDER BY tablename;
```

---

## 📦 Files Created for You

I've created these helper files in your repository:

1. **SUPABASE_VERIFICATION_CHECKLIST.md** - Complete checklist with detailed descriptions
2. **SUPABASE_SETUP_SUMMARY.md** - Quick reference guide
3. **SUPABASE_MISSING_ITEMS_REPORT.md** - This file
4. **supabase/COMPLETE_SETUP.sql** - All SQL in one file (1180 lines)
5. **supabase/nearby-merchants-function.sql** - Missing function definition
6. **check-supabase-setup.sql** - Verification queries
7. **deploy-supabase.sh** - Interactive deployment script

---

## 🎯 Priority Actions

### High Priority ⚠️

1. **Apply nearby-merchants-function.sql**
   - Required by merchants-nearby edge function
   - Missing from original schema

2. **Verify all 21 tables exist**
   - Core functionality depends on these

3. **Enable RLS on all tables**
   - Critical for security

### Medium Priority ⚡

4. **Create storage buckets**
   - Needed for file uploads

5. **Enable realtime on 16 tables**
   - Required for live updates

6. **Deploy all 7 edge functions**
   - Needed for business logic

### Low Priority 💡

7. **Verify all indexes exist**
   - Performance optimization

8. **Check all triggers**
   - Automated updates

---

## 🆘 Common Issues

### Issue: "Function nearby_merchants does not exist"
**Solution:** Apply nearby-merchants-function.sql

### Issue: "No rows in table X"
**Solution:** Table exists but is empty - this is normal, data comes from app usage

### Issue: "Permission denied for table X"
**Solution:** Check RLS policies are applied correctly

### Issue: "Extension postgis not found"
**Solution:** Enable in Dashboard → Database → Extensions

### Issue: "Storage bucket not found"
**Solution:** Apply storage-setup.sql

### Issue: "Realtime subscription not working"
**Solution:** Check realtime.sql is applied and table is in publication

---

## ✅ Final Checklist

Before going live, verify:

- [ ] All 21 tables created
- [ ] 35+ indexes created
- [ ] 50+ RLS policies active
- [ ] RLS enabled on all tables
- [ ] 5 custom functions exist
- [ ] 11 triggers active
- [ ] 4 storage buckets created
- [ ] 16 tables in realtime publication
- [ ] 7 edge functions deployed
- [ ] Extensions enabled (uuid-ossp, postgis)
- [ ] nearby_merchants() function exists
- [ ] Storage RLS policies applied
- [ ] Verification queries pass
- [ ] Test queries work

---

## 📞 Need Help?

1. Review detailed documentation: SUPABASE_VERIFICATION_CHECKLIST.md
2. Run verification: check-supabase-setup.sql
3. Use deployment guide: deploy-supabase.sh
4. Check architecture: SUPABASE_ARCHITECTURE.md

---

**Ready to deploy? Start with supabase/COMPLETE_SETUP.sql!**

