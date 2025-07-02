class AzkarModel {
  int _id;
  String _text;
  int _count;
  String _audio;
  String _filename;


  AzkarModel({
    required int id,
    required String text,
    required int count,
    required String audio,
    required String filename,
  })  : _id = id,
        _text = text,
        _count = count,
        _audio = audio,
        _filename = filename;

  factory AzkarModel.fromJson(Map<String, dynamic> json) {
    return AzkarModel(
      id: json['id'],
      text: json['text'],
      count: json['count'],
      audio: json['audio'],
      filename: json['filename'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'count': count,
      'audio': audio,
      'filename': filename,
    };
  }
  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get text => _text;

  String get filename => _filename;

  set filename(String value) {
    _filename = value;
  }

  String get audio => _audio;

  set audio(String value) {
    _audio = value;
  }

  int get count => _count;

  set count(int value) {
    _count = value;
  }

  set text(String value) {
    _text = value;
  }
}

