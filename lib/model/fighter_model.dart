class Fighter{
  int id;
  String name;
  List<Fighter> fought = [];

  Fighter({required this.id, required this.name});

  @override
  String toString() {
    return name;
  }
}
