import 'package:flutter/material.dart';
import 'package:jain_songs/custom_widgets/constantWidgets.dart';

//TODO: Making clear button to clear all textfield

class FormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              formFieldTitle('Name'),
              SizedBox(
                height: 7,
              ),
              formTextFeild(1),
              SizedBox(
                height: 20,
              ),
              formFieldTitle('Song Name'),
              SizedBox(
                height: 7,
              ),
              formTextFeild(null),
              SizedBox(
                height: 20,
              ),
              formFieldTitle('Lyrics / Link'),
              SizedBox(
                height: 7,
              ),
              formTextFeild(null),
              SizedBox(
                height: 20,
              ),
              formFieldTitle('Other Details'),
              SizedBox(
                height: 7,
              ),
              formTextFeild(null),
              SizedBox(
                height: 30,
              ),
              FlatButton(
                onPressed: () {},
                child: Container(
                  width: 250,
                  height: 57,
                  color: Color(0xFF7DCFEF),
                  child: Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
