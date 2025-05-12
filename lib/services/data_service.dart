import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rental_estate_app/providers/estate_provider.dart';

import '../models/estate.dart';


class DataService{
  final EstateProvider estateProvider;

  const DataService({
    Key? key,
    required this.estateProvider
  });

  // Future<List<Estate>> fetchEstates() async{
  //   await estateProvider.loadEstates();
  //   QuerySnapshot snapshot = QuerySnapshot();
  //
  // }
}