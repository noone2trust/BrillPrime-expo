-- Comprehensive Supabase Setup Check
-- This script checks for all tables, indexes, RLS policies, functions, and realtime configuration

-- Check all tables
SELECT 'TABLES' AS check_type, tablename AS name, 'EXISTS' AS status
FROM pg_tables 
WHERE schemaname = 'public'
ORDER BY tablename;

-- Check all indexes
SELECT 'INDEXES' AS check_type, indexname AS name, tablename AS on_table
FROM pg_indexes 
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

-- Check RLS status on tables
SELECT 'RLS_STATUS' AS check_type, 
       tablename AS name, 
       CASE WHEN rowsecurity THEN 'ENABLED' ELSE 'DISABLED' END AS status
FROM pg_tables t
JOIN pg_class c ON t.tablename = c.relname
WHERE schemaname = 'public'
ORDER BY tablename;

-- Check RLS policies
SELECT 'RLS_POLICIES' AS check_type, 
       tablename AS table_name, 
       policyname AS policy_name,
       cmd AS command_type
FROM pg_policies 
WHERE schemaname = 'public'
ORDER BY tablename, policyname;

-- Check extensions
SELECT 'EXTENSIONS' AS check_type, extname AS name, extversion AS version
FROM pg_extension
WHERE extname IN ('uuid-ossp', 'postgis');

-- Check functions
SELECT 'FUNCTIONS' AS check_type, 
       routine_name AS name,
       routine_type AS type
FROM information_schema.routines
WHERE routine_schema = 'public'
  AND routine_type = 'FUNCTION'
ORDER BY routine_name;

-- Check triggers
SELECT 'TRIGGERS' AS check_type,
       trigger_name AS name,
       event_object_table AS on_table,
       action_timing || ' ' || event_manipulation AS timing
FROM information_schema.triggers
WHERE trigger_schema = 'public'
ORDER BY event_object_table, trigger_name;

-- Check storage buckets
SELECT 'STORAGE_BUCKETS' AS check_type, 
       id AS name, 
       public AS is_public,
       file_size_limit
FROM storage.buckets
ORDER BY id;

-- Check realtime publication tables
SELECT 'REALTIME_TABLES' AS check_type, 
       schemaname || '.' || tablename AS table_name
FROM pg_publication_tables
WHERE pubname = 'supabase_realtime'
ORDER BY tablename;

-- List all columns for critical tables
SELECT 'TABLE_COLUMNS' AS check_type,
       table_name,
       column_name,
       data_type,
       is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name IN ('users', 'merchants', 'products', 'orders', 'cart_items', 
                      'notifications', 'transactions', 'wallet_balances')
ORDER BY table_name, ordinal_position;
