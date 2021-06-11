import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'auth/auth_service.dart';
import 'auth/sign_up_page.dart';
import 'auth/verification_page.dart';
import 'auth/login_page.dart';
import 'home/home.dart';
import 'search/search.dart';
import 'todo/todo.dart';
import 'schedule/schedule.dart';
import 'user_settings/settings.dart';

// void main() {
//   initializeDateFormatting().then((_) => runApp(ProviderScope(child: MyApp())));
// }

// final routeStateProvider = StateNotifierProvider((ref) => RouteStateNotifier());
// class RouteStateNotifier extends StateNotifier{
//   RouteStateNotifier() : super(RouteState(routeInformationParser: RouteInformationParser()));
// }
// class RouteState {
//   RouteState({this.routeInformationParser,this.routerDelegate});
//   final RouterDelegate routerDelegate;
//   final RouteInformationParser routeInformationParser;
// }

// class MyApp extends HookWidget {
//   static const String _title = 'MyAppTitle';
//   @override
//   Widget build(BuildContext context) {
//     final routeState = useProvider(routeStateProvider);
//     return MaterialApp.router(
//         title: _title,
//         routeInformationParser: ,
//         routerDelegate: routerDelegate);
//   }
// }

// class AppState extends StateNotifier{

// }
// class AppState

// final selectedIndexProvider = StateNotifierProvider((_) => SelectedIndexState);

// class SelectedIndexState extends StateNotifier {
//   SelectedIndexState() : super(0);
//   set selectedIndex(int index) {
//     this.state = index;
//   }
// }

// class MyAppRouteInformationParser extends RouteInformationParser<RoutePath> {
//   @override
//   Future<RoutePath> parseRouteInformation(
//       RouteInformation routeInformation) async {
//     final uri = Uri.parse(routeInformation.location);
//     if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'settings') {
//       return SettingsPath();
//     } else {
//       if (uri.pathSegments.length >= 2) {
//         if (uri.pathSegments[0] == 'book') {
//           return BooksDetaisPath(int.tryParse(uri.pathSegments[1]));
//         }
//       }
//       return BooksListPath();
//     }
//   }

//   @override
//   RouteInformation restoreRouteInformation(RoutePath configuration) {
//     if (configuration is BooksListPath) {
//       return RouteInformation(location: '/home');
//     }
//     if (configuration is SettingsPath){
//       return RouteInformation(location: '/settings')
//     }

//     return null;
//   }
// }

// final navigatorKeyProvider = StateNotifierProvider<GlobalKeyState,GlobalKey<NavigatorState>>((ref) => GlobalKeyState());

// class GlobalKeyState extends StateNotifier<GlobalKey<NavigatorState>>{
//   GlobalKeyState() : super(GlobalKey<NavigatorState>());
// }

// final todoAppStateProvider = StateNotifierProvider((ref) => TodoAppState());
// class TodoAppState extends StateNotifier{
//   TodoAppState() : super();
// }
// class TodoRouterDelegate extends RouterDelegate<TodoRoutePath>{
//   @override
//   Widget build(BuildContext context){
//     final navigatorKey = useProvider(navigatorKeyProvider);
//     final todoAppState = useProvider(todoAppStateProvider);
//     return Navigator(
//       key: navigatorKey,
//       pages: [
//         MaterialPage(
//           child: AppShell(appState: appState)
//         ),
//       ],
//       onPopPage: (route,result){
//         if(!route.didPop(result)){
//           return false;
//         }

//         if(appState.selectedTodo!=null) {
//           appState.selectedTodo = null;
//         }
//         return true;
//       },
//     )
//   }
//   @override
//   Future<void> setNewRoutePath(RoutePath path) async{
//     if(path is TodoListPath){
//       appState.selectedIndex = 0;
//       appState.selectedTodo = null;
//     }else if(path is SettingsPath){
//       appState.selectedIndex = 1;
//     }else if(path is TodoDetailsPath){
//       appState.setSelectedTodoById(path.id);
//     }
//   }
// }

// abstract class RoutePath{}
// class TodoListPath extends RoutePath{}
// class SettingsPath extends RoutePath{}
// class TodoDetailsPath extends RoutePath{
//   final int id;
//   TodoDetailsPath(this.id);
// }
// class AppShell extends HookWidget{
//   @override
//   Widget build(BuildContext context){
//     final _routeDelegate;
//     final _backButtonDispatcher;
//     return Scaffold(
//       appBar: AppBar(),
//       body:Router(
//         routerDelegate: _routeDelegate,
//         backButtonDispatcher: _backButtonDispatcher,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: [
//           BottomNavigationBarItem(icon:Icon(Icons.home),label: 'Home'),
//           BottomNavigationBarItem(icon:Icon(Icons.settings),label: 'Settings'),
//         ],
//         currentIndex: appState.selectedIndex,
//         onTap: (newIndex){
//           appState.selectedIndex = newIndex;
//         },
//       ),
//     );
//   }
// }

