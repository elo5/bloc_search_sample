import 'package:flutter/material.dart';
import 'package:bloc_search_sample/bloc/bloc_provicer.dart';
import 'package:bloc_search_sample/bloc/search_bloc.dart';
import 'package:bloc_search_sample/ui/search_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Search Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Flutter Search Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Click the button to search',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ((){

          Navigator.push(
              context,
              new MaterialPageRoute<void>(
                  builder: (ctx) => new BlocProvider<SearchBloc>(
                    child: SearchPage(),
                    bloc: new SearchBloc(),
                  )));
        }),
        tooltip: 'Search',
        child: Icon(Icons.search),
      ),
    );
  }
}
