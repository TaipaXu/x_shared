class XSharedConvert<T> {
  String name;
  String Function(T) encode;
  T Function(String) decode;

  XSharedConvert({required this.encode, required this.decode})
      : name = T.toString();

  @override
  bool operator ==(covariant XSharedConvert other) {
    return name == other.name;
  }

  @override
  int get hashCode => super.hashCode;
}
