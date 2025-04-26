import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:todo/todo_detail.dart';
import 'package:todo/todo_provider.dart';

class TodoYetOrDoneWidget extends ConsumerWidget {
  final int pageCounter;
  const TodoYetOrDoneWidget({super.key, required this.pageCounter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final watchData = ref.watch(allTodoListProvider);
    final readMethod = ref.read(allTodoListProvider);

    // var watchData = ref.watch(allTodoListProvider);

    // watchData.riverPodBottomIndex = pageCounter;

    return Scaffold(
      body: Consumer(
        builder:
            (context, ref, child) => ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: (watchData.selectedTodoList(pageCounter).length),

              itemBuilder: (context, index) {
                var itemTitle =
                    watchData
                        .selectedTodoList(pageCounter)[index]
                        .title
                        .toString();
                var itemContent =
                    watchData.selectedTodoList(pageCounter)[index].content;
                return Container(
                  margin: const EdgeInsets.all(8),
                  // alignment: Alignment(0, 0),
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ), // 角を直角
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${index + 1}'
                                ' $itemTitle',
                                style: const TextStyle(fontSize: 30),
                                textAlign: TextAlign.left,
                              ),
                              Text(itemContent),
                            ],
                          ),
                        ),

                        Checkbox(
                          value:
                              watchData
                                  .selectedTodoList(pageCounter)[index]
                                  .isCompleted,
                          activeColor: Colors.green,
                          checkColor: Colors.white,
                          onChanged: (value) {
                            readMethod.todoListReplace(
                              readMethod
                                  .selectedTodoList(pageCounter)[index]
                                  .id,
                            );
                          },
                        ),
                      ],
                    ),

                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return RiverPodTodoDetailPage(
                              id:
                                  readMethod
                                      .selectedTodoList(pageCounter)[index]
                                      .id,
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      ),
    );
  }
}
