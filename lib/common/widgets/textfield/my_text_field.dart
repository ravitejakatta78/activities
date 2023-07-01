
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:publicschool_app/utilities/ps_colors.dart';

import '../../../utilities/fonts.dart';

class MyTextField extends StatelessWidget{
  final _controller = TextEditingController();

  final labelText;
  final hintText;
  final initialText;
  final obscureText;
  final double height;
  final inputAction;
  final keyboardType;
  final int linesLimit;
  final int? charactersLimit;
  final _focusNode;
  final _onSubmit;
  final _validationStream;
  final _onChange;
  final backgroundColor;

  MyTextField(
      {labelText,
        hintText = '',
        initialText = '',
        obscureText = false,
        height = 50.0,
        inputAction,
        keyboardType,
        charactersLimit,
        linesLimit = 1,
        focusNode,
        onSubmit,
        validationStream,
        onChange,
        backgroundColor})
      : this.labelText = labelText,
        this.hintText = hintText,
        this.initialText = initialText,
        this.obscureText = obscureText,
        this.height = height,
        this.inputAction = inputAction,
        this.linesLimit = linesLimit,
        this.charactersLimit = charactersLimit,
        this.keyboardType = keyboardType,
        _focusNode = focusNode,
        _onSubmit = onSubmit,
        _validationStream = validationStream,
        this.backgroundColor = backgroundColor,
        _onChange = onChange {
    _controller.text = initialText;
  }


  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: StreamBuilder<String>(
        initialData: null,
        stream: _validationStream,
        builder: (c, s) {
          return InputDecorator(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 12, right: 12),
              labelText: labelText,
              labelStyle: TextStyle(color: Colors.black),
              errorText: s.data,
              errorBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(25)),

              enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            ),
            child: Container(
              height: height,
              child: TextField(
                //controller: _controller,
                keyboardType: keyboardType,
                textInputAction: inputAction,
                style: TextStyle(color: PSColors.text_color,fontSize: 12,fontFamily: WorkSans.semiBold,),
                maxLines: linesLimit,
                onChanged: _onChange,
                onSubmitted: _onSubmit,
                obscureText: obscureText,
                focusNode: _focusNode,
                inputFormatters: [
                  if (charactersLimit != null)
                    LengthLimitingTextInputFormatter(charactersLimit)
                ],
                decoration: InputDecoration(
                  hintText: hintText,
                  hintMaxLines: 1,
                  border: InputBorder.none,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}