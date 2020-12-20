import 'dart:convert';
import 'package:book_midterm/BooksDetail.dart';
import 'package:book_midterm/DetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(MaterialApp(home: MainScreen()));

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

List book;

class _MainScreenState extends State<MainScreen> {
  double screenHeight, screenWidth;
  String title = "";

  @override
  void initState() {
    super.initState();
    _loadBook();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('List of All Books'),
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        children: [
          book == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 18,
                      backgroundColor: Colors.cyan,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ))))
              : Flexible(
                  child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: (screenWidth / screenHeight) / 0.90,
                  children: List.generate(book.length, (index) {
                    return Padding(
                        padding: EdgeInsets.all(10),
                        child: Card(
                          child: InkWell(
                            onTap: () => _loadBookDetail(index),
                            child: Column(
                              children: [
                                Container(
                                    height: screenHeight / 4.0,
                                    width: screenWidth / 3.0,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "http://slumberjer.com/bookdepo/bookcover/${book[index]['cover']}.jpg",
                                      fit: BoxFit.contain,
                                      placeholder: (context, url) =>
                                          new CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          new Icon(
                                        Icons.broken_image,
                                        size: screenWidth / 2,
                                      ),
                                    )),
                                SizedBox(height: 2.5),
                                Text(
                                  book[index]['booktitle'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'by ' + book[index]['author'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'RM' + book[index]['price'],
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Rating: ' + book[index]['rating'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
                  }),
                ))
        ],
      ),
    );
  }

  void _loadBook() {
    http.post("http://slumberjer.com/bookdepo/php/load_books.php",
        body: {}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        book = null;
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          book = jsondata["books"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _loadBookDetail(int index) {
    print(book[index]['booktitle']);

    BookDetail booksDetail = new BookDetail(
      bookid: book[index]['bookid'],
      booktitle: book[index]['booktitle'],
      author: book[index]['author'],
      price: book[index]['price'],
      description: book[index]['description'],
      rating: book[index]['rating'],
      publisher: book[index]['publisher'],
      isbn: book[index]['isbn'],
      cover: book[index]['cover'],
    );

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                DetailScreen(book: booksDetail)));
  }
}
