import 'package:auraflow/data/models/ambience_model.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class AmbienceRepository {
  Future<List<Ambience>> getAmbiences() async{
    final jsonString= await rootBundle.loadString('assets/data/ambiences.json');

    final List data=json.decode(jsonString);

    return data.map((e)=> Ambience.fromJson(e)).toList();
  }
}