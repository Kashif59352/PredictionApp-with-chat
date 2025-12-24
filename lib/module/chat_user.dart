// class ChatUser {
//   String image;
//   String about;
//   String name;
//   String createdAt;
//   String lastActive;
//   bool isOnline;
//   String id;
//   String email;
//   String pushToken;

//   ChatUser({
//     required this.image,
//     required this.about,
//     required this.name,
//     required this.createdAt,
//     required this.lastActive,
//     required this.isOnline,
//     required this.id,
//     required this.email,
//     required this.pushToken,
//   });

//   // 🔽 Firestore / API se data lena
//   factory ChatUser.fromJson(Map<String, dynamic> json) {
//     return ChatUser(
//       image: json['image'] ?? "",
//       about: json['about'] ?? "",
//       name: json['name'] ?? "",
//       createdAt: json['created_at'] ?? "",
//       lastActive: json['last_active'] ?? "",
//       isOnline: json['isOnline'] ?? false, // ✅ bool
//       id: json['id'] ?? "",
//       email: json['email'] ?? "",
//       pushToken: json['push_token'] ?? "",
//     );
//   }

//   // 🔼 Firestore / API me data bhejna
//   Map<String, dynamic> toJson() {
//     return {
//       'image': image,
//       'about': about,
//       'name': name,
//       'created_at': createdAt,
//       'last_active': lastActive,
//       'isOnline': isOnline,
//       'id': id,
//       'email': email,
//       'push_token': pushToken,
//     };
//   }
// }
class ChatUser {
  ChatUser({
    required this.image,
    required this.about,
    required this.name,
    required this.createdAt,
    required this.isOnline,
    required this.id,
    required this.lastActive,
    required this.email,
    required this.pushToken,
  });
  late String image;
  late String about;
  late String name;
  late String createdAt;
  late bool isOnline;
  late String id;
  late String lastActive;
  late String email;
  late String pushToken;

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    about = json['about'] ?? '';
    name = json['name'] ?? '';
    createdAt = json['created_at'] ?? '';
    isOnline = json['is_online'] ?? false;
    id = json['id'] ?? '';
    lastActive = json['last_active'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['about'] = about;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    data['id'] = id;
    data['last_active'] = lastActive;
    data['email'] = email;
    data['push_token'] = pushToken;
    return data;
  }
}
