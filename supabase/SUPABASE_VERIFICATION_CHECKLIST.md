# Supabase Setup Verification Checklist

This document outlines all required Supabase components for the BrillPrime application.

## 📋 Required Tables

Based on the SQL files in `/supabase/`, the following tables should exist:

### Core Tables (schema.sql)
- [x] **users** - User accounts synced from Firebase
- [x] **merchants** - Merchant/vendor profiles
- [x] **products** - Product/commodity listings
- [x] **orders** - Customer orders
- [x] **order_items** - Line items for orders
- [x] **notifications** - User notifications
- [x] **conversations** - Chat conversations
- [x] **messages** - Chat messages
- [x] **payment_methods** - Stored payment methods
- [x] **addresses** - User delivery addresses
- [x] **kyc_documents** - KYC verification documents
- [x] **reviews** - Product/merchant reviews

### Additional Tables
- [x] **cart_items** (cart-items-table.sql) - Shopping cart
- [x] **driver_locations** (driver-locations.sql) - Real-time driver tracking
- [x] **user_privacy_settings** (privacy-settings.sql) - Privacy preferences
- [x] **data_deletion_requests** (privacy-settings.sql) - GDPR deletion requests
- [x] **data_export_requests** (privacy-settings.sql) - GDPR export requests
- [x] **transactions** (transactions.sql) - Financial transactions
- [x] **wallet_balances** (transactions.sql) - User wallet balances
- [x] **withdrawal_requests** (transactions.sql) - Withdrawal requests
- [x] **review_votes** (reviews-enhancements.sql) - Review helpfulness votes
- [x] **review_responses** (reviews-enhancements.sql) - Merchant responses to reviews

**Total: 21 tables**

---

## 🗂️ Required Indexes

### Performance-Critical Indexes

#### Users Table
- `idx_users_firebase_uid` - Firebase UID lookup
- `idx_users_email` - Email lookup

#### Merchants Table
- `idx_merchants_user_id` - User relationship
- `idx_merchants_location` (GIST) - Geospatial queries

#### Products Table
- `idx_products_merchant_id` - Merchant relationship

#### Orders Table
- `idx_orders_user_id` - User orders lookup
- `idx_orders_merchant_id` - Merchant orders lookup
- `idx_orders_status` - Status filtering

#### Notifications Table
- `idx_notifications_user_id` - User notifications
- `idx_notifications_read` - Read/unread filtering

#### Messages Table
- `idx_messages_conversation_id` - Conversation messages

#### Cart Items Table
- `idx_cart_items_user_id` - User cart lookup
- `idx_cart_items_product_id` - Product lookup

#### Driver Locations Table
- `idx_driver_locations_driver_id` - Driver lookup
- `idx_driver_locations_timestamp` - Time-based queries

#### Privacy Tables
- `idx_privacy_settings_user` - User privacy settings
- `idx_deletion_requests_user` - Deletion requests lookup
- `idx_deletion_requests_status` - Status filtering
- `idx_export_requests_user` - Export requests lookup
- `idx_export_requests_status` - Status filtering

#### Transactions Tables
- `idx_transactions_user` - User transactions
- `idx_transactions_order` - Order transactions
- `idx_transactions_status` - Status filtering
- `idx_transactions_type` - Type filtering
- `idx_transactions_created` - Time-based queries
- `idx_wallet_balances_user` - Wallet lookup
- `idx_withdrawal_requests_user` - Withdrawal requests
- `idx_withdrawal_requests_status` - Status filtering

#### Reviews Tables
- `idx_review_votes_review` - Review votes
- `idx_review_votes_user` - User votes
- `idx_review_responses_review` - Review responses
- `idx_review_responses_merchant` - Merchant responses

**Total: ~35+ indexes**

---

## 🔒 Row Level Security (RLS)

### RLS Must Be Enabled On All Tables
All 21 tables should have RLS enabled.

### Key RLS Policies Required

