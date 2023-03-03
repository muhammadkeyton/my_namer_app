import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
                seedColor:
                    Color(0xFF3E54AC)) //provides the theme for the whole app
            ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var currentWord = WordPair.random();
  var favorites = <WordPair>[];

  void getNext() {
    currentWord = WordPair.random();
    notifyListeners();
  }

  void toggleFavorite() {
    if (favorites.contains(currentWord)) {
      favorites.remove(currentWord);
    } else {
      favorites.add(currentWord);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void bottomNavItemTap(int index){
      print('item tapped $index');
      setState((){
        _selectedIndex = index;
      });
  }


  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var titleText = theme.textTheme.bodySmall!.copyWith(
      color:theme.colorScheme.onPrimary,
    );



    Widget Page;

    switch(_selectedIndex){
      case 0:
        Page = WordGenerator();
        break;
      case 1:
        Page = Favorites();
        break;
      default:
        throw UnimplementedError('no widget for index $_selectedIndex');
    }

    

    return Scaffold(
        appBar: AppBar(
          title: Text('My Namer App',style:titleText),
          backgroundColor: theme.colorScheme.primary,
        ),
        body: Page,
        bottomNavigationBar: SafeArea(
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorites',
              ),
            ],
            currentIndex:_selectedIndex,
            onTap:bottomNavItemTap,
          ),
        ),
      );
   

    
  }
}

class WordGenerator extends StatelessWidget {
  const WordGenerator({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    var pair = appState.currentWord;

    Icon likeIcon;

    //like button
    if (appState.favorites.contains(pair)) {
      likeIcon = Icon(Icons.favorite);
    } else {
      likeIcon = Icon(Icons.favorite_border);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WordCard(pair: pair),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                  icon: likeIcon,
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  label: Text('Like')),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text("Next"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WordCard extends StatelessWidget {
  const WordCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var textStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      elevation: 5,
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          style: textStyle,
          pair.asLowerCase,
          semanticsLabel: pair.asPascalCase,
        ),
      ),
    );
  }
}


class Favorites extends StatelessWidget{
  const Favorites({super.key});

  @override
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty){
      return Center(child: Text('you have no favorite words yet!'));
    }
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Text('you have ${appState.favorites.length} favorites'),
        ),
        for (var word in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('$word'),
          )
        
      ],
    );
  }
}
