class ThemeModel {

  final int themeId;

  ThemeModel({required this.themeId});

  Map<String, dynamic> toMap() {
    return {
      'themeId': themeId,
    };
  }

  factory ThemeModel.fromMap(Map<String, dynamic> map) {
    return ThemeModel(
      themeId: map['themeId'], 
    );
  }
}
