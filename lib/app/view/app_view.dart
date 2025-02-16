import 'dart:developer';

import 'package:my_transcriber/chats/chats.dart';
import 'package:my_transcriber/questions/questions.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    NavigationBarAlignment alignment = NavigationBarAlignment.spaceAround;
    bool expands = true;
    NavigationLabelType labelType = NavigationLabelType.none;

    NavigationButton buildButton(String label, IconData icon) {
      return NavigationButton(
        style: const ButtonStyle.muted(density: ButtonDensity.icon),
        selectedStyle: const ButtonStyle.fixed(density: ButtonDensity.icon),
        label: Text(label),
        child: Icon(icon),
      );
    }

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ShadcnApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorSchemes.darkGreen(),
              radius: 0.5,
            ),
            home: Scaffold(
              backgroundColor: Colors.cyan,
              footers: [
                const Divider(),
                NavigationBar(
                  onSelected: (i) {
                    setState(() {
                      selected = i;
                    });
                    log('Selected: $i  $selected');
                  },
                  index: selected,
                  alignment: alignment,
                  labelType: labelType,
                  expands: expands,
                  children: [
                    buildButton('Home', BootstrapIcons.house),
                    buildButton('Explore', BootstrapIcons.compass),
                    buildButton('Library', BootstrapIcons.musicNoteList),
                  ],
                ),
              ],
              child: IndexedStack(
                index: selected,
                children: const [
                  QuestionsPage(),
                  ChatPage(),
                  Center(child: Text('Library')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
