import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final userRef = FirebaseFirestore.instance.collection("users");
const style = TextStyle(
  fontSize: 18,
);
