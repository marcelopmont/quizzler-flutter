import 'package:flutter/material.dart';
import 'package:quizzler/quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {

  List<Icon> scoreKeeper = [];

  QuizBrain quizBrain = QuizBrain();

  void checkAnswer(bool userPickedAnswer) {
    bool isCorrect = quizBrain.isUserAnswerCorrect(userPickedAnswer);

    if (isCorrect) {
      addCorrectAnswer();
    } else {
      addWrongAnswer();
    }

    setState(() {
      bool isFinished = quizBrain.nextQuestion();

      if (isFinished) {
        Alert(context: context,
            title: 'Quiz Finished',
            desc: 'Congrats! Your score is ${quizBrain.getScore()}',
            closeFunction: () {
              setState(() {
                quizBrain.reset();
                scoreKeeper = [];
              });
            },
            buttons: [
              DialogButton(
                child: Text(
                  'Play again',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  setState(() {
                    quizBrain.reset();
                    scoreKeeper = [];
                    Navigator.pop(context);
                  });
                },
                width: 120,
              )
            ]).show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                checkAnswer(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                checkAnswer(false);
              },
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        ),
      ],
    );
  }

  void addCorrectAnswer() {
    scoreKeeper.add(
        Icon(
          Icons.check,
          color: Colors.green,
        )
    );
  }

  void addWrongAnswer() {
    scoreKeeper.add(
        Icon(
          Icons.close,
          color: Colors.red,
        )
    );
  }
}