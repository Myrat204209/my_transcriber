// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class ChatTextField extends StatelessWidget {
//   final bool speechEnabled;
//   const ChatTextField({super.key, required this.speechEnabled});

//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);
//     return BlocBuilder<TextBloc, TextState>(
//       buildWhen: (previous, current) {
//         if (previous != current && current is TextRequestedState) {
//           return current.fromSpeaking;
//         } else {
//           return false;
//         }
//       },
//       builder: (context, state) {
//         String text = "";
//         if (state is TextRequestedState) {
//           text = state.text;
//         }
//         return TextField(
//           controller: TextEditingController(text: text),
//           minLines: 1,
//           maxLines: 6,
//           // style: theme.appTextStyleTheme.textMediumRegular,
//           // cursorColor: theme.appColorTheme.primary,
//           textInputAction: TextInputAction.newline,
//           keyboardType: TextInputType.multiline,
//           decoration: InputDecoration(
//             contentPadding:
//                 const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//             hintText: speechEnabled
//                 ? 'Type something, or tap the microphone to speak'
//                 : 'Message',
//           ),
//           onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
//           onChanged: (value) {
//             BlocProvider.of<TextBloc>(context).add(
//               TextRequestedEvent(text: value, fromSpeaking: false),
//             );
//           },
//         );
//       },
//     );
//   }
// }