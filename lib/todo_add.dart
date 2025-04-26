import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/todo_provider.dart';

// ここからchangeNotiferします
final addTodoProvider = ChangeNotifierProvider<AddTodoChangeNotifier>(
  (ref) => AddTodoChangeNotifier(),
);

class AddTodoChangeNotifier extends ChangeNotifier {
  final addFormKey = GlobalKey<FormState>();
  final Map<String, String> addFormValue = {};

  // void addFormKeyOrFormValueChanged() {
  //   notifyListeners();
  // }
}

//
class RiverPodTodoAddPage extends ConsumerWidget {
  const RiverPodTodoAddPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TOD

    final addFormValue =
        ref.watch<AddTodoChangeNotifier>(addTodoProvider).addFormValue;
    final addFormKey =
        ref.watch<AddTodoChangeNotifier>(addTodoProvider).addFormKey;
    // final changed = ref.read(addTodoProvider).addFormKeyOrFormValueChanged();

    final readMethod = ref.read(allTodoListProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Row(
          children: [
            Text(
              'Todo 追加',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(Icons.add),
          ],
        ),

        backgroundColor: Colors.deepPurple,
      ),
      body: Form(
        key: addFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              padding: const EdgeInsets.all(24),
              child: TextFormField(
                maxLines: 2,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'タイトルを入力してください';
                  } else if (value.length > 30) {
                    return 'タイトルは30文字以内で入力してください';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'タイトル',
                  alignLabelWithHint: true,
                ),
                onSaved: (value) {
                  addFormValue['title'] = value.toString();
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              child: TextFormField(
                minLines: 5,
                maxLines: 10,
                validator: (value) {
                  return value == null || value.isEmpty ? '内容を入力してください' : null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '内容',
                  alignLabelWithHint: true,
                ),
                onSaved: (value) {
                  addFormValue['content'] = value.toString();
                  debugPrint(value);
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 119, 31, 207),
              ),
              onPressed: () {
                // changed;
                if (addFormKey.currentState!.validate()) {
                  addFormKey.currentState?.save();
                  readMethod.addTodoItem(addFormValue);

                  Navigator.of(context).pop();
                }
              },
              child: const SizedBox(
                width: 100,
                child: Row(
                  children: [
                    Text(
                      'Todo を追加',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    Icon(Icons.add, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// ここまで

// // consumerstatefulwidgetでやります
// class DemoTodoAddPage extends ConsumerStatefulWidget {
//   const DemoTodoAddPage({super.key});
//   @override
//   ConsumerState<DemoTodoAddPage> createState() => _DemoTodoAdd();
// }

// class _DemoTodoAdd extends ConsumerState<DemoTodoAddPage> {
//   final csfFormKey = GlobalKey<FormState>();
//   final Map<String, String> csfFormValue = {};

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Todo 追加',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.red,
//       ),
//       body: Form(
//         key: csfFormKey,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,

//           children: [
//             Padding(
//               padding: const EdgeInsets.all(24),
//               child: TextFormField(
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'タイトルを入力してください';
//                   } else if (value.length > 30) {
//                     return 'タイトルは30文字以内で入力してください';
//                   }
//                   return null;
//                 },
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'タイトル',
//                   alignLabelWithHint: true,
//                 ),
//                 onSaved: (value) {
//                   csfFormValue['title'] = value.toString();
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(24),
//               child: TextFormField(
//                 validator: (value) {
//                   return value == null || value.isEmpty ?
//'内容を入力してください' : null;
//                 },
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: '内容',
//                   alignLabelWithHint: true,
//                 ),
//                 onSaved: (value) {
//                   csfFormValue['content'] = value.toString();
//                   debugPrint(value);
//                 },
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 if (csfFormKey.currentState!.validate()) {
//                   csfFormKey.currentState?.save();

//                   ref
//                       .read(allTodoListProvider)
//                       .riverPodAddTodoItem(csfFormValue);

//                   debugPrint(csfFormValue['content']);
//                   debugPrint('heu');
//                   Navigator.of(context).pop();
//                 } else if (csfFormKey.currentState == null) {
//                   debugPrint('null');
//                 }
//               },
//               child: const Text('Todo を追加'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// ここまででconsumerstatefulwidgetおわり

// class TodoAddPage extends StatefulWidget {
//   const TodoAddPage({super.key});
//   @override
//   TodoAddPageState createState() => TodoAddPageState();
// }

// class TodoAddPageState extends State {
//   final formKey = GlobalKey<FormState>();
//   Map<String, String> formValue = {};
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
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Todo 追加',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.blue,
//       ),

//       body: Form(
//         key: formKey,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,

//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 width: 300,
//                 child: TextFormField(
//                   decoration: const InputDecoration(
//                     labelText: 'タイトル',
//                     border: OutlineInputBorder(),
//                   ),
//                   onSaved: (value) {
//                     formValue['title'] = value.toString();
//                   },
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'タイトルを入力してください';
//                     } else if (value.length > 30) {
//                       return 'タイトルは30文字以内で入力してください';
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 width: 300,
//                 height: 200,
//                 child: TextFormField(
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: '内容',
//                     alignLabelWithHint: true,
//                   ),
//                   keyboardType: TextInputType.multiline,
//                   maxLines: null,
//                   minLines: 8,
//                   onSaved: (value) {
//                     formValue['content'] = value.toString();
//                   },
//                   validator: (value) {
//                     return value == null || value.isEmpty
//                         ? '内容を入力してください'
//                         : null;
//                   },
//                 ),
//               ),
//               SizedBox(
//                 width: 300,
//                 height: 40,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     if (formKey.currentState!.validate()) {
//                       formKey.currentState?.save();
//                       addTodoItem(formValue);
//                       Navigator.of(context).pop();
//                       for (var i = 0; i < allTodoList.length; i++) {
//                         debugPrint('${allTodoList[i].id}');
//                       }
//                     }
//                   },
//                   child: const Text('Todo を追加'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
