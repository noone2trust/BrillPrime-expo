# Firebase & Supabase Integration Guide

## Overview
This project uses both Firebase and Supabase through their respective CLIs, with each service handling specific responsibilities:

- **Firebase**: Authentication (Phone Auth, Email/Password)
- **Supabase**: PostgreSQL Database, Storage, Realtime subscriptions

## CLI Setup Complete ✓

### Firebase CLI
- **Version**: 14.25.0
- **Project**: brillprimefirebase
- **Configuration**: `.firebaserc`, `firebase.json`
- **Service Account**: `firebase-service-account.json`

### Supabase CLI
- **Version**: 2.54.11
- **Project Reference**: lkfprjjlqmtpamukoatl
- **URL**: https://lkfprjjlqmtpamukoatl.supabase.co
- **Configuration**: `supabase/config.toml`

## Available Commands

### Firebase Commands

```bash
# Set credentials (run before firebase commands)
export GOOGLE_APPLICATION_CREDENTIALS="$(pwd)/firebase-service-account.json"

# List projects
firebase projects:list

# Deploy Firestore rules
firebase deploy --only firestore:rules

# Deploy Storage rules
firebase deploy --only firestore:storage

# Deploy all
firebase deploy

# Start Firebase emulators
firebase emulators:start

# Specific emulator
firebase emulators:start --only auth,firestore
```

### Supabase Commands

```bash
# Link to remote project (one-time setup)
npx supabase link --project-ref lkfprjjlqmtpamukoatl

# Pull remote database schema
npx supabase db pull

# Push local migrations to remote
npx supabase db push

# Start local Supabase (includes all services)
npx supabase start

# Stop local Supabase
npx supabase stop

# Generate TypeScript types from database
npx supabase gen types typescript --local > types/supabase.ts

# Create a new migration
npx supabase migration new migration_name

# Check database differences
npx supabase db diff

# Reset local database
npx supabase db reset
```

### Combined Workflow Commands

```bash
# Full setup script
./setup-firebase-supabase-connection.sh

# Start all local development services
npm run dev & firebase emulators:start & npx supabase start

# Deploy everything
firebase deploy && npx supabase db push
```

## Architecture Integration

### Authentication Flow
1. User signs in via Firebase Auth (phone or email)
2. Firebase returns user UID
3. App creates/updates user record in Supabase with Firebase UID
4. Supabase RLS policies check Firebase UID for authorization

### Data Flow
```
User → Firebase Auth → App → Supabase Database
                    ↓
              Supabase Storage
                    ↓
           Supabase Realtime
```

### Code Integration

#### Firebase Auth Setup
```typescript
// config/firebase.ts
import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';

const firebaseConfig = {
  apiKey: process.env.EXPO_PUBLIC_FIREBASE_API_KEY,
  authDomain: process.env.EXPO_PUBLIC_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.EXPO_PUBLIC_FIREBASE_PROJECT_ID,
  // ... other config
};

const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
```

#### Supabase Client Setup
```typescript
// config/supabase.ts
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY!;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
```

#### Combined Auth Hook
```typescript
// hooks/useAuth.ts
import { auth } from '@/config/firebase';
import { supabase } from '@/config/supabase';
import { useEffect, useState } from 'react';

export function useAuth() {
  const [user, setUser] = useState(null);

  useEffect(() => {
    // Listen to Firebase auth changes
    const unsubscribe = auth.onAuthStateChanged(async (firebaseUser) => {
      if (firebaseUser) {
        // Sync with Supabase
        const { data } = await supabase
          .from('users')
          .select('*')
          .eq('firebase_uid', firebaseUser.uid)
          .single();
        
        setUser({ firebase: firebaseUser, supabase: data });
      } else {
        setUser(null);
      }
    });

    return () => unsubscribe();
  }, []);

  return user;
}
```

## Environment Variables Required

All these are already set in your `.env` file:

