import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ibmi/widgets/info_card.dart';

class BMIPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BMIPageState();
  }
}

class _BMIPageState extends State<BMIPage> {
  int age = 25, weight = 160, height = 70, gender = 0;

  double? _deviceHeight, _deviceWidth;
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return CupertinoPageScaffold(
      child: Center(
        child: Container(
          height: _deviceHeight! * .85,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _ageSelectContainer(),
                  _weightSelectContainer(),
                ],
              ),
              _heightSelectContainer(),
              _genderSelectContainer(),
              _calculateBMIButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ageSelectContainer() {
    return InfoCard(
      height: _deviceHeight! * 0.20,
      width: _deviceWidth! * 0.45,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Age yr',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            age.toString(),
            style: const TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                child: CupertinoDialogAction(
                  onPressed: () {
                    setState(() {
                      age--;
                    });
                  },
                  child: Text('-'),
                  textStyle: const TextStyle(
                    fontSize: 25,
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(
                width: 50,
                child: CupertinoDialogAction(
                  onPressed: () {
                    setState(() {
                      age++;
                    });
                  },
                  child: Text('+'),
                  textStyle: const TextStyle(
                    fontSize: 25,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _weightSelectContainer() {
    return InfoCard(
      height: _deviceHeight! * 0.20,
      width: _deviceWidth! * 0.45,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Weight lbs",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            weight.toString(),
            style: const TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                child: CupertinoDialogAction(
                  onPressed: () {
                    setState(() {
                      weight--;
                    });
                  },
                  child: const Text(
                    "-",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 50,
                child: CupertinoDialogAction(
                  onPressed: () {
                    setState(() {
                      weight++;
                    });
                  },
                  child: const Text(
                    "+",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heightSelectContainer() {
    return InfoCard(
      height: _deviceHeight! * 0.15,
      width: _deviceWidth! * 0.90,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Height in',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            height.toString(),
            style: const TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            width: _deviceWidth! * 0.80,
            child: CupertinoSlider(
              min: 0,
              max: 96,
              divisions: 96,
              value: height.toDouble(),
              onChanged: (_value) {
                setState(() {
                  height = _value.toInt();
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _genderSelectContainer() {
    return InfoCard(
      height: _deviceHeight! * 0.11,
      width: _deviceWidth! * 0.90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Gender',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          CupertinoSlidingSegmentedControl(
            groupValue: gender,
            children: const {
              0: Text("Male"),
              1: Text("Female"),
            },
            onValueChanged: (_value) {
              setState(() {
                gender = _value as int;
              });
            },
          )
        ],
      ),
    );
  }

  Widget _calculateBMIButton() {
    return Container(
      height: _deviceHeight! * 0.07,
      child: CupertinoButton.filled(
        child: const Text(
          "Calculate BMI",
        ),
        onPressed: () {
          if (height > 0 && weight > 0 && age > 0) {
            double _bmi = 703 * (weight / pow(height, 2));
            showResultDialog(_bmi);
          }
        },
      ),
    );
  }

  void showResultDialog(double _bmi) {
    String? _status;
    if (_bmi < 18.5) {
      _status = "Underweight";
    } else if (_bmi >= 18.5 && _bmi < 25) {
      _status = "Normal";
    } else if (_bmi >= 25 && _bmi < 30) {
      _status = "Overweight";
    } else if (_bmi >= 30) {
      _status = "Obese";
    }

    showCupertinoDialog(
      context: context,
      builder: (BuildContext _context) {
        return CupertinoAlertDialog(
          title: Text(_status!),
          content: Text(
            _bmi.toStringAsFixed(2),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Ok'),
              onPressed: () {
                _saveResult(_bmi.toString(), _status!);
                Navigator.pop(_context);
              },
            ),
          ],
        );
      },
    );
  }

  void _saveResult(String _bmi, String _status) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'bmi_date',
      DateTime.now().toString(),
    );
    await prefs.setStringList('bmi_data', <String>[_bmi, _status]);
    print("Results Saved");
  }
}
