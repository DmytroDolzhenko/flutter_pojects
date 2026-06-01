class Product {
  final String keyName; 
  final double basePriceUSD; 
  final DateTime dateAdded;

  const Product({
    required this.keyName,
    required this.basePriceUSD,
    required this.dateAdded,
  });
}