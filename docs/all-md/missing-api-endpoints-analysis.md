# Missing Backend API Endpoints Analysis
**Analysis Date**: October 09, 2025  
**Purpose**: Identify frontend API calls that may be missing from backend

---

## Summary

| Category | Total Endpoints | Tested ✅ | Potentially Missing ⚠️ | Requires Verification 🔍 |
|----------|----------------|-----------|------------------------|-------------------------|
| Authentication | 9 | 4 | 0 | 5 |
| User Management | 4 | 1 | 0 | 3 |
| Merchants & Commodities | 8 | 1 | 1 | 6 |
| Orders | 7 | 1 | 0 | 6 |
| Payments & Transactions | 11 | 0 | 0 | 11 |
| Cart | 5 | 0 | 0 | 5 |
| Notifications | 9 | 1 | 0 | 8 |
| Location Services | 5 | 0 | 0 | 5 |
| KYC/Verification | 11 | 0 | 0 | 11 |
| Communication | 11 | 0 | 0 | 11 |
| Admin Services | 15 | 0 | 0 | 15 |
| Favorites | 3 | 0 | 0 | 3 |
| **TOTAL** | **98** | **8** | **1** | **89** |

---

## 1. Authentication Service (9 endpoints)

### ✅ Tested & Working (4)
| Endpoint | Method | Status |
|----------|--------|--------|
| `/api/auth/register` | POST | ✅ Working |
| `/api/auth/login` | POST | ✅ Working |
| `/api/password-reset/request` | POST | ✅ Working |
| `/api/auth/profile` | GET | ✅ Requires auth (expected) |

### 🔍 Needs Verification (5)
| Endpoint | Method | Purpose | Priority |
|----------|--------|---------|----------|
| `/api/auth/social-login` | POST | Google/Apple/Facebook login | HIGH |
| `/api/auth/verify-otp` | POST | Email/phone OTP verification | HIGH |
| `/api/auth/resend-otp` | POST | Resend OTP code | MEDIUM |
| `/api/password-reset/verify-code` | POST | Verify password reset code | HIGH |
| `/api/password-reset/complete` | POST | Complete password reset | HIGH |
| `/api/jwt-tokens/logout` | POST | User logout | MEDIUM |

---

## 2. User Management (4 endpoints)

### ✅ Tested & Working (1)
| Endpoint | Method | Status |
|----------|--------|--------|
| `/api/auth/profile` | GET | ✅ Working |

### 🔍 Needs Verification (3)
| Endpoint | Method | Purpose | Priority |
|----------|--------|---------|----------|
| `/api/auth/profile` | PUT | Update user profile | HIGH |
| `/api/user/settings` | GET/PUT | Get/Update user settings | MEDIUM |
| `/api/user/password` | PUT | Change password | HIGH |
| `/api/user/account` | DELETE | Delete user account | LOW |

---

## 3. Merchants & Commodities (8 endpoints)

### ✅ Tested & Working (1)
| Endpoint | Method | Status |
|----------|--------|--------|
| `/api/merchants` | GET | ✅ Working (requires auth) |

### ⚠️ Potentially Missing (1)
| Endpoint | Method | Issue | Priority |
|----------|--------|-------|----------|
| `/api/commodities` | GET | Returned 404 during testing | HIGH |

### 🔍 Needs Verification (6)
| Endpoint | Method | Purpose | Priority |
|----------|--------|---------|----------|
| `/api/merchants/{id}` | GET | Get specific merchant | HIGH |
| `/api/merchants` | POST | Create merchant | MEDIUM |
| `/api/merchants/{id}` | PUT | Update merchant | MEDIUM |
| `/api/merchants/{id}` | DELETE | Delete merchant | LOW |
| `/api/merchants/{merchantId}/commodities` | GET | Get merchant's commodities | HIGH |
| `/api/merchants/{merchantId}/commodities` | POST | Add commodity to merchant | MEDIUM |
| `/api/merchants/{merchantId}/commodities/{commodityId}` | PUT | Update commodity | MEDIUM |
| `/api/merchants/{merchantId}/commodities/{commodityId}` | DELETE | Delete commodity | LOW |

---

## 4. Orders Service (7 endpoints)

### ✅ Tested & Working (1)
| Endpoint | Method | Status |
|----------|--------|--------|
| `/api/orders` | GET | ✅ Working (requires auth) |

### 🔍 Needs Verification (6)
| Endpoint | Method | Purpose | Priority |
|----------|--------|---------|----------|
| `/api/orders` | POST | Create new order | **CRITICAL** |
| `/api/orders/{orderId}` | GET | Get order details | HIGH |
| `/api/orders/{orderId}` | PUT | Update order status | HIGH |
| `/api/orders/{orderId}/cancel` | PUT | Cancel order | HIGH |
| `/api/orders/{orderId}/tracking` | GET | Track order & driver location | HIGH |
| `/api/orders/summary` | GET | Get order statistics | MEDIUM |
