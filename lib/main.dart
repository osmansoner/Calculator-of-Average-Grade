import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculating Grade',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String lessonName;
  int lessonCredit = 1;
  double letterGrade = 4;
  List<Ders> allLessons;
  static int counter = 0;
  var formKey = GlobalKey<FormState>();
  double mean = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allLessons = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //klavye açılınca sığmam durumu için
      appBar: AppBar(
        title: Text("Calculate Grade Average"),
        backgroundColor: Colors.lightGreen.shade600,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
          }
        },
        child: Icon(
          Icons.add,
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return appBody();
          } else {
            return appBodyLandScape();
          }
        },
      ),
    );
  }

  Widget appBody() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Lesson Name",
                      labelStyle: TextStyle(fontSize: 20),
                      hintText: "Math",
                      hintStyle: TextStyle(fontSize: 20),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                    ),
                    validator: (typedLesson) {
                      if (typedLesson.length >= 0) {
                        return null;
                      } else {
                        return "Lesson Name can't be empty";
                      }
                    },
                    onSaved: (savedLesson) {
                      lessonName = savedLesson;
                      setState(() {
                        allLessons.add(Ders(lessonName, letterGrade,
                            lessonCredit, createRandomColor()));
                        mean = 0;
                        _calculateMean();
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            items: lessonCreditItems(),
                            value: lessonCredit,
                            onChanged: (selectedCredit) {
                              setState(() {
                                lessonCredit = selectedCredit;
                              });
                            },
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      Container(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<double>(
                            items: lessonLetterGrade(),
                            value: letterGrade,
                            onChanged: (selectedLetterGrade) {
                              setState(() {
                                letterGrade = selectedLetterGrade;
                              });
                            },
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 70,
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                    text: allLessons.length == 0
                        ? "Please type a lesson!"
                        : "Mean: ",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  TextSpan(
                    text: allLessons.length == 0
                        ? ""
                        : "${mean.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 30,
                      color: mean < 2.0 ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemBuilder: _createListElement,
                itemCount: allLessons.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> lessonCreditItems() {
    List<DropdownMenuItem<int>> creditGrade = [];
    for (int i = 1; i <= 10; i++) {
      /*
      var ii = DropdownMenuItem<int>(value: i, child: Text("$i Credit"));
      creditGrade.add(ii);

       */
      creditGrade.add(
        DropdownMenuItem<int>(
          value: i,
          child: Text(
            "$i Credit",
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }
    return creditGrade;
  }

  List<DropdownMenuItem<double>> lessonLetterGrade() {
    List<DropdownMenuItem<double>> letters = [];
    letters.add(DropdownMenuItem(
      child: Text(
        " AA ",
        style: TextStyle(fontSize: 20),
      ),
      value: 4,
    ));
    letters.add(DropdownMenuItem(
      child: Text(
        " BA ",
        style: TextStyle(fontSize: 20),
      ),
      value: 3.5,
    ));
    letters.add(DropdownMenuItem(
      child: Text(
        " BB ",
        style: TextStyle(fontSize: 20),
      ),
      value: 3,
    ));
    letters.add(DropdownMenuItem(
      child: Text(
        " CB ",
        style: TextStyle(fontSize: 20),
      ),
      value: 2.5,
    ));
    letters.add(DropdownMenuItem(
      child: Text(
        " CC ",
        style: TextStyle(fontSize: 20),
      ),
      value: 2,
    ));
    letters.add(DropdownMenuItem(
      child: Text(
        " DC ",
        style: TextStyle(fontSize: 20),
      ),
      value: 1.5,
    ));
    letters.add(DropdownMenuItem(
      child: Text(
        " DD ",
        style: TextStyle(fontSize: 20),
      ),
      value: 1,
    ));
    letters.add(DropdownMenuItem(
      child: Text(
        " FF ",
        style: TextStyle(fontSize: 20),
      ),
      value: 0,
    ));
    return letters;
  }

  Widget _createListElement(BuildContext context, int index) {
    counter++;
    debugPrint(counter.toString());
    return Dismissible(
      key: Key(counter.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          allLessons.removeAt(index);
          _calculateMean();
        });
      },
      child: Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: allLessons[index].color, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.done,
                color: allLessons[index].color,
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.keyboard_arrow_right,
                color: allLessons[index].color,
              ),
              Text(
                "Remove",
                style: TextStyle(color: allLessons[index].color, fontSize: 12),
              ),
            ],
          ),
          title: Text(allLessons[index].name),
          subtitle: Text(allLessons[index].credit.toString() +
              " credit Lesson Grade: " +
              allLessons[index].letterGrade.toString()),
        ),
      ),
    );
  }

  void _calculateMean() {
    double totalGrade = 0;
    double totalCredit = 0;
    for (var currentLesson in allLessons) {
      var credit = currentLesson.credit;
      var letterGrade = currentLesson.letterGrade;

      totalGrade = totalGrade + (letterGrade * credit);
      totalCredit = totalCredit + credit;
    }
    mean = totalGrade / totalCredit;
  }

  Color createRandomColor() {
    return Color.fromARGB(155 + Random().nextInt(105), Random().nextInt(255),
        Random().nextInt(255), Random().nextInt(255));
  }

  Widget appBodyLandScape() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Lesson Name",
                            labelStyle: TextStyle(fontSize: 20),
                            hintText: "Math",
                            hintStyle: TextStyle(fontSize: 20),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 2),
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.green, width: 2),
                            ),
                          ),
                          validator: (typedLesson) {
                            if (typedLesson.length >= 0) {
                              return null;
                            } else {
                              return "Lesson Name can't be empty";
                            }
                          },
                          onSaved: (savedLesson) {
                            lessonName = savedLesson;
                            setState(() {
                              allLessons.add(Ders(lessonName, letterGrade,
                                  lessonCredit, createRandomColor()));
                              mean = 0;
                              _calculateMean();
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  items: lessonCreditItems(),
                                  value: lessonCredit,
                                  onChanged: (selectedCredit) {
                                    setState(() {
                                      lessonCredit = selectedCredit;
                                    });
                                  },
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 4),
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.red, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            Container(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<double>(
                                  items: lessonLetterGrade(),
                                  value: letterGrade,
                                  onChanged: (selectedLetterGrade) {
                                    setState(() {
                                      letterGrade = selectedLetterGrade;
                                    });
                                  },
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 4),
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.red, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(5),
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                            text: allLessons.length == 0
                                ? "Please type a lesson!"
                                : "Mean: ",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          TextSpan(
                            text: allLessons.length == 0
                                ? ""
                                : "${mean.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 30,
                              color: mean < 2.0 ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            flex: 1,
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemBuilder: _createListElement,
                itemCount: allLessons.length,
              ),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }
}

class Ders {
  String name;
  double letterGrade;
  int credit;
  Color color;
  Ders(this.name, this.letterGrade, this.credit, this.color);
}
