class Fighter{
  int id;
  String name;

  Fighter({required this.id, required this.name});

  @override
  String toString() {
    return name;
  }
}
