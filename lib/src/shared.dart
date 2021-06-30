import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_shared/src/convert.dart';

class XShared {
  static List<String> _globalGroup = [];
  List<String> _group = [];
  static SharedPreferences? _prefs;
  static Set<XSharedConvert> _converts = Set();
  final String _splitter = '##xShared##';

  XShared._();

  /// Get a instance of XShared
  static Future<XShared> getInstance() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return XShared._();
  }

  /// Register a class that you can use XShared to store it.
  static void registerType<T>(
      String Function(T) encode, T Function(String) decode) {
    _converts.add(XSharedConvert<T>(encode: encode, decode: decode));
  }

  /// Get value.
  T? get<T>(String key) {
    assert(_prefs != null);
    String storeKey = '$_prefix$key';
    switch (T.toString()) {
      case 'bool':
        {
          return _prefs!.getBool(storeKey) as T?;
        }
      case 'double':
        {
          return _prefs!.getDouble(storeKey) as T;
        }
      case 'int':
        {
          return _prefs!.getInt(storeKey) as T;
        }
      case 'String':
        {
          return _prefs!.getString(storeKey) as T?;
        }
      case 'List<String>':
        {
          return _prefs!.getStringList(storeKey) as T?;
        }
      default:
        {
          T Function(String) decode =
              (_converts.firstWhere((element) => element.name == T.toString())
                      as XSharedConvert<T>)
                  .decode;
          String? value = _prefs!.getString(storeKey);
          return decode(value!);
        }
    }
  }

  /// Set value.
  Future<void> set<T>(String key, T value) async {
    assert(_prefs != null);

    String storeKey = '$_prefix$key';

    if (value is bool) {
      await _prefs!.setBool(storeKey, value);
    } else if (value is double) {
      await _prefs!.setDouble(storeKey, value);
    } else if (value is int) {
      await _prefs!.setInt(storeKey, value);
    } else if (value is String) {
      await _prefs!.setString(storeKey, value);
    } else if (value is List<String>) {
      await _prefs!.setStringList(storeKey, value);
    } else {
      String Function(T) encode =
          (_converts.firstWhere((element) => element.name == T.toString())
                  as XSharedConvert<T>)
              .encode;
      await _prefs!.setString(storeKey, encode(value));
    }
  }

  /// Remove the item stored by key.
  Future<bool> remove(String key) async {
    assert(_prefs != null);
    String storeKey = '$_prefix$key';
    return _prefs!.remove(storeKey);
  }

  /// Clear all items.
  static Future<void> clear() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    await _prefs!.clear();
  }

  /// Set a global namespace.
  static void setGlobalGroup(String group) {
    assert(group.isNotEmpty);
    _globalGroup.add(group);
  }

  /// Remove a global namespace.
  static void removeGlobalGroup(String group) {
    assert(group.isNotEmpty);
    int index = _globalGroup.lastIndexOf(group);
    if (index >= 0) {
      _globalGroup.removeRange(index, _globalGroup.length);
    }
  }

  /// Clear all global groups.
  static void clearGlobalGroup() {
    _globalGroup.clear();
  }

  /// Begin a namespace.
  void startGroup(String group) {
    assert(group.isNotEmpty);
    _group.add(group);
  }

  /// End a namespace.
  void endGroup([String? group]) {
    assert(group == null || group.isNotEmpty);
    if (group == null) {
      _group.removeLast();
    } else {
      int index = _group.lastIndexOf(group);
      if (index >= 0) {
        _group.removeRange(index, _group.length);
      }
    }
  }

  /// Clear all groups.
  void clearGroup() {
    _group.clear();
  }

  String get _prefix {
    String globalGropStr = _globalGroup.join(_splitter);
    String? groupStr = _group.join(_splitter);
    return '$globalGropStr$groupStr$_splitter';
  }
}
