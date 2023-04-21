import 'package:chattyhive/shared/constants.dart';
import 'package:flutter/material.dart';

final textInputDecotation = InputDecoration(
    labelStyle: const TextStyle(color: Colors.black),
    focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF50BFA6), width: 2),
        borderRadius: BorderRadius.circular(8)),
    enabledBorder: OutlineInputBorder(
        borderSide: const  BorderSide(color: Colors.grey, width: 2)
        ,borderRadius: BorderRadius.circular(8),
        ),
        
    errorBorder:  OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent, width: 2)
        ,borderRadius: BorderRadius.circular(8),
        ));

void showSnackBar(message, color, context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message,style: const TextStyle(fontSize: 14),),
    backgroundColor: color,
    duration: const Duration(seconds: 2),
    action: SnackBarAction(label: "Ok",onPressed: (){},textColor: Constants.primary,),
  ));
}
