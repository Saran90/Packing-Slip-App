class ProductItem {
  int id;
  String name;
  String packing;
  double mrp;
  List<double> availableMrps;
  String barCode;

  ProductItem({
    required this.id,
    required this.name,
    required this.packing,
    required this.mrp,
    required this.barCode,
    required this.availableMrps,
  });

  @override
  String toString() {
    return name.toString();
  }

  bool hasMutipleMrps() {
    return availableMrps.length > 1;
  }
}
