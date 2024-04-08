import 'package:appnote/edit_note_page.dart';
import 'package:flutter/material.dart';

class SearchInNotes extends SearchDelegate {
  List searchItems = [];
  double height;
  double width;
  SearchInNotes(
      {required this.searchItems, required this.height, required this.width});

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primaryColor: Colors.black,
      colorScheme: ColorScheme.dark(
        background: Colors.black,
      ),
      appBarTheme: AppBarTheme(
        color: Colors.black, // Set the app bar color to black
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              height * width * 0.000097), // Set border radius
          borderSide: BorderSide(color: Colors.white),
        ),
        contentPadding: EdgeInsets.only(
          bottom: width * height * 0.000016,
          top: width * height * 0.000016,
          left: width * height * 0.000016,
          right: width * height * 0.000016,
        ),
        fillColor: Colors.black,
        filled: true,
        hintStyle: TextStyle(color: Colors.white),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(height * width * 0.000097),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(
            Icons.clear,
            color: Colors.white,
          ))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List filterItems = searchItems
        .where((element) => element['note'].contains(query))
        .toList();

    return Container(
      height: height,
      width: width,
      //color: Colors.black,
      padding: EdgeInsets.only(
        top: height * width * 0.000064,
      ),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
        ),
        itemCount: query == "" ? searchItems.length : filterItems.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => EditNote(
                              id: query == ''
                                  ? searchItems[index]['id']
                                  : filterItems[index]['id'],
                              title: query == ''
                                  ? searchItems[index]['title']
                                  : filterItems[index]['title'],
                              note: query == ''
                                  ? searchItems[index]['note']
                                  : filterItems[index]['note'],
                              important: query == ''
                                  ? searchItems[index]['important']
                                  : filterItems[index]['important'],
                              date: query == ''
                                  ? searchItems[index]['date']
                                  : filterItems[index]['date'],
                            )),
                  );
                },
                child: Container(
                  height: height * 0.28,
                  width: width * 0.42,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius:
                        BorderRadius.circular(height * width * 0.000064),
                    boxShadow: (query == ''
                            ? searchItems[index]['important'] != 'yes'
                            : filterItems[index]['important'] != 'yes')
                        ? null
                        : [
                            BoxShadow(
                              color:
                                  Colors.green.withOpacity(0.5), // Shadow color
                              spreadRadius: 2, // Spread radius
                              blurRadius: 5, // Blur radius
                              offset: Offset(4, 5), // Offset of the shadow
                            ),
                          ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(height * width * 0.000025),
                    child: Text(
                      query == ''
                          ? "${searchItems[index]['note']}"
                          : "${filterItems[index]['note']}",
                      maxLines: 8,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 0.012 * height,
                ),
                child: Text(
                  query == ''
                      ? searchItems[index]['title']
                      : filterItems[index]['title'],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: height * width * 0.000064,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                query == ''
                    ? "${searchItems[index]["date"].substring(0, 10)}"
                    : "${filterItems[index]["date"].substring(0, 10)}",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
