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

  NavigationBarAlignment alignment = NavigationBarAlignment.spaceAround;
  bool expands = true;
  NavigationLabelType labelType = NavigationLabelType.none;
  bool customButtonStyle = true;
  bool expanded = true;

  NavigationItem buildButton(String label, IconData icon) {
    return NavigationItem(
      style:
          customButtonStyle
              ? const ButtonStyle.muted(density: ButtonDensity.icon)
              : null,
      selectedStyle:
          customButtonStyle
              ? const ButtonStyle.fixed(density: ButtonDensity.icon)
              : null,
      label: Text(label),
      child: Icon(icon),
    );
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
            home: Scaffold(
              backgroundColor: Colors.cyan,
              footers: [
                const Divider(),
                NavigationBar(
                  alignment: alignment,
                  labelType: labelType,
                  expanded: expanded,
                  expands: expands,
                  index: selected,
                  onSelected: (i) {
                    setState(() {
                      selected = i;
                    });
                  },
                  children: [
                    buildButton('Вопрос', BootstrapIcons.questionCircle),
                    buildButton('Микрофон', BootstrapIcons.mic),
                    buildButton('Резултаты', BootstrapIcons.chat),
                  ],
                ),
              ],
              child: IndexedStack(
                index: selected,
                children: const [QuestionsPage(), ChatPage(), ResultsPage()],
              ),
            ),
          );
        },
      ),
    );
  }
}
