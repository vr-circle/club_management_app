import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DummyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          const FlutterLogo(),
          const Text('CMA'),
        ],
      )),
      body: const Center(
        child: const Text('dummy'),
      ),
    );
  }
}

// RouteMap getRouteMap(AppState appState) {
//   print('getRouteMap');
//   switch (appState.loggedInState) {
//     case LoggedInState.loggedOut:
//       return RouteMap(onUnknownRoute: (route) => Redirect('/login'), routes: {
//         '/login': (route) => MaterialPage(
//               key: const ValueKey('loggedOut'),
//               child: LoginPage(handleLogin: appState.logIn),
//             ),
//       });
//     case LoggedInState.loggedIn:
//       return RouteMap(onUnknownRoute: (_) => Redirect('/home'), routes: {
//         '/': (_) => CupertinoTabPage(
//             child: AppShell(),
//             paths: ['/home', '/schedule', '/todo', '/search', '/setting']),
//         '/home': (route) => MaterialPage(child: Dummy('home')),
//         '/schedule': (route) => MaterialPage(child: Dummy('schedule')),
//         '/todo': (route) => MaterialPage(
//                 child: TodoPage(
//               key: ValueKey('todo'),
//               targetId: route.pathParameters['id'],
//             )),
//         '/search': (route) => MaterialPage(child: Dummy('search')),
//         '/setting': (route) => MaterialPage(child: DummyPage(appState, () {})),
//         '/setting/user': (route) =>
//             MaterialPage(child: DummyPage(appState, () {})),
//       });
//     default:
//       return RouteMap(
//           routes: {},
//           onUnknownRoute: (route) => MaterialPage(
//                   child: Scaffold(
//                 body: Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               )));
//   }
// }
// class Dummy extends StatelessWidget {
//   Dummy(this.tmp);
//   final String tmp;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: Row(
//         children: [
//           FlutterLogo(),
//           Text('CMA'),
//         ],
//       )),
//       body: Center(
//         child: TextButton(
//           child: Text(tmp),
//           onPressed: () {
//             Routemaster.of(context).replace('home');
//           },
//         ),
//       ),
//     );
//   }
// }