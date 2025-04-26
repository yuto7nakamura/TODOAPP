import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/todo_add.dart';

import 'package:todo/todo_provider.dart';
import 'package:todo/todo_yet_or_done.dart';

class RiverPodTodoListPage extends ConsumerWidget {
  const RiverPodTodoListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readMethod = ref.read<AllTodoListChangeNotifier>(allTodoListProvider);

    final watchData = ref.watch(allTodoListProvider);

    final doneCount = readMethod.todoListLengthCounter()[0];
    final allCount = readMethod.todoListLengthCounter()[1];

    final controller = PageController();

    // if (_controller.page == 0.0) {
    //   watchData.bottomIndex = 1;
    // } else if (_controller.page == 1.0) {
    //   watchData.bottomIndex = 0;
    // }
    return Scaffold(
      appBar: AppBar(
        title: Consumer(
          builder:
              (context, ref, child) => Text(
                'Todo 一覧 (完了済み) '
                '$doneCount'
                '/$allCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: PageView(
        controller: controller,
        onPageChanged: (page) {
          watchData.bottomIndex = page;
          // debugPrint('page: $page');
          readMethod.allTodoListChanged();
        },
        children: [
          const TodoYetOrDoneWidget(pageCounter: 0),
          const TodoYetOrDoneWidget(pageCounter: 1),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepPurple,
        selectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.unpublished), label: '未完了'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: '完了'),
        ],
        onTap: (final index) {
          if (watchData.bottomIndex != index) {
            watchData.bottomIndex = index;
            controller.animateToPage(
              index,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.ease,
            );

            readMethod.allTodoListChanged();
          }
        },
        currentIndex: watchData.bottomIndex,
        // currentIndex: bottomIndex,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const RiverPodTodoAddPage(); //consumer widgetで
                // return const DemoTodoAddPage();//consumerstatefulで
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// RiverPodここまで

// ここから以下は全く使っておりません

// class TodoList extends StatefulWidget {
//   const TodoList({super.key});
//   @override
//   TodoListState createState() => TodoListState();
// }

// List selectedTodoList = [];

// void todoListReplace(int id) {
//   var replaceItem = allTodoList[id];

//   replaceItem.toggleIsCompleted();
// }

// final List allTodoList = [
//   TodoItem(id: 0, title: '中村', content: '教習所に行った', isCompleted: true),
//   TodoItem(id: 1, title: 'バス', content: '京都バスマジひどい', isCompleted: true),
//   TodoItem(
//     id: 2,
//     title: '優しいおばあちゃん',
//     content: '海外観光客に地図見せてあげてた',
//     isCompleted: true,
//   ),
//   TodoItem(id: 3, title: '中村（偽）', content: '夜中にお散歩', isCompleted: false),
//   TodoItem(
//     id: 4,
//     title: '麻雀',
//     content: '大負けしたのはルールよく知らなかったから',
//     isCompleted: false,
//   ),
//   TodoItem(id: 5, 
//title: '腐った豆乳', content: '面白いことに黒色になる', isCompleted: false),
// ];
// // List doneList =
// //     tryList.where((element) => element.isCompleted == true).toList();
// List yetTodoList =
//     allTodoList.where((item) => item.isCompleted == false).toList();
// List doneTodoList =
//     allTodoList.where((item) => item.isCompleted == true).toList();

// // この文字を消す前ならば、listの動作が確認できた
// class TodoListState extends State {
//   final List tabName = ['未完了', '完了'];

//   int bottomIndex = 0;
//   void addTodoItem(Map<String, String> formValue) {
//     setState(() {
//       allTodoList.add(
//         TodoItem(
//           id: allTodoList.length,
//           title: formValue['title'],
//           content: formValue['content'],
//           isCompleted: false,
//         ),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (bottomIndex == 0) {
//       selectedTodoList =
//           allTodoList.where((item) => item.isCompleted == false).toList();
//     } else if (bottomIndex == 1) {
//       selectedTodoList =
//           allTodoList.where((item) => item.isCompleted == true).toList();
//     }
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Todo 一覧 (完了済み) ${allTodoList.where((value) => value.isCompleted == true).toList().length}/${allTodoList.length}',
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Colors.blue,
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(8),
//         itemCount: selectedTodoList.length,

//         itemBuilder: (context, index) {
//           return Container(
//             margin: const EdgeInsets.all(8),
//             // alignment: Alignment(0, 0),
//             alignment: Alignment.centerLeft,
//             child: ElevatedButton(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '${index + 1} ${selectedTodoList[index].title}',
//                         style: const TextStyle(fontSize: 30),
//                         textAlign: TextAlign.left,
//                       ),
//                       Text('${selectedTodoList[index].content}'),
//                     ],
//                   ),
//                   Checkbox(
//                     value: selectedTodoList[index].isCompleted,
//                     activeColor: Colors.green,
//                     checkColor: Colors.white,
//                     onChanged: (value) {
//                       todoListReplace(selectedTodoList[index].id);
//                       setState(() {});
//                     },
//                   ),
//                 ],
//               ),

//               onPressed: () {
//                 debugPrint('${selectedTodoList[index]}');
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) {
//                       return TodoDetail(
//                         id: selectedTodoList[index].id,
//                         // title: selectedTodoList[index].title,
//                         // context: selectedTodoList[index].context,
//                         // isCompleted: selectedTodoList[index].isCompleted,
//                       );
//                     },
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),

//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.unpublished),
// label: '未完了'),
//           BottomNavigationBarItem(icon: Icon(Icons.check_circle), 
//label: '完了'),
//         ],
//         onTap: (final index) {
//           if (bottomIndex != index) {
//             setState(() {
//               bottomIndex = index;
//               debugPrint('$index');
//             });
//           }
//         },
//         currentIndex: bottomIndex,
//         // currentIndex: bottomIndex,
//       ),

//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) {
//                 // return TodoAddPage();
//                 // return const RiverPodTodoAddPage();
//                 return const DemoTodoAddPage();
//               },
//             ),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
