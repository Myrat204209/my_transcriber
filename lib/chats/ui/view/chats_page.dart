import 'package:flutter/material.dart' ;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:my_transcriber/chats/chats.dart';
import 'package:talker/talker.dart' show Talker;
// import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

part 'chats_view.dart';
final talker = GetIt.I<Talker>(); 
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChatView();
  }
}