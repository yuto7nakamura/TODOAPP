# レビュー

## todo_item.dart

`isCompleted` はコンストラクタの中でデフォルト値を設定すると `required` を外せて毎回値を指定する必要がなくなります。

```dart
class TodoItem {
  final int id;
  String title;
  bool isCompleted; // ここではなく
  String content;

  TodoItem({
    required this.id,
    required this.title,
    required this.content,
    this.isCompleted = false, // ここ
  });

  void toggleIsCompleted() => isCompleted = !isCompleted;
}
```

## todo_provider.dart

### AllTodoListChangeNotifier クラス

- `idCounter` を用意して自動で採番するようにしているのは工夫が見られて良いですね。

- `getTodoItem` 関数ですが、`allTodoList` が空の時にはおそらくエラーが起きるのでそのような場合は null を返すなどのエラーハンドリングがあると安心ですかね。

- `addAndDeleteTodoItem` 関数の設計ですが、元のクラスを消して新しいクラスを追加するというのはイミュータブルの設計に近くて良いですね。(イミュータブルなクラスという概念があるので調べてみて下さい)
ただ、今の実装だと Todo を編集した後にリストの一番最後に追加されてしまうので、リスト内での順番を保つような実装にするとより使いやすくなって良いと思います。

- `selectedTodoList` で分けていますが、Notifier の状態として完了のリストと未完了のリストは分けて管理した方がリストの取得は楽かなと思います。

- `bottomIndex` はリストの操作とはあまり関係ないので別のプロバイダーとして切り分けて管理するのが良いかもしれないですね。StateProvider は単純な値を管理するのに適してるやつです。

  ```dart
  final bottomIndexProvider = StateProvider<int>((_) => 0);
  ```

- `todoListLengthCounter` の返り値の型が `List<dynamic>` となっているのできちんと型を書いておくと良いですね。ちなみに完了リストと未完了リストの状態を分ける場合、この関数は不要になると思います。

  ```dart
  List<int> countTodoListLength() {
  ```

  また、細かい話ではありますが関数の命名は 「動詞」を用いることが多いです(これはおそらくどのプログラミング言語でも共通です)。なので、ここでは `countTodoListLength` などが適していますね。

- 実は `ChangeNotifierNotifier` の使用は非推奨で、似たようなものである `StateNotifierProvider` が公式では推奨されているのでそちらの使い方も調べてみて下さい。

## todo_list.dart

### RiverPodTodoListPage クラス

- `read` と `watch` それぞれ代入しておいて同じものを何度も書かないようにしているのは良い工夫だと思います。ただ、`RiverPodTodoListPage` 全体を `ConsumerWidget` で定義してしまっているので、ref で値を参照したいウィジェットのみ `Consumer` で囲むのが良い実装です。(再レンダリング範囲の限定)

- `PageController` を build メソッド内で定義していますが、StatefulWidget 内で用いて使用後には`dispose` をするとメモリリークの心配がなくて良いと思います。-> (使用例)[https://api.flutter.dev/flutter/widgets/PageController-class.html]

## todo_yet_or_done.dart

- ここも細かい話ですが、クラスはコンストラクタ -> プロパティの順に並べて書くことが多いです(これはおそらくエディタが設定によっては自動でやってくれます)。また、間に改行が入っていると読みやすくて良いです。

  ```dart
  class TodoYetOrDoneWidget extends ConsumerWidget {
  const TodoYetOrDoneWidget({super.key, required this.pageCounter});

  final int pageCounter;
  ```

- Scaffold の body を `Consumer` で囲っていますが、`TodoYetOrDoneWidget` 自体が `ConsumerWidget` なのでここでは不要ですね。

- `itemTitle` と `itemContent` は `final` にできますね(これも設定によってはエディタが警告を出してくれるので気付けることが多いです)。実際に業務に入るとわかりますがほとんど `const` と `final` しか出てきません。

  ```dart
  itemBuilder: (context, index) {
    final itemTitle = ...
    final itemContent = ...
  ```

- borderRadius ですが、以下の書き方が良いですね。

  ```diff
  -        borderRadius: BorderRadius.circular(30),
  +        borderRadius: const BorderRadius.all(Radius.circular(30)),
  ```

  違いは、下の書き方では const がつきます。const がついたクラスはアプリ内で使い回され (同一のインスタンスになる)ます。また、Flutter 側で const がついたウィジェットはリビルドされることがないのでパフォーマンスを上げることができます。なので、アプリ開発の際は積極的に const が使える書き方が好ましいです ([参照](https://qiita.com/shimekake_slj/items/7efa5424a2b9f29b638c))。

  他にも const を使うパターンとして、なるべく Container の使用を避けるなどもあります。

## todo_detail.dart

### RiverPodTodoDetailPage

- 詳細を表示する `TodoItem` のインスタンスをページ間で受け渡すのではなく、`id` だけ渡してデータはプロバイダーを参照するという設計にしているのは good ですね。

- 上の方でも言及しましたが、`ConsumerWidget` の中で `Consumer` で囲うのは意味があまりないので、どちらかに統一するのが良いですね。基本は `ConsumerWidget` はあまり使わず、`StatelessWidget` などの中で再描画したい所を `Consumer` で囲います。

## todo_add.dart

### AddTodoChangeNotifier クラス

- `final` な値を `ChangeNotifierProvider` で管理するのはあまり意味がないので、フォームの状態は `StatefulWidget` などで管理するのが良いと思います。この[記事](https://zenn.dev/tsukatsuka1783/articles/global_key_text_form_field)とか参考になるかもです。

## todo_edit.dart

- 詳細ページ同様、編集する `TodoItem` インスタンスの受け渡しではなく `id` を渡しているのは非常に良いと思います。

- Form の使い方周辺の指摘は `todo_add.dart` と同様です。

- 削除の際に確認のモーダルを出すのはユーザー目線に立てていて good です。またデザインもユニークで良いと思います。

## 総評

まずはきちんと動くものが作れるようになったので自信を持って下さい！状態管理の方法 (ConsumerWidget や Consumer の使い方など) はまだ少し理解が甘い部分がありそうなので、ドキュメントや技術記事などをよく読んでおくと良いと思います。また、不要なコメントアウトやデバッグ用の print 文は消しておくと良いですね(これはまだ練習なので大丈夫ですが、実際に業務に入ってプルリクを出す時には気をつけて下さい)。
