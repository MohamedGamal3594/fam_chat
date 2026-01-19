import 'package:chat_app/models/message.dart';
import 'package:chat_app/utilities/app_colors.dart';
import 'package:chat_app/utilities/constants.dart';
import 'package:chat_app/utilities/extensions/show_snackbar.dart';
import 'package:chat_app/utilities/helpers/intl_helper.dart';
import 'package:chat_app/utilities/services/auth_service.dart';
import 'package:chat_app/utilities/services/messages_service.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_overlay/loading_overlay.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isLoading = false;
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _stream;
  @override
  void initState() {
    _stream = MessagesService.instance.getMessagesStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            AppConstants.appTitle,
            style: TextStyle(
              fontSize: 30,
              fontWeight: .bold,
              color: AppColors.mainColor,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                try {
                  await AuthService.instance.signOut();
                  if (context.mounted) {
                    context.showSnackbar(message: 'Sign out successful!');
                    context.go('/signIn');
                  }
                } catch (error) {
                  if (context.mounted) {
                    context.showSnackbar(message: error.toString());
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }
              },
              icon: const Icon(
                Icons.logout,
                size: 30,
                color: AppColors.mainColor,
              ),
            ),
          ],
        ),
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const .symmetric(horizontal: 16),
            child: StreamBuilder(
              stream: _stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<({String id, Message data, bool isPending})>
                  messages = snapshot.data!.docs
                      .map(
                        (doc) => (
                          id: doc.id,
                          data: Message.fromJson(doc.data()),
                          isPending: doc.metadata.hasPendingWrites,
                        ),
                      )
                      .toList();
                  return Stack(
                    alignment: .bottomCenter,
                    children: [
                      CustomScrollView(
                        reverse: true,
                        slivers: <Widget>[
                          SliverToBoxAdapter(child: SizedBox(height: 96)),
                          SliverList.separated(
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              return ChatBubble(message: messages[index]);
                            },
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 8),
                          ),
                          SliverToBoxAdapter(child: SizedBox(height: 8)),
                        ],
                      ),
                      SafeArea(child: const _MessageTextField()),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Oop! There is an error.'));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageTextField extends StatefulWidget {
  const _MessageTextField();

  @override
  State<_MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<_MessageTextField> {
  late final FocusNode _myFocusNode;
  late final TextEditingController _controller;
  TextDirection _textDirection = .ltr;
  bool _isTextEmpty = true;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _myFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      children: [
        TextField(
          controller: _controller,
          focusNode: _myFocusNode,
          textDirection: _textDirection,
          cursorColor: AppColors.mainColor,
          style: const TextStyle(color: AppColors.mainColor),
          onSubmitted: (value) async {
            if (value.trim().isNotEmpty) {
              setState(() {
                _isTextEmpty = true;
              });
              await sendMessage(context);
            }
          },
          onChanged: (value) {
            setState(() {
              _isTextEmpty = value.trim().isEmpty;
              _textDirection = isRTL(value) ? .rtl : .ltr;
            });
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            hintText: 'Send message',
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.mainColor),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.mainColor),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.mainColor),
            ),
            suffixIcon: IconButton(
              onPressed: _isTextEmpty
                  ? null
                  : () async {
                      setState(() {
                        _isTextEmpty = true;
                      });
                      await sendMessage(context);
                    },
              disabledColor: AppColors.grey,
              color: AppColors.mainColor,
              icon: const Icon(Icons.send),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Future<void> sendMessage(BuildContext context) async {
    try {
      final text = _controller.text;
      _controller.clear();
      _myFocusNode.requestFocus();
      await MessagesService.instance.sendMessage(text: text);
    } catch (error) {
      if (context.mounted) {
        context.showSnackbar(message: error.toString());
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _myFocusNode.dispose();
    super.dispose();
  }
}
