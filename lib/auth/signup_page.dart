// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/app_state.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';

// class SignUpPage extends HookWidget {
//   SignUpPage(this.appState);
//   final MyAppState appState;
//   @override
//   Widget build(BuildContext context) {
//     String email = '';
//     String password = '';
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('SignUp'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: EdgeInsets.all(32),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextField(
//                 decoration: InputDecoration(
//                     icon: Icon(Icons.email), labelText: 'Email'),
//                 onChanged: (value) {
//                   email = value;
//                 },
//               ),
//               TextField(
//                 decoration: InputDecoration(
//                     icon: Icon(Icons.lock_open), labelText: 'Password'),
//                 onChanged: (value) {
//                   password = value;
//                 },
//               ),
//               TextButton(
//                   onPressed: () async {
//                     try {
//                       appState.signUpWithEmailAndPassword(email, password);
//                     } catch (e) {
//                       print('failed to signUp');
//                     }
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('SignUp'))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
