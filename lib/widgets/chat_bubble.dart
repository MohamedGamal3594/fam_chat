import 'package:chat_app/models/message.dart';
import 'package:chat_app/utilities/app_colors.dart';
import 'package:chat_app/utilities/enums/message_type.dart';
import 'package:chat_app/utilities/extensions/show_snackbar.dart';
import 'package:chat_app/utilities/helpers/intl_helper.dart';
import 'package:chat_app/utilities/services/messages_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});
  final ({String id, Message data, bool isPending}) message;

  @override
  Widget build(BuildContext context) {
    final type = MessageType.getMessageType(
      messageSenderName: message.data.senderName,
    );
    return GestureDetector(
      onDoubleTap: () {
        Clipboard.setData(ClipboardData(text: message.data.text));
        context.showSnackbar(message: 'Message copied to clipboard!');
      },
      onLongPress: () async {
        if (MessageType.getMessageType(
              messageSenderName: message.data.senderName,
            ) ==
            .sended) {
          try {
            if (context.mounted) {
              context.showSnackbar(
                message: 'Message deleted successfully!',
                isDelete: true,
              );
            }
            await MessagesService.instance.deleteMessage(messageId: message.id);
          } catch (e) {
            if (context.mounted) {
              context.showSnackbar(message: e.toString());
            }
          }
        }
      },
      child: Align(
        alignment: type == .sended ? .centerRight : .centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.6,
          ),
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: type == .sended
                  ? AppColors.mainColor
                  : AppColors.lightBlue,
              borderRadius: BorderRadius.only(
                topLeft: .circular(16),
                topRight: .circular(16),
                bottomLeft: type == .sended ? .circular(16) : .zero,
                bottomRight: type == .received ? .circular(16) : .zero,
              ),
            ),
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .start,
                children: [
                  Text(
                    message.data.senderName,
                    style: TextStyle(color: AppColors.black),
                  ),
                  Text(
                    message.data.text,
                    style: const TextStyle(color: AppColors.white),
                    textDirection: isRTL(message.data.text)
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                  ),
                  Align(
                    alignment: .centerRight,
                    child: Row(
                      mainAxisSize: .min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          formatMessageDate(message.data.createdAt),
                          style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 10,
                          ),
                        ),
                        message.isPending
                            ? const Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: SizedBox(
                                  width: 10,
                                  height: 10,
                                  child: Icon(
                                    Icons.access_time,
                                    color: AppColors.black,
                                    size: 10,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.check,
                                color: AppColors.black,
                                size: 10,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