// final todoNavigatorKeyProvider = StateNotifierProvider<GlobalKeyState,GlobalKey<NavigatorState>>((ref) => GlobalKeyState());

// class InnerRouterDelegate extends RouterDelegate<TodoRoutePath> with PopNavigatorRouterDelegateMixin<TodoRoutePath>{
//   final navigatorKey = useProvider(todoNavigatorKeyProvider);
//   InnerRouterDelegate(this._appState);

//   @override
//   Widget build(BuildContext context){
//     return Navigator(
//       key: navigatorKey,
//       pages: [
//         if(appState.selectedIndex == 0) ...[
//         ]
//       ],
//       onPopPage: (route,result){
//         appState.selectedTodo = null;
//         return route.didPop(result);
//       },
//     )
//   }

//   @override
//   Future<void> setNewRoutePath(RoutePath path) async {
//     assert(false);
//   }

//   void _handleBookTapped(Todo todo){
//     appState.selectedTodo = todo;
//   }
// }

// class FadeAnimationPage extends Page{
//   final Widget child;
//   FadeAnimationPage({Key key,this.child}): super(key: key);

//   Route createRoute(BuildContext context){
//     return PageRouteBuilder(
//       settings: this,
//       pageBuilder: (context,animatino,animation2){
//       var curveTween = CurveTween(curve: Curves.easeIn);
//       return FadeTransition(opacity: animatino.drive(curveTween),child: child,);
//     });
//   }
// }

// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

// import 'package:flutter/material.dart';

void main() {
  runApp(ProviderScope(child: NestedRouterDemo()));
}

class Book {
  final String title;
  final String author;

  Book(this.title, this.author);
}

final routerStateProvider =
    StateNotifierProvider<RouterStateNotifier, RouterState>(
        (ref) => RouterStateNotifier());

class RouterStateNotifier extends StateNotifier<RouterState> {
  RouterStateNotifier()
      : super(RouterState(
            routeInformationParser: BookRouteInformationParser(),
            routerDelegate: BookRouterDelegate()));
}

class RouterState {
  RouterState({this.routeInformationParser, this.routerDelegate});
  BookRouterDelegate routerDelegate;
  BookRouteInformationParser routeInformationParser;
}

class NestedRouterDemo extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final routerState = useProvider(routerStateProvider);
    return MaterialApp.router(
      title: 'Books App',
      routerDelegate: routerState.routerDelegate,
      routeInformationParser: routerState.routeInformationParser,
    );
  }
}

class BooksAppState extends ChangeNotifier {
  int _selectedIndex;

  Book _selectedBook;

  final List<Book> books = [
    Book('Stranger in a Strange Land', 'Robert A. Heinlein'),
    Book('Foundation', 'Isaac Asimov'),
    Book('Fahrenheit 451', 'Ray Bradbury'),
  ];

  BooksAppState() : _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int idx) {
    _selectedIndex = idx;
    if (_selectedIndex == 1) {
      // Remove this line if you want to keep the selected book when navigating
      // between "settings" and "home" which book was selected when Settings is
      // tapped.
      // selectedBook = null;
    }
    notifyListeners();
  }

  Book get selectedBook => _selectedBook;

  set selectedBook(Book book) {
    _selectedBook = book;
    notifyListeners();
  }

  int getSelectedBookById() {
    if (!books.contains(_selectedBook)) return 0;
    return books.indexOf(_selectedBook);
  }

  void setSelectedBookById(int id) {
    if (id < 0 || id > books.length - 1) {
      return;
    }

    _selectedBook = books[id];
    notifyListeners();
  }
}

class BookRouteInformationParser extends RouteInformationParser<BookRoutePath> {
  @override
  Future<BookRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);

    if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'settings') {
      return BooksSettingsPath();
    } else {
      if (uri.pathSegments.length >= 2) {
        if (uri.pathSegments[0] == 'book') {
          return BooksDetailsPath(int.tryParse(uri.pathSegments[1]));
        }
      }
      return BooksListPath();
    }
  }

  @override
  RouteInformation restoreRouteInformation(BookRoutePath configuration) {
    if (configuration is BooksListPath) {
      return RouteInformation(location: '/home');
    }
    if (configuration is BooksSettingsPath) {
      return RouteInformation(location: '/settings');
    }
    if (configuration is BooksDetailsPath) {
      return RouteInformation(location: '/book/${configuration.id}');
    }
    return null;
  }
}

