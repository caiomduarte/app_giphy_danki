import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class TelaHome extends StatefulWidget {
  const TelaHome({Key? key}) : super(key: key);

  @override
  _TelaHomeState createState() => _TelaHomeState();
}

class _TelaHomeState extends State<TelaHome> {
  Future<Map> _buscarGifs() async {
    http.Response response;

    var urlTrending = Uri.parse(
        "https://api.giphy.com/v1/gifs/trending?api_key=0ULdKYOik0CmByHRQVDiCJPkQvbaWl55&limit=25&rating=g");

    response = await http.get(urlTrending);

    return json.decode(response.body);
  }

  Widget _tabelaGifs(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8),
        itemCount: snapshot.data["data"].length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Image.network(
              snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              height: 300,
              fit: BoxFit.cover,
            ),
          );
        });
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    _buscarGifs().then((item) {
      print(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Image.network(
              "https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                decoration: InputDecoration(
                    labelText: "Pesquisar Gifs",
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    )),
              ),
            ),
            Expanded(
                child: FutureBuilder(
                    future: _buscarGifs(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return Container(
                            width: 200,
                            height: 200,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                              strokeWidth: 5,
                            ),
                          );
                        default:
                          if (snapshot.hasError) {
                            return Container();
                          } else {
                            return _tabelaGifs(context, snapshot);
                          }
                      }
                    }))
          ],
        ));
  }
}
