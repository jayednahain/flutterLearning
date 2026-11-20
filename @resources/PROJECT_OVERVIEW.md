# TWG Client: What's Happening Inside (Plain English Guide)

This guide explains the `twg_client` Flutter app from the outside in. First, why it exists and who uses it. Then, what it can do. Last, how everything flows inside the code.

- Every file link opens the exact line in VSCode.
- Facts come from reading the code on 2026-11-20 (and the backend in `../twg-platform` where noted).
- Bangla versions with more detail: [PROJECT_GUIDE_BN.md](PROJECT_GUIDE_BN.md) (code guide), [SETUP_GUIDE_BN.md](SETUP_GUIDE_BN.md) (machine setup).

## Contents

**Part A: The product**
1. [Purpose: what is this app?](#1-purpose-what-is-this-app)
2. [Customers: who is it for?](#2-customers-who-is-it-for)
3. [Features: what can users do?](#3-features-what-can-users-do)

**Part B: How it's built**

4. [The big picture](#4-the-big-picture)
5. [Packages and why they're used](#5-packages-and-why-theyre-used)
6. [APIs: how many, and why](#6-apis-how-many-and-why)

**Part C: The flows**

7. [App start](#7-app-start)
8. [Registration (sign up)](#8-registration-sign-up)
9. [Authentication (log in, log out)](#9-authentication-log-in-log-out)
10. [State management (complete)](#10-state-management-complete)
11. [Data flow](#11-data-flow)
12. [Booking and payment flow](#12-booking-and-payment-flow)
13. [Other flows: events, shop, push, support](#13-other-flows-events-shop-push-support)
14. [Complex UI logic](#14-complex-ui-logic)
15. [Banners, sliders and images](#15-banners-sliders-and-images)
16. [Error handling](#16-error-handling)
17. [Problems to know about](#17-problems-to-know-about)
18. [Where to start reading the code](#18-where-to-start-reading-the-code)

---

# Part A: The product

## 1. Purpose: what is this app?

**In one sentence:** it's a membership app that turns a group of fashion and lifestyle brands into one private club. Members book spaces, go to events, shop, and get perks, all in one place.

The company is **TWG (The Whitaker Group)**. It owns several brands, each with physical spaces in different US cities:

| Brand | How the app describes it | Example cities (from the app) |
| --- | --- | --- |
| **TWG** | Culture and creative spaces | Detroit Commons, The Collective |
| **A Ma Manière** | Luxury, culture and timeless design | Atlanta, DC, Houston, Chicago, Folly Beach |
| **Social Status** | Streetwear, community and beSocial | Pittsburgh, Charlotte, Houston, Detroit, Tampa, Baltimore |
| **APB Store** | Skate, street and APB YOU | Charlotte, Charleston, Columbia, Greenville, Jacksonville, Tallahassee |
| **JAIDE** | Lounge, wine and elevated events | Atlanta, Charlotte |
| **38a** | Style, culture and community | (home style exists in the app) |

Sources: brand texts in [home_page.dart:9492-9560](lib/features/home/presentation/pages/home_page.dart#L9492-L9560), cities in [app_session_state.dart:106-136](lib/core/state/app_session_state.dart#L106-L136).

**Why the app exists:** without it, each brand's spaces, events and stores would be separate. The app gives members one login, one wallet and one membership across all of them. The business decides everything from an **admin panel** (in the `twg-platform` backend): listings, prices, which payment gateway to use, which social logins are on, and more. The app mostly shows what the backend sends.

## 2. Customers: who is it for?

The users are **members and fans of the TWG brands**: people who love the fashion, streetwear and culture side of these brands and want access to their spaces and events.

Every user has a **membership tier**. The tier decides what they can do. These plans come from the backend's seed data ([MembershipSeeder.php](../twg-platform/database/seeders/MembershipSeeder.php)). Real prices can be changed in the admin panel.

| Tier (slug) | Price (seed) | Can view and shop | Can RSVP and book | Booking limits |
| --- | --- | --- | --- | --- |
| **Complimentary** (`free`) | $0 | ✅ | ❌ | 0 |
| **Engagement** (`standard`) | $29.99 / year | ✅ | ✅ | 3 a day, 20 a month |
| **Inner Circle** (`vip`) | $99.99 / year | ✅ | ✅ | 10 a day, 100 a month |

Two rules come from the tier:

- **Permissions:** [tierPermissionsProvider](lib/features/account/presentation/providers/account_providers.dart#L13-L40) reads `can_shop`, `can_do_rsvp`, `can_do_bookings` and the daily or monthly limits. If a user taps something their tier can't do, a bottom sheet asks them to upgrade ([tier_restriction_sheet.dart:25-34](lib/core/widgets/tier_restriction_sheet.dart#L25-L34)).
- **Price:** only Inner Circle (`vip`) members pay the **member price**. Everyone else pays the non-member price ([member_pricing.dart:11-23](lib/core/utils/member_pricing.dart#L11-L23)).

**Personal experience:** each user picks a **brand** (and a city). The whole home screen changes colors, titles and sections based on that brand (see [section 14](#14-complex-ui-logic)).

## 3. Features: what can users do?

The app has **27 feature folders** and about **156 screens**.

| Area | What users can do | Folder |
| --- | --- | --- |
| **Sign up and log in** | Register with email and OTP, log in with email or Apple, reset password, pick a brand, allow notifications | `auth`, `splash` |
| **Home** | Brand-styled home with sections (stays, food, studios, events, shop…), city tabs, brand switcher | `home` |
| **Book a place or service** | 9 kinds of booking, all with the same steps: list → details → pick date → options → review → pay | `living` (stays), `space`, `studio`, `beach`, `barber_shop`, `eats`, `wine`, `food_and_lounge`, `retail` |
| **RSVP to events** | Events, workshops, gallery exhibitions | `events`, `workshop`, `gallery_exhibition` |
| **Raffles** | See product raffles (drops) collected from sources, open them in a web view | `raffles` |
| **Shop** | Browse the brands' Shopify stores, cart, checkout in a web view | `shop` |
| **Pay** | Pay with Stripe or Adyen (the admin chooses), saved cards, promo codes, pay later, invoices | `payment` |
| **Wallet** | Passes with offline QR codes, reward points, promo codes, receipts, membership card | `wallet` |
| **Waiver** | Sign a waiver (draw or upload) before some bookings | `waiver` |
| **Account** | Profile, photo, email or phone change with OTP, addresses, payment methods, preferences, documents, membership upgrade, delete account | `account` |
| **Support** | Support tickets with photos, chat with staff, AI help, FAQs, legal pages, ask for a price | `support`, `account` |
| **Notifications** | Push notifications, notification list, unread count | `notifications` |
| **Content** | Discover tab: stories, campaign films, behind the scenes, city guides, lookbooks, announcements | `stories`, `announcements` |
| **Calendar and map** | Monthly calendar of events, map of locations | `calendar`, `locations` |

Seven folders are **empty** (only `.gitkeep`): `add_ons`, `booking`, `checkin`, `membership`, `rsvp`, `search`, `city_selection`.

---

# Part B: How it's built

## 4. The big picture

```text
┌─────────────────────────────────────────────────────────────────────┐
│ Flutter app (this repo)                                             │
│                                                                     │
│  Screens (pages)            156 screens, mostly ConsumerWidget      │
│        │ ref.watch / ref.read                                       │
│        ▼                                                            │
│  Riverpod providers         FutureProvider, StateNotifier, …        │
│        │                                                            │
│        ▼                                                            │
│  Repositories               one per feature, turn JSON into models  │
│        │                                                            │
│        ▼                                                            │
│  TwgApiClient (Dio)         one HTTP client, adds the login token   │
└────────┼────────────────────────────────────────────────────────────┘
         ▼  https://thewhtkrgrp.com/api/v1/...
┌─────────────────────────────────────────────────────────────────────┐
│ twg-platform backend (Laravel) + admin panel                        │
│   ├─ Stripe / Adyen   (payments)                                    │
│   ├─ Shopify          (stores, through the backend)                 │
│   └─ Firebase FCM     (push notifications)                          │
└─────────────────────────────────────────────────────────────────────┘
```

Each feature folder follows the same shape:

```text
features/living/
├── data/models/          ← Dart classes made from JSON (fromJson)
├── data/repositories/    ← API calls
└── presentation/
    ├── providers/        ← Riverpod providers
    └── pages/            ← screens
```

## 5. Packages and why they're used

| Package | What it does in this app | Why this one |
| --- | --- | --- |
| `flutter_riverpod` 2.6 | All state management | Safe, testable, no `BuildContext` needed to read state |
| `go_router` | Named routes for start, login and auth screens | URL-like routes, deep links, `context.go` for stack resets |
| `dio` | All HTTP calls | Interceptors (adds the token), timeouts, file upload |
| `flutter_secure_storage` | Stores the login token | Encrypted (iOS Keychain, Android Keystore) |
| `shared_preferences` | Stores small settings: user JSON, brand, city | Simple key-value storage |
| `flutter_screenutil` | Sizes that scale with the screen (`.w`, `.h`, `.sp`) | Design was made for a 390×844 screen |
| `firebase_core`, `firebase_messaging` | Push notifications | Standard for iOS and Android push |
| `flutter_local_notifications` | Shows a notification while the app is open | FCM doesn't show it by itself in the foreground |
| `flutter_stripe` | Stripe payment sheet | Native card UI, card saving |
| `adyen_checkout` | Adyen drop-in payment | Second gateway, the admin can switch |
| `sign_in_with_apple` | Apple login (iOS) | Required by App Store when social login exists |
| `google_sign_in` | **Not used yet** (installed only) | Google login was planned |
| `flutter_map`, `latlong2` | Maps on detail pages and the locations page | Free OpenStreetMap, no API key |
| `table_calendar` | Booking date picker | Custom days, ranges, disabled dates |
| `image_picker` | Pick photos (profile, waiver, support) | Standard camera or gallery picker |
| `signature` | Draw a signature for the waiver | Turns drawing into PNG |
| `webview_flutter` | Shopify checkout, invoices, raffles | Show web pages inside the app |
| `url_launcher` | Open browser, maps, phone | Open other apps |
| `qr_flutter` | QR code on wallet passes | Draws QR on the phone, works offline |
| `intl` | Date formats | `DateFormat('yyyy-MM-dd')` |
| `connectivity_plus`, `json_serializable`, `build_runner` | **Installed but never used** | — |

## 6. APIs: how many, and why

The app talks to **one backend**: `twg-platform`, at `https://thewhtkrgrp.com/api/v1`. A script scanned every API call in the code and found **about 170 different endpoints** (method + path) in 11 groups:

| Group | Endpoints | Why the app needs them | Main file |
| --- | --- | --- | --- |
| Auth and onboarding | 23 | Register, OTP, login (email, Apple, Google), password reset, logout, brands, cities, memberships, brand banners | [auth_repository.dart](lib/features/auth/data/repositories/auth_repository.dart), [member_repositories.dart](lib/features/auth/data/repositories/member_repositories.dart) |
| Account | 27 | Profile, photo, email and phone change, addresses, preferences, consents, documents, password, membership upgrade, delete account | [account_repository.dart](lib/features/account/data/repositories/account_repository.dart) |
| Bookings (9 kinds) | 38 | For each kind: list, details, check availability, create booking (some also confirm payment) | e.g. [living_repository.dart](lib/features/living/data/repositories/living_repository.dart) |
| Events and RSVP | 15 | Events, workshops, gallery: list, details, book, cancel, confirm payment | [event_repository.dart](lib/features/events/data/repositories/event_repository.dart), [workshop_repository.dart](lib/features/workshop/data/repositories/workshop_repository.dart) |
| Shop | 16 | Shopify brands, collections, products, cart (create, add, update, remove), checkout | [shopify_repository.dart](lib/features/shop/data/repositories/shopify_repository.dart) |
| Payments | 10 | Create payment intent, confirm Adyen, saved cards, card setup, history, invoices, pay later | [payment_repository.dart](lib/features/payment/data/repositories/payment_repository.dart) |
| Support | 10 | Ticket categories, tickets, messages, unread count, AI chat, price request | [support_repository.dart](lib/features/support/data/support_repository.dart) |
| Content | 11 | Stories, campaign films, behind the scenes, city guides, lookbooks, spotlights, announcements, FAQs, legal | [stories_repository.dart](lib/features/stories/data/repositories/stories_repository.dart) |
| Notifications | 7 | Notification list, read or unread, delete, register or remove the device token | [notification_repository.dart](lib/features/notifications/data/repositories/notification_repository.dart) |
| Wallet | 7 | Passes, points, achievements, promo codes | [wallet/data/](lib/features/wallet/data/) |
| Other | 6 | Calendar month and date check, map coordinates, raffle sources and crawl, waiver settings | various |
| **Total** | **~170** | | |

Things to know:

- **All calls go through one class**, [TwgApiClient](lib/core/network/twg_api_client.dart), which adds `Authorization: Bearer <token>` to every request ([twg_api_client.dart:44-52](lib/core/network/twg_api_client.dart#L44-L52)).
- **Shopify is not called directly.** The backend works as a middleman (`/shopify/...`), so the app holds no Shopify keys.
- **Payment SDKs talk to Stripe or Adyen directly**, but only with one-time data the backend creates. No secret keys are in the app.
- **Three repositories try several URLs for each call:** workshops ([workshop_repository.dart:20-47](lib/features/workshop/data/repositories/workshop_repository.dart#L20-L47)), events ([event_repository.dart:42-45](lib/features/events/data/repositories/event_repository.dart#L42-L45)) and announcements ([announcement_repository.dart:15-17](lib/features/announcements/data/repositories/announcement_repository.dart#L15-L17)). The first URL (`/api/api/v1/...`) is wrong, so each of these calls gets a 404 first and then retries. That makes them slower.
- **Server address:** production by default. A different server can be set at build time with `--dart-define=SERVER_URL=...` ([twg_api_client.dart:11-15](lib/core/network/twg_api_client.dart#L11-L15)).

---

# Part C: The flows

## 7. App start

```text
main()
 ├─ Firebase init + background push handler              main.dart:22-23
 ├─ Stripe placeholder key (real key comes per payment)  main.dart:33-34
 ├─ Android notification channel "twg_bookings"          main.dart:36
 ├─ Load SharedPreferences, create ONE TwgApiClient      main.dart:38-39
 ├─ Restore saved brand and city                         main.dart:41
 └─ runApp(ProviderScope(...)) with apiClient override   main.dart:43-50
        │
TwgApp: start push service, MaterialApp.router             app.dart:22, 36-41
        │
Splash (1.4 s)
 ├─ no token ─────────────────────────────▶ Login
 └─ token → load cached user → GET /member/auth/profile
              ├─ 200 ────────────────────▶ Home
              ├─ 401 / 403 → delete token ▶ Login
              └─ other / no internet ─────▶ Home (works offline)
```

Code: [main.dart](lib/main.dart), [app.dart](lib/app/app.dart), [splash_page.dart:25-69](lib/features/splash/presentation/pages/splash_page.dart#L25-L69).

## 8. Registration (sign up)

```text
Login ─▶ Register form ─▶ Email OTP ─▶ Choose Experience ─▶ Smart Alerts ─▶ Home
         (POST register)   (POST verify-otp,  (pick a brand)     (allow push?)
                            token saved)
```

| Step | What happens | Code |
| --- | --- | --- |
| 1. Form | Full name, email, phone, password, confirm. The password must pass **5 rules**: 8+ characters, an uppercase letter, a lowercase letter, a number and a symbol. The rules are checked live while typing | [register_form.dart:16-51](lib/features/auth/presentation/pages/register_form.dart#L16-L51), submit [:90-128](lib/features/auth/presentation/pages/register_form.dart#L90-L128) |
| 2. Create account | `POST /member/auth/register`. If the server says no (for example, email already taken), its message is shown | [auth_repository.dart:27-50](lib/features/auth/data/repositories/auth_repository.dart#L27-L50) |
| 3. Verify email | User enters the 6-digit OTP. `POST /member/auth/verify-otp` returns a **token**, which is saved. The user is now logged in | [register_verification.dart:34-60](lib/features/auth/presentation/pages/register_verification.dart#L34-L60), [auth_repository.dart:79-103](lib/features/auth/data/repositories/auth_repository.dart#L79-L103) |
| 4. Choose Experience | Brand cards come from `GET /mobile/brand-banners` (with 2 backup endpoints). The choice is saved on the phone | [choose_experience.dart](lib/features/auth/presentation/pages/choose_experience.dart), [riverpod_providers.dart:325-342](lib/features/auth/presentation/providers/riverpod_providers.dart#L325-L342) |
| 5. Smart Alerts | "Allow" asks for push permission and sends the device token to the backend. "Not now" skips it. The choice is remembered, so this screen shows only once | [smart_alerts.dart:14-31](lib/features/auth/presentation/pages/smart_alerts.dart#L14-L31) |

**Unused parts:** the code also has an older flow: an OTP page, then a membership plan picker, then a city picker. No screen leads to it anymore. `RegistrationFlowHelper` ([registration_helper.dart](lib/features/auth/presentation/utils/registration_helper.dart)) and `completeProfile()` are written but never called.

## 9. Authentication (log in, log out)

**Type:** token-based. After login, the backend (Laravel Passport) returns an `access_token`. The app saves it in **secure storage** and sends it with every request as `Authorization: Bearer <token>`. There is **no refresh token**.

**Ways to log in:**

| # | Way | Status | Code |
| --- | --- | --- | --- |
| 1 | Email + password (`POST /member/auth/login-mobile`) | ✅ Works | [auth_notifier.dart:106-131](lib/features/auth/presentation/providers/auth_notifier.dart#L106-L131), [auth_repository.dart:106-130](lib/features/auth/data/repositories/auth_repository.dart#L106-L130) |
| 2 | Register + email OTP (auto login after verify) | ✅ Works | section 8 |
| 3 | Sign in with Apple (iOS only, if the admin turns it on) | ✅ Works | [auth_notifier.dart:223-274](lib/features/auth/presentation/providers/auth_notifier.dart#L223-L274) |
| 4 | Google | ❌ Half built: the API method exists, but there's no button | [auth_repository.dart:133-155](lib/features/auth/data/repositories/auth_repository.dart#L133-L155) |
| — | Saved session (token found at app start) | ✅ Works | section 7 |

**Forgot password:** email → OTP → `reset_token` → new password → back to login.

**Log out:** [profile_page.dart:525-530](lib/features/account/presentation/pages/profile_page.dart#L525-L530) → `POST /member/auth/logout` → delete the token and the cached user ([auth_repository.dart:252-260](lib/features/auth/data/repositories/auth_repository.dart#L252-L260)) → go to the pre-login screen.

**Where the user data is kept:**

| Data | Where |
| --- | --- |
| Access token | Secure storage, key `access_token` |
| User profile (JSON copy) | SharedPreferences, key `user_data` |
| Logged-in user in memory | `authProvider` (Riverpod) |

## 10. State management (complete)

The app uses **Riverpod 2** in the older style (`StateNotifier` + `FutureProvider`, no code generation). There's also one old-style `ChangeNotifier` and a lot of local `setState`.

| Tool | Count | Used for |
| --- | --- | --- |
| `FutureProvider` (+ `.family`) | 80 (43 family) | Loading data from the API (read only) |
| `StateNotifier` | 9 | Data that changes: login, account, Shopify cart, beach booking form, calendar |
| `StateProvider` | 9 | Small values: selected home city, tab index, page number |
| `ChangeNotifier` | 1 | `AppSessionState`: selected brand and city |
| `setState` | 369 | Local screen state: filters, tabs, forms |
| `autoDispose` | only 7 | Most providers stay in memory until the app closes |

**The important global state:**

| State | Provider | What it holds | Code |
| --- | --- | --- | --- |
| API client | `apiClientProvider` | The single `TwgApiClient` (set in `main()`) | [riverpod_providers.dart:13-15](lib/features/auth/presentation/providers/riverpod_providers.dart#L13-L15) |
| Login | `authProvider` | Current user, token, loading, error, registration step | [riverpod_providers.dart:50](lib/features/auth/presentation/providers/riverpod_providers.dart#L50) |
| Account | `accountProvider` | Profile, membership, addresses and more | [account_providers.dart:49](lib/features/account/presentation/providers/account_providers.dart#L49) |
| Tier rules | `tierPermissionsProvider` | What this user may do (computed) | [account_providers.dart:13-40](lib/features/account/presentation/providers/account_providers.dart#L13-L40) |
| Brand | `appSessionStateProvider`, `selectedBrandProvider` | Which brand's home to show | [riverpod_providers.dart:501-538](lib/features/auth/presentation/providers/riverpod_providers.dart#L501-L538) |
| Home city | `selectedHomeCityProvider` | City tab on home (drives all home API calls) | [riverpod_providers.dart:541](lib/features/auth/presentation/providers/riverpod_providers.dart#L541) |
| Cart | `ShopifyCartNotifier` | Shopify cart | [shopify_providers.dart:242](lib/features/shop/presentation/providers/shopify_providers.dart#L242) |

**Pattern every StateNotifier follows:**

```dart
state = state.copyWith(isLoading: true);          // 1. show loading
try {
  final res = await repository.doSomething();     // 2. call the API
  state = state.copyWith(isLoading: false, data: res);   // 3a. success
  return true;                                    //     screen moves on
} catch (e) {
  state = state.copyWith(isLoading: false, error: e.toString());   // 3b. failure
  return false;                                   //     screen shows a SnackBar
}
```

**Saved on the phone (survives app restart):** token (secure storage), plus user JSON, brand, city, notification choice, saved signature and calendar events (SharedPreferences).

**Gaps:** logout doesn't clear the other providers or the brand choice. Since few providers use `autoDispose`, a new user on the same phone may briefly see the old user's data.

## 11. Data flow

**Reading data, for example the Living (stays) list:**

```text
LivingListingPage
  ref.watch(allLivingsProvider(page))                       living_listing_page.dart:112
        ▼
allLivingsProvider = FutureProvider.family                  living_providers.dart:23-29
        ▼
LivingRepository.getAllLivings()                            living_repository.dart:62-84
        ▼
TwgApiClient.get('/livings', page, per_page)  + Bearer token
        ▼
JSON → LivingListResponse.fromJson()
        ▼
UI: .when(loading: spinner, error: "Try again", data: list)  living_listing_page.dart:124-157
```

**Automatic refresh when something changes, for example the city tab on home:**

```text
User taps "Atlanta"
  → selectedHomeCityProvider = 'Atlanta'                    home_page.dart:247
  → every home section provider watches it, so they all re-run
  → each re-calls its API with city=Atlanta
  → sections rebuild with new data
```

Changing the brand works the same way: `AppSessionState.selectBrand()` saves it, notifies listeners, `selectedBrandProvider` changes, and the home providers reload for that brand.

**Writing data** (booking, profile edit, payment) goes through a `StateNotifier` method or a direct repository call from the screen, as shown in sections 10 and 12.

## 12. Booking and payment flow

All 9 booking types (stays, spaces, studios, beach, barber, eats, wine, food and lounge, retail) follow the same path. Living (stays) is shown here:

```text
1. Listing        list or map view, search, filters                   living_listing_page.dart
2. Details        photo slider, info, amenities, map                  living_details_page.dart
3. Availability   TierCalendar: available days from the API,
                  tier-locked days show an upgrade sheet               tier_calendar.dart
4. Options        booking type, session length, guests, room, add-ons  (one page each)
5. Review         price breakdown → waiver (if required)
                  → POST /livings/{id}/bookings                        review_booking_page.dart:489-609
6. Payment        promo code, pay now / saved card / pay later         add_payment_page.dart
7. Processing     waits 3 seconds so the payment webhook can reach
                  the server before the confirmation is loaded         payment_processing_page.dart:38-43
8. Confirmation   booking details, directions, invoice                 booking_confirmation_page.dart
```

**How the price is calculated** ([review_booking_page.dart:149-158](lib/features/living/presentation/pages/review_booking_page.dart#L149-L158)):

```text
unit price  = member price (if Inner Circle) or non-member price
total       = unit price × nights or sessions  +  add-ons  +  service fee
```

**Payment step** ([add_payment_page.dart](lib/features/payment/presentation/pages/add_payment_page.dart)):

```text
Promo code? → POST /member/promo-codes/validate                       :70-110
   │
   ├─ Pay now ──▶ PaymentGatewayService.payForBooking()               :145
   │               POST /member/payments/create-intent
   │               └─ server answers with the gateway the admin chose:
   │                   ├─ Stripe → Stripe payment sheet
   │                   └─ Adyen  → Adyen drop-in → POST /member/payments/adyen/confirm
   ├─ Saved card ─▶ SavedWalletsPage (same gateway logic)             :120-128
   └─ Pay later ──▶ POST /bookings/{type}/{id}/pay-later              :567
   │
success → PaymentProcessingPage (3 s) → BookingConfirmationPage
cancel  → stay on page,  fail → error message
```

The final payment status is set by the **server** when Stripe or Adyen sends a webhook. The app only shows the result to the user. Gateway code: [payment_gateway_service.dart:23-63](lib/core/payments/payment_gateway_service.dart#L23-L63).

## 13. Other flows: events, shop, push, support

**Events, workshops and gallery (RSVP):** list → details → RSVP page → review → book (`POST /events/{id}/bookings`). Free events go straight to confirmation. Paid events go to the same payment page as bookings ([event_review_booking_page.dart:70-94](lib/features/events/presentation/pages/event_review_booking_page.dart#L70-L94)). Bookings can be cancelled, and their payment confirmed or completed later.

**Shop (Shopify):**

```text
Collections → products → product details → add to cart
  Cart lives on the backend: POST /shopify/stores/{id}/cart, then add, update or remove lines
  → delivery option, shipping address (buyer identity)
  → checkout opens Shopify's own page in a web view
  → app watches the URL; when it sees /thank_you it knows the order is placed
```

Code: [shopify_checkout_page.dart:64-81](lib/features/shop/presentation/pages/shopify_checkout_page.dart#L64-L81).

**Push notifications:**

```text
App start → set up local notifications, listen for pushes, re-register the token if allowed
Smart Alerts "Allow" → ask OS permission → POST /member/device-tokens/register
Push arrives:
  app open       → shown with flutter_local_notifications
  app in back    → OS shows it
User taps:
  support_message → opens that support chat
  anything else   → opens the notifications list
```

Code: [notification_service.dart](lib/core/notifications/notification_service.dart) (tap routing at [:166-191](lib/core/notifications/notification_service.dart#L166-L191)).

**Support:** create a ticket (category, text, photos) → chat with staff. The chat screen **asks the server for new messages every 5 seconds** ([support_conversation_page.dart:37](lib/features/support/presentation/pages/support_conversation_page.dart#L37)). There's also an AI help chat (`/member/account/support/ai-chat`).

## 14. Complex UI logic

These are the parts with the most logic. They're good to understand before changing anything.

| What | How it works | Code |
| --- | --- | --- |
| **Brand-based home** | The app figures out a "brand key" (`twg`, `amm`, `ss`, `apb`, `jaide`, `38a`) by matching the brand's id, slug or name. Each key has its own config (title, subtitle, header color, accent color) **and its own home layout** with different sections. 6 layouts live in one 9,906-line file | [home_page.dart:163-188](lib/features/home/presentation/pages/home_page.dart#L163-L188), key [:9370-9390](lib/features/home/presentation/pages/home_page.dart#L9370-L9390), config [:9475-9560](lib/features/home/presentation/pages/home_page.dart#L9475-L9560) |
| **Bottom tabs** | Home, Discover, Calendar, Locations, Wallet. Built with `if` checks instead of `IndexedStack`, so switching tabs resets the old tab's scroll and state | [home_page.dart:121-161](lib/features/home/presentation/pages/home_page.dart#L121-L161) |
| **Tier calendar** | Each month it loads availability from `GET /calendar/month`. Past and fully booked days are disabled. Days locked by **tier** stay tappable on purpose, so a tap can open an upgrade sheet instead of selecting. Supports single dates and date ranges (check-in to check-out) | [tier_calendar.dart:60-100](lib/core/widgets/tier_calendar.dart#L60-L100), [:146](lib/core/widgets/tier_calendar.dart#L146), [:154-185](lib/core/widgets/tier_calendar.dart#L154-L185) |
| **Tier restriction sheet** | Before RSVP or booking, it checks the permission. If not allowed, it shows an upgrade bottom sheet | [tier_restriction_sheet.dart:25-34](lib/core/widgets/tier_restriction_sheet.dart#L25-L34) |
| **Member pricing** | Inner Circle pays the member price, others pay the non-member price, plus the service fee once per booking | [member_pricing.dart:11-23](lib/core/utils/member_pricing.dart#L11-L23) |
| **Waiver gate** | Before booking, it asks the server whether a waiver is required. If yes, the user goes through notice → signature → confirmation | [waiver_settings.dart:37-58](lib/features/waiver/data/waiver_settings.dart#L37-L58) |
| **Payment gateway switch** | The same "Pay" button runs Stripe or Adyen, depending on the server's answer | [payment_gateway_service.dart:37-62](lib/core/payments/payment_gateway_service.dart#L37-L62) |
| **Shopify checkout** | Detects the order by watching URLs. Retries an autofill script every 0.7 seconds | [shopify_checkout_page.dart:64-96](lib/features/shop/presentation/pages/shopify_checkout_page.dart#L64-L96) |
| **Listing page** | List or map toggle, search, filter dialog, paging | [living_listing_page.dart](lib/features/living/presentation/pages/living_listing_page.dart) |
| **OTP resend timer** | Counts down every second before "Resend" turns on | [otp_verification_page.dart:47](lib/features/account/presentation/pages/otp_verification_page.dart#L47) |

## 15. Banners, sliders and images

No slider package is used. Every slider is built by hand with Flutter's `PageView` plus custom dots.

| Component | Where | How it works |
| --- | --- | --- |
| **Brand banner cards** | Choose Experience screen | Big card per brand with its banner image from the API. Falls back to a local asset if the image fails ([auth_banner_option_card.dart:63-73](lib/core/widgets/auth_banner_option_card.dart#L63-L73)) |
| **Brand switcher** | Top of home | Tap to open a dropdown of brands (loaded only when first opened). Picking one saves it and rebuilds home ([home_page.dart:7772-7800](lib/features/home/presentation/pages/home_page.dart#L7772-L7800)) |
| **Announcements carousel** | Home | `PageView` with `viewportFraction: 0.92` (the next card peeks in) and dots ([home_page.dart:9149-9201](lib/features/home/presentation/pages/home_page.dart#L9149-L9201), also [:5630-5671](lib/features/home/presentation/pages/home_page.dart#L5630-L5671)) |
| **Photo slider on details** | Living, beach | Swipe through gallery photos. The active dot grows wider ([living_details_page.dart:175-245](lib/features/living/presentation/pages/living_details_page.dart#L175-L245)) |
| **Auto-sliding images** | Raffle details | Moves to the next image **every 3 seconds** with a `Timer` ([raffle_details_page.dart:44-54](lib/features/raffles/presentation/pages/raffle_details_page.dart#L44-L54)) |
| **Featured stories** | Discover tab | `PageView` of featured stories, tap to open ([discover_page.dart:261-264](lib/features/stories/presentation/pages/discover_page.dart#L261-L264)) |
| **Horizontal rows** | Home sections and listings | 36 horizontal `ListView`s (cards you scroll sideways) |
| **Hero animation** | Workshop, studio, retail details | The image "flies" from the list to the details page (18 places) |

**How images are loaded:**

- `Image.network` in **103 places**. Almost all have an `errorBuilder` (a fallback when an image fails), and 31 have a `loadingBuilder` (a spinner while loading).
- The backend often sends **relative paths** like `/storage/x.jpg`. [ImageUtils.getImageUrl()](lib/shared/utils/image_utils.dart#L14-L29) turns them into full URLs on the same server, or returns a placeholder if empty. It's used in 109 places.
- Local images: logos and icons from `assets/` with `Image.asset`.
- **No image cache package** (like `cached_network_image`). Images are cached only in memory and download again after an app restart.

## 16. Error handling

Errors pass through 4 layers:

```text
1. TwgApiClient   accepts EVERY status code as "success" (validateStatus: true)
                  → only network problems (no internet, timeout) throw DioException
2. Repository     checks statusCode; if not 200 → throws its own ApiException
                  DioException → ApiException(friendly message)
3. Notifier       catch (e) → state.error = e.toString(), return false
                  (FutureProvider turns errors into AsyncError automatically)
4. Screen         SnackBar (113 places), error view with "Try again", dialogs
```

| Good | Missing or weak |
| --- | --- |
| Most list screens have a "Try again" button (`ref.invalidate`) | **401 is never handled during use.** Because of `validateStatus: true`, the 401 code in the interceptor never runs. An expired token just shows "Failed to…" errors ([twg_api_client.dart:36-61](lib/core/network/twg_api_client.dart#L36-L61)) |
| Registration and booking show the server's real message | **About 75 places throw a fixed message** and lose the server's message. Wrong password shows only "Login failed" ([auth_repository.dart:123](lib/features/auth/data/repositories/auth_repository.dart#L123)) |
| Payment cancel is treated separately from failure | **No crash reporting** (no Crashlytics or Sentry) and no global error handler |
| Logs are only printed in debug builds | **11 copies of `ApiException`**, one per feature, instead of one shared class |
| | `connectivity_plus` is installed but unused, so there's no offline banner |

## 17. Problems to know about

The full list with priorities is in [PROJECT_GUIDE_BN.md section 14](PROJECT_GUIDE_BN.md#১৪-সমস্যা-ও-ঝুঁকি-আগে-জেনে-রাখুন). The biggest ones:

1. Expired tokens aren't caught during use, so the user isn't sent back to login (section 16).
2. Server error messages are lost in about 75 places (section 16).
3. Logout doesn't remove the push token, so the old user's pushes still reach that phone ([notification_service.dart:54-63](lib/core/notifications/notification_service.dart#L54-L63) is never called).
4. The payment "processing" screen waits a fixed 3 seconds before showing the confirmation. This is on purpose: it gives the Stripe or Adyen webhook time to reach the server (see the comment in [add_payment_page.dart:158-159](lib/features/payment/presentation/pages/add_payment_page.dart#L158-L159)). But it's a guess. If the webhook is slower, the confirmation can show an old status. Asking the server for the status (and retrying) would be safer ([payment_processing_page.dart:38-43](lib/features/payment/presentation/pages/payment_processing_page.dart#L38-L43)).
5. Three repositories hit a wrong URL first on every call (section 6).
6. Debug builds use the **production** server unless `SERVER_URL` is set.
7. `home_page.dart` is 9,906 lines. The bottom tabs lose state when switched.
8. Google login is half built. Unused packages, routes and folders remain.

## 18. Where to start reading the code

1. [main.dart](lib/main.dart) → [app.dart](lib/app/app.dart) → [app_router.dart](lib/app/router/app_router.dart) → [splash_page.dart](lib/features/splash/presentation/pages/splash_page.dart): how the app starts.
2. [twg_api_client.dart](lib/core/network/twg_api_client.dart): how every API call works.
3. [riverpod_providers.dart](lib/features/auth/presentation/providers/riverpod_providers.dart) and [app_session_state.dart](lib/core/state/app_session_state.dart): global state.
4. One full feature, **living**: providers → repository → listing → details → review → [add_payment_page.dart](lib/features/payment/presentation/pages/add_payment_page.dart). The other 8 booking types are copies of this pattern.
5. [auth_notifier.dart](lib/features/auth/presentation/providers/auth_notifier.dart), [notification_service.dart](lib/core/notifications/notification_service.dart), [payment_gateway_service.dart](lib/core/payments/payment_gateway_service.dart).
6. [home_page.dart](lib/features/home/presentation/pages/home_page.dart): don't read it top to bottom. Search for class names with `Cmd+Shift+O`.
