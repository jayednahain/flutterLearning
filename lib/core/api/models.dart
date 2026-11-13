// JSONPlaceholder-এর ডেটা মডেল: https://jsonplaceholder.typicode.com
// শুধু যে ফিল্ডগুলো ডেমোতে লাগে, সেগুলো রাখা হয়েছে।

class Post {
  const Post({required this.id, required this.userId, required this.title, required this.body});

  final int id;
  final int userId;
  final String title;
  final String body;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json['id'] as int,
        userId: json['userId'] as int,
        title: json['title'] as String,
        body: json['body'] as String,
      );
}

class Comment {
  const Comment({
    required this.id,
    required this.postId,
    required this.name,
    required this.email,
    required this.body,
  });

  final int id;
  final int postId;
  final String name;
  final String email;
  final String body;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json['id'] as int,
        postId: json['postId'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        body: json['body'] as String,
      );
}

class User {
  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.city,
    required this.companyName,
  });

  final int id;
  final String name;
  final String username;
  final String email;
  final String city;
  final String companyName;

  // নেস্টেড JSON: address.city আর company.name
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int,
        name: json['name'] as String,
        username: json['username'] as String,
        email: json['email'] as String,
        city: (json['address'] as Map<String, dynamic>?)?['city'] as String? ?? '',
        companyName: (json['company'] as Map<String, dynamic>?)?['name'] as String? ?? '',
      );
}

class Todo {
  const Todo({
    required this.id,
    required this.userId,
    required this.title,
    required this.completed,
  });

  final int id;
  final int userId;
  final String title;
  final bool completed;

  Todo copyWith({int? id, bool? completed}) => Todo(
        id: id ?? this.id,
        userId: userId,
        title: title,
        completed: completed ?? this.completed,
      );

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json['id'] as int,
        userId: json['userId'] as int,
        title: json['title'] as String,
        completed: json['completed'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'completed': completed,
      };
}
