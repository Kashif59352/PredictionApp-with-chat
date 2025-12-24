import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fypproject/main.dart';
import 'package:fypproject/module/chat_user.dart';
import 'package:fypproject/screens/chat_screen.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    np = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: np.width * 0.04),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => ChatScreen(user: widget.user)),
          );
        },
        child: ListTile(
          // leading: CircleAvatar(child: Icon(Icons.person)),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              width: np.width * .099,
              height: np.height * .099,
              imageUrl: widget.user.image,
              errorWidget: (context, url, error) =>
                  CircleAvatar(child: Icon(Icons.error)),
            ),
          ),
          title: Text(widget.user.name, maxLines: 1),
          subtitle: Text(widget.user.about),
          trailing: Container(
            width: 15,
            height: 15,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.greenAccent.shade400,
            ),
          ),
        ),
      ),
    );
  }
}
