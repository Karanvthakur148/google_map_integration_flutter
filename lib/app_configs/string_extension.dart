extension CapExtension on String {
  String get inCaps =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
  String get allInCaps => toUpperCase();
  String get firstTwo =>
      isNotEmpty ? '${split(" ")[0][0]}${split(" ")[1][0]}' : '';
  String get secondTwo =>
      isNotEmpty ? split(" ")[1].substring(0, 2).toUpperCase() : '';
  String get capitalizeFirstOfEach => replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.inCaps)
      .join(" ");
}
