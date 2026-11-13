import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api/api_providers.dart';
import '../core/api/json_placeholder_api.dart';
import '../core/api/models.dart';

// ─────────────────────────────────────────────────────────────
// 11. StateNotifier + StateNotifierProvider (পুরোনো, legacy স্টাইল)
//     TWG-র AuthNotifier, AccountNotifier ঠিক এভাবে লেখা: repository বা API
//     constructor দিয়ে আসে, আর মেথড Future<bool> ফেরত দেয়।
//     নতুন কোডে Notifier বা AsyncNotifier (ডেমো 7, 8) ভালো, তবে এটা পড়তে জানা দরকার।
//
//     JSONPlaceholder-এ আসল লগইন নেই। তাই GET /users?username=… দিয়ে ইউজার খুঁজি,
//     আর পাসওয়ার্ড ধরে নিই 1234। username: Bret, Antonette, Samantha, Karianne…
// ─────────────────────────────────────────────────────────────

@immutable
class LoginState {
  const LoginState({
    this.isLoading = false,
    this.user,
    this.error,
  });

  final bool isLoading;
  final User? user;
  final String? error;

  bool get isLoggedIn => user != null;

  LoginState copyWith({bool? isLoading, User? user, String? error}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error, // TWG-র মতো: error না পাঠালে মুছে যায়
    );
  }
}

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier(this._api) : super(const LoginState()); // শুরুর state constructor-এ

  final JsonPlaceholderApi _api;

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _api.findUserByUsername(username.trim());

      // mounted: await-এর মধ্যে provider dispose হয়ে গেলে state বদলানো যাবে না
      if (!mounted) return false;

      if (user == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'No user "$username". Try: Bret, Antonette, Samantha',
        );
        return false;
      }
      if (password != '1234') {
        state = state.copyWith(isLoading: false, error: 'Wrong password (hint: 1234)');
        return false;
      }
      state = state.copyWith(isLoading: false, user: user);
      return true;
    } on ApiException catch (e) {
      if (mounted) state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  void logout() => state = const LoginState();
}

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(ref.watch(apiProvider)), // dependency constructor-এ
  name: 'loginProvider',
);

class StateNotifierDemoPage extends ConsumerStatefulWidget {
  const StateNotifierDemoPage({super.key});

  @override
  ConsumerState<StateNotifierDemoPage> createState() => _StateNotifierDemoPageState();
}

class _StateNotifierDemoPageState extends ConsumerState<StateNotifierDemoPage> {
  final _user = TextEditingController(text: 'Bret');
  final _pass = TextEditingController();

  @override
  void dispose() {
    _user.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // TWG-র login.dart-এর মতো: Future<bool> দেখে সিদ্ধান্ত
    final ok = await ref.read(loginProvider.notifier).login(_user.text, _pass.text);
    if (!mounted) return;
    final message = ok ? 'Welcome!' : ref.read(loginProvider).error ?? 'Failed';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);
    final user = state.user;

    return Scaffold(
      appBar: AppBar(title: const Text('11. StateNotifier (legacy)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: user != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: Theme.of(context).textTheme.headlineSmall),
                  Text('@${user.username} · ${user.email}'),
                  Text('${user.companyName} · ${user.city}'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => ref.read(loginProvider.notifier).logout(),
                    child: const Text('Logout'),
                  ),
                ],
              )
            : Column(
                children: [
                  TextField(
                    controller: _user,
                    decoration: const InputDecoration(labelText: 'Username (e.g. Bret)'),
                  ),
                  TextField(
                    controller: _pass,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password', errorText: state.error),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: state.isLoading ? null : _submit,
                    child: Text(state.isLoading ? 'Signing in…' : 'Login'),
                  ),
                ],
              ),
      ),
    );
  }
}
