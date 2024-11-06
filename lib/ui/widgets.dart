import 'package:flutter/material.dart';

Widget emptyList() {
  return const Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(
          Icons.not_interested,
          size: 32,
        ),
      ),
      Text(
        'Нет контактов',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    ],
  );
}
