import 'package:flutter/material.dart';

class ErrorModel {
  final String errorMessage;
  final Widget? errorImage;
  final int? statusCode;

  const ErrorModel({
    required this.errorMessage,
    this.errorImage,
    this.statusCode,
  });
}