```bash
# Firebase
EXPO_PUBLIC_FIREBASE_API_KEY
EXPO_PUBLIC_FIREBASE_AUTH_DOMAIN
EXPO_PUBLIC_FIREBASE_PROJECT_ID
EXPO_PUBLIC_FIREBASE_STORAGE_BUCKET
EXPO_PUBLIC_FIREBASE_MESSAGING_SENDER_ID
EXPO_PUBLIC_FIREBASE_APP_ID
EXPO_PUBLIC_FIREBASE_MEASUREMENT_ID
EXPO_PUBLIC_FIREBASE_DATABASE_URL

# Supabase
EXPO_PUBLIC_SUPABASE_URL
EXPO_PUBLIC_SUPABASE_ANON_KEY
EXPO_PUBLIC_SUPABASE_SERVICE_ROLE_KEY
```

## Local Development with Emulators

### Firebase Emulators
Configure in `firebase.json`:
- Auth: http://localhost:9099
- Firestore: http://localhost:8080
- Functions: http://localhost:5001
- Storage: http://localhost:9199
- Emulator UI: http://localhost:4000

### Supabase Local
Configure in `supabase/config.toml`:
- API: http://localhost:54321
- Database: postgresql://postgres:postgres@localhost:54322/postgres
- Studio: http://localhost:54323

### Using Emulators in Code
```typescript
// Enable Firebase emulators in development
if (__DEV__) {
  import { connectAuthEmulator } from 'firebase/auth';
  import { connectFirestoreEmulator } from 'firebase/firestore';
  
  connectAuthEmulator(auth, 'http://localhost:9099');
  connectFirestoreEmulator(firestore, 'localhost', 8080);
}
```

## Security Rules

### Firebase Firestore Rules (`firestore.rules`)
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### Firebase Storage Rules (`storage.rules`)
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### Supabase RLS Policies
See `supabase/rls-policies.sql` for Row Level Security policies that use Firebase UIDs.

## Deployment Workflow

### Development
1. Run `npx supabase start` for local database
2. Run `firebase emulators:start` for local auth
3. Run `npm run dev` for the app

### Production Deploy
```bash
# 1. Deploy Firebase rules
export GOOGLE_APPLICATION_CREDENTIALS="$(pwd)/firebase-service-account.json"
firebase deploy --only firestore:rules,storage

# 2. Push Supabase migrations
npx supabase db push

# 3. Deploy app
npm run build
```

## Troubleshooting

### Firebase Authentication Issues
```bash
# Check auth state
firebase auth:export users.json

# Test with emulator
firebase emulators:start --only auth --inspect-functions
```

### Supabase Connection Issues
```bash
# Check connection
npx supabase status

# View logs
npx supabase logs

# Reset if needed
npx supabase db reset
```

### CLI Login Issues
```bash
# Firebase (already configured with service account)
export GOOGLE_APPLICATION_CREDENTIALS="$(pwd)/firebase-service-account.json"

# Supabase (link to project)
npx supabase link --project-ref lkfprjjlqmtpamukoatl
```

## Next Steps

1. **Link Supabase to remote project**:
   ```bash
   npx supabase link --project-ref lkfprjjlqmtpamukoatl
   ```
   This will prompt for your Supabase access token (get from https://app.supabase.com/account/tokens)

2. **Pull existing schema**:
   ```bash
   npx supabase db pull
   ```

3. **Deploy Firebase rules**:
   ```bash
   export GOOGLE_APPLICATION_CREDENTIALS="$(pwd)/firebase-service-account.json"
   firebase deploy --only firestore:rules,storage
   ```

4. **Test the integration**:
   ```bash
   npm run dev
   ```

## Resources

- [Firebase CLI Documentation](https://firebase.google.com/docs/cli)
- [Supabase CLI Documentation](https://supabase.com/docs/guides/cli)
- [Firebase Auth Guide](https://firebase.google.com/docs/auth)
- [Supabase Database Guide](https://supabase.com/docs/guides/database)
