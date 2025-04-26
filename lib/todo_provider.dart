import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/todo_item.dart';

// いざRiver Podにチャレンジ！
final allTodoListProvider = ChangeNotifierProvider<AllTodoListChangeNotifier>(
  (ref) => AllTodoListChangeNotifier(),
);

class AllTodoListChangeNotifier extends ChangeNotifier {
  // 今idがどれくらい発行されているか
  int idCounter = 0;

  // すべてのTodoのリストの保存場所
  List<TodoItem> allTodoList = [
    // TodoItem(id: 0, title: '中村', content: '教習所に行った', isCompleted: true),
    // TodoItem(id: 1, title: 'バス', content: '京都バスマジひどい', isCompleted: true),
    // TodoItem(
    //   id: 2,
    //   title: '優しいおばあちゃん',
    //   content: '海外観光客に地図見せてあげてた',
    //   isCompleted: true,
    // ),
    // TodoItem(id: 3, title: '中村（偽）', content: '夜中にお散歩', isCompleted: false),
    // TodoItem(
    //   id: 4,
    //   title: '麻雀',
    //   content: '大負けしたのはルールよく知らなかったから',
    //   isCompleted: false,
    // ),
    // TodoItem(id: 5, title: '腐った豆乳', content: '面白いことに黒色になる',
    //isCompleted: false),
  ];
  void allTodoListChanged() {
    notifyListeners();
    debugPrint('allTodoListに何らかの変更が加えられました');
  }

  // idをもらってそのidを持つtodoのインスタンスを返す
  TodoItem getTodoItem(int id) {
    var item = allTodoList.where((todo) => todo.id == id).toList()[0];
    return item;
  }

  // Todoを作成
  void addTodoItem(Map<String, String> csfFormValue) {
    allTodoList.add(
      TodoItem(
        id: idCounter + 1,
        title: csfFormValue['title'] ?? '',
        content: csfFormValue['content'] ?? '',
        isCompleted: false,
      ),
    );
    idCounter++;
    notifyListeners();
  }

  // 既にあるtodoを編集したとき、追加して、元のを削除する　　つまりは編集したときの保存
  void addAndDeleteTodoItem(Map<String, String> editFormValue, int id) {
    debugPrint('$id');
    var editItem = getTodoItem(id);
    debugPrint('$editItem');
    allTodoList.remove(editItem);
    for (var element in allTodoList) {
      debugPrint('${element.id}');
    }
    allTodoList.add(
      TodoItem(
        id: id,
        title: editFormValue['title'] ?? '',
        content: editFormValue['content'] ?? '',
        isCompleted: false,
      ),
    );
    notifyListeners();
  }

  // 完了と未完了を変える
  void todoListReplace(int id) {
    var replaceItem = getTodoItem(id);

    replaceItem.toggleIsCompleted();
    notifyListeners();
  }

  // 完了と未完了のTodoの仕分け　trueを入れたら、完了したTodoリスト。falseなら未完了のTodoリスト
  List<TodoItem> selectedTodoList(int bottomIndex) {
    var selectedTodoList = <TodoItem>[];
    if (bottomIndex == 0) {
      selectedTodoList =
          allTodoList.where((item) => item.isCompleted == false).toList();
    } else if (bottomIndex == 1) {
      selectedTodoList =
          allTodoList.where((item) => item.isCompleted == true).toList();
    }

    return selectedTodoList;
  }

  // Todoを削除
  void deleteTodoItem(int id) {
    var deleteItem = getTodoItem(id);
    allTodoList.remove(deleteItem);
  }

  // リストの第一要素は未完了の個数、第二要素はすべての要素の個数
  List todoListLengthCounter() {
    var doneListLengthAndYetListLength = [];

    doneListLengthAndYetListLength.add(selectedTodoList(1).length);
    doneListLengthAndYetListLength.add(allTodoList.length);
    return doneListLengthAndYetListLength;
  }

  int bottomIndex = 0;
}