class BookRouterDelegate extends RouterDelegate<BookRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BookRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  BooksAppState appState = BooksAppState();

  BookRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    appState.addListener(notifyListeners);
  }

  BookRoutePath get currentConfiguration {
    if (appState.selectedIndex == 1) {
      return BooksSettingsPath();
    } else {
      if (appState.selectedBook == null) {
        return BooksListPath();
      } else {
        return BooksDetailsPath(appState.getSelectedBookById());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          child: AppShell(appState: appState),
        ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        if (appState.selectedBook != null) {
          appState.selectedBook = null;
        }
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(BookRoutePath path) async {
    if (path is BooksListPath) {
      appState.selectedIndex = 0;
      appState.selectedBook = null;
    } else if (path is BooksSettingsPath) {
      appState.selectedIndex = 1;
    } else if (path is BooksDetailsPath) {
      appState.setSelectedBookById(path.id);
    }
  }
}

// Routes
abstract class BookRoutePath {}

class BooksListPath extends BookRoutePath {}

class BooksSettingsPath extends BookRoutePath {}

class BooksDetailsPath extends BookRoutePath {
  final int id;

  BooksDetailsPath(this.id);
}

// Widget that contains the AdaptiveNavigationScaffold
class AppShell extends StatefulWidget {
  final BooksAppState appState;

  AppShell({
    @required this.appState,
  });

  @override
  _AppShellState createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  InnerRouterDelegate _routerDelegate;
  ChildBackButtonDispatcher _backButtonDispatcher;

  void initState() {
    super.initState();
    _routerDelegate = InnerRouterDelegate(widget.appState);
  }

  @override
  void didUpdateWidget(covariant AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    _routerDelegate.appState = widget.appState;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Defer back button dispatching to the child router
    _backButtonDispatcher = Router.of(context)
        .backButtonDispatcher
        .createChildBackButtonDispatcher();
  }

  @override
  Widget build(BuildContext context) {
    var appState = widget.appState;

    // Claim priority, If there are parallel sub router, you will need
    // to pick which one should take priority;
    _backButtonDispatcher.takePriority();

    return Scaffold(
      appBar: AppBar(),
      body: Router(
        routerDelegate: _routerDelegate,
        backButtonDispatcher: _backButtonDispatcher,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: appState.selectedIndex,
        onTap: (newIndex) {
          appState.selectedIndex = newIndex;
        },
      ),
    );
  }
}

class InnerRouterDelegate extends RouterDelegate<BookRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BookRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  BooksAppState get appState => _appState;
  BooksAppState _appState;
  set appState(BooksAppState value) {
    if (value == _appState) {
      return;
    }
    _appState = value;
    notifyListeners();
  }

  InnerRouterDelegate(this._appState);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (appState.selectedIndex == 0) ...[
          FadeAnimationPage(
            child: BooksListScreen(
              books: appState.books,
              onTapped: _handleBookTapped,
            ),
            key: ValueKey('BooksListPage'),
          ),
          if (appState.selectedBook != null)
            MaterialPage(
              key: ValueKey(appState.selectedBook),
              child: BookDetailsScreen(book: appState.selectedBook),
            ),
        ] else
          FadeAnimationPage(
            child: SettingsScreen(),
            key: ValueKey('SettingsPage'),
          ),
      ],
      onPopPage: (route, result) {
        appState.selectedBook = null;
        notifyListeners();
        return route.didPop(result);
      },
    );
  }

  @override
  Future<void> setNewRoutePath(BookRoutePath path) async {
    // This is not required for inner router delegate because it does not
    // parse route
    assert(false);
  }

  void _handleBookTapped(Book book) {
    appState.selectedBook = book;
    notifyListeners();
  }
}

class FadeAnimationPage extends Page {
  final Widget child;

  FadeAnimationPage({Key key, this.child}) : super(key: key);

  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, animation2) {
        var curveTween = CurveTween(curve: Curves.easeIn);
        return FadeTransition(
          opacity: animation.drive(curveTween),
          child: child,
        );
      },
    );
  }
}

// Screens
class BooksListScreen extends StatelessWidget {
  final List<Book> books;
  final ValueChanged<Book> onTapped;

  BooksListScreen({
    @required this.books,
    @required this.onTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          for (var book in books)
            ListTile(
              title: Text(book.title),
              subtitle: Text(book.author),
              onTap: () => onTapped(book),
            )
        ],
      ),
    );
  }
}

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  BookDetailsScreen({
    @required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Back'),
            ),
            if (book != null) ...[
              Text(book.title, style: Theme.of(context).textTheme.headline6),
              Text(book.author, style: Theme.of(context).textTheme.subtitle1),
            ],
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Settings screen'),
      ),
    );
  }
}
