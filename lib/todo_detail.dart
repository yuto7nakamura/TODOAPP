import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter/services.dart';
import 'package:todo/todo_edit.dart';

import 'package:todo/todo_provider.dart';

// ここからriverPodチャレンジします

class RiverPodTodoDetailPage extends ConsumerWidget {
  final int id;

  const RiverPodTodoDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final readMethod = ref.read(allTodoListProvider);
    final watchData = ref.watch(allTodoListProvider);
    final selectedTodoItem = watchData.getTodoItem(id);

    final title = selectedTodoItem.title;

    final content = selectedTodoItem.content;

    final isCompleted = selectedTodoItem.isCompleted;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.red),
        title: const Text(
          'Todo 詳細',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('タイトル', style: TextStyle(fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: 300,
                child: Consumer(
                  builder:
                      (context, ref, child) =>
                          Text(title, style: const TextStyle(fontSize: 30)),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('内容', style: TextStyle(fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: 300,
                child: Consumer(
                  builder:
                      (context, ref, child) =>
                          Text(content, style: const TextStyle(fontSize: 30)),
                ),
              ),
            ),
            SizedBox(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, //ボタンの背景色
                    ),
                    onPressed: () {
                      // debugPrint('${allTodoList[id].isCompleted}');
                      watchData.todoListReplace(id);

                      Navigator.of(context).pop();
                      readMethod.allTodoListChanged();
                    },
                    child: SizedBox(
                      width: 110,
                      child: Row(
                        children: [
                          Text(
                            isCompleted ? '未完了にする' : '完了にする',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Icon(
                            isCompleted ? Icons.unpublished : Icons.check,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return RiverPodTodoEditPage(id: id);
                          },
                        ),
                      );
                    },
                    child: const SizedBox(
                      width: 80,
                      child: Row(
                        children: [
                          Text('編集する', style: TextStyle(color: Colors.white)),
                          Icon(Icons.edit, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ここまで

// class TodoDetail extends StatefulWidget {
//   final int id;

//   const TodoDetail({super.key, required this.id});
//   @override
//   State<TodoDetail> createState() => _TodoDetailState();
// }

// class _TodoDetailState extends State<TodoDetail> {
//   String? errorMassage;

//   final formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Todo 詳細',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.blue,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Padding(
//               padding: EdgeInsets.all(8),
//               child: Text('タイトル', style: TextStyle(fontSize: 20)),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8),
//               child: SizedBox(
//                 height: 100,
//                 width: 300,
//                 child: Text(
//                   '${allTodoList[widget.id].title}',
//                   style: const TextStyle(fontSize: 30),
//                 ),
//               ),
//             ),

//             const Padding(
//               padding: EdgeInsets.all(8),
//               child: Text('内容', style: TextStyle(fontSize: 20)),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8),
//               child: SizedBox(
//                 width: 300,
//                 child: Text(
//                   '${allTodoList[widget.id].content}',
//                   style: const TextStyle(fontSize: 30),
//                 ),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 debugPrint('${allTodoList[widget.id].isCompleted}');
//                 todoListReplace(widget.id);

//                 debugPrint('${allTodoList[widget.id].isCompleted}');
//                 debugPrint('$doneTodoList');

//                 setState(() {
//                   Navigator.of(context).pop();
//                 });
//               },
//               child: SizedBox(
//                 width: 100,
//                 child: Text(
//                   '${allTodoList[widget.id].isCompleted ?
// '未完了にする' : '完了にする'}',
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
