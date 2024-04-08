import 'package:appnote/home_page.dart';
import 'package:appnote/sql_db.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  bool importantt = false;
  String important = 'no';
  String title = '';
  String note = '';
  SqlDB sqlDB = SqlDB();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: CircleAvatar(
          radius: height * width * 0.0001,
          backgroundColor: Colors.grey[850],
          child: IconButton(
            onPressed: () async {
              int response = await sqlDB.Insert(
                  "INSERT INTO 'notes' ('note','title','important','date')VALUES ('$note','$title','$important','${DateTime.now().toString()}')");

              if (response > 0) {
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
                          SizedBox(
                            height: height * 0.1,
                            width: width * 0.6,
                            child: TextFormField(
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              controller: titleController,
                              onChanged: (text) {
                                title = text;
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
                                  value: importantt,
                                  onChanged: (on) {
                                    setState(() {
                                      importantt = !importantt;
                                      if (importantt == true) {
                                        important = 'yes';
                                      } else {
                                        important = 'no';
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
                            note = text;
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
