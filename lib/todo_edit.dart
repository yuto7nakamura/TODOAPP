import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:todo/todo_provider.dart';

final editTodoProvider = ChangeNotifierProvider<EditTodoChangeNotifier>(
  (ref) => EditTodoChangeNotifier(),
);

class EditTodoChangeNotifier extends ChangeNotifier {
  final editFormKey = GlobalKey<FormState>();
  final Map<String, String> editFormValue = {};
  bool modalFlag = false;

  void somethingChanged() {
    notifyListeners();
  }

  void modalChange({required bool to}) {
    modalFlag = to;
    notifyListeners();
  }

  void modalSwitch() {
    modalFlag = !modalFlag;
    notifyListeners();
  }
}

class RiverPodTodoEditPage extends ConsumerWidget {
  final int id;
  const RiverPodTodoEditPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //

    final readMethod = ref.read(allTodoListProvider);
    final watchData = ref.watch(allTodoListProvider);
    final selectedTodoItem = watchData.getTodoItem(id);
    final title = selectedTodoItem.title;
    final content = selectedTodoItem.content;

    final watchEditData = ref.watch(editTodoProvider);
    final editFormKey = watchEditData.editFormKey;
    final editFormValue = watchEditData.editFormValue;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.lightGreenAccent),
        title: const Text(
          'Todo 編集',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            watchEditData.modalChange(to: false);
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Consumer(
        builder:
            (context, ref, child) => Container(
              color: watchEditData.modalFlag ? Colors.black : Colors.white,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Form(
                    key: editFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: TextFormField(
                            initialValue: title,
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
                              editFormValue['title'] = value.toString();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: TextFormField(
                            initialValue: content,
                            validator: (value) {
                              return value == null || value.isEmpty
                                  ? '内容を入力してください'
                                  : null;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: '内容',
                              alignLabelWithHint: true,
                            ),
                            onSaved: (value) {
                              editFormValue['content'] = value.toString();
                              debugPrint(value);
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (editFormKey.currentState!.validate()) {
                              editFormKey.currentState?.save();

                              readMethod.addAndDeleteTodoItem(
                                editFormValue,
                                id,
                              );

                              Navigator.of(context).pop();
                              readMethod.allTodoListChanged();
                              // Navigator.of(context).pop();
                            } else if (editFormKey.currentState == null) {
                              debugPrint('null');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent,
                          ),
                          child: const SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                Text(
                                  'Todo を保存',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Icon(Icons.publish, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            watchEditData.modalSwitch();
                            debugPrint('${watchEditData.modalFlag}');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const SizedBox(
                            width: 100,

                            child: Row(
                              children: [
                                Text(
                                  'Todo を削除',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Icon(Icons.delete, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (watchEditData.modalFlag)
                    Container(
                      alignment: AlignmentDirectional.center,

                      margin: const EdgeInsets.all(32),
                      color: Colors.black,
                      width: double.infinity,
                      height: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipPath(
                            clipper: HexagonClipper(),
                            child: Container(
                              width: 200 * 0.7,
                              height: 173 * 0.7,
                              color: const Color.fromARGB(255, 227, 70, 70),
                              child: const Center(
                                child: Text(
                                  'EMERGENCY',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ClipPath(
                                clipper: HexagonClipper(),
                                child: Container(
                                  width: 200 * 0.7,
                                  height: 173 * 0.7,
                                  color: const Color.fromARGB(255, 227, 70, 70),
                                  child: const Center(
                                    child: Text(
                                      'EMERGENCY',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              ClipPath(
                                clipper: HexagonClipper(),
                                child: Container(
                                  width: 200 * 0.7,
                                  height: 173 * 0.7,
                                  color: const Color.fromARGB(255, 227, 70, 70),
                                  child: const Center(
                                    child: Text(
                                      'EMERGENCY',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ClipPath(
                            clipper: HexagonClipper(),
                            child: Container(
                              width: 200 * 1.0,
                              height: 173 * 1.0,
                              color: const Color.fromARGB(255, 227, 70, 70),
                              child: Center(
                                child: Container(
                                  color: Colors.red,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        '本当にTodoを\n消しても\nよろしいですか？',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          debugPrint('cancel');
                                          watchEditData.modalSwitch();
                                        },
                                        icon: const Icon(
                                          Icons.cancel,
                                          color: Colors.white,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.amberAccent,
                                        ),

                                        onPressed: () async {
                                          watchEditData.modalSwitch();

                                          Navigator.of(
                                            context,
                                          ).popUntil((route) => route.isFirst);

                                          await Future.delayed(
                                            const Duration(seconds: 1),
                                            () {},
                                          );
                                          readMethod.deleteTodoItem(id);
                                          // 1秒待ってから再作画しないと存在しないtodoの詳細画面が出てしまう
                                          readMethod.allTodoListChanged();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ClipPath(
                                clipper: HexagonClipper(),
                                child: Container(
                                  width: 200 * 0.7,
                                  height: 173 * 0.7,
                                  color: const Color.fromARGB(255, 227, 70, 70),
                                  child: const Center(
                                    child: Text(
                                      'EMERGENCY',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              ClipPath(
                                clipper: HexagonClipper(),
                                child: Container(
                                  width: 200 * 0.7,
                                  height: 173 * 0.7,
                                  color: const Color.fromARGB(255, 227, 70, 70),
                                  child: const Center(
                                    child: Text(
                                      'EMERGENCY',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          ClipPath(
                            clipper: HexagonClipper(),
                            child: Container(
                              width: 200 * 0.7,
                              height: 173 * 0.7,
                              color: const Color.fromARGB(255, 227, 70, 70),
                              child: const Center(
                                child: Text(
                                  'EMERGENCY',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
      ),
    );
  }
}

class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;

    path.moveTo(width * 0.25, 0); // 上の左側の点
    path.lineTo(width * 0.75, 0); // 上の右側の点
    path.lineTo(width, height * 0.5); // 右側の中間点
    path.lineTo(width * 0.75, height); // 下の右側の点
    path.lineTo(width * 0.25, height); // 下の左側の点
    path.lineTo(0, height * 0.5); // 左側の中間点
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

// 六角形終わり
