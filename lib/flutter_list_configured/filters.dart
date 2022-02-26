import 'package:flutter/material.dart';

class Filters {
  String category;
  String name;
  Color color;

  Filters(this.category, this.name, {this.color = Colors.indigo});
}

class UserFilters {
  String genre;
  String tirthankar;
  String category;
  String language;

  UserFilters({
    this.genre = "",
    this.tirthankar = "",
    this.category = "",
    this.language = "",
  });

  Map<String, String> toMap() {
    return {
      'genre': genre,
      'tirthankar': tirthankar,
      'category': category,
      'language': language,
    };
  }
}
