import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

final productsProvider = Provider<List<Product>>((ref) {
  return [
    const Product(
      id: '1',
      name: 'iPhone 14',
      price: 999.99,
      category: 'Electronics',
      image: '📱',
    ),
    const Product(
      id: '2',
      name: 'MacBook Pro',
      price: 1999.99,
      category: 'Electronics',
      image: '💻',
    ),
    const Product(
      id: '3',
      name: 'Apple Watch',
      price: 399.99,
      category: 'Electronics',
      image: '⌚',
    ),
    const Product(
      id: '4',
      name: 'Hoodie Blue',
      price: 59.99,
      category: 'Clothing',
      image: '🧥',
    ),
    const Product(
      id: '5',
      name: 'Flutter for Beginners',
      price: 29.99,
      category: 'Books',
      image: '📚',
    ),
  ];
});
final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final filteredProductsProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(productsProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

  return products.where((product) {
    final matchesCategory = selectedCategory == null || product.category == selectedCategory;
    final matchesSearch = product.name.toLowerCase().contains(searchQuery);
    
    return matchesCategory && matchesSearch;
  }).toList();
});