#### Users Table
- Users can view own data
- Users can update own data
- Anyone can insert users (for registration)

#### Merchants Table
- Anyone can view active merchants
- Merchants can update own data
- Users can create merchant profiles

#### Products Table
- Anyone can view available products
- Merchants can manage own products

#### Orders Table
- Users can view own orders
- Users can create orders
- Users and merchants can update orders

#### Order Items Table
- Users can view own order items
- Order items inherit order permissions

#### Notifications Table
- Users can view own notifications
- Users can update own notifications
- System can insert notifications

#### Conversations & Messages
- Users can view own conversations
- Users can view messages in their conversations
- Users can send messages in their conversations

#### Payment Methods & Addresses
- Users can manage own payment methods
- Users can manage own addresses

#### KYC Documents
- Users can manage own KYC documents

#### Reviews
- Anyone can view reviews
- Users can create reviews for own orders

#### Cart Items
- Users can CRUD their own cart items

#### Driver Locations
- Drivers can update/insert their own location
- Everyone can read driver locations

#### Privacy Settings
- Users can manage own privacy settings
- Users can create deletion/export requests

#### Transactions & Wallet
- Users can view own transactions
- System can insert/update transactions
- Users can view own wallet balance
- Users can create withdrawal requests

#### Review Enhancements
- Anyone can view review votes/responses
- Authenticated users can vote on reviews
- Merchants can respond to their reviews

**Total: 50+ RLS policies**

---

## ⚡ Realtime Configuration

### Tables That Should Be in supabase_realtime Publication

The following tables need real-time subscriptions enabled:

1. **users** - User status updates
2. **orders** - Order status changes
3. **order_items** - Order item updates
4. **notifications** - New notifications
5. **messages** - New messages
6. **conversations** - Conversation updates
7. **products** - Product availability
8. **cart_items** - Cart changes
9. **driver_locations** - Real-time driver tracking
10. **merchants** - Merchant status
11. **user_privacy_settings** - Privacy setting changes
12. **data_deletion_requests** - Deletion request updates
13. **data_export_requests** - Export request updates
14. **transactions** - Transaction updates
15. **wallet_balances** - Wallet balance changes
16. **withdrawal_requests** - Withdrawal status updates

**Total: 16 realtime-enabled tables**

---

## 🔧 Database Functions

### Required PostgreSQL Functions

1. **update_updated_at_column()** - Trigger function for auto-updating timestamps
2. **update_driver_location_timestamp()** - Driver location timestamp update
3. **update_privacy_settings_updated_at()** - Privacy settings timestamp
4. **update_review_helpful_count()** - Update review vote counts
5. **nearby_merchants()** - PostGIS function for finding nearby merchants (needs to be created)

---

## 🎯 Database Triggers

### Required Triggers

1. **update_users_updated_at** - ON users BEFORE UPDATE
2. **update_merchants_updated_at** - ON merchants BEFORE UPDATE
3. **update_products_updated_at** - ON products BEFORE UPDATE
4. **update_orders_updated_at** - ON orders BEFORE UPDATE
5. **update_driver_location_timestamp** - ON driver_locations BEFORE UPDATE
6. **privacy_settings_updated_at** - ON user_privacy_settings BEFORE UPDATE
7. **transactions_updated_at** - ON transactions BEFORE UPDATE
8. **wallet_balances_updated_at** - ON wallet_balances BEFORE UPDATE
9. **withdrawal_requests_updated_at** - ON withdrawal_requests BEFORE UPDATE
10. **review_votes_count_trigger** - ON review_votes AFTER INSERT/UPDATE/DELETE
11. **review_responses_updated_at** - ON review_responses BEFORE UPDATE

---

## 📦 Storage Buckets

### Required Storage Buckets

1. **product-images**
   - Public: ✅ Yes
   - Size limit: 5MB
   - MIME types: image/jpeg, image/png, image/jpg, image/webp
   - RLS: Upload (authenticated), View (public), Update/Delete (owner)

