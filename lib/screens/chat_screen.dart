import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fypproject/api/apis.dart';
import 'package:fypproject/main.dart';
import 'package:fypproject/module/chat_user.dart';
import 'package:fypproject/module/message.dart';
import 'package:fypproject/widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> list = [];
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    np = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 158, 193, 221),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: APIs.getAllMessages(widget.user),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Center(child: CircularProgressIndicator());
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                    case ConnectionState.done:

                      // 🔴 Error state
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Something went wrong'),
                        );
                      }

                      // ⏳ Loading state
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // 📭 No data
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No users found'));
                      }
                      final data = snapshot.data!.docs;
                      list = data
                          .map((e) => Message.fromJson(e.data()))
                          .toList();
                      // log("data ${list[0].name}");
                      // final list = ["ahi", "hellow"];
                      // list.add(
                      //   Message(
                      //     toId: "xyz",
                      //     msg: "hi",
                      //     read: " ",
                      //     type: Type.text,
                      //     fromId: APIs.user.uid,
                      //     sent: "12-10-25",
                      //   ),
                      // );
                      // list.add(
                      //   Message(
                      //     toId: APIs.user.uid,
                      //     msg: "hi",
                      //     read: " ",
                      //     type: Type.text,
                      //     fromId: "xyz",
                      //     sent: "12-10-25",
                      //   ),
                      // );
                      if (list.isNotEmpty) {
                        return ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            // final data = users[index];

                            return MessageCard(message: list[index]);
                          },
                        );
                      } else {
                        return Center(
                          child: Text(
                            "Not USers",
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      }
                  }
                },
              ),
            ),

            // temporory
            _chatInput(),
          ],
        ),
      ),
    );
  }

  // bottom chat input field
  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: np.height * .01,
        horizontal: np.width * .025,
      ),
      child: Row(
        children: [
          //input field & buttons
          Expanded(
            child: Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                    onPressed: () {
                      // FocusScope.of(context).unfocus();
                      // setState(() => _showEmoji = !_showEmoji);
                    },
                    icon: const Icon(
                      Icons.emoji_emotions,
                      color: Colors.blueAccent,
                      size: 25,
                    ),
                  ),

                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () {
                        // if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  //pick image from gallery button
                  IconButton(
                    onPressed: () async {
                      // final ImagePicker picker = ImagePicker();

                      // // Picking multiple images
                      // final List<XFile> images =
                      //     await picker.pickMultiImage(imageQuality: 70);

                      // // uploading & sending image one by one
                      // for (var i in images) {
                      //   log('Image Path: ${i.path}');
                      //   setState(() => _isUploading = true);
                      //   await APIs.sendChatImage(widget.user, File(i.path));
                      //   setState(() => _isUploading = false);
                      // }
                    },
                    icon: const Icon(
                      Icons.image,
                      color: Colors.blueAccent,
                      size: 26,
                    ),
                  ),

                  //take image from camera button
                  IconButton(
                    onPressed: () async {
                      // final ImagePicker picker = ImagePicker();

                      // // Pick an image
                      // final XFile? image = await picker.pickImage(
                      //     source: ImageSource.camera, imageQuality: 70);
                      // if (image != null) {
                      //   log('Image Path: ${image.path}');
                      //   setState(() => _isUploading = true);

                      //   await APIs.sendChatImage(
                      //       widget.user, File(image.path));
                      //   setState(() => _isUploading = false);
                      // }
                    },
                    icon: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.blueAccent,
                      size: 26,
                    ),
                  ),

                  //adding some space
                  SizedBox(width: np.width * .02),
                ],
              ),
            ),
          ),

          //send message button
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textController.text);
                _textController.text = " ";
              }
            },
            minWidth: 0,
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
              right: 5,
              left: 10,
            ),
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(Icons.send, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }
  // old app bar

  // Widget _appBar() {
  //   return Row(
  //     children: [
  //       IconButton(
  //         onPressed: () {},
  //         icon: Icon(Icons.arrow_back, color: Colors.black),
  //       ),
  //       ClipRRect(
  //         borderRadius: BorderRadiusGeometry.circular(np.height * .03),

  //         child: CachedNetworkImage(
  //           imageUrl: widget.user.image,
  //           errorWidget: (context, url, error) =>
  //               CircleAvatar(child: Icon(Icons.error)),
  //         ),
  //       ),
  //       Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Text(
  //             widget.user.name,
  //             style: TextStyle(
  //               fontSize: 16,
  //               color: Colors.black,
  //               fontWeight: FontWeight.w400,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // gpt app bar
  Widget _appBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back, color: Colors.black),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(np.height * .03),
              child: CachedNetworkImage(
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                imageUrl: widget.user.image,
                errorWidget: (context, url, error) =>
                    CircleAvatar(child: Icon(Icons.error)),
              ),
            ),
            SizedBox(width: 10),
            Text(
              widget.user.name,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
