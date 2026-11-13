import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'd05_family.dart';

// ─────────────────────────────────────────────────────────────
// 14. select আর selectAsync — বড় অবজেক্টের শুধু একটা অংশ watch করা।
//     সেই অংশ না বদলালে উইজেট রিবিল্ড হয় না।
// ─────────────────────────────────────────────────────────────

@immutable
class Profile {
  const Profile({required this.name, required this.age, required this.followers});
  final String name;
  final int age;
  final int followers;

  Profile copyWith({int? age, int? followers}) => Profile(
        name: name,
        age: age ?? this.age,
        followers: followers ?? this.followers,
      );
}

class ProfileNotifier extends Notifier<Profile> {
  @override
  Profile build() => const Profile(name: 'Rahim', age: 25, followers: 100);

  void birthday() => state = state.copyWith(age: state.age + 1);
  void gainFollower() => state = state.copyWith(followers: state.followers + 1);
}

final profileProvider = NotifierProvider<ProfileNotifier, Profile>(
  ProfileNotifier.new,
  name: 'profileProvider',
);

// selectAsync: async provider-এর শুধু একটা অংশ, Future হিসেবে।
// GET /users/:id-এর পুরো User থেকে শুধু শহর নেওয়া (userProvider আসে ডেমো 5 থেকে)।
// ইউজারের অন্য কোনো ফিল্ড বদলালে এই provider আবার চলবে না, শুধু city বদলালে চলবে।
final userCityProvider = FutureProvider.family<String, int>(
  (ref, id) => ref.watch(userProvider(id).selectAsync((u) => u.city)),
  name: 'userCityProvider',
);

// কয়বার build হলো গোনার জন্য (শুধু ডেমোর জন্য)
int _ageCardBuilds = 0;
int _followersCardBuilds = 0;
int _wholeCardBuilds = 0;

class SelectDemoPage extends ConsumerWidget {
  const SelectDemoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final city = ref.watch(userCityProvider(1));

    return Scaffold(
      appBar: AppBar(title: const Text('14. select / selectAsync')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _AgeCard(),
          const _FollowersCard(),
          const _WholeProfileCard(),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              FilledButton(
                onPressed: () => ref.read(profileProvider.notifier).birthday(),
                child: const Text('Birthday (age+1)'),
              ),
              FilledButton.tonal(
                onPressed: () => ref.read(profileProvider.notifier).gainFollower(),
                child: const Text('Follower +1'),
              ),
            ],
          ),
          const Divider(height: 32),
          Text('selectAsync → user 1-এর শহর: ${city.valueOrNull ?? 'loading…'}'),
        ],
      ),
    );
  }
}

class _AgeCard extends ConsumerWidget {
  const _AgeCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final age = ref.watch(profileProvider.select((p) => p.age));
    _ageCardBuilds++;
    return ListTile(title: Text('Age: $age'), subtitle: Text('builds: $_ageCardBuilds'));
  }
}

class _FollowersCard extends ConsumerWidget {
  const _FollowersCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followers = ref.watch(profileProvider.select((p) => p.followers));
    _followersCardBuilds++;
    return ListTile(
      title: Text('Followers: $followers'),
      subtitle: Text('builds: $_followersCardBuilds'),
    );
  }
}

class _WholeProfileCard extends ConsumerWidget {
  const _WholeProfileCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider); // select ছাড়া: যেকোনো বদলে রিবিল্ড
    _wholeCardBuilds++;
    return ListTile(
      title: Text('Whole profile: ${profile.name}, ${profile.age}, ${profile.followers}'),
      subtitle: Text('builds: $_wholeCardBuilds (select নেই, তাই প্রতিবার)'),
    );
  }
}
