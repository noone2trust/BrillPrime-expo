# Firebase & Supabase CLI Connection - Setup Complete ✅

## What Was Done

Successfully connected your BrillPrime Expo project to both Firebase and Supabase through their respective CLIs.

## Files Created

1. **`.firebaserc`** - Firebase project configuration pointing to `brillprimefirebase`
2. **`firebase.json`** - Firebase services configuration (Firestore, Functions, Hosting, Storage, Emulators)
3. **`firebase-service-account.json`** - Service account credentials for CLI authentication (gitignored)
4. **`firestore.rules`** - Firestore security rules
5. **`firestore.indexes.json`** - Firestore database indexes
6. **`storage.rules`** - Firebase Storage security rules
7. **`setup-firebase-supabase-connection.sh`** - Automated setup script
8. **`cli-commands.sh`** - Quick reference for CLI commands
9. **`firebase-supabase-integration.md`** - Complete integration documentation
10. **Updated `.gitignore`** - Added Firebase and Supabase sensitive files

## Current Status

### ✅ Firebase CLI
- **Status**: Connected and authenticated
- **Project**: brillprimefirebase (655201684400)
- **Authentication**: Using service account (`firebase-service-account.json`)
- **Services Configured**: Firestore, Functions, Hosting, Storage, Emulators

### ✅ Supabase CLI  
- **Status**: Configured
- **Project Reference**: lkfprjjlqmtpamukoatl
- **URL**: https://lkfprjjlqmtpamukoatl.supabase.co
- **Configuration**: `supabase/config.toml`
- **Next Step**: Link to remote with `npx supabase link --project-ref lkfprjjlqmtpamukoatl`

## Quick Start Commands

### View Command Reference
```bash
./cli-commands.sh
```

### Run Full Setup
```bash
./setup-firebase-supabase-connection.sh
```

### Deploy Firebase Rules
```bash
export GOOGLE_APPLICATION_CREDENTIALS="$(pwd)/firebase-service-account.json"
firebase deploy --only firestore:rules,storage
```

### Link Supabase (One-Time)
```bash
npx supabase link --project-ref lkfprjjlqmtpamukoatl
```
You'll be prompted for your Supabase access token. Get it from: https://app.supabase.com/account/tokens

### Start Local Development
```bash
# Start Supabase local (includes database, API, auth, storage)
npx supabase start

# Start Firebase emulators (optional for local auth testing)
firebase emulators:start

# Start your app
npm run dev
```

### Pull Remote Database Schema
```bash
npx supabase db pull
```

### Generate TypeScript Types
```bash
npx supabase gen types typescript --local > types/supabase.ts
```

## Architecture Overview

```
┌─────────────────┐
│   Your App      │
└────────┬────────┘
         │
    ┌────┴─────┐
    │          │
    ▼          ▼
┌────────┐  ┌──────────┐
│Firebase│  │ Supabase │
│  Auth  │  │ Database │
└────────┘  │ Storage  │
            │ Realtime │
            └──────────┘
```

### Responsibilities

**Firebase Handles:**
- User Authentication (Phone, Email/Password)
- Firebase Admin SDK operations
- User session management

**Supabase Handles:**
- PostgreSQL Database (users, orders, products, etc.)
- File Storage
- Real-time subscriptions
- Row Level Security (RLS)

### Integration Points

1. User signs in via Firebase Auth
2. Firebase UID is stored in Supabase user table
3. Supabase RLS policies verify Firebase UID
4. App uses Supabase for all data operations
5. Real-time updates via Supabase subscriptions

## Environment Variables

All required environment variables are already configured in your `.env` file:

### Firebase
- ✅ EXPO_PUBLIC_FIREBASE_API_KEY
- ✅ EXPO_PUBLIC_FIREBASE_AUTH_DOMAIN
- ✅ EXPO_PUBLIC_FIREBASE_PROJECT_ID
- ✅ EXPO_PUBLIC_FIREBASE_STORAGE_BUCKET
- ✅ EXPO_PUBLIC_FIREBASE_MESSAGING_SENDER_ID
- ✅ EXPO_PUBLIC_FIREBASE_APP_ID
- ✅ EXPO_PUBLIC_FIREBASE_MEASUREMENT_ID
- ✅ EXPO_PUBLIC_FIREBASE_DATABASE_URL

### Supabase
- ✅ EXPO_PUBLIC_SUPABASE_URL
- ✅ EXPO_PUBLIC_SUPABASE_ANON_KEY
- ✅ EXPO_PUBLIC_SUPABASE_SERVICE_ROLE_KEY

## Next Steps

### 1. Link Supabase to Remote Project
```bash
npx supabase link --project-ref lkfprjjlqmtpamukoatl
```
This requires a Supabase access token from https://app.supabase.com/account/tokens

### 2. Pull Existing Database Schema
```bash
npx supabase db pull
```

### 3. Deploy Firebase Security Rules
```bash
export GOOGLE_APPLICATION_CREDENTIALS="$(pwd)/firebase-service-account.json"
firebase deploy --only firestore:rules,storage
```

### 4. Test the Integration
```bash
npm run dev
```

### 5. Generate TypeScript Types (Recommended)
```bash
npx supabase gen types typescript --local > types/supabase.ts
```

## Documentation

- **Complete Integration Guide**: `firebase-supabase-integration.md`
- **CLI Commands Reference**: Run `./cli-commands.sh`
- **Setup Script**: `./setup-firebase-supabase-connection.sh`

## Useful Resources

- [Firebase CLI Reference](https://firebase.google.com/docs/cli)
- [Supabase CLI Reference](https://supabase.com/docs/guides/cli)
- [Firebase Auth Docs](https://firebase.google.com/docs/auth)
- [Supabase Docs](https://supabase.com/docs)

## Troubleshooting

### Firebase Commands Not Working
Make sure to export credentials first:
```bash
export GOOGLE_APPLICATION_CREDENTIALS="$(pwd)/firebase-service-account.json"
```

### Supabase Link Failing
1. Get access token from https://app.supabase.com/account/tokens
2. Make sure you're using the correct project reference: `lkfprjjlqmtpamukoatl`

### Local Services Not Starting
```bash
# Supabase
npx supabase stop
npx supabase start

# Firebase
firebase emulators:kill
firebase emulators:start
```

### Need to Reset Everything
```bash
npx supabase db reset  # Resets local database
firebase emulators:kill  # Stops Firebase emulators
```

## Security Notes

🔒 **Important**: The following files contain sensitive credentials and are gitignored:
- `firebase-service-account.json` - Firebase admin credentials
- `.env` - All API keys and secrets
- `.firebase/` - Firebase CLI cache
- `supabase/.temp/` - Supabase temporary files

Never commit these files to version control!

## Support

For issues or questions:
1. Check `firebase-supabase-integration.md` for detailed documentation
2. Run `./cli-commands.sh` for command reference
3. Run `./setup-firebase-supabase-connection.sh` to verify setup

---

**Setup Date**: November 18, 2025  
**Firebase Project**: brillprimefirebase  
**Supabase Project**: lkfprjjlqmtpamukoatl  
**Status**: ✅ Connected and Ready
