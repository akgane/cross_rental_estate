import 'package:rental_estate_app/models/estate.dart';

class EstateUtils{
  static List<Estate> copyList(List<Estate> target){
    return target.map((estate) => estate.copyWith()).toList();
  }

  static List<Estate> getRandomEstates(List<Estate> estates, int count){
    List<Estate> _estates = copyList(estates);
    _estates.shuffle();
    return _estates.take(count).toList();
  }
}