import 'package:rental_estate_app/models/estate.dart';

class SortUtils {
  static List<Estate> sortBy(String sortBy, List<Estate> estates, bool isAscending) {
    switch (sortBy) {
      case "price":
        estates.sort((a, b) => isAscending 
          ? a.price.compareTo(b.price)
          : b.price.compareTo(a.price));
        break;
      case "title":
        estates.sort((a, b) => isAscending 
          ? a.title.compareTo(b.title)
          : b.title.compareTo(a.title));
        break;
      case "date":
        estates.sort((a, b) => isAscending 
          ? a.postedDate.compareTo(b.postedDate)
          : b.postedDate.compareTo(a.postedDate));
        break;
      case "views":
        estates.sort((a, b) => isAscending 
          ? a.views.compareTo(b.views)
          : b.views.compareTo(a.views));
        break;
    }
    return estates;
  }
} 