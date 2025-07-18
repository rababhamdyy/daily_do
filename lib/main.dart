import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Cubits/task_cubit.dart';
import 'pages/home_page.dart';
import 'pages/add_task_page.dart';
import 'models/task_model.dart';

void main() {
  runApp(BlocProvider(create: (_) => TaskCubit(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Do',
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == '/edit_task') {
          final task = settings.arguments as TaskModel;
          return MaterialPageRoute(
            builder: (context) => AddtaskPage(task: task),
          );
        }
        return null;
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);
    final List<Widget> pages = [const HomePage(), const AddtaskPage()];
    return ValueListenableBuilder<int>(
      valueListenable: selectedIndex,
      builder: (context, index, _) {
        return Scaffold(
          body: IndexedStack(index: index, children: pages),
          bottomNavigationBar: BottomNavigationBar(
            fixedColor: Colors.deepPurple,
            currentIndex: index,
            onTap: (i) => selectedIndex.value = i,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.new_label_outlined),
                activeIcon: Icon(Icons.new_label),
                label: 'Add Task',
              ),
            ],
          ),
        );
      },
    );
  }
}
