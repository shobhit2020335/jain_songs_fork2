import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jain_songs/custom_widgets/constantWidgets.dart';

//TODO: Making clear button to clear all textfield

class FormPage extends StatelessWidget {
  final textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.black,
                    child: Icon(
                      FontAwesomeIcons.music,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Geet',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontFamily: 'Pacifico',
                      fontWeight: FontWeight.w100,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Suggest us some songs.',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'If you provide the lyrics or link for the lyrics, credit of the song will be given to you once the song is uploaded.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        formFieldTitle('Name'),
                        SizedBox(
                          height: 7,
                        ),
                        formTextFeild(
                          1,
                          hint: 'Name',
                          editingController: textFieldController,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        formFieldTitle('Email'),
                        SizedBox(
                          height: 7,
                        ),
                        formTextFeild(
                          1,
                          hint: 'Email',
                          editingController: textFieldController,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              formFieldTitle('Song Name'),
              SizedBox(
                height: 7,
              ),
              formTextFeild(null,
                  hint: 'Song name', editingController: textFieldController),
              SizedBox(
                height: 20,
              ),
              formFieldTitle('Lyrics / Link'),
              SizedBox(
                height: 7,
              ),
              formTextFeild(
                null,
                hint: 'Lyrics or link where lyrics can be found',
                editingController: textFieldController,
              ),
              SizedBox(
                height: 20,
              ),
              formFieldTitle('Other Details'),
              SizedBox(
                height: 7,
              ),
              formTextFeild(
                null,
                hint: 'Other details of the song.',
                editingController: textFieldController,
              ),
              SizedBox(
                height: 30,
              ),
              FlatButton(
                onPressed: () {
                  showToast(
                    context,
                    'ThankYou for suggesting! Song will be updated soon.',
                  );
                  textFieldController.clear();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0xFF54BEE6),
                  ),
                  width: 250,
                  height: 57,
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
