import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Todo List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class TodoItem {
  String text = '';
  bool completed = false;

  TodoItem(String _text, bool _completed) {
    text = _text;
    completed = _completed;
  }
}

enum DisplayMode {
  All,
  Active,
  Completed
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<TodoItem> todoItems = [
    TodoItem('ItemA', true),
    TodoItem('ItemB', false),
  ];
  String inputText = '';
  DisplayMode displayMode = DisplayMode.All;



  void _addTodoItemByText(String text) {
    TodoItem todoItem = TodoItem(text, false);
    if (!todoItems.contains(todoItem)) {
      setState(() {
        todoItems.add(todoItem);
      });
    }
  }

  void _deleteTodoItem(TodoItem todoItem) {
    if (todoItems.contains(todoItem)) {
      setState(() {
        todoItems.remove(todoItem);
      });
    }
  }

  void _completeItem(TodoItem todoItem) {
    setState(() {
      todoItem.completed = true;
    });
  }

  void _activateItem(TodoItem todoItem) {
    setState(() {
      todoItem.completed = false;
    });
  }

  void _toogleItem(TodoItem todoItem) {
    setState(() {
      todoItem.completed = !todoItem.completed;
    });
  }

  void _setDisplayMode( DisplayMode mode ) {
    setState( () {
      displayMode = mode;
    } );
  }

  // # text field
  _handleTextFieldChanged(text) {
    inputText = text;
  }

  _handleAddButtonClick() {
    print(inputText);
    _addTodoItemByText(inputText);
  }

  _handleClearCompletedPress() {
    setState(() {
      todoItems = todoItems.where( (TodoItem item) => !item.completed ).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    List<TodoItem> displayingTodoItems = [];
    for (TodoItem item in todoItems) {
      if ( displayMode == DisplayMode.All ) {
        displayingTodoItems.add( item );
      } else if ( displayMode == DisplayMode.Active && item.completed == false ) {
        displayingTodoItems.add( item );
      } else if (displayMode == DisplayMode.Completed && item.completed == true) {
        displayingTodoItems.add( item );
      }
    };

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(onChanged: _handleTextFieldChanged),
            RaisedButton(
              child: Text('Add'),
              onPressed: _handleAddButtonClick,
            ),
            TodoItemsContainer(
                displayingTodoItems, this._toogleItem, this._deleteTodoItem),
            Row(
              children: <Widget>[
                FlatButton(
                  child: Text('All'),
                  onPressed: () {
                    _setDisplayMode(DisplayMode.All);
                  },
                ),
                FlatButton(
                  child: Text('Active'),
                  onPressed: () {
                    _setDisplayMode(DisplayMode.Active);
                  },
                ),
                FlatButton(
                  child: Text('Completed'),
                  onPressed: () {
                    _setDisplayMode(DisplayMode.Completed);
                  },
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text('0 items left'),
                OutlineButton(
                  child: Text('Clear completed'),
                  onPressed: this._handleClearCompletedPress,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget TodoItemsContainer(
    List<TodoItem> todoItems, Function toogleItem, Function deleteItem) {
  return new Expanded(
      child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: todoItems.length,
          itemBuilder: (context, index) {
            print(index);
            TodoItem todoItem = todoItems[index];
            return ListTile(
              leading: Checkbox(
                value: todoItem.completed,
                onChanged: (bool v) {
                  toogleItem(todoItem);
                },
              ),
              title: Text(todoItem.text),
              trailing: FlatButton(
                child: Text('X'),
                onPressed: () {
                  deleteItem(todoItem);
                },
              ),
            );
          }));
}
