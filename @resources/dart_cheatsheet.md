# Dart Cheat Sheet — মনে করিয়ে দেওয়ার জন্য (বাংলা)

> **কার জন্য:** যারা আগে Dart শিখেছেন কিন্তু অনেকদিন ব্যবহার করেননি, আর এখন TWG-র মতো আসল প্রজেক্টের কোড পড়তে বা লিখতে চান।
> **প্রতিটা বিষয়ে যা থাকবে:** কী, কেন লাগে, কীভাবে জীবন সহজ করে, সহজ উদাহরণ, আর বাস্তব উদাহরণ (TWG প্রজেক্টের আসল কোড, লাইনের লিংকসহ), সাথে খুঁটিনাটি।
> **যাচাই করা:** সব "সহজ উদাহরণ" Dart 3.11-এ চালিয়ে দেখা হয়েছে। কমেন্টে `// →` দিয়ে যে আউটপুট লেখা, সেটাই আসল আউটপুট।
> [← কোর্স রোডম্যাপ](README.md)

## সূচিপত্র

**শুরুর আগে:** [০. চিহ্নের মানে, এক নজরে](#০-চিহ্নের-মানে-এক-নজরে)

| অংশ       | বিষয়                                                                                                                                                                                                                                                                                         |
| --------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ভিত্তি    | [১. ভ্যারিয়েবল](#১-ভ্যারিয়েবল-var-final-const-late-dynamic) · [২. টাইপ আর String](#২-টাইপ-সংখ্যা-আর-string) · [৩. Null safety](#৩-null-safety) · [৪. দরকারি অপারেটর](#৪-দরকারি-অপারেটর)                                                                                                     |
| কালেকশন   | [৫. List, Map, Set](#৫-list-map-set) · [৬. Map&lt;String, dynamic&gt;](#৬-mapstring-dynamic) · [৭. collection if/for, spread](#৭-collection-if-for-আর-spread) · [৮. List-এর মেথড](#৮-list-এর-দরকারি-মেথড)                                                                                     |
| ফাংশন     | [৯. ফাংশন আর প্যারামিটার](#৯-ফাংশন-আর-প্যারামিটার-positional-optional-named-required) · [১০. callback আর typedef](#১০-function-টাইপ-callback-আর-typedef)                                                                                                                                      |
| ক্লাস     | [১১. Constructor (সব ধরন)](#১১-ক্লাস-আর-constructor-সব-ধরন) · [১২. `_` প্রাইভেট](#১২-_-আন্ডারস্কোর-প্রাইভেট) · [১৩. getter, static](#১৩-getter-setter-static) · [১৪. extends, implements, with](#১৪-extends-implements-with-abstract) · [১৫. enum](#১৫-enum) · [১৬. extension](#১৬-extension) |
| ডেটা মডেল | [১৭. Immutable আর copyWith](#১৭-immutable-ক্লাস-আর-copywith) · [১৮. == আর hashCode](#১৮--আর-hashcode) · [১৯. Generics &lt;&gt;](#১৯-generics--অ্যাঙ্গেল-ব্র্যাকেট) · [২০. JSON](#২০-json-jsondecode-→-fromjson-→-tojson-→-jsonencode)                                                         |
| Async     | [২১. Future, async/await](#২১-future-async-await) · [২২. Stream](#২২-stream) · [২৩. এরর হ্যান্ডলিং](#২৩-এরর-হ্যান্ডলিং-try-catch-on-finally-rethrow)                                                                                                                                          |
| Dart 3    | [২৪. Record](#২৪-record-একসাথে-একাধিক-মান) · [২৫. Pattern matching, switch, sealed](#২৫-pattern-matching-switch-expression-sealed-class)                                                                                                                                                      |
| শেষে      | [২৬. অ্যানোটেশন ও অন্যান্য](#২৬-অ্যানোটেশন-আর-অন্যান্য) · [২৭. সাধারণ runtime এরর](#২৭-সাধারণ-runtime-এরর-আর-তার-মানে) · [২৮. একটা জটিল লাইন ভেঙে পড়া](#২৮-একটা-জটিল-লাইন-ভেঙে-পড়া)                                                                                                         |

---

## ০. চিহ্নের মানে, এক নজরে

কোড পড়তে গিয়ে কোনো চিহ্নে আটকে গেলে আগে এই টেবিল দেখুন।

| চিহ্ন              | নাম                                      | মানে                                        | উদাহরণ                        |
| ------------------ | ---------------------------------------- | ------------------------------------------- | ----------------------------- |
| `?` (টাইপের পরে)   | nullable                                 | এই ভ্যারিয়েবলে `null`-ও থাকতে পারে         | `String? phone`               |
| `!`                | null assertion                           | "আমি নিশ্চিত এটা null না", null হলে crash   | `phone!.length`               |
| `??`               | if-null                                  | বাঁ পাশ null হলে ডান পাশ নাও                | `name ?? 'Guest'`             |
| `??=`              | null হলে বসাও                            | শুধু null থাকলে মান বসায়                   | `city ??= 'Dhaka'`            |
| `?.`               | null-aware access                        | null না হলে তবেই মেথড ডাকো, নইলে null       | `user?.name`                  |
| `..`               | cascade                                  | একই অবজেক্টে পরপর অনেক কাজ                  | `list..add(1)..add(2)`        |
| `...`              | spread                                   | একটা লিস্ট আরেকটার ভেতরে ছড়িয়ে দেওয়া     | `[...old, newItem]`           |
| `...?`             | null-aware spread                        | লিস্ট null হলে কিছুই যোগ করে না             | `[...?maybeList]`             |
| `=>`               | arrow                                    | এক লাইনের ফাংশন: `{ return x; }`-এর ছোট রূপ | `int sq(int x) => x * x;`     |
| `_` (নামের শুরুতে) | private                                  | শুধু এই **ফাইলের** ভেতরে দেখা যায়          | `_apiClient`                  |
| `<T>`              | generic                                  | "কোন টাইপের জিনিস"                          | `List<String>`                |
| `[ ]`              | লিস্ট / optional positional প্যারামিটার  |                                             | `[1, 2]`, `f(a, [b])`         |
| `{ }`              | Map / Set / named প্যারামিটার / কোড ব্লক |                                             | `{'a': 1}`, `f({required a})` |
| `$x`, `${expr}`    | string interpolation                     | স্ট্রিংয়ের ভেতরে মান বসানো                 | `'Hi $name ${a + b}'`         |
| `r'...'`           | raw string                               | `$` আর `\n`-এর বিশেষ মানে থাকে না           | `r'$100'`                     |
| `'''...'''`        | multi-line string                        | একাধিক লাইনের স্ট্রিং                       |                               |
| `@`                | annotation                               | কম্পাইলার বা টুলকে তথ্য দেওয়া              | `@override`                   |
| `is` / `is!`       | টাইপ চেক                                 | এই টাইপের কিনা                              | `if (x is String)`            |
| `as`               | টাইপ কাস্ট                               | "এটাকে এই টাইপ ধরো", ভুল হলে crash          | `json['id'] as int`           |
| `~/`               | integer division                         | ভাগফলের পূর্ণ অংশ                           | `7 ~/ 2 // → 3`               |
| `? :`              | ternary                                  | ছোট if-else                                 | `ok ? 'Yes' : 'No'`           |
| `late`             | পরে মান বসবে                             | এখন না, ব্যবহারের আগে মান বসানো হবে         | `late Dio _dio;`              |

---

## ১. ভ্যারিয়েবল: var, final, const, late, dynamic

|                         |                                                                                                          |
| ----------------------- | -------------------------------------------------------------------------------------------------------- |
| **কী**                  | মান রাখার নামযুক্ত বাক্স। কোন শব্দ দিয়ে ঘোষণা করছেন, তা ঠিক করে মানটা বদলানো যাবে কিনা আর কখন জানা যাবে |
| **কেন লাগে**            | যে মান বদলাবে না সেটা `final` বা `const` রাখলে ভুল করে বদলে ফেলা যায় না                                 |
| **কীভাবে জীবন সহজ করে** | কম্পাইলার আগেই ভুল ধরে। `const` উইজেট Flutter-কে রিবিল্ড এড়াতে সাহায্য করে, ফলে অ্যাপ দ্রুত চলে         |

| শব্দ      | আবার মান দেওয়া যায়? | মান কখন জানা যায়  | কখন ব্যবহার করবেন                               |
| --------- | --------------------- | ------------------ | ----------------------------------------------- |
| `var`     | হ্যাঁ                 | runtime-এ          | লোকাল ভ্যারিয়েবল, যেটা বদলাবে                  |
| `final`   | না (একবারই)           | runtime-এ          | API থেকে আসা মান, অবজেক্ট, বেশিরভাগ ক্ষেত্রে    |
| `const`   | না                    | **কম্পাইলের সময়** | স্থির সংখ্যা, স্ট্রিং, `const` উইজেট            |
| `late`    | —                     | পরে, ব্যবহারের আগে | `initState`-এ মান বসবে এমন ফিল্ড                |
| `dynamic` | হ্যাঁ, যেকোনো টাইপে   | runtime-এ          | JSON-এর মতো অজানা টাইপের ডেটা (কম ব্যবহার করুন) |

**সহজ উদাহরণ**

```dart
var name = 'Rahim';                      // টাইপ নিজে থেকে String ধরা হয়
final createdAt = DateTime(2026, 11, 13); // runtime মান, একবারই বসে
const maxGuests = 10;                     // কম্পাইলের সময়েই জানা

final list = [1, 2];
list.add(3);       // ঠিক আছে! final মানে ভ্যারিয়েবল বদলাবে না, ভেতরের জিনিস বদলাতে পারে
// list = [9];     // এরর: final-এ নতুন লিস্ট বসানো যায় না

dynamic anything = 5;
anything = 'now a string';   // dynamic: টাইপ চেক বন্ধ
print(anything.length);      // → 12 (ভুল হলেও কম্পাইলার ধরবে না, runtime-এ crash)

late String token;           // এখন খালি
token = 'abc';               // ব্যবহারের আগে বসাতেই হবে
```

**বাস্তব উদাহরণ (TWG)**

- `static const`: [twg_api_client.dart:11-18](../lib/core/network/twg_api_client.dart#L11-L18)। `SERVER_URL`, `TOKEN_KEY` কখনো বদলায় না।
- `late`: [twg_api_client.dart:20](../lib/core/network/twg_api_client.dart#L20) `late Dio _dio;` constructor-এর ভেতরে `_initializeDio()`-এ বসে। আরেকটা [home_page.dart:85](../lib/features/home/presentation/pages/home_page.dart#L85) `late ProviderSubscription<int> _tabSub;` বসে `initState`-এ।

**খুঁটিনাটি**

- `final` লিস্টের ভেতরটা বদলানো যায়। পুরোপুরি অপরিবর্তনীয় চাইলে `const [1, 2]` বা `List.unmodifiable(...)`।
- `late` ভ্যারিয়েবল মান বসানোর আগে পড়লে `LateInitializationError` হয়।
- `dynamic` আর `Object?` এক না। `Object?`-এ মেথড ডাকার আগে টাইপ চেক করতে হয়, তাই এটা নিরাপদ।

---

## ২. টাইপ, সংখ্যা আর String

|                         |                                                                                                    |
| ----------------------- | -------------------------------------------------------------------------------------------------- |
| **কী**                  | `int` (পূর্ণ সংখ্যা), `double` (দশমিক), `num` (দুটোই), `String`, `bool`                            |
| **কেন লাগে**            | API থেকে দাম কখনো `120`, কখনো `120.5`, আবার কখনো `"120"` আসে। ঠিক টাইপে রূপান্তর না করলে crash হয় |
| **কীভাবে জীবন সহজ করে** | `tryParse` আর `toDouble()` দিয়ে যেকোনো আকারের সংখ্যা নিরাপদে নেওয়া যায়                          |

**সহজ উদাহরণ**

```dart
int a = 7;
double b = 2.5;
num c = a + b;                 // → 9.5
print(7 ~/ 2);                 // → 3   (পূর্ণ ভাগফল)
print(7 / 2);                  // → 3.5 (সবসময় double)
print(7 % 2);                  // → 1   (ভাগশেষ)

int.tryParse('42');            // → 42
int.tryParse('abc');           // → null (crash না!)
double.parse('3.14');          // → 3.14 (ভুল হলে crash, তাই tryParse ভালো)
(10 as num).toDouble();        // → 10.0
3.7.toInt();                   // → 3
3.14159.toStringAsFixed(2);    // → "3.14"

final user = 'Rahim';
print('Hello $user, you have ${2 + 3} bookings');  // → Hello Rahim, you have 5 bookings
print(r'Raw: $user \n');                            // → Raw: $user \n
```

**বাস্তব উদাহরণ (TWG)**

[workshop_models.dart:152-165](../lib/features/workshop/data/models/workshop_models.dart#L152-L165): API থেকে যে আকারেই আসুক, নিরাপদে সংখ্যা বানানো।

```dart
static double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();            // 120 বা 120.5
  if (value is String) return double.tryParse(value) ?? 0.0; // "120.5"
  return 0.0;
}
```

- টাকা দেখানো: [member_pricing.dart:25-29](../lib/core/utils/member_pricing.dart#L25-L29)-এ `toStringAsFixed`।
- interpolation: [twg_api_client.dart:49](../lib/core/network/twg_api_client.dart#L49) `'Bearer $token'`, আর [:15](../lib/core/network/twg_api_client.dart#L15) `'$SERVER_URL/api/v1'`।

**খুঁটিনাটি**

- `$name` যথেষ্ট যখন শুধু একটা ভ্যারিয়েবল। কোনো expression বা `.` লাগলে `${user.name}`।
- `int` হলো `num`, কিন্তু `int` সরাসরি `double` না। `double x = 5;` চলে (literal), কিন্তু `double x = someInt;` চলে না।

---

## ৩. Null safety: `?` `!` `??` `??=` `?.`

|                         |                                                                                                     |
| ----------------------- | --------------------------------------------------------------------------------------------------- |
| **কী**                  | Dart-এ ডিফল্টভাবে কোনো ভ্যারিয়েবল null হতে পারে না। null হতে দিতে হলে টাইপের পরে `?` লিখতে হয়     |
| **কেন লাগে**            | মোবাইল অ্যাপে সবচেয়ে বেশি crash হয় null-এ মেথড ডাকলে। API-র অনেক ফিল্ড ঐচ্ছিক (`phone`, `avatar`) |
| **কীভাবে জীবন সহজ করে** | কম্পাইলার জোর করে null সামলাতে বলে, তাই "Null check" crash অনেক কমে যায়                            |

**সহজ উদাহরণ**

```dart
String? phone;                       // null হতে পারে
print(phone?.length);                // → null  (crash না)
print(phone ?? 'No phone');          // → No phone
phone ??= '017';                     // null ছিল, তাই বসল
print(phone);                        // → 017

final p = Profile('Rahim');          // city দেওয়া হয়নি (String? city)
print(p.city?.toUpperCase() ?? 'Unknown city');  // → Unknown city

String? maybe = 'x';
print(maybe!.length);                // → 1   (! মানে "আমি নিশ্চিত null না")

final List<int>? ids = null;
print([0, ...?ids]);                 // → [0]
```

**বাস্তব উদাহরণ (TWG)**

- `??` দিয়ে বিকল্প key আর ডিফল্ট মান: [auth_response_models.dart:407-438](../lib/features/auth/data/models/auth_response_models.dart#L407-L438)
  ```dart
  firstName: json['first_name'] ?? json['firstName'] ?? '',   // snake_case না পেলে camelCase, তাও না পেলে ''
  cityId: json['city_id']?.toString(),                        // null হলে null, নইলে String
  ```
- `?.` দিয়ে চেইন: [main.dart:62-65](../lib/main.dart#L62-L65), `resolvePlatformSpecificImplementation<...>()?.createNotificationChannel(channel)`। iOS-এ Android-এর implementation null আসে, তাই কিছু হয় না।
- `!`: [app_session_state.dart:90](../lib/core/state/app_session_state.dart#L90) `_prefs!.getString(...)`। ঠিক আগের লাইনে `if (_prefs == null) return;` দিয়ে নিশ্চিত করা হয়েছে।

**খুঁটিনাটি**

- `!` যত কম ব্যবহার করবেন তত ভালো। প্রতিটা `!` হলো সম্ভাব্য crash: "Null check operator used on a null value"।
- **Smart cast:** `if (x != null) { x.length }`-এর ভেতরে Dart নিজেই বোঝে x null না। তবে এটা শুধু লোকাল ভ্যারিয়েবলে কাজ করে, ক্লাসের ফিল্ডে না। ফিল্ড হলে আগে `final local = field;` করে নিন।
- `required` named প্যারামিটার null-able হতে পারে (`required String? note`), মানে দিতেই হবে, কিন্তু null দেওয়া যাবে।

---

## ৪. দরকারি অপারেটর

**সহজ উদাহরণ**

```dart
// is: টাইপ চেক, আর চেকের পর smart cast
Object v = 'hello';
if (v is String) print(v.toUpperCase());   // → HELLO (এখানে v নিজে থেকেই String)

// as: জোর করে টাইপ ধরা (ভুল হলে crash)
final n = (42 as Object) as int;           // → 42

// ternary
final isMember = true;
print(isMember ? 'Member price' : 'Regular price');   // → Member price

// cascade (..): একই অবজেক্টে পরপর কাজ, শেষে অবজেক্টটাই ফেরত আসে
final sb = StringBuffer()
  ..write('A')
  ..write('B')
  ..write('C');
print(sb.toString());                      // → ABC

// ?.call(): ফাংশন null না হলে তবেই ডাকো
void Function(String)? onDone;
onDone?.call('skipped');                   // কিছুই হয় না
```

**বাস্তব উদাহরণ (TWG)**

- cascade: [invoice_view_page.dart:26-35](../lib/features/payment/presentation/pages/invoice_view_page.dart#L26-L35)
  ```dart
  _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(NavigationDelegate(...))
    ..loadRequest(Uri.parse(widget.viewUrl));
  ```
  cascade না থাকলে `_controller.` চারবার লিখতে হতো।
- `?.call`: [tier_calendar.dart:116](../lib/core/widgets/tier_calendar.dart#L116) `widget.onDaySelected?.call(day);`। callback দেওয়া থাকলে তবেই ডাকে।
- ternary: [member_pricing.dart:27](../lib/core/utils/member_pricing.dart#L27)

---

## ৫. List, Map, Set

|                         |                                                                                          |
| ----------------------- | ---------------------------------------------------------------------------------------- |
| **কী**                  | `List`: ক্রমানুসারে সাজানো, ডুপ্লিকেট চলে। `Map`: key থেকে value। `Set`: ডুপ্লিকেট ছাড়া |
| **কেন লাগে**            | প্রোডাক্টের লিস্ট (List), JSON অবজেক্ট (Map), ফেভারিট id-গুলো (Set)                      |
| **কীভাবে জীবন সহজ করে** | অনেক বিল্ট-ইন মেথড আছে, তাই লুপ লেখার দরকার কমে যায় (সেকশন ৮)                           |

**সহজ উদাহরণ**

```dart
final List<String> cities = ['Dhaka', 'Chattogram'];
final Map<String, int> stock = {'apple': 5, 'mango': 0};
final Set<int> ids = {1, 2, 2, 3};      // → {1, 2, 3} (ডুপ্লিকেট বাদ)

cities[0];                     // → Dhaka
cities.length;                 // → 2
stock['apple'];                // → 5
stock['banana'];               // → null (key না থাকলে null, crash না)
stock.containsKey('mango');    // → true
stock['banana'] = 7;           // নতুন key যোগ
stock.keys.toList();           // → [apple, mango, banana] (ঢোকানোর ক্রমেই থাকে)
```

**বাস্তব উদাহরণ (TWG)**

- Set: ডেমো playground-এ ফেভারিট post ([riverpod_playground.md, d07](riverpod_playground.md#৩৭-notifier))।
- List: [living_models.dart:86](../lib/features/living/data/models/living_models.dart#L86) `List<String>.from(json['room_types'] ?? [])`।

**খুঁটিনাটি**

- `{}` লিখলে Dart সেটাকে **Map** ধরে, Set না। খালি Set চাইলে `<int>{}`।
- Map-এ `map['x']`-এর ফল সবসময় nullable, কারণ key না-ও থাকতে পারে।

---

## ৬. `Map<String, dynamic>`

|                         |                                                                                                                                                                      |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **কী**                  | এমন Map, যার key সবসময় `String` আর value যেকোনো টাইপ (`dynamic`)                                                                                                    |
| **কেন লাগে**            | JSON অবজেক্ট ঠিক এই আকারের: `{"id": 1, "name": "Rahim", "tags": [...], "address": {...}}`। key সবসময় স্ট্রিং, কিন্তু value কখনো সংখ্যা, কখনো লিস্ট, কখনো আরেকটা Map |
| **কীভাবে জীবন সহজ করে** | `jsonDecode`-এর ফল সরাসরি এতে রাখা যায়, আর API-তে পাঠানোর body-ও এভাবে বানানো যায়                                                                                  |

**সহজ উদাহরণ**

```dart
final Map<String, dynamic> json = {
  'id': 1,
  'title': 'Sea View Suite',
  'price': 120,
  'tags': ['sea', 'vip'],
  'host': {'name': 'Rahim'},
};

final title = json['title'] as String;                         // টাইপ জানিয়ে নেওয়া
final price = (json['price'] as num).toDouble();               // int বা double যেকোনোটা
final host = json['host'] as Map<String, dynamic>;             // ভেতরের Map
final tags = List<String>.from(json['tags'] as List);          // ভেতরের List
final note = json['note'] as String? ?? '';                    // না থাকলে ডিফল্ট
```

**বাস্তব উদাহরণ (TWG)**

প্রজেক্টে `Map<String, dynamic>` আছে **623 বার**। সবচেয়ে বেশি দুই জায়গায়:

1. **মডেলে:** `factory X.fromJson(Map<String, dynamic> json)`। পুরো এক্সপ্লেনেশন সেকশন ২০-এ।
2. **API-তে পাঠানোর body:** [auth_response_models.dart:1001-1004](../lib/features/auth/data/models/auth_response_models.dart#L1001-L1004)
   ```dart
   Map<String, dynamic> toJson() => {
     'identity_token': identityToken,
     if (fullName != null) 'full_name': fullName,   // null হলে key-টাই যাবে না
   };
   ```

**খুঁটিনাটি**

- `json['price']` এর টাইপ `dynamic`, তাই এর উপর যা খুশি লেখা যায়, কম্পাইলার ধরে না। এজন্যই `as` দিয়ে টাইপ জানিয়ে নেওয়া ভালো অভ্যাস।
- `<String, dynamic>{}` দিয়ে খালি Map-এর টাইপ বলে দেওয়া যায় (দেখুন [workshop_repository.dart:85](../lib/features/workshop/data/repositories/workshop_repository.dart#L85))।

---

## ৭. collection if, for আর spread `...`

|                         |                                                                                  |
| ----------------------- | -------------------------------------------------------------------------------- |
| **কী**                  | List, Map বা Set বানানোর **ভেতরেই** `if`, `for` আর `...` লেখা যায়               |
| **কেন লাগে**            | শর্ত অনুযায়ী উইজেট দেখানো, ঐচ্ছিক key পাঠানো, পুরোনো লিস্টে নতুন আইটেম যোগ করা  |
| **কীভাবে জীবন সহজ করে** | `list.add(...)` দিয়ে ধাপে ধাপে বানাতে হয় না, এক জায়গায় পুরো কাঠামো দেখা যায় |

**সহজ উদাহরণ**

```dart
final cities = ['Dhaka', 'Chattogram'];
final isVip = true;
final List<int>? extra = null;

final menu = [
  'Home',
  if (isVip) 'VIP Lounge',               // শর্ত সত্য হলে যোগ
  for (final c in cities) 'Shop $c',     // লুপ চালিয়ে যোগ
  ...?extra?.map((e) => '$e'),           // null হলে কিছুই না
];
// → [Home, VIP Lounge, Shop Dhaka, Shop Chattogram]

final body = <String, dynamic>{
  'title': 'Hi',
  if (extra != null) 'extra': extra,     // Map-এও চলে
};
// → {title: Hi}
```

**বাস্তব উদাহরণ (TWG)**

- spread দিয়ে নতুন লিস্ট (immutable আপডেট): [riverpod_providers.dart:289-295](../lib/features/auth/presentation/providers/riverpod_providers.dart#L289-L295)
  ```dart
  final updated = isSelected
      ? state.selectedBrands.where((b) => b.id != brand.id).toList()   // বাদ দাও
      : [...state.selectedBrands, brand];                               // যোগ করো
  ```
- উইজেটে: `children: [..._timeGrid(), ..._eventCards(dayEvents)]`, দেখুন [calendar_page.dart:395](../lib/features/calendar/presentation/pages/calendar_page.dart#L395)।
- UI-তে শর্তসাপেক্ষ উইজেট: [login.dart:182-212](../lib/features/auth/presentation/pages/login.dart#L182-L212) `if (iOS && appleEnabled) ...[ ... ]`, এখানে spread দিয়ে একসাথে অনেক উইজেট যোগ।

---

## ৮. List-এর দরকারি মেথড

|                         |                                                                            |
| ----------------------- | -------------------------------------------------------------------------- |
| **কী**                  | লুপ না লিখে লিস্ট রূপান্তর, ফিল্টার আর হিসাব করার মেথড                     |
| **কেন লাগে**            | API-র লিস্ট থেকে মডেল বানানো, ফিল্টার, মোট দাম হিসাব                       |
| **কীভাবে জীবন সহজ করে** | পাঁচ লাইনের `for` লুপ এক লাইনে হয়ে যায়, আর কোড পড়লেই বোঝা যায় কী হচ্ছে |

**সহজ উদাহরণ** (`final prices = [120, 80, 200, 50];`)

| মেথড                                                   | কাজ                              | ফল                        |
| ------------------------------------------------------ | -------------------------------- | ------------------------- |
| `prices.map((p) => p * 2).toList()`                    | প্রতিটা বদলাও                    | `[240, 160, 400, 100]`    |
| `prices.where((p) => p > 100).toList()`                | ফিল্টার                          | `[120, 200]`              |
| `prices.firstWhere((p) => p > 100)`                    | প্রথম মিল                        | `120`                     |
| `prices.firstWhere((p) => p > 1000, orElse: () => -1)` | না মিললে ডিফল্ট                  | `-1`                      |
| `prices.any((p) => p < 60)`                            | একটাও মেলে কিনা                  | `true`                    |
| `prices.every((p) => p > 10)`                          | সবগুলো মেলে কিনা                 | `true`                    |
| `prices.fold<int>(0, (sum, p) => sum + p)`             | সব মিলিয়ে একটা মান              | `450`                     |
| `prices.reduce((a, b) => a > b ? a : b)`               | সবচেয়ে বড়                      | `200`                     |
| `[...prices]..sort()`                                  | কপি করে সাজাও                    | `[50, 80, 120, 200]`      |
| `prices.take(2).toList()` / `skip(2)`                  | প্রথম 2টা / প্রথম 2টা বাদে       | `[120, 80]` / `[200, 50]` |
| `['A', null, 'B'].whereType<String>().join(' • ')`     | null বাদ দিয়ে জোড়া             | `A • B`                   |
| `List<String>.from(raw)` / `raw.cast<String>()`        | `List<dynamic>` থেকে টাইপড লিস্ট | `[x, y]`                  |
| `List.generate(3, (i) => i * 10)`                      | বানানো                           | `[0, 10, 20]`             |
| `{for (final p in prices) 'p$p': p}`                   | List থেকে Map                    | `{p120: 120, …}`          |

**বাস্তব উদাহরণ (TWG)**

- JSON লিস্ট থেকে মডেলের লিস্ট: [living_models.dart:104-106](../lib/features/living/data/models/living_models.dart#L104-L106)
  ```dart
  amenities: ((json['amenities'] as List?) ?? [])
      .map((item) => LivingAmenity.fromJson(item as Map<String, dynamic>))
      .toList(),
  ```
- null বাদ দিয়ে নাম জোড়া: [auth_notifier.dart:239-243](../lib/features/auth/presentation/providers/auth_notifier.dart#L239-L243)
  ```dart
  final nameParts = [credential.givenName, credential.familyName]
      .whereType<String>()          // null বাদ
      .where((s) => s.isNotEmpty)   // খালি বাদ
      .toList();
  ```

**খুঁটিনাটি**

- `map` আর `where` **lazy**। এরা `Iterable` দেয়, তাই শেষে `.toList()` না দিলে List পাবেন না।
- `firstWhere` কিছু না পেলে crash করে (`StateError`)। তাই হয় `orElse:` দিন, নয়তো try/catch। TWG try/catch ব্যবহার করে: [riverpod_providers.dart:130-133](../lib/features/auth/presentation/providers/riverpod_providers.dart#L130-L133)।
- `sort()` আসল লিস্টটাকেই বদলে দেয় আর কিছু ফেরত দেয় না। তাই `[...list]..sort()` লিখে কপি করে সাজান।

---

## ৯. ফাংশন আর প্যারামিটার: positional, optional, named, required

|                         |                                                                                                                   |
| ----------------------- | ----------------------------------------------------------------------------------------------------------------- |
| **কী**                  | প্যারামিটার তিনভাবে দেওয়া যায়: positional (ক্রম অনুযায়ী), optional positional `[ ]`, আর named `{ }`            |
| **কেন লাগে**            | অনেক প্যারামিটার থাকলে named দিলে বোঝা যায় কোনটা কী। `required` দিলে জরুরি জিনিস দিতে ভুলে যাওয়া যায় না        |
| **কীভাবে জীবন সহজ করে** | `book(room: 'Suite', guests: 3)` পড়লেই মানে বোঝা যায়, অথচ `book('Suite', 3, null, true)` দেখে কিছু বোঝা যায় না |

| ধরন                 | ঘোষণা                   | ডাকা                | দিতেই হবে?          |
| ------------------- | ----------------------- | ------------------- | ------------------- |
| positional          | `f(int a)`              | `f(1)`              | হ্যাঁ, ক্রম মেনে    |
| optional positional | `f(int a, [int b = 0])` | `f(1)` বা `f(1, 2)` | না                  |
| named               | `f({int? b})`           | `f(b: 2)`           | না (null বা ডিফল্ট) |
| named + default     | `f({int b = 1})`        | `f()` বা `f(b: 3)`  | না                  |
| named + required    | `f({required int b})`   | `f(b: 2)`           | **হ্যাঁ**           |

**সহজ উদাহরণ**

```dart
int add(int a, int b) {           // সাধারণ
  return a + b;
}
int addArrow(int a, int b) => a + b;   // arrow: এক লাইনে

String greet(String name, [String greeting = 'Hello']) => '$greeting, $name';
greet('Rahim');              // → Hello, Rahim
greet('Rahim', 'Salam');     // → Salam, Rahim

String book({required String room, int guests = 1, String? note}) =>
    'room=$room guests=$guests note=${note ?? '-'}';
book(room: 'Suite');                                     // → room=Suite guests=1 note=-
book(guests: 3, room: 'Suite', note: 'late check-in');   // named হলে ক্রম যেকোনো

final square = (int x) => x * x;   // নামহীন (anonymous) ফাংশন
square(4);                          // → 16

var counter = 0;
void increment() => counter++;      // closure: বাইরের ভ্যারিয়েবল মনে রাখে
increment(); increment();
print(counter);                     // → 2
```

**বাস্তব উদাহরণ (TWG)**

- named + required: [payment_gateway_service.dart:24-29](../lib/core/payments/payment_gateway_service.dart#L24-L29)
  ```dart
  payForBooking({
    required String bookableType,
    required String bookableId,
    String? promoCodeId,            // ঐচ্ছিক
    String? stripePromotionCodeId,
  })
  ```
- optional positional: [auth_repository.dart:278](../lib/features/auth/data/repositories/auth_repository.dart#L278) `ApiException(this.message, [this.statusCode, this.validationErrors]);`, ডাকা হয় `ApiException('Login failed', response.statusCode)` দিয়ে।

---

## ১০. Function টাইপ, callback আর typedef

|                         |                                                                                           |
| ----------------------- | ----------------------------------------------------------------------------------------- |
| **কী**                  | Dart-এ ফাংশনও একটা মান। ভ্যারিয়েবলে রাখা যায়, প্যারামিটার হিসেবে পাঠানো যায় (callback) |
| **কেন লাগে**            | চাইল্ড উইজেট প্যারেন্টকে জানাবে "তারিখ বাছাই হলো", বাটন জানাবে "চাপা হলো"                 |
| **কীভাবে জীবন সহজ করে** | একটা উইজেট বানিয়ে অনেক জায়গায় ব্যবহার করা যায়। কী ঘটবে তা ঠিক করে যে ব্যবহার করছে সে  |

**সহজ উদাহরণ**

```dart
typedef PriceFormatter = String Function(double amount);   // টাইপের একটা নাম

void runFormatter(PriceFormatter f) => print(f(12.5));
runFormatter((a) => '\$${a.toStringAsFixed(2)}');          // → $12.50

void Function(DateTime)? onDaySelected;                      // nullable callback
onDaySelected?.call(DateTime(2026));                         // null, তাই কিছু হয় না
onDaySelected = (d) => print('picked ${d.year}');
onDaySelected?.call(DateTime(2026));                         // → picked 2026
```

**বাস্তব উদাহরণ (TWG)**

- উইজেটের callback: [tier_calendar.dart:9](../lib/core/widgets/tier_calendar.dart#L9) `final void Function(DateTime)? onDaySelected;` ডাকা হয় [:116](../lib/core/widgets/tier_calendar.dart#L116)-এ।
- typedef: [signature_page.dart:14-15](../lib/features/waiver/presentation/pages/signature_page.dart#L14-L15) `typedef WaiverSignatureCallback = void Function(String signatureType, String signatureValue);`
- async ফাংশন প্যারামিটার: [auth_interceptor.dart:6](../lib/core/network/interceptors/auth_interceptor.dart#L6) `final Future<String?> Function() getAccessToken;`

**খুঁটিনাটি:** Flutter-এর `VoidCallback` আসলে `void Function()`-এর typedef।

---

## ১১. ক্লাস আর constructor (সব ধরন)

|                         |                                                                                          |
| ----------------------- | ---------------------------------------------------------------------------------------- |
| **কী**                  | ক্লাস হলো ডেটা আর আচরণের নকশা। constructor দিয়ে সেই নকশা থেকে অবজেক্ট বানানো হয়        |
| **কেন লাগে**            | মডেল (`User`, `Booking`), সার্ভিস (`ApiClient`), উইজেট, সবই ক্লাস                        |
| **কীভাবে জীবন সহজ করে** | `this.x` shorthand, named প্যারামিটার আর factory দিয়ে অল্প কোডে নিরাপদ অবজেক্ট তৈরি হয় |

**সব ধরনের constructor, এক জায়গায়**

```dart
// ১. positional + this.x shorthand
class Room {
  Room(this.name, this.price);          // Room('Suite', 120)
  final String name;
  final double price;
}

// ২. named + required + ডিফল্ট + const (মডেল আর উইজেটে সবচেয়ে বেশি)
class Booking {
  const Booking({required this.roomId, this.guests = 1, this.note});
  final String roomId;
  final int guests;
  final String? note;
}
// const Booking(roomId: 'R1') → roomId=R1, guests=1, note=null

// ৩. optional positional [ ]
class ApiError implements Exception {
  ApiError(this.message, [this.statusCode]);
  final String message;
  final int? statusCode;
}
// ApiError('Not found', 404) বা ApiError('Offline')

// ৪. initializer list (:) — body চলার আগে final ফিল্ড বসানো
class Client {
  Client({required String baseUrl})
      : _baseUrl = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/' {
    print('Client ready for $_baseUrl');   // → Client ready for https://api.example.com/
  }
  final String _baseUrl;
}

// ৫. named constructor আর redirecting
class Money {
  const Money(this.amount, this.currency);
  const Money.usd(double amount) : this(amount, 'USD');   // অন্য constructor-এ পাঠায়
  Money.zero() : amount = 0, currency = 'USD';
  final double amount;
  final String currency;
}

// ৬. private constructor + singleton
class Session {
  Session._();                                   // বাইরে থেকে Session() লেখা যাবে না
  static final Session instance = Session._();   // একটাই অবজেক্ট
}

// ৭. super দিয়ে প্যারেন্টে পাঠানো
class Dog extends Animal {
  Dog(super.name);                               // Animal(name)-কে পাঠায়
}

// ৮. factory — নতুন অবজেক্ট বানানোর আগে লজিক চালানো যায় (যেমন JSON থেকে)
class Product {
  Product({required this.id, required this.title, required this.price});
  final int id;
  final String title;
  final double price;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as int,
        title: json['title'] as String? ?? 'Untitled',
        price: (json['price'] as num).toDouble(),
      );
}
```

**বাস্তব উদাহরণ (TWG)**

| ধরন                                    | TWG-তে                                                                                                                                                                 |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| named + required + `super.key` (উইজেট) | [app.dart:12](../lib/app/app.dart#L12) `const TwgApp({super.key, required this.apiClient});`                                                                           |
| named + ডিফল্ট (state)                 | [auth_state.dart:13-21](../lib/features/auth/presentation/providers/auth_state.dart#L13-L21) `this.isLoading = false`, `this.registrationStep = 1`                     |
| optional positional                    | [auth_repository.dart:278](../lib/features/auth/data/repositories/auth_repository.dart#L278)                                                                           |
| initializer list                       | [twg_api_client.dart:24-26](../lib/core/network/twg_api_client.dart#L24-L26) `TwgApiClient({required SharedPreferences prefs}) : _prefs = prefs { _initializeDio(); }` |
| প্যারেন্টকে শুরুর মান                  | [auth_notifier.dart:11](../lib/features/auth/presentation/providers/auth_notifier.dart#L11) `AuthNotifier(this._authRepository) : super(const AuthState());`           |
| private + singleton                    | [app_session_state.dart:53-55](../lib/core/state/app_session_state.dart#L53-L55) `AppSessionState._();` আর `static final instance`                                     |
| শুধু static মেথডের ক্লাস               | [member_pricing.dart:9](../lib/core/utils/member_pricing.dart#L9) `const MemberPricing._();` (অবজেক্ট বানানো বন্ধ)                                                     |
| factory fromJson                       | [living_models.dart:76](../lib/features/living/data/models/living_models.dart#L76) (প্রজেক্টে 149টা)                                                                   |

**খুঁটিনাটি**

- `const` constructor তখনই সম্ভব যখন সব ফিল্ড `final`।
- `super.key` উইজেটে লাগে, যাতে Flutter উইজেট চিনতে পারে। প্রায় সব উইজেটে থাকে (181 জায়গায়)।
- factory-র ভেতরে `this` থাকে না, আর factory নতুন অবজেক্ট না দিয়ে আগের কোনো অবজেক্টও ফেরত দিতে পারে।

---

## ১২. `_` (আন্ডারস্কোর): প্রাইভেট

|                         |                                                                                                |
| ----------------------- | ---------------------------------------------------------------------------------------------- |
| **কী**                  | নামের শুরুতে `_` দিলে সেটা শুধু **ঐ ফাইলের (library) ভেতরে** দেখা যায়                         |
| **কেন লাগে**            | ভেতরের খুঁটিনাটি (টোকেন, হেল্পার মেথড, ছোট উইজেট) বাইরে লুকিয়ে রাখা                           |
| **কীভাবে জীবন সহজ করে** | অন্য ফাইল থেকে ভুল করে ভেতরের জিনিস ব্যবহার বা বদলানো যায় না। আর বোঝা যায় কোনটা "public API" |

**সহজ উদাহরণ**

```dart
// cart.dart
class Cart {
  final _items = <String>[];          // বাইরে থেকে cart._items লেখা যাবে না
  int get count => _items.length;     // বাইরে শুধু সংখ্যাটা দেখানো হলো
  void add(String item) => _items.add(item);
}

class _CartBadge extends StatelessWidget { ... }   // শুধু এই ফাইলেই ব্যবহার
const _maxItems = 20;                               // top-level প্রাইভেট কনস্ট্যান্ট
```

**বাস্তব উদাহরণ (TWG)**

- প্রাইভেট ফিল্ড: [twg_api_client.dart:20-22](../lib/core/network/twg_api_client.dart#L20-L22) `_dio`, `_prefs`, `_secureStorage`। বাইরে থেকে শুধু `get()`, `post()` ব্যবহার করা যায়।
- প্রাইভেট মেথড: [login.dart:57](../lib/features/auth/presentation/pages/login.dart#L57) `Future<void> _handleLogin()`।
- প্রাইভেট উইজেট: [home_page.dart:230](../lib/features/home/presentation/pages/home_page.dart#L230) `class _AmmHomeBody`। হোম পেজের ভেতরের প্রায় 50টা ক্লাসই এমন।
- প্রাইভেট State: প্রতিটা `StatefulWidget`-এর `_XState` ক্লাস।
- প্রাইভেট constructor: সেকশন ১১-এর ৬ নম্বর।
- top-level প্রাইভেট: [signature_page.dart:17](../lib/features/waiver/presentation/pages/signature_page.dart#L17) `const _kSavedSigKey = 'twg_waiver_signature';`

**খুঁটিনাটি (জরুরি)**

- Dart-এ `private` কীওয়ার্ড নেই। আর `_` মানে **ফাইল-প্রাইভেট, ক্লাস-প্রাইভেট না**। একই ফাইলে থাকা অন্য ক্লাস `_items` দেখতে পারে।
- এজন্যই হোম পেজের 50টা `_XxxSection` ক্লাস একে অপরের প্রাইভেট জিনিস ব্যবহার করতে পারে, কারণ সব এক ফাইলে।

---

## ১৩. getter, setter, static

|                         |                                                                                                               |
| ----------------------- | ------------------------------------------------------------------------------------------------------------- |
| **কী**                  | **getter**: ফিল্ডের মতো দেখতে, কিন্তু আসলে হিসাব করা মান। **static**: অবজেক্টের না, ক্লাসের নিজের জিনিস       |
| **কেন লাগে**            | `isAdyen`, `isLoggedIn`-এর মতো হিসাব করা মান। আর কনস্ট্যান্ট এক জায়গায় রাখতে static                         |
| **কীভাবে জীবন সহজ করে** | `intent.isAdyen` পড়া অনেক সহজ `intent.paymentGateway == 'adyen'`-এর চেয়ে। আর হিসাবের নিয়ম এক জায়গায় থাকে |

**সহজ উদাহরণ**

```dart
class Cart {
  final _items = <String>[];
  int get count => _items.length;            // getter
  bool get isEmpty => _items.isEmpty;
  set firstItem(String v) => _items.insert(0, v);   // setter: cart.firstItem = 'Z'
  static const maxItems = 20;                // Cart.maxItems
  static int created = 0;                    // সব অবজেক্টের জন্য একটাই
}

abstract final class AppColors {             // অবজেক্ট বানানো আর extend করা দুটোই বন্ধ
  static const primary = 0xFF1E88E5;         // শুধু কনস্ট্যান্টের ঘর
}
```

**বাস্তব উদাহরণ (TWG)**

- getter: [payment_models.dart:41](../lib/features/payment/data/models/payment_models.dart#L41) `bool get isAdyen => paymentGateway == 'adyen';`
- হিসাব করা getter: [app_session_state.dart:141-147](../lib/core/state/app_session_state.dart#L141-L147) `String get selectedCity`
- কনস্ট্যান্টের ক্লাস: [route_names.dart:1-25](../lib/app/router/route_names.dart#L1-L25) `abstract final class RouteNames { static const login = '/login'; ... }`। ব্যবহার হয় `RouteNames.login` দিয়ে।

---

## ১৪. extends, implements, with, abstract

|                         |                                                                                                                                                                                                             |
| ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **কী**                  | **extends**: উত্তরাধিকার (প্যারেন্টের কোড পাওয়া)। **implements**: চুক্তি মানা (সব মেথড নিজে লিখতে হয়)। **with**: mixin (কিছু ক্ষমতা ধার নেওয়া)। **abstract**: অর্ধেক নকশা, সরাসরি অবজেক্ট বানানো যায় না |
| **কেন লাগে**            | একই ইন্টারফেসের অনেক বাস্তবায়ন (Stripe/Adyen), প্যারেন্টের কোড পুনর্ব্যবহার, lifecycle শোনার ক্ষমতা যোগ                                                                                                    |
| **কীভাবে জীবন সহজ করে** | টেস্টে আসল repository-র জায়গায় নকল বসানো যায়, আর একই কোড বারবার লিখতে হয় না                                                                                                                             |

**সহজ উদাহরণ**

```dart
abstract class PaymentGateway {        // চুক্তি
  Future<bool> pay(double amount);
  String get name;
}

class StripeGateway implements PaymentGateway {   // চুক্তি মানছে
  @override
  String get name => 'Stripe';
  @override
  Future<bool> pay(double amount) async => amount > 0;
}

mixin Logger {                          // ধার দেওয়ার মতো ক্ষমতা
  final logs = <String>[];
  void log(String m) => logs.add('[$runtimeType] $m');
}

class OrderService with Logger {
  void place() => log('order placed');
}
// OrderService()..place() → logs: [[OrderService] order placed]
```

**বাস্তব উদাহরণ (TWG)**

- abstract interface + implements: [living_repository.dart:15-25](../lib/features/living/data/repositories/living_repository.dart#L15-L25) `abstract class ILivingRepository` আর `class LivingRepository implements ILivingRepository`।
- exception: [auth_repository.dart:273](../lib/features/auth/data/repositories/auth_repository.dart#L273) `class ApiException implements Exception`।
- mixin: [home_page.dart:82-83](../lib/features/home/presentation/pages/home_page.dart#L82-L83) `extends ConsumerState<HomePage> with WidgetsBindingObserver`। এর ফলে [:105-111](../lib/features/home/presentation/pages/home_page.dart#L105-L111)-এ `didChangeAppLifecycleState` override করা যায়।
- extends: প্রতিটা উইজেট `extends StatelessWidget` বা `ConsumerWidget`।

**খুঁটিনাটি:** একটা ক্লাস একটাই `extends` করতে পারে, কিন্তু যত খুশি `implements` আর `with`।

---

## ১৫. enum

|                         |                                                                                                                         |
| ----------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| **কী**                  | নির্দিষ্ট কিছু মানের তালিকা, যার বাইরে কিছু হতে পারে না                                                                 |
| **কেন লাগে**            | পেমেন্টের ফল (success/cancelled/failed), ব্র্যান্ড, বুকিং স্ট্যাটাস। String হলে টাইপো হয় (`'sucess'`), enum হলে হয় না |
| **কীভাবে জীবন সহজ করে** | `switch`-এ কোনো case বাদ পড়লে কম্পাইলার নিজেই সতর্ক করে                                                                |

**সহজ উদাহরণ**

```dart
enum BannerType { twg, amm, ss }

const t = BannerType.amm;
t.name;                  // → amm
t.index;                 // → 1
BannerType.values;       // সবগুলো

final label = switch (t) {        // সব case না দিলে কম্পাইল এরর
  BannerType.twg => 'TWG',
  BannerType.amm => 'A Ma Maniere',
  BannerType.ss => 'Social Status',
};                                 // → A Ma Maniere

// enhanced enum: ফিল্ড, constructor আর মেথডসহ
enum BookingStatus {
  pending('Pending', 0xFFFFA000),
  confirmed('Confirmed', 0xFF43A047),
  cancelled('Cancelled', 0xFFE53935);

  const BookingStatus(this.label, this.color);
  final String label;
  final int color;

  bool get isFinal => this != pending;

  static BookingStatus fromApi(String value) =>
      values.firstWhere((s) => s.name == value, orElse: () => pending);
}
// BookingStatus.fromApi('confirmed').label → Confirmed
// BookingStatus.fromApi('weird').label     → Pending
```

**বাস্তব উদাহরণ (TWG)**

- [app_session_state.dart:4](../lib/core/state/app_session_state.dart#L4) `enum BannerType { twg, amm, ss, apb, jaide }`, আর [:37-50](../lib/core/state/app_session_state.dart#L37-L50)-এ `switch` দিয়ে নাম।
- [payment_gateway_service.dart:6](../lib/core/payments/payment_gateway_service.dart#L6) `enum PaymentFlowResult { success, cancelled, failed }`

**প্রজেক্টে যা নেই:** TWG-তে enhanced enum নেই। স্ট্যাটাসগুলো বেশিরভাগ String হিসেবে রাখা (যেমন `status: json['status'] ?? 'published'`)। উপরের `BookingStatus`-এর মতো enum দিলে টাইপো ধরা পড়ত।

---

## ১৬. extension

|                         |                                                                                                      |
| ----------------------- | ---------------------------------------------------------------------------------------------------- |
| **কী**                  | কারো ক্লাস না বদলে তাতে নতুন মেথড বা getter যোগ করা (String, double, এমনকি অন্যের প্যাকেজের ক্লাসেও) |
| **কেন লাগে**            | `12.5.asUsd`, `email.isValidEmail`-এর মতো ছোট সহায়ক, যেগুলো বারবার লাগে                             |
| **কীভাবে জীবন সহজ করে** | `Utils.formatUsd(price)` না লিখে `price.asUsd` লেখা যায়। পড়তে স্বাভাবিক লাগে                       |

**সহজ উদাহরণ**

```dart
extension PriceX on double {
  String get asUsd => '\$${toStringAsFixed(2)}';
}
12.5.asUsd;                       // → $12.50

extension StringX on String? {
  bool get isNullOrBlank => this == null || this!.trim().isEmpty;
}
String? a;
a.isNullOrBlank;                  // → true

extension LetX<T> on T {          // generic extension: যেকোনো টাইপে
  R let<R>(R Function(T) block) => block(this);
}
final int? maybeId = 7;
maybeId?.let((id) => 'id=$id');   // → id=7
```

**বাস্তব উদাহরণ (TWG):** [beach_review_booking_page.dart:537-539](../lib/features/beach/presentation/pages/beach_review_booking_page.dart#L537-L539)। ঠিক উপরের `LetX`-এর মতো `extension _Let<T> on T`। প্রজেক্টে এটাই একমাত্র extension। আর লেসন 06-এ `cacheFor` আরেকটা উদাহরণ ([riverpod_playground.md](riverpod_playground.md#৩৬-autodispose-আর-lifecycle))।

---

## ১৭. Immutable ক্লাস আর copyWith

|                         |                                                                                                                                                              |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **কী**                  | **Immutable:** অবজেক্ট একবার বানালে আর বদলানো যায় না (সব ফিল্ড `final`)। **copyWith:** পুরোনো অবজেক্ট থেকে কয়েকটা ফিল্ড বদলে **নতুন** অবজেক্ট বানানোর মেথড |
| **কেন লাগে**            | Riverpod বা যেকোনো স্টেট ম্যানেজমেন্ট বোঝে স্টেট বদলেছে তখনই, যখন **নতুন অবজেক্ট** আসে। পুরোনো অবজেক্টের ভেতর বদলালে UI আপডেট হয় না                         |
| **কীভাবে জীবন সহজ করে** | 7টা ফিল্ডের স্টেট থেকে শুধু `isLoading` বদলাতে বাকি 6টা আবার লিখতে হয় না: `state.copyWith(isLoading: true)`                                                 |

**সহজ উদাহরণ**

```dart
class AuthState {
  const AuthState({this.isLoading = false, this.userName, this.error});
  final bool isLoading;
  final String? userName;
  final String? error;

  AuthState copyWith({bool? isLoading, String? userName, String? error}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,   // নতুন দিলে নতুন, না দিলে পুরোনো
      userName: userName ?? this.userName,
      error: error ?? this.error,
    );
  }
}

const s1 = AuthState();
final s2 = s1.copyWith(isLoading: true);
final s3 = s2.copyWith(isLoading: false, userName: 'Rahim');
// s1 → (isLoading: false, userName: null,  error: null)   ← বদলায়নি
// s2 → (isLoading: true,  userName: null,  error: null)
// s3 → (isLoading: false, userName: Rahim, error: null)
identical(s1, s2);   // → false (আলাদা অবজেক্ট, তাই Riverpod বোঝে বদলেছে)
```

**বড় ফাঁদ: copyWith দিয়ে null বসানো যায় না**

```dart
final e1 = s3.copyWith(error: 'Wrong password');
final e2 = e1.copyWith(error: null);   // error মুছতে চাইলাম…
print(e2.error);                        // → Wrong password  😬 মোছেনি!
```

কারণ `error ?? this.error`-এ `null` দিলে পুরোনো মানটাই নেয়। তিনটা সমাধান আছে:

| সমাধান                                | কোড                                                                                                                                    | কেমন                                                                                                    |
| ------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| **ক. `??` বাদ দেওয়া** (TWG যা করেছে) | `error: error,`                                                                                                                        | `error` না পাঠালেই মুছে যায়। সহজ, কিন্তু অন্য কিছু আপডেট করার সময় এরর রাখতে চাইলে প্রতিবার পাঠাতে হয় |
| **খ. clear ফ্ল্যাগ**                  | `copyWith({String? error, bool clearError = false})` আর `error: clearError ? null : (error ?? this.error)`                             | স্পষ্ট বোঝা যায়                                                                                        |
| **গ. ফাংশন পাঠানো**                   | `copyWith({String? Function()? error})` আর `error: error != null ? error() : this.error`, ডাকা হয় `copyWith(error: () => null)` দিয়ে | সবচেয়ে নিখুঁত, তবে দেখতে একটু অদ্ভুত                                                                   |

**বাস্তব উদাহরণ (TWG)**

- [auth_state.dart:23-41](../lib/features/auth/presentation/providers/auth_state.dart#L23-L41)। লক্ষ করুন [:36](../lib/features/auth/presentation/providers/auth_state.dart#L36) `error: error,`, মানে সমাধান **ক**।
- ব্যবহার: [auth_notifier.dart:115-122](../lib/features/auth/presentation/providers/auth_notifier.dart#L115-L122)
  ```dart
  state = state.copyWith(
    isLoading: false,
    currentUser: response.data.user,
    accessToken: response.data.accessToken,
    isLoggedIn: true,
  );
  ```
- মডেলেও আছে: [auth_response_models.dart:484](../lib/features/auth/data/models/auth_response_models.dart#L484) `MemberProfile copyWith({...})`, প্রায় 30টা ফিল্ডসহ। প্রজেক্টে মোট 20টা copyWith।

**খুঁটিনাটি**

- লিস্ট ফিল্ড থাকলে নতুন লিস্ট বানিয়ে পাঠান: `copyWith(items: [...items, x])`। `items.add(x)` করবেন না (সেকশন ৭)।
- অনেক ফিল্ড হলে হাতে লেখা ঝামেলার। তখন `freezed` প্যাকেজ copyWith, `==` আর JSON নিজেই বানিয়ে দেয়। TWG-তে এটা নেই।

---

## ১৮. `==` আর `hashCode`

|                         |                                                                                                                               |
| ----------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| **কী**                  | ডিফল্টভাবে দুটো অবজেক্ট `==` হয় শুধু তখনই, যখন ঠিক একই অবজেক্ট। মান মিলিয়ে তুলনা চাইলে `==` আর `hashCode` override করতে হয় |
| **কেন লাগে**            | Riverpod-এর `.family`, Map-এর key আর Set, সবাই `==` দিয়ে চেনে কোন দুটো "একই"                                                 |
| **কীভাবে জীবন সহজ করে** | একই প্যারামিটারে আবার API কল হয় না, cache কাজ করে                                                                            |

**সহজ উদাহরণ**

```dart
class Point {
  const Point(this.x, this.y);
  final int x, y;
  @override
  bool operator ==(Object other) => other is Point && other.x == x && other.y == y;
  @override
  int get hashCode => Object.hash(x, y);   // == বদলালে hashCode-ও বদলাতে হবে
}

class PlainPoint {
  const PlainPoint(this.x);
  final int x;
}

Point(1, 2) == Point(1, 2);           // → true
PlainPoint(1) == PlainPoint(1);       // → false (override নেই)
{Point(1, 2), Point(1, 2)}.length;    // → 1
(1, 'a') == (1, 'a');                 // → true  (record-এ এটা নিজে থেকেই হয়!)
```

**বাস্তব উদাহরণ (TWG):** [shopify_providers.dart:102-116](../lib/features/shop/presentation/providers/shopify_providers.dart#L102-L116)। `CollectionProductsArgs` একটা Riverpod family-র প্যারামিটার। এখানে `==` না থাকলে প্রতিবার রিবিল্ডে নতুন অবজেক্ট আসত, provider ভাবত নতুন প্যারামিটার, আর **প্রতিবার আবার API কল হতো**।

**খুঁটিনাটি:** একাধিক প্যারামিটারের সহজ সমাধান হলো record, যেমন `({String storeId, String handle})`। record-এ `==` নিজে থেকেই থাকে (playground-এর d05-এ এভাবে করা)।

---

## ১৯. Generics `<>` (অ্যাঙ্গেল ব্র্যাকেট)

|                         |                                                                                                                                          |
| ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| **কী**                  | `<T>` মানে "**কোন টাইপের** জিনিস"। `List<String>` মানে স্ট্রিংয়ের লিস্ট, `Future<User>` মানে ভবিষ্যতে একটা User আসবে                    |
| **কেন লাগে**            | একই কোড (List, Future, Provider, ApiResponse) অনেক টাইপের সাথে কাজ করে, অথচ টাইপের নিরাপত্তাও থাকে                                       |
| **কীভাবে জীবন সহজ করে** | `users.first.name` লিখলে কম্পাইলার জানে এটা User, তাই autocomplete কাজ করে আর ভুল আগেই ধরা পড়ে। `<>` না থাকলে সবকিছু `dynamic` হয়ে যেত |

**কোথায় কোথায় `<>` দেখবেন**

| লেখা                                                        | পড়বেন এভাবে                                             |
| ----------------------------------------------------------- | -------------------------------------------------------- |
| `List<String>`                                              | স্ট্রিংয়ের লিস্ট                                        |
| `Map<String, dynamic>`                                      | key স্ট্রিং, value যেকোনো কিছু                           |
| `Map<String, List<int>>`                                    | key স্ট্রিং, value হলো int-এর লিস্ট                      |
| `Future<void>`                                              | ভবিষ্যতে শেষ হবে, কিছু ফেরত দেবে না                      |
| `Future<List<User>>`                                        | ভবিষ্যতে User-এর একটা লিস্ট আসবে                         |
| `Stream<int>`                                               | সময়ের সাথে বারবার int আসবে                              |
| `ApiResponse<T>`                                            | যেকোনো টাইপের ডেটা মোড়ানো রেসপন্স (নিজের generic ক্লাস) |
| `T firstOr<T>(...)`                                         | generic ফাংশন                                            |
| `<T extends num>`                                           | T হতে হবে num বা তার সন্তান (int, double)                |
| `Provider<TwgApiClient>`                                    | TwgApiClient দেয় এমন provider                           |
| `StateNotifierProvider<AuthNotifier, AuthState>`            | notifier ক্লাস AuthNotifier, আর স্টেট AuthState          |
| `.whereType<String>()`, `.cast<String>()`, `fold<int>(...)` | মেথডেও টাইপ বলে দেওয়া যায়                              |
| `<String, dynamic>{}`                                       | খালি Map, কিন্তু টাইপ বলা                                |

**সহজ উদাহরণ**

```dart
class ApiResponse<T> {                       // নিজের generic ক্লাস
  ApiResponse({required this.success, this.data});
  final bool success;
  final T? data;
}

final r1 = ApiResponse<int>(success: true, data: 5);
final r2 = ApiResponse<List<String>>(success: true, data: ['A', 'B']);
r1.data! + 1;         // → 6  (কম্পাইলার জানে data হলো int)
r2.data!.length;      // → 2  (জানে data হলো List)

T firstOr<T>(List<T> items, T fallback) => items.isEmpty ? fallback : items.first;
firstOr<String>([], 'empty');   // → empty
firstOr([3, 4], 0);             // → 3 (টাইপ নিজে থেকে int ধরে নেয়)

class Box<T extends num> {      // শুধু সংখ্যা চলবে
  Box(this.value);
  final T value;
  double doubled() => value * 2.0;
}
Box(4).doubled();               // → 8.0
// Box('x');                    // কম্পাইল এরর
```

**বাস্তব উদাহরণ (TWG)**

- নিজের generic ক্লাস: [auth_response_models.dart:157-180](../lib/features/auth/data/models/auth_response_models.dart#L157-L180)
  ```dart
  class ApiResponse<T> {
    final bool success;
    final String message;
    final T? data;
    ...
    factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic)? fromJsonT,    // T বানানোর ফাংশন বাইরে থেকে আসে
    ) { ... }
  }
  ```
  ব্যবহার: [auth_repository.dart:7](../lib/features/auth/data/repositories/auth_repository.dart#L7) `Future<ApiResponse<Map<String, dynamic>>> resendOtp(...)`। ভেতর থেকে বাইরে পড়ুন: একটা Map, সেটা ApiResponse-এ মোড়ানো, আর সেটা ভবিষ্যতে আসবে।
- Riverpod: [riverpod_providers.dart:50](../lib/features/auth/presentation/providers/riverpod_providers.dart#L50) `StateNotifierProvider<AuthNotifier, AuthState>`, আর [living_providers.dart:23](../lib/features/living/presentation/providers/living_providers.dart#L23) `FutureProvider.family<LivingListResponse, int>` (ফলাফলের টাইপ, তারপর প্যারামিটারের টাইপ)।
- generic extension: সেকশন ১৬-এর `_Let<T>`।

**খুঁটিনাটি**

- লম্বা generic পড়ার কৌশল: **ভেতর থেকে বাইরে** পড়ুন।
- `T` শুধু একটা নাম। যেকোনো নাম দেওয়া যায়, তবে প্রথা হলো `T` (type), `E` (element), `K`/`V` (key/value), `R` (return)।
- টাইপ না লিখলে Dart অনুমান করে (`var list = <int>[];`)। কিন্তু `[]` লিখলে হয় `List<dynamic>`, তাই খালি কালেকশনে টাইপ লিখে দিন।

---

## ২০. JSON: jsonDecode → fromJson → toJson → jsonEncode

|                         |                                                                                                                                                          |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **কী**                  | সার্ভার আর অ্যাপের মধ্যে ডেটা আসা-যাওয়া করে JSON **স্ট্রিং** হিসেবে। Dart-এ সেটাকে টাইপড অবজেক্ট (মডেল) বানাতে হয়, আবার পাঠানোর আগে স্ট্রিং বানাতে হয় |
| **কেন লাগে**            | `json['propety_name']`-এর মতো টাইপো সারা অ্যাপে ছড়িয়ে থাকলে খুঁজে পাওয়া কঠিন। মডেল থাকলে লেখা হয় `living.propertyName`, আর ভুল হলে কম্পাইলার ধরে     |
| **কীভাবে জীবন সহজ করে** | JSON থেকে মডেলে রূপান্তর এক জায়গায় (`fromJson`) হয়। API বদলালে শুধু সেখানেই ঠিক করতে হয়                                                              |

**পুরো যাত্রা**

```text
সার্ভার  ── '{"id":1,"price":120}' (String) ──▶  jsonDecode()  ──▶  Map<String, dynamic>
                                                                       │
                                                         Product.fromJson(map)
                                                                       ▼
                                                                Product (টাইপড মডেল)
                                                                       │
                                                         product.toJson()
                                                                       ▼
সার্ভার  ◀── '{"id":1,"price":120.0}' (String) ──  jsonEncode()  ◀── Map<String, dynamic>
```

**সহজ উদাহরণ**

```dart
import 'dart:convert';    // jsonDecode, jsonEncode এখানে থাকে

class Product {
  Product({required this.id, required this.title, required this.price});
  final int id;
  final String title;
  final double price;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as int,
        title: json['title'] as String? ?? 'Untitled',   // null হলে ডিফল্ট
        price: (json['price'] as num).toDouble(),        // 120 বা 120.5 দুটোই চলবে
      );

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'price': price};
}

const body = '{"id": 1, "title": "Sea View Suite", "price": 120, "tags": ["sea", "vip"], "host": {"name": "Rahim"}}';

final map = jsonDecode(body) as Map<String, dynamic>;   // String → Map
map['price'].runtimeType;                               // → int (120, 120.0 না!)
final tags = List<String>.from(map['tags'] as List);    // → [sea, vip]
final host = (map['host'] as Map<String, dynamic>)['name'];   // → Rahim

final p = Product.fromJson(map);                        // Map → মডেল
p.price;                                                // → 120.0 (double)

jsonEncode(p.toJson());                                 // মডেল → String
// → {"id":1,"title":"Sea View Suite","price":120.0}

// লিস্ট
const listBody = '[{"id": 1, "title": "A", "price": 1.5}, {"id": 2, "title": null, "price": 2}]';
final products = (jsonDecode(listBody) as List)
    .map((e) => Product.fromJson(e as Map<String, dynamic>))
    .toList();
// → [A:1.5, Untitled:2.0]
```

**সবচেয়ে কমন crash, যেটা যাচাই করে দেখা হয়েছে:**

```dart
final bad = jsonDecode('{"price": 120}') as Map<String, dynamic>;
final double price = bad['price'];   // 💥 TypeError: 'int' is not a subtype of 'double'
// ঠিক উপায়: (bad['price'] as num).toDouble()
```

**বাস্তব উদাহরণ (TWG)**

- **jsonEncode/jsonDecode দিয়ে লোকালে সেভ:** [twg_api_client.dart:108-118](../lib/core/network/twg_api_client.dart#L108-L118)
  ```dart
  await _prefs.setString(USER_KEY, jsonEncode(userData));   // Map → String → সেভ
  ...
  return jsonDecode(jsonString);                            // String → Map
  ```
- **নোটিফিকেশনের payload:** [notification_service.dart:162](../lib/core/notifications/notification_service.dart#L162) `payload: jsonEncode(data)`, আর ফেরত [:96-97](../lib/core/notifications/notification_service.dart#L96-L97) `jsonDecode(details.payload!) as Map<String, dynamic>`।
- **জটিল fromJson:** [living_models.dart:76-110](../lib/features/living/data/models/living_models.dart#L76-L110)। এখানে সবকিছুর উদাহরণ আছে:
  ```dart
  brand: json['brand'] != null                                          // nested অবজেক্ট (null হতে পারে)
      ? LivingBrand.fromJson(json['brand'] as Map<String, dynamic>)
      : null,
  roomTypes: List<String>.from(json['room_types'] ?? []),               // স্ট্রিংয়ের লিস্ট
  basePrice: _parseDouble(json['base_price']),                          // নিরাপদ সংখ্যা
  priceOnRequest: json['price_on_request'] == true,                     // bool নিরাপদে
  amenities: ((json['amenities'] as List?) ?? [])                       // মডেলের লিস্ট
      .map((item) => LivingAmenity.fromJson(item as Map<String, dynamic>))
      .toList(),
  ```
- **সার্ভার অসঙ্গত হলে:** [auth_response_models.dart:407-429](../lib/features/auth/data/models/auth_response_models.dart#L407-L429)। একই ফিল্ড কখনো `first_name`, কখনো `firstName` আসে, আর `registration_step` কখনো String, কখনো int। `??` চেইন আর `int.tryParse` দিয়ে সামলানো হয়েছে।

**খুঁটিনাটি**

- `jsonDecode`-এর ফল আসলে `_Map<String, dynamic>`। তাই `as Map<String, dynamic>` লিখলে কাজ চলে।
- নেস্টেড লিস্টের ভেতরের প্রতিটা আইটেমও `dynamic`। তাই `.map((e) => X.fromJson(e as Map<String, dynamic>))` লাগে।
- তারিখ: `DateTime.parse('2026-11-13T10:30:00Z')` (ভুল হলে crash), `DateTime.tryParse('not a date')` → null। UI-তে দেখানোর আগে `.toLocal()`।
- TWG-র 149টা `fromJson` সব হাতে লেখা। কোড জেনারেশন (`json_serializable`) দিয়ে এগুলো নিজে থেকে বানানো যায়, দেখুন [লেসন 12](12_dev_tools.md)।

---

## ২১. Future, async, await

|                         |                                                                                                                                                                                                                |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **কী**                  | **Future:** এমন একটা মান যেটা **পরে** আসবে (API-র উত্তর, ফাইল পড়া)। **async:** ফাংশনটা Future ফেরত দেবে। **await:** Future শেষ হওয়া পর্যন্ত এই ফাংশনের পরের লাইনগুলো থামিয়ে রাখা, কিন্তু অ্যাপ (UI) থামে না |
| **কেন লাগে**            | API কলে সময় লাগে। অপেক্ষার সময় UI জমে গেলে অ্যাপ "not responding" হয়ে যেত                                                                                                                                   |
| **কীভাবে জীবন সহজ করে** | async কোড সাধারণ কোডের মতো ওপর থেকে নিচে পড়া যায়, callback-এর জট (`.then().then()`) লাগে না                                                                                                                  |

**সহজ উদাহরণ** (চালানোর ক্রম নম্বর দিয়ে দেখানো)

```dart
Future<String> fetchUser() async {
  await Future<void>.delayed(const Duration(milliseconds: 100));   // নেটওয়ার্কের ভান
  return 'Rahim';                    // Future<String>, যদিও লিখছি শুধু String
}

Future<void> demo() async {
  print('1. start');
  final name = await fetchUser();    // এখানে অপেক্ষা
  print('2. got $name');

  // একটার পর একটা: প্রায় 200ms
  await fetchUser();
  await fetchCount();

  // একসাথে (parallel): প্রায় 100ms
  final results = await Future.wait([fetchUser(), fetchCount()]);
  print('3. ${results[0]} ${results[1]}');                 // → 3. Rahim 3

  // Dart 3: record দিয়ে আলাদা টাইপে একসাথে
  final (user, count) = await (fetchUser(), fetchCount()).wait;

  // then: অপেক্ষা না করে "পরে এটা করো"
  fetchUser().then((n) => print('6. then: $n'));
  print('5. after then (not waiting)');                    // এটা আগে ছাপে!

  try {
    await failingCall();
  } on ApiError catch (e) {
    print('7. caught $e');
  } finally {
    print('8. finally always runs');
  }

  Future.microtask(() => print('10. microtask'));
  print('9. sync code first');                             // microtask-এর আগে
}
```

| জিনিস                 | কাজ                                                          |
| --------------------- | ------------------------------------------------------------ |
| `Future<T>`           | পরে একটা T আসবে                                              |
| `Future<void>`        | পরে শেষ হবে, কিছু ফেরত দেবে না                               |
| `async`               | ফাংশনের ভেতরে `await` ব্যবহার করা যাবে, আর ফাংশন Future দেবে |
| `await x`             | x শেষ হওয়া পর্যন্ত **এই ফাংশন** থামবে                       |
| `Future.wait([...])`  | সব একসাথে শুরু, সব শেষ হলে ফল                                |
| `Future.delayed(d)`   | কিছুক্ষণ অপেক্ষা                                             |
| `Future.microtask(f)` | এখনকার কোড শেষ হলেই সাথে সাথে চালাও                          |
| `Future.value(x)`     | এখনই তৈরি থাকা Future                                        |
| `unawaited(f)`        | ইচ্ছা করে অপেক্ষা না করা (`dart:async`)                      |

**বাস্তব উদাহরণ (TWG)**

- **Splash-এর পুরো async ফ্লো:** [splash_page.dart:25-69](../lib/features/splash/presentation/pages/splash_page.dart#L25-L69)
  ```dart
  Future<void> _resolveInitialRoute() async {
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;                                 // ← Flutter-এর জরুরি নিয়ম
    final bool hasToken = await apiClient.isAuthenticated();
    ...
    final response = await apiClient.get('/member/auth/profile');
    if (!mounted) return;
  ```
- **একসাথে তিনটা API কল:** [shopify_providers.dart:66-70](../lib/features/shop/presentation/providers/shopify_providers.dart#L66-L70)
  ```dart
  final results = await Future.wait([
    repo.getBrandCollections(brandId: brandId, limit: 8),
    repo.getCategories(brandId: brandId),
    repo.getAllStoresProducts(brandId: brandId, limit: 6),
  ]);
  ```
  একটার পর একটা চালালে তিনগুণ সময় লাগত।
- **build শেষ হওয়ার পর চালানো:** [home_page.dart:99-102](../lib/features/home/presentation/pages/home_page.dart#L99-L102), [app.dart:22](../lib/app/app.dart#L22) `Future.microtask(...)`।
- **finally দিয়ে পরিষ্কার:** [auth_repository.dart:252-260](../lib/features/auth/data/repositories/auth_repository.dart#L252-L260)। লগআউট API ব্যর্থ হলেও টোকেন মোছা হবে।

**খুঁটিনাটি (Flutter-এ জরুরি)**

- **`await`-এর পর `mounted` চেক।** অপেক্ষার মাঝে ইউজার পেজ বন্ধ করে দিলে `context` আর বৈধ থাকে না। State-এ `if (!mounted) return;`, অন্য জায়গায় `if (!context.mounted) return;`। TWG-তে analyzer এটা নিয়ে 8টা সতর্কতা দেয় ([লেসন 12](12_dev_tools.md))।
- `async` ফাংশন থেকে কোনো এরর ছুড়লে সেটা Future-এর ভেতরে যায়। ধরতে হলে `await` করে try/catch করুন।
- `build()`-এর ভেতরে `await` চলে না। build সবসময় সিঙ্ক।
- `await` শুধু `async` ফাংশনের ভেতরে লেখা যায়।

---

## ২২. Stream

|                         |                                                                       |
| ----------------------- | --------------------------------------------------------------------- |
| **কী**                  | Future একবার একটা মান দেয়, আর Stream সময়ের সাথে **বারবার** মান দেয় |
| **কেন লাগে**            | পুশ নোটিফিকেশন আসা, ঘড়ি, চ্যাট, লোকেশন আপডেট                         |
| **কীভাবে জীবন সহজ করে** | "নতুন কিছু এলে জানিও" লিখে দিলেই হয়, বারবার জিজ্ঞেস করতে হয় না      |

**সহজ উদাহরণ**

```dart
Stream<int> countdown(int from) async* {   // async* = stream বানানো ফাংশন
  for (var i = from; i >= 0; i--) {
    yield i;                                // একটা করে মান পাঠানো
  }
}

await for (final n in countdown(3)) {       // প্রতিটা মানের জন্য অপেক্ষা
  print(n);                                 // → 3, 2, 1, 0
}

final c = StreamController<String>();       // হাতে stream বানানো
final sub = c.stream.listen((m) => print('listen: $m'));
c.add('hello');                             // → listen: hello
await sub.cancel();                         // শোনা বন্ধ (না করলে মেমোরি লিক)
await c.close();
```

**বাস্তব উদাহরণ (TWG):** [notification_service.dart:112](../lib/core/notifications/notification_service.dart#L112) `FirebaseMessaging.onMessage.listen((message) {...})`। প্রতিটা নতুন পুশ এলে চলে। আরও আছে [:50](../lib/core/notifications/notification_service.dart#L50) `onTokenRefresh.listen(...)` আর [:125](../lib/core/notifications/notification_service.dart#L125) `onMessageOpenedApp.listen(...)`। Riverpod-এ stream: [playground d04, d09](riverpod_playground.md#৩৪-streamprovider)।

---

## ২৩. এরর হ্যান্ডলিং: try, catch, on, finally, rethrow

|                         |                                                                                       |
| ----------------------- | ------------------------------------------------------------------------------------- |
| **কী**                  | কোনো কিছু ব্যর্থ হলে `throw` দিয়ে এরর ছোড়া, আর `try/catch` দিয়ে ধরা                |
| **কেন লাগে**            | নেটওয়ার্ক বন্ধ, সার্ভার 500, ভুল JSON। এগুলো সামলাতে না পারলে অ্যাপ crash করে        |
| **কীভাবে জীবন সহজ করে** | নিজের exception ক্লাস থাকলে UI জানে কী ধরনের সমস্যা, আর ইউজারকে ঠিক মেসেজ দেখাতে পারে |

**সহজ উদাহরণ**

```dart
class ApiError implements Exception {        // নিজের exception
  ApiError(this.message, [this.statusCode]);
  final String message;
  final int? statusCode;
}

try {
  throw ApiError('Not found', 404);
} on ApiError catch (e) {                    // নির্দিষ্ট টাইপ ধরা
  print('code=${e.statusCode}');             // → code=404
} catch (e, stackTrace) {                    // বাকি সব (stackTrace ঐচ্ছিক)
  print('unknown: $e');
} finally {
  print('always');                           // সফল হোক বা না হোক
}

try {
  try {
    throw const FormatException('bad json');
  } catch (e) {
    print('log then rethrow');               // লগ করে…
    rethrow;                                 // …আবার উপরে পাঠাও
  }
} on FormatException catch (e) {
  print('outer got ${e.message}');           // → outer got bad json
}
```

| শব্দ            | কাজ                                          |
| --------------- | -------------------------------------------- |
| `throw X`       | এরর ছোড়া                                    |
| `on Type`       | শুধু ঐ টাইপ ধরা                              |
| `catch (e)`     | এরর অবজেক্ট নেওয়া                           |
| `catch (e, st)` | এরর আর stack trace দুটোই                     |
| `finally`       | সবসময় চলে (লোডিং বন্ধ, রিসোর্স বন্ধ)        |
| `rethrow`       | ধরা এরর আবার উপরে পাঠানো, আসল stack trace সহ |

**বাস্তব উদাহরণ (TWG)**

- নির্দিষ্ট টাইপ ধরে নিজের টাইপে রূপান্তর: [living_repository.dart:54-59](../lib/features/living/data/repositories/living_repository.dart#L54-L59) `on DioException catch (e) { throw ApiException(...) }`
- বাতিল আলাদা, বাকিটা rethrow: [stripe_payment_service.dart:41-47](../lib/core/payments/stripe_payment_service.dart#L41-L47)
  ```dart
  } on StripeException catch (e) {
    if (e.error.code == FailureCode.Canceled) return null;   // বাতিল = এরর না
    rethrow;                                                 // আসল এরর উপরে যাক
  }
  ```
- নিজের exception: [auth_repository.dart:273-282](../lib/features/auth/data/repositories/auth_repository.dart#L273-L282)।

**খুঁটিনাটি:** `catch (e) { }` দিয়ে এরর চুপচাপ গিলে ফেলবেন না। অন্তত লগ করুন। TWG-তে এমন কয়েকটা জায়গা আছে, যেমন [notification_service.dart:62](../lib/core/notifications/notification_service.dart#L62) `catch (_) {}`।

---

## ২৪. Record: একসাথে একাধিক মান

|                         |                                                                                     |
| ----------------------- | ----------------------------------------------------------------------------------- |
| **কী**                  | Dart 3-এর নতুন জিনিস। আলাদা ক্লাস না বানিয়ে কয়েকটা মান একসাথে রাখা বা ফেরত দেওয়া |
| **কেন লাগে**            | একটা ফাংশন থেকে দুটো জিনিস ফেরত দিতে হয় (যেমন পেমেন্টের intent আর ফলাফল)           |
| **কীভাবে জীবন সহজ করে** | ছোট কাজের জন্য আলাদা ক্লাস লিখতে হয় না, আর `==` নিজে থেকেই থাকে                    |

**সহজ উদাহরণ**

```dart
(String, int) nameAndAge() => ('Rahim', 25);                // positional record
final (name, age) = nameAndAge();                            // ভেঙে নেওয়া (destructuring)
// → Rahim 25

({double total, int items}) cartSummary(List<double> prices) =>   // named record
    (total: prices.fold(0, (a, b) => a + b), items: prices.length);
final s = cartSummary([10, 20.5]);
s.total;   // → 30.5
s.items;   // → 2
final (:total, :items) = cartSummary([5]);                   // নাম ধরে ভেঙে নেওয়া

typedef Outcome = ({bool ok, String? message});              // record-এর নাম
const Outcome o = (ok: false, message: 'Sold out');
```

**বাস্তব উদাহরণ (TWG)**

- একসাথে দুটো মান ফেরত: [payment_gateway_service.dart:23](../lib/core/payments/payment_gateway_service.dart#L23) `Future<({PaymentIntentResult intent, PaymentFlowResult result})> payForBooking(...)`। ফেরত দেওয়া হয় [:62](../lib/core/payments/payment_gateway_service.dart#L62) `return (intent: intent, result: _fromStripe(stripeResult));` দিয়ে।
- typedef record: [adyen_payment_service.dart:8-12](../lib/core/payments/adyen_payment_service.dart#L8-L12) `typedef AdyenDropInOutcome = ({AdyenPaymentResult result, String? sessionId, String? sessionResult});`
- provider-এর ফল: [riverpod_providers.dart:563-564](../lib/features/auth/presentation/providers/riverpod_providers.dart#L563-L564) `FutureProvider<({bool googleEnabled, bool appleEnabled})>`

---

## ২৫. Pattern matching, switch expression, sealed class

|                         |                                                                                                                                 |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| **কী**                  | Dart 3-এ `switch` একটা মান ফেরত দিতে পারে (switch expression), আর অবজেক্টের আকার মিলিয়ে ভেতরের মান বের করে নিতে পারে (pattern) |
| **কেন লাগে**            | API স্ট্যাটাস কোড থেকে মেসেজ, পেমেন্টের ফলাফলের ধরন থেকে UI, JSON-এর আকার যাচাই                                                 |
| **কীভাবে জীবন সহজ করে** | লম্বা `if-else if` চেইন এক ব্লকে নেমে আসে। `sealed` হলে কোনো case বাদ পড়লে কম্পাইলার ধরে                                       |

**সহজ উদাহরণ**

```dart
// switch expression: মান ফেরত দেয়, প্রতিটা case-এ =>
final text = switch (statusCode) {
  200 || 201 => 'OK',               // অথবা
  401 => 'Login again',
  >= 500 => 'Server error',         // তুলনা
  _ => 'Something went wrong',      // বাকি সব (default)
};

// sealed class: নির্দিষ্ট কয়েকটা সন্তান, তার বাইরে কেউ না
sealed class PayResult {}
class PaySuccess extends PayResult { PaySuccess(this.receiptId); final String receiptId; }
class PayCancelled extends PayResult {}
class PayFailed extends PayResult { PayFailed(this.reason); final String reason; }

String describe(PayResult r) => switch (r) {
      PaySuccess(:final receiptId) => 'Paid, receipt $receiptId',   // ভেতরের মান বের করা
      PayCancelled() => 'User cancelled',
      PayFailed(:final reason) => 'Failed: $reason',
    };   // কোনো case বাদ দিলে কম্পাইল এরর
// describe(PayFailed('card declined')) → Failed: card declined

// if-case: আকার মিললে তবেই, সাথে মান বের করা
final Map<String, dynamic> json = {'user': {'name': 'Rahim', 'age': 25}};
if (json case {'user': {'name': final String n, 'age': final int a}}) {
  print('$n $a');                   // → Rahim 25
}

// collection-এর ভেতরে if-case
String? availability = 'today';
final params = {
  'page': 1,
  if (availability case final String a?) 'availability': a,   // null না হলে তবেই
};
// → {page: 1, availability: today}
```

**বাস্তব উদাহরণ (TWG)**

- switch expression: [tier_restriction_sheet.dart:25-30](../lib/core/widgets/tier_restriction_sheet.dart#L25-L30)
  ```dart
  final allowed = switch (requiredPermission) {
    'can_do_rsvp' => perms.canDoRsvp,
    'can_do_reservation' => perms.canDoReservation,
    'can_do_bookings' => perms.canDoBookings,
    _ => true,
  };
  ```
- sealed class + pattern (Adyen প্যাকেজের `PaymentResult` sealed): [adyen_payment_service.dart:65-76](../lib/core/payments/adyen_payment_service.dart#L65-L76)
  ```dart
  switch (result) {
    case PaymentSessionFinished(:final resultCode):
    case PaymentAdvancedFinished(:final resultCode):
      return _mapResultCode(resultCode);
    case PaymentCancelledByUser():
      return AdyenPaymentResult.cancelled;
    case PaymentError(:final reason):
      throw Exception(reason ?? 'Payment error');
  }
  ```
- if-case: [workshop_repository.dart:88](../lib/features/workshop/data/repositories/workshop_repository.dart#L88) `if (availability case final String a?) 'availability': a,`

**খুঁটিনাটি:** `(:final x)` আসলে `(x: final x)`-এর ছোট রূপ, মানে "x নামের ফিল্ডটা নিয়ে x নামের ভ্যারিয়েবলে রাখো"।

---

## ২৬. অ্যানোটেশন আর অন্যান্য

| জিনিস                            | কী                                                                      | TWG-তে                                                                                    |
| -------------------------------- | ----------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| `@override`                      | "প্যারেন্টের মেথড বদলাচ্ছি"। নাম ভুল হলে কম্পাইলার ধরে                  | প্রায় সব `build()`                                                                       |
| `@pragma('vm:entry-point')`      | release বিল্ডে এই ফাংশন মুছে ফেলো না। native থেকে ডাকা হয়              | [main.dart:14](../lib/main.dart#L14), background পুশ হ্যান্ডলার                           |
| `@immutable`                     | সব ফিল্ড final হওয়া উচিত, না হলে সতর্ক করে (`package:meta` বা Flutter) | নেই, playground-এ আছে                                                                     |
| `String.fromEnvironment('X')`    | বিল্ডের সময় `--dart-define=X=...` থেকে মান নেওয়া                      | [twg_api_client.dart:11-14](../lib/core/network/twg_api_client.dart#L11-L14) `SERVER_URL` |
| `const` উইজেট                    | একবার বানানো উইজেট বারবার ব্যবহার, রিবিল্ডে নতুন বানায় না              | `const SizedBox(height: 12)` সব জায়গায়                                                  |
| `import '...' as x`              | নামের সংঘাত এড়াতে prefix দেওয়া                                        | `import 'package:http/http.dart' as http;`                                                |
| `import '...' show A` / `hide A` | শুধু নির্দিষ্ট জিনিস আনা বা বাদ দেওয়া                                  | [twg_api_client.dart:3](../lib/core/network/twg_api_client.dart#L3) `show kReleaseMode`   |
| `export '...'`                   | barrel file: অনেক ফাইল এক জায়গা থেকে export                            | [living.dart](../lib/features/living/living.dart)                                         |
| `part` / `part of`               | একটা library অনেক ফাইলে ভাগ করা (কোড জেনারেশনে লাগে)                    | নেই, [লেসন 12](12_dev_tools.md)                                                           |

---

## ২৭. সাধারণ runtime এরর আর তার মানে

| এরর মেসেজ                                                                             | মানে                                                         | কোথায় খুঁজবেন                             |
| ------------------------------------------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------ |
| `type 'int' is not a subtype of type 'double'`                                        | JSON-এ `120` এসেছে, আপনি `double` ধরেছেন                     | `(json['x'] as num).toDouble()` (সেকশন ২০) |
| `type 'Null' is not a subtype of type 'String'`                                       | JSON-এ ফিল্ড নেই বা null, আপনি `as String` ধরেছেন            | `as String? ?? ''`                         |
| `'_Map<String, dynamic>' is not a subtype of type 'List<dynamic>'`                    | ভেবেছিলেন লিস্ট আসবে, এসেছে অবজেক্ট (যেমন `{"data": [...]}`) | `json['data'] as List`                     |
| `Null check operator used on a null value`                                            | কোনো `!` এর বাঁ পাশ null ছিল                                 | ঐ লাইনের `!` (সেকশন ৩)                     |
| `LateInitializationError: Field '_x' has not been initialized`                        | `late` ভ্যারিয়েবল মান বসানোর আগেই পড়া হয়েছে               | `initState` বা constructor (সেকশন ১)       |
| `Bad state: No element`                                                               | `firstWhere` বা `first` কিছু পায়নি                          | `orElse:` দিন (সেকশন ৮)                    |
| `RangeError (index)`                                                                  | লিস্টের বাইরের index                                         | `list.length` চেক করুন                     |
| `FormatException`                                                                     | `int.parse` বা `jsonDecode` ভুল ফরম্যাট পেয়েছে              | `tryParse`, try/catch                      |
| `NoSuchMethodError: ... was called on null` বা `Class 'X' has no instance getter 'y'` | `dynamic` ভ্যারিয়েবলে ভুল মেথড বা ফিল্ড                     | `dynamic` কমান, `as` দিয়ে টাইপ দিন        |
| `Concurrent modification during iteration`                                            | লুপ চলার সময় একই লিস্টে add/remove                          | নতুন লিস্ট বানান (`where(...).toList()`)   |
| `use_build_context_synchronously` (analyzer)                                          | `await`-এর পর `mounted` চেক ছাড়া `context`                  | `if (!mounted) return;` (সেকশন ২১)         |

---

## ২৮. একটা জটিল লাইন ভেঙে পড়া

TWG-র [living_models.dart:104-106](../lib/features/living/data/models/living_models.dart#L104-L106):

```dart
amenities: ((json['amenities'] as List?) ?? [])
    .map((item) => LivingAmenity.fromJson(item as Map<String, dynamic>))
    .toList(),
```

ভেতর থেকে বাইরে পড়ুন:

| ধাপ | অংশ                            | মানে                                                 | সেকশন  |
| --- | ------------------------------ | ---------------------------------------------------- | ------ |
| 1   | `json['amenities']`            | Map থেকে `amenities` key-র মান, টাইপ `dynamic`       | ৬      |
| 2   | `as List?`                     | "এটা একটা লিস্ট, অথবা null"                          | ৩, ৪   |
| 3   | `( … ) ?? []`                  | null হলে খালি লিস্ট নাও, যাতে পরের ধাপে crash না হয় | ৩      |
| 4   | `.map((item) => …)`            | লিস্টের প্রতিটা `item`-এর জন্য                       | ৮      |
| 5   | `item as Map<String, dynamic>` | প্রতিটা item একটা JSON অবজেক্ট                       | ৬      |
| 6   | `LivingAmenity.fromJson(…)`    | factory constructor দিয়ে মডেল বানাও                 | ১১, ২০ |
| 7   | `.toList()`                    | lazy Iterable থেকে আসল `List<LivingAmenity>`         | ৮      |

আরেকটা, [auth_response_models.dart:425-429](../lib/features/auth/data/models/auth_response_models.dart#L425-L429):

```dart
registrationStep:
    (json['registration_step'] is String
        ? int.tryParse(json['registration_step'] as String)
        : json['registration_step']) ??
    1,
```

এর মানে: মানটা String হলে (`is String`, সেকশন ৪) সেটাকে সংখ্যা বানাও (`int.tryParse`, সেকশন ২), না হলে যেমন আছে তেমনই নাও (ternary)। আর পুরো ফলটা null হলে (`?? 1`) ধরে নাও ধাপ 1। সার্ভার কখনো `"2"`, কখনো `2` পাঠায়, এই লাইন দুটোই সামলায়।

---

**এরপর:** এই cheat sheet পাশে রেখে [Riverpod Playground](riverpod_playground.md)-এর কোড পড়ুন। প্রায় প্রতিটা লাইনে এখানকার কোনো না কোনো বিষয় পাবেন।

[← কোর্স রোডম্যাপ](README.md)