2. **profile-images**
   - Public: ✅ Yes
   - Size limit: 2MB
   - MIME types: image/jpeg, image/png, image/jpg, image/webp
   - RLS: Upload (authenticated), View (public), Update/Delete (owner)

3. **attachments**
   - Public: ✅ Yes
   - Size limit: 10MB
   - MIME types: images, PDF, text
   - RLS: Upload (authenticated), View (public), Update/Delete (owner)

4. **kyc-documents**
   - Public: ❌ No (Private)
   - Size limit: 10MB
   - MIME types: images, PDF
   - RLS: Upload (authenticated), View (owner only), Delete (owner)

---

## 🚀 Edge Functions

### Deployed Edge Functions

All edge functions should be deployed with CORS support:

1. **cart-add** - Add item to cart
2. **cart-delete** - Remove item from cart
3. **cart-get** - Get user's cart
4. **cart-update** - Update cart item quantity
5. **create-order** - Create new order
6. **merchants-nearby** - Find nearby merchants using PostGIS
7. **payment-process** - Process payment for order

**Total: 7 edge functions**

---

## 🔌 Required Extensions

1. **uuid-ossp** - UUID generation
2. **postgis** - Geolocation features

---

## ✅ How to Verify

### Option 1: Use the SQL Check Script

Run the generated `check-supabase-setup.sql` file in your Supabase SQL Editor to get a complete report of:
- All existing tables
- All indexes
- RLS status and policies
- Extensions
- Functions
- Triggers
- Storage buckets
- Realtime publication tables
- Column definitions

### Option 2: Manual Verification via Supabase Dashboard

1. **Database → Tables** - Check all 21 tables exist
2. **Database → Indexes** - Verify indexes are created
3. **Database → Policies** - Check RLS is enabled and policies exist
4. **Database → Extensions** - Ensure uuid-ossp and postgis are enabled
5. **Database → Functions** - Verify custom functions exist
6. **Database → Triggers** - Check all triggers are set up
7. **Storage** - Verify 4 buckets exist with correct permissions
8. **Database → Replication** - Check realtime publication includes 16 tables
9. **Edge Functions** - Verify all 7 functions are deployed

### Option 3: Use Supabase CLI

If you have Supabase CLI installed, you can run:

```bash
# Check database migrations status
supabase db diff

# Check deployed functions
supabase functions list

# Check storage buckets
supabase storage ls
```

---

## 🚨 Common Missing Items to Check

1. ❓ **nearby_merchants RPC function** - This is referenced in the merchants-nearby edge function but may not be defined in schema.sql
2. ❓ **Storage bucket RLS policies** - Storage policies may need manual creation
3. ❓ **Realtime grants** - The realtime.sql file includes GRANT statements that need to be executed
4. ❓ **Edge function deployments** - Functions need to be deployed via CLI or dashboard

---

## 📝 Next Steps

1. Run `check-supabase-setup.sql` in Supabase SQL Editor
2. Compare results with this checklist
3. Apply missing SQL files in order:
   - schema.sql (core tables)
   - cart-items-table.sql
   - driver-locations.sql
   - privacy-settings.sql
   - transactions.sql
   - reviews-enhancements.sql
   - rls-policies.sql
   - realtime.sql
   - storage-setup.sql
4. Deploy edge functions using Supabase CLI
5. Verify all components are working

---

## 🔗 Files Reference

All SQL setup files are located in `/supabase/`:
- `schema.sql` - Core database schema
- `cart-items-table.sql` - Shopping cart
- `driver-locations.sql` - Real-time tracking
- `privacy-settings.sql` - Privacy & GDPR
- `transactions.sql` - Payments & wallet
- `reviews-enhancements.sql` - Review system
- `rls-policies.sql` - Security policies
- `realtime.sql` - Realtime configuration
- `storage-setup.sql` - File storage buckets
- `seed-comprehensive-data.sql` - Sample data (optional)

Edge functions are in `/supabase/functions/[function-name]/index.ts`
