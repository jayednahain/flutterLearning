import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// JSONPlaceholder-এর মতো আচরণ করা নকল সার্ভার।
/// টেস্টে httpClientProvider-কে এটা দিয়ে override করলে ইন্টারনেট লাগে না,
/// আর ফলাফল সবসময় একই থাকে।
MockClient fakeJsonPlaceholder() {
  final users = [
    for (var i = 1; i <= 10; i++)
      {
        'id': i,
        'name': 'User $i',
        'username': i == 1 ? 'Bret' : 'user$i',
        'email': 'user$i@example.com',
        'address': {'city': 'City $i'},
        'company': {'name': 'Company $i'},
      },
  ];
  final posts = [
    for (var i = 1; i <= 100; i++)
      {'id': i, 'userId': (i - 1) ~/ 10 + 1, 'title': 'Post $i', 'body': 'Body of post $i'},
  ];
  final todos = [
    for (var i = 1; i <= 20; i++) {'id': i, 'userId': 1, 'title': 'Todo $i', 'completed': false},
  ];
  List<Map<String, Object>> commentsOf(int postId) => [
        for (var i = 1; i <= 5; i++)
          {
            'id': (postId - 1) * 5 + i,
            'postId': postId,
            'name': 'Comment $i',
            'email': 'c$i@example.com',
            'body': 'Comment $i on post $postId',
          },
      ];

  http.Response json(Object body, [int status = 200]) =>
      http.Response(jsonEncode(body), status, headers: {'content-type': 'application/json'});

  return MockClient((request) async {
    final q = request.url.queryParameters;
    final segments = request.url.pathSegments;

    switch ((request.method, segments)) {
      case ('GET', ['users']):
        final username = q['username'];
        return json(username == null ? users : users.where((u) => u['username'] == username).toList());
      case ('GET', ['users', final id]):
        final i = int.parse(id);
        return i >= 1 && i <= 10 ? json(users[i - 1]) : json({}, 404);
      case ('GET', ['posts']):
        var list = posts;
        if (q['userId'] case final userId?) {
          list = list.where((p) => p['userId'] == int.parse(userId)).toList();
        }
        if ((q['_page'], q['_limit']) case (final page?, final limit?)) {
          final l = int.parse(limit);
          list = list.skip((int.parse(page) - 1) * l).take(l).toList();
        }
        return json(list);
      case ('GET', ['posts', final id]):
        final i = int.parse(id);
        return i >= 1 && i <= 100 ? json(posts[i - 1]) : json({}, 404);
      case ('GET', ['posts', final id, 'comments']):
        return json(commentsOf(int.parse(id)));
      case ('POST', ['comments']):
        return json({...jsonDecode(request.body) as Map<String, dynamic>, 'id': 501}, 201);
      case ('GET', ['todos']):
        return json(todos);
      case ('POST', ['todos']):
        return json({...jsonDecode(request.body) as Map<String, dynamic>, 'id': 201}, 201);
      case ('PUT', ['todos', final id]):
        // আসল JSONPlaceholder-এর মতো: 1–200 আছে, বাকিগুলো 404
        return int.parse(id) <= 200 ? json(jsonDecode(request.body) as Object) : json({}, 404);
      case ('DELETE', ['todos', _]):
        return json({});
      default:
        return json({}, 404);
    }
  });
}
