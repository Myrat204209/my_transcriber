import 'package:flutter/material.dart' as mat;
import 'package:my_transcriber/chats/chats.dart';
import 'package:my_transcriber/questions/questions.dart';
import 'package:my_transcriber/results/results.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  int selected = 0;

  bool customButtonStyle = true;
  bool expanded = true;

  BottomNavigationBarItem buildButton(String label, IconData icon) {
    return BottomNavigationBarItem(icon: Icon(icon), label: label);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ShadcnApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorSchemes.darkGreen(),
              radius: 0.5,
            ),
            // ThemeData.dark(useMaterial3: true),
            home: Scaffold(
              footers: [
                mat.BottomNavigationBar(
                  selectedItemColor: Colors.green,
                  unselectedItemColor: mat.Colors.blueGrey,

                  currentIndex: selected,
                  type: mat.BottomNavigationBarType.shifting,
                  onTap: (value) {
                    setState(() {
                      selected = value;
                    });
                  },

                  items: [
                    buildButton('Вопрос', BootstrapIcons.questionCircle),
                    buildButton('Микрофон', BootstrapIcons.mic),
                    buildButton('Резултаты', BootstrapIcons.chat),
                  ],
                ),
              ],
              child: IndexedStack(
                index: selected,
                children: [QuestionsPage(), ChatPage(), ResultsPage()],
              ),
            ),
          );
        },
      ),
    );
  }
}
