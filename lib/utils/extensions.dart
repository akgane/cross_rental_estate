extension StringExtension on String{
  String capitalize(){
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }

  String removeUnderscore(){
    return replaceAll('_', ' ');
  }
}