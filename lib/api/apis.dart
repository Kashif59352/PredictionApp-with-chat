import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fypproject/module/chat_user.dart';
import 'package:fypproject/module/message.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  // store self info
  static late ChatUser me;
  // one time userdata get
  static User get user => auth.currentUser!;
  // for cheaking user exist
  static Future<bool> userExist() async {
    return (await firestore.collection("users").doc(user.uid).get()).exists;
  }

  // getting cruunt user
  static Future<void> getSelfInfo() async {
    await firestore.collection("users").doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  // for create /new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      about: "yes i am useing chat",
      image: user.photoURL.toString(),
      email: user.email.toString(),
      isOnline: false,
      createdAt: time,
      lastActive: time,
      pushToken: "",
    );
    return await firestore
        .collection("users")
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUser() {
    return firestore
        .collection("users")
        .where("id", isNotEqualTo: user.uid)
        .snapshots();
  }

  // update user information in profilesection
  static Future<void> updateUserData() async {
    await firestore.collection("users").doc(user.uid).update({
      "name": me.name,
      "about": me.about,
    });
  }

  // usefull to getting conversation
  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // for getting all messages
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
    ChatUser user,
  ) {
    return firestore
        .collection("chats/${getConversationId(user.id)}/messages/")
        .snapshots();
  }

  static Future<void> sendMessage(ChatUser chatUser, String msg) async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();

    final Message message = Message(
      toId: chatUser.id,
      msg: msg,
      read: "",
      type: Type.text,
      fromId: user.uid,
      sent: time,
    );

    final ref = firestore.collection(
      "chats/${getConversationId(chatUser.id)}/messages/",
    );
    await ref.doc(time).set(message.toJson());
  }
}
