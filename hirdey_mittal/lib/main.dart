import 'dart:developer' as devtools show log;
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hirdey_mittal/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:hirdey_mittal/service/auth/auth_service.dart';
import 'package:hirdey_mittal/views/notes/create-update-notes-view.dart';
import 'package:hirdey_mittal/views/notes/notes_view.dart';
import 'firebase_options.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        createOrUpdateNotesRoutes: (context) => const createUpdateNoteView(),
      },
    ),
  );
}

// class HomePage extends StatelessWidget {
//   const HomePage({ Key? key }) : super(key: key);

//  @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: AuthService.firebase().initialise(),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.done:
//             final user = AuthService.firebase().currentUser;
//             if (user!= null){
//               if(user.isEmailVerified) {
//                 devtools.log('Hello World');
//                 Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (Route<dynamic> route) => false);
//                 return const NotesView();
//               }
//               else{
//                 return const RegisterView();
//               }
//             } else {
//               return const LoginView();
//             }

//         default:
//         return const CircularProgressIndicator();}

//         }
// //       );
//   }
// }
// enum MenuAction { logout }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => counterBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Test Bloc')),
        body: BlocConsumer<counterBloc, CounterState>(
          listener: (context, state) {
            _controller.clear();
          },
          builder: (context, state) {
            final invalidValue =
                (state is CounterStateInvalidNumber) ? state.invalidValue : '';
            return Column(
              children: [
                Text('Current Value => ${state.value}'),
                Visibility(
                    child: Text('Invalid Input: $invalidValue'),
                    visible: state is CounterStateInvalidNumber),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Enter A Number Here',
                  ),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        context
                            .read<counterBloc>()
                            .add(decrementEvent(_controller.text));
                      },
                      child: const Text('-'),
                    ),
                    TextButton(
                      onPressed: () {
                        context
                            .read<counterBloc>()
                            .add(incrementEvent(_controller.text));
                      },
                      child: const Text('+'),
                    ),
                    TextButton(
                      onPressed: () {
                        context
                            .read<counterBloc>()
                            .add(multipleEvent(_controller.text));
                      },
                      child: const Text('*'),
                    )
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

@immutable
abstract class CounterState {
  final int value;

  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  const CounterStateValid(int value) : super(value);
}

class CounterStateInvalidNumber extends CounterState {
  final String invalidValue;
  const CounterStateInvalidNumber({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}

@immutable
abstract class CounterEvent {
  final String value;
  const CounterEvent(this.value);
}

class incrementEvent extends CounterEvent {
  incrementEvent(String value) : super(value);
}

class decrementEvent extends CounterEvent {
  decrementEvent(String value) : super(value);
}

class multipleEvent extends CounterEvent {
  multipleEvent(String value) : super(value);
}

class counterBloc extends Bloc<CounterEvent, CounterState> {
  counterBloc() : super(const CounterStateValid(0)) {
    on<incrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(
          CounterStateInvalidNumber(
            invalidValue: event.value,
            previousValue: state.value,
          ),
        );
      } else {
        emit(
          CounterStateValid(state.value + integer),
        );
      }
    });
    on<decrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(
          CounterStateInvalidNumber(
            invalidValue: event.value,
            previousValue: state.value,
          ),
        );
      } else {
        emit(
          CounterStateValid(state.value - integer),
        );
      }
    });
    on<multipleEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(
          CounterStateInvalidNumber(
            invalidValue: event.value,
            previousValue: state.value,
          ),
        );
      } else {
        emit(
          CounterStateValid(state.value * integer),
        );
      }
    });
  }
}
