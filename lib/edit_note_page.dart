// ignore_for_file: must_be_immutable

import 'package:appnote/home_page.dart';
import 'package:appnote/sql_db.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditNote extends StatefulWidget {
  String title;
  String note;
  String important;
  String date;
  int id;
  EditNote(
      {super.key,
      required this.title,
      required this.note,
      required this.important,
      required this.date,
      required this.id});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  bool? important;
  SqlDB sqlDB = SqlDB();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    titleController.text = widget.title;
    noteController.text = widget.note;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: CircleAvatar(
          radius: height * width * 0.0001,
          backgroundColor: Colors.grey[850],
          child: IconButton(
            onPressed: () async {
              int response = await sqlDB.Delete(
                  "DELETE FROM notes WHERE id = ${widget.id}");
              int response1 = await sqlDB.Insert(
                  "INSERT INTO 'notes' ('note','title','important','date')VALUES ('${widget.note}','${widget.title}','${widget.important}','${DateTime.now().toString()}')");

              if ((response > 0) && (response1 > 0)) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (route) => false);
              }
            },
            icon: Icon(
              Icons.data_saver_on_sharp,
              size: height * width * 0.0001,
              color: Colors.amber[900],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: SizedBox(
              height: height,
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(height * width * 0.000064),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              right: height * width * 0.000022,
                              bottom: height * width * 0.000048,
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[850],
                              child: IconButton(
                                onPressed: () async {
                                  showModalBottomSheet(
                                      context: context,
                                      backgroundColor:
                                          Color.fromARGB(0, 0, 0, 8),
                                      builder: (context) {
                                        return Padding(
                                          padding: EdgeInsets.all(
                                              height * width * 0.000048),
                                          child: Container(
                                            height: height * 0.149,
                                            width: width,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[900],
                                              borderRadius:
                                                  BorderRadius.circular(height *
                                                      width *
                                                      0.000097),
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
                                                    "Do you want to delete this note?",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    OutlinedButton(
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        shape:
                                                            RoundedRectangleBorder(
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
                                                            color: Colors
                                                                .grey[900]!),
                                                        foregroundColor:
                                                            Colors.white,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      color: Colors.grey[850],
                                                      height: height * 0.024,
                                                      width: width * 0.00260,
                                                    ),
                                                    OutlinedButton(
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        shape:
                                                            RoundedRectangleBorder(
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
                                                            color: Colors
                                                                .grey[900]!),
                                                        foregroundColor:
                                                            Colors.white,
                                                      ),
                                                      onPressed: () async {
                                                        int response =
                                                            await sqlDB.Delete(
                                                                "DELETE FROM notes WHERE id = ${widget.id}");
                                                        if (response > 0) {
                                                          Navigator.of(context)
                                                              .pushReplacement(
                                                                  MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    HomePage(),
                                                          ));
                                                        }
                                                      },
                                                      child: Text(
                                                        "Delete",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.amber[900],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.1,
                            width: width * 0.55,
                            child: TextFormField(
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              controller: titleController,
                              onChanged: (text) {
                                widget.title = text;
                              },
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    height * width * 0.08,
                                  ),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    height * width * 0.08,
                                  ),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                labelText: "Title",
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              cursorColor: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: height * width * 0.00022,
                            width: height * width * 0.00025,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "is important?",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: height * width * 0.00004),
                                ),
                                CupertinoSwitch(
                                  value: widget.important == 'yes'
                                      ? important = true
                                      : important = false,
                                  onChanged: (on) {
                                    setState(() {
                                      important = !important!;
                                      if (important == true) {
                                        widget.important = 'yes';
                                      } else {
                                        widget.important = 'no';
                                      }
                                    });
                                  },
                                  activeColor: Colors.green,
                                  trackColor: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: height * 0.08,
                    ),
                    child: Container(
                      width: width, // Adjust width as needed
                      height: height * 0.75, // Adjust height as needed
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(
                          height * width * 0.00006,
                        ),
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(height * width * 0.000025),
                        child: TextField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          controller: noteController,
                          onChanged: (text) {
                            widget.note = text;
                          },
                          maxLines: null, // Allow multiple lines
                          decoration: InputDecoration.collapsed(
                            hintText: "Write your note here",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
