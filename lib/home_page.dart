import 'package:appnote/add_note_page.dart';
import 'package:appnote/edit_note_page.dart';
import 'package:appnote/search_page.dart';
import 'package:appnote/sql_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SqlDB sqlDb = SqlDB();
  List notes = [];
  List<Map<dynamic, dynamic>> items = List.empty(growable: true);
  bool longPressedMode = false;
  bool canPop = true;
  bool _isLoading = true;
  int itemsCount = 0;
  Widget selectAll = Icon(
    Icons.circle,
    color: Colors.grey,
  );
  bool showSelectAllIcon = false;

  void CountingSelectedItems() {
    itemsCount = 0;
    for (int i = 0; i < items.length; i++) {
      if (items[i]['selected']) itemsCount++;
    }
  }

  Future FetchNotes() async {
    List response = await sqlDb.Select("SELECT * FROM 'notes'");
    setState(() {
      notes = List.from(response);
      items.clear();
      for (int i = 0; i < notes.length; i++)
        items.add({'id': notes[i]['id'], 'selected': false});
    });
  }

  Future DeleteNote(String query) async {
    int response = await sqlDb.Delete(query);
  }

  bool _shouldShowDeleteButton() {
    for (int i = 0; i < items.length; i++) {
      if (items[i]['selected']) return true;
    }
    return false;
  }

  void _deleteSelectedNotes(List items) {
    for (int i = items.length - 1; i >= 0; i--) {
      if (items[i]['selected']) {
        DeleteNote("DELETE FROM notes WHERE id = ${items[i]['id']}");

        items.removeAt(i);

        notes.removeAt(i);
      }
    }
    setState(() {
      if (canPop == false) canPop = true;
    });
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
    FetchNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: canPop,
      onPopInvoked: (didPop) {
        if (didPop == false) {
          setState(() {
            for (int i = 0; i < items.length; i++) {
              items[i]['selected'] = false;
            }
            canPop = true;
            longPressedMode = false;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: longPressedMode == false
            ? CircleAvatar(
                radius: height * width * 0.0001,
                backgroundColor: Colors.grey[850],
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AddNote()));
                  },
                  icon: Icon(
                    Icons.add_box_outlined,
                    size: height * width * 0.0001,
                    color: Colors.amber[900],
                  ),
                ),
              )
            : SizedBox(),
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: width * 0.3,
                    child: _shouldShowDeleteButton()
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                if (showSelectAllIcon == true) {
                                  showSelectAllIcon = false;
                                  longPressedMode = false;
                                } else {
                                  showSelectAllIcon = true;
                                }
                                selectAll = Icon(
                                  showSelectAllIcon
                                      ? Icons.check_circle
                                      : Icons.circle,
                                  color: showSelectAllIcon
                                      ? Colors.amber[900]
                                      : Colors.grey,
                                );
                                for (int i = 0; i < items.length; i++) {
                                  if (showSelectAllIcon)
                                    items[i]['selected'] = true;
                                  else
                                    items[i]['selected'] = false;
                                }
                                itemsCount = items.length;
                              });
                            },
                            icon: Row(
                              children: [
                                selectAll,
                                Expanded(
                                  child: Text(
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    "All \n(${itemsCount} Notes)",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : null,
                  ),
                  Text(
                    "All Notes",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: height * width * 0.0001,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: width * 0.18,
                  ),
                  IconButton(
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: SearchInNotes(
                            searchItems: notes, height: height, width: width),
                      );
                    },
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: height * width * 0.0001,
                    ),
                  )
                ],
              ),
              Flexible(
                child: notes.length == 0
                    ? _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                            color: Colors.amber[900],
                          )) // Show circular progress indicator while loading
                        : Center(
                            child: Text(
                              "There are no notes yet!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                    : AnimationLimiter(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // Number of columns
                                  childAspectRatio: 0.6),
                          itemCount:
                              notes.length, // Number of items in the grid
                          itemBuilder: (BuildContext context, int oldIndex) {
                            int index = notes.length - 1 - oldIndex;
                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              columnCount: 2,
                              child: SlideAnimation(
                                horizontalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        0.000064 * height * width),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        InkWell(
                                          onLongPress: () {
                                            if (longPressedMode == false) {
                                              longPressedMode = true;
                                              canPop = false;
                                            }

                                            setState(() {
                                              if (items[index]['selected'] ==
                                                  true) {
                                                items[index]['selected'] =
                                                    false;
                                              } else {
                                                items[index]['selected'] = true;
                                              }
                                              CountingSelectedItems();
                                              if (itemsCount == items.length) {
                                                showSelectAllIcon = true;
                                                selectAll = Icon(
                                                  Icons.check_circle,
                                                  color: Colors.amber[900],
                                                );
                                              } else {
                                                showSelectAllIcon = false;
                                                selectAll = Icon(
                                                  Icons.circle,
                                                  color: Colors.grey,
                                                );
                                              }
                                            });
                                          },
                                          onTap: () {
                                            if (_shouldShowDeleteButton() ==
                                                false) {
                                              longPressedMode = false;
                                            }
                                            if (longPressedMode == false) {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditNote(
                                                            id: notes[index]
                                                                ['id'],
                                                            title: notes[index]
                                                                ['title'],
                                                            note: notes[index]
                                                                ['note'],
                                                            important: notes[
                                                                    index]
                                                                ['important'],
                                                            date: notes[index]
                                                                ['date'],
                                                          )));
                                            } else {
                                              setState(() {
                                                if (items[index]['selected'] ==
                                                    true) {
                                                  items[index]['selected'] =
                                                      false;
                                                } else {
                                                  items[index]['selected'] =
                                                      true;
                                                }
                                                if (_shouldShowDeleteButton() ==
                                                    false) {
                                                  longPressedMode = false;
                                                }
                                                CountingSelectedItems();
                                                if (itemsCount ==
                                                    items.length) {
                                                  showSelectAllIcon = true;
                                                  selectAll = Icon(
                                                    Icons.check_circle,
                                                    color: Colors.amber[900],
                                                  );
                                                } else {
                                                  showSelectAllIcon = false;
                                                  selectAll = Icon(
                                                    Icons.circle,
                                                    color: Colors.grey,
                                                  );
                                                }
                                              });
                                            }
                                          },
                                          child: Container(
                                            height: height * 0.25,
                                            width: width * 0.45,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[900],
                                              borderRadius:
                                                  BorderRadius.circular(height *
                                                      width *
                                                      0.000064),
                                              boxShadow: notes[index]
                                                          ['important'] !=
                                                      'yes'
                                                  ? null
                                                  : [
                                                      BoxShadow(
                                                        color: Colors.green
                                                            .withOpacity(
                                                                0.5), // Shadow color
                                                        spreadRadius:
                                                            2, // Spread radius
                                                        blurRadius:
                                                            5, // Blur radius
                                                        offset: Offset(4,
                                                            5), // Offset of the shadow
                                                      ),
                                                    ],
                                            ),
                                            child: Stack(
                                              children: [
                                                if (items[index]['selected'])
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.check_circle,
                                                        color:
                                                            Colors.amber[900],
                                                        size: height *
                                                            width *
                                                            0.00008,
                                                      ),
                                                    ),
                                                  ),
                                                Padding(
                                                  padding: EdgeInsets.all(
                                                      height *
                                                          width *
                                                          0.000025),
                                                  child: Text(
                                                    "${notes[index]['note']}",
                                                    maxLines: 8,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: 0.012 * height,
                                          ),
                                          child: Text(
                                            notes[index]['title'] == ''
                                                ? "Text Note"
                                                : notes[index]['title'],
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize:
                                                  height * width * 0.000064,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "${notes[index]["date"].substring(0, 10)}",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
              _shouldShowDeleteButton()
                  ? Padding(
                      padding: EdgeInsets.all(height * width * 0.00007),
                      child: Container(
                        height: height * 0.062,
                        width: width * 0.260,
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius:
                              BorderRadius.circular(height * width * 0.000064),
                        ),
                        child: InkWell(
                          onTap: () {
                            CountingSelectedItems();
                            showModalBottomSheet(
                                context: context,
                                backgroundColor: Color.fromARGB(0, 0, 0, 8),
                                builder: (context) {
                                  return Padding(
                                    padding: EdgeInsets.all(
                                        height * width * 0.000048),
                                    child: Container(
                                      height: height * 0.149,
                                      width: width,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[900],
                                        borderRadius: BorderRadius.circular(
                                            height * width * 0.000097),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: width * 0.03),
                                            child: Text(
                                              items.length == 1
                                                  ? "Do you want to delete this note?"
                                                  : "Do you want to delete ${itemsCount} notes?",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            height *
                                                                width *
                                                                0.000064),
                                                  ),
                                                  minimumSize: Size(
                                                      width * 0.39,
                                                      height * 0.049),
                                                  backgroundColor:
                                                      Colors.grey[900],
                                                  side: BorderSide(
                                                      width: 0,
                                                      color: Colors.grey[900]!),
                                                  foregroundColor: Colors.white,
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                color: Colors.grey[850],
                                                height: height * 0.024,
                                                width: width * 0.00260,
                                              ),
                                              OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            height *
                                                                width *
                                                                0.000064),
                                                  ),
                                                  minimumSize: Size(
                                                      width * 0.39,
                                                      height * 0.049),
                                                  backgroundColor:
                                                      Colors.grey[900],
                                                  side: BorderSide(
                                                      width: 0,
                                                      color: Colors.grey[900]!),
                                                  foregroundColor: Colors.white,
                                                ),
                                                onPressed: () {
                                                  longPressedMode = false;
                                                  _deleteSelectedNotes(items);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Center(
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.amber[900],
                                  size: height * width * 0.0001,
                                ),
                              ),
                              Center(
                                  child: Text(
                                "Delete",
                                style: TextStyle(
                                  color: Colors.amber[900],
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
