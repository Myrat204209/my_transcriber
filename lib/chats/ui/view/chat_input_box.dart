// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:my_transcriber/chats/chats.dart'; // Contains ChatsBloc, ChatsState, ChatsStatus & events.
// // import 'package:lottie/lottie.dart';
// // import 'package:my_transcriber/assets/assets.dart';
// // import 'package:my_transcriber/text_bloc/text_bloc.dart';

// class ChatInputBox extends StatelessWidget {
//   const ChatInputBox({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final ThemeData theme = Theme.of(context);

//     return BlocProvider(
//       create: (context) => ChatsBloc()..add(const ChatsStarted()),
//       child: SizedBox(
//         height: 600,
//         width: 360,
//         child: Card(
//           margin: const EdgeInsets.all(8),
//           child: Row(
//             children: [
//               // Text input area (using ChatTextField that depends on speechEnabled flag)
//               // Expanded(
//               //   // child: BlocBuilder<ChatsBloc, ChatsState>(
//               //   //   // builder: (context, state) {
//               //   //   //   // return ChatTextField(speechEnabled: state.speechEnabled);
//               //   //   // },
//               //   ),
//               // ),
//               // Microphone/animation icon area
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 5),
//                 child: BlocBuilder<ChatsBloc, ChatsState>(
//                   builder: (context, state) {
//                     bool startListening = false;

//                     // Use new unified status checks
//                     if (state.status == ChatsStatus.beeped) {
//                       // After beep, the UI should reflect that listening is about to start.
//                       startListening = true;
//                       // You could optionally dispatch an event here if needed.
//                     } else if (state.status == ChatsStatus.listening) {
//                       startListening = true;
//                       // If recognized text is available, send it to TextBloc and finish the session.
//                       if (state.recognizedText != null &&
//                           state.recognizedText!.isNotEmpty) {
//                         // BlocProvider.of<TextBloc>(context).add(
//                         //   // TextRequestedEvent(
//                         //   //   text: state.recognizedText!,
//                         //   //   fromSpeaking: true,
//                         //   // ),
//                         // );
//                         BlocProvider.of<ChatsBloc>(context)
//                             .add(const ChatFinished());
//                       }
//                     } else {
//                       startListening = false;
//                     }

//                     return InkWell(
//                       onTap: () {
//                         // On tap, dispatch a ChatQuestioned event with the text from your input field.
//                         // Replace "Your question here" with the actual input.
//                         BlocProvider.of<ChatsBloc>(context)
//                             .add(const ChatQuestioned("Your question here"));
//                       },
//                       // child: startListening
//                       // ? Lottie.asset(
//                       //     Assets.micAnimation,
//                       //     height: 30,
//                       //     width: 30,
//                       //     delegates: LottieDelegates(
//                       //       values: [
//                       //         ValueDelegate.color(
//                       //           const ['**'],
//                       //           value: theme.appColorTheme.primary,
//                       //         ),
//                       //       ],
//                       //     ),
//                       //   )
//                       // : Icon(
//                       //     Icons.mic_off,
//                       //     color: theme.appColorTheme.primary,
//                       //   ),
//                     );
//                   },
//                 ),
//               ),
//               // Send button for manual text input
//               ElevatedButton(
//                 onPressed: () {
//                   // BlocProvider.of<TextBloc>(context).add(
//                   //   const TextRequestedEvent(
//                   //     text: "",
//                   //     fromSpeaking: true,
//                   //   ),
//                   // );
//                 },
//                 child: const Text("Send"),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
