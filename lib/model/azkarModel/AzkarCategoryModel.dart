import 'ItemAzkatr.dart';

class AzkarCategoryModel {
  int _id;
  String _category;
  String _audio;
  String _filename;
  List<AzkarModel> _array;

  AzkarCategoryModel({
    required int id,
    required String category,
    required String audio,
    required String filename,
    required List<AzkarModel> array,
  }) : _id = id,
       _category = category,
       _audio = audio,
       _filename = filename,
       _array = array;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  factory AzkarCategoryModel.fromJson(Map<String, dynamic> json) {
    var list = json['array'] as List;
    List<AzkarModel> azkarList =
        list.map((i) => AzkarModel.fromJson(i)).toList();

    return AzkarCategoryModel(
      id: json['id'],
      category: json['category'],
      audio: json['audio'],
      filename: json['filename'],
      array: azkarList,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'audio': audio,
      'filename': filename,
      'array': array.map((azkar) => azkar.toJson()).toList(),
    };
  }

  String get category => _category;

  set category(String value) {
    _category = value;
  }

  String get audio => _audio;

  set audio(String value) {
    _audio = value;
  }

  String get filename => _filename;

  set filename(String value) {
    _filename = value;
  }

  List<AzkarModel> get array => _array;

  set array(List<AzkarModel> value) {
    _array = value;
  }
}
