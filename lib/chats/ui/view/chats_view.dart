part of 'chats_page.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Транскрибатор'), centerTitle: true),
      body: ChatsContent(),
      bottomNavigationBar: ChatsControlPanel(),
    );
  }
}
