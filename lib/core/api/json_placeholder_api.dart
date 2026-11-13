import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models.dart';

/// অ্যাপের নিজের এরর। UI শুধু এটা চেনে, http প্যাকেজের ভেতরের জিনিস না।
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => statusCode == null ? message : '$message (HTTP $statusCode)';
}

/// JSONPlaceholder-এর সব কল এক জায়গায়।
/// মনে রাখুন: JSONPlaceholder POST, PUT আর DELETE-এ সফল উত্তর দেয়, কিন্তু আসলে কিছু সেভ করে না।
class JsonPlaceholderApi {
  JsonPlaceholderApi(this._client, {required this.baseUrl});

  final http.Client _client;
  final String baseUrl;

  static const _headers = {'Content-Type': 'application/json; charset=UTF-8'};
  static const _timeout = Duration(seconds: 15);

  // ─── users ──────────────────────────────────────────────

  /// [simulateError] শুধু ডেমোর জন্য: ভুল path-এ রিকোয়েস্ট পাঠিয়ে 404 আনে।
  Future<List<User>> getUsers({bool simulateError = false}) async {
    final json = await _get(simulateError ? '/users-broken' : '/users');
    return _list(json).map(User.fromJson).toList();
  }

  Future<User> getUser(int id) async =>
      User.fromJson(await _get('/users/$id') as Map<String, dynamic>);

  /// GET /users?username=Bret → মিললে একজন, না মিললে খালি লিস্ট
  Future<User?> findUserByUsername(String username) async {
    final json = await _get('/users', {'username': username});
    final users = _list(json).map(User.fromJson).toList();
    return users.isEmpty ? null : users.first;
  }

  // ─── posts & comments ───────────────────────────────────

  /// GET /posts?userId=1&_page=2&_limit=5
  Future<List<Post>> getPosts({int? userId, int? page, int? limit}) async {
    final json = await _get('/posts', {'userId': userId, '_page': page, '_limit': limit});
    return _list(json).map(Post.fromJson).toList();
  }

  Future<Post> getPost(int id) async =>
      Post.fromJson(await _get('/posts/$id') as Map<String, dynamic>);

  Future<List<Comment>> getComments({required int postId}) async {
    final json = await _get('/posts/$postId/comments');
    return _list(json).map(Comment.fromJson).toList();
  }

  /// POST /comments → সার্ভার সবসময় id 501 দেয়
  Future<Comment> createComment({required int postId, required String body}) async {
    final json = await _send('POST', '/comments', {
      'postId': postId,
      'name': 'Me',
      'email': 'me@example.com',
      'body': body,
    });
    return Comment.fromJson(json as Map<String, dynamic>);
  }

  // ─── todos ──────────────────────────────────────────────

  Future<List<Todo>> getTodos({required int userId}) async {
    final json = await _get('/todos', {'userId': userId});
    return _list(json).map(Todo.fromJson).toList();
  }

  /// POST /todos → সার্ভার সবসময় id 201 দেয়
  Future<Todo> createTodo({required int userId, required String title}) async {
    final json = await _send('POST', '/todos', {
      'userId': userId,
      'title': title,
      'completed': false,
    });
    return Todo.fromJson(json as Map<String, dynamic>);
  }

  /// PUT /todos/:id → সার্ভারে আছে এমন id (1–200) হলে 200, না থাকলে 404
  Future<Todo> updateTodo(Todo todo) async {
    final json = await _send('PUT', '/todos/${todo.id}', todo.toJson());
    return Todo.fromJson(json as Map<String, dynamic>);
  }

  Future<void> deleteTodo(int id) => _send('DELETE', '/todos/$id');

  // ─── ভেতরের সহায়ক ───────────────────────────────────────

  Uri _uri(String path, [Map<String, Object?> query = const {}]) {
    final params = {
      for (final e in query.entries)
        if (e.value != null) e.key: '${e.value}',
    };
    return Uri.parse('$baseUrl$path').replace(queryParameters: params.isEmpty ? null : params);
  }

  Future<Object?> _get(String path, [Map<String, Object?> query = const {}]) =>
      _handle(_client.get(_uri(path, query)));

  Future<Object?> _send(String method, String path, [Object? body]) {
    final uri = _uri(path);
    final encoded = body == null ? null : jsonEncode(body);
    return _handle(switch (method) {
      'POST' => _client.post(uri, headers: _headers, body: encoded),
      'PUT' => _client.put(uri, headers: _headers, body: encoded),
      'DELETE' => _client.delete(uri),
      _ => throw ArgumentError('Unsupported method $method'),
    });
  }

  Future<Object?> _handle(Future<http.Response> request) async {
    final http.Response response;
    try {
      response = await request.timeout(_timeout);
    } on TimeoutException {
      throw const ApiException('Server is taking too long. Please try again.');
    } on http.ClientException catch (e) {
      throw ApiException('Network error: ${e.message}');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final req = response.request;
      throw ApiException(
        'Request failed: ${req?.method} ${req?.url.path}',
        statusCode: response.statusCode,
      );
    }
    return response.body.isEmpty ? null : jsonDecode(response.body);
  }

  List<Map<String, dynamic>> _list(Object? json) =>
      (json as List).cast<Map<String, dynamic>>();
}
