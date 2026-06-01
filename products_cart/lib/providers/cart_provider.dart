import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/cart_item.dart';


class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]) {
    _loadCart();
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('cart_data');
    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      state = decoded.map((item) => CartItem(
        quantity: item['quantity'],
        product: Product(
          id: item['id'],
          name: item['name'],
          price: item['price'],
          category: item['category'],
          image: item['image'],
        ),
      )).toList();
    }
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = state.map((item) => {
      'quantity': item.quantity,
      'id': item.product.id,
      'name': item.product.name,
      'price': item.product.price,
      'category': item.product.category,
      'image': item.product.image,
    }).toList();
    await prefs.setString('cart_data', jsonEncode(encoded));
  }

  void addProduct(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == index) state[i].copyWith(quantity: state[i].quantity + 1) else state[i]
      ];
    } else {
      state = [...state, CartItem(product: product, quantity: 1)];
    }
    _saveCart();
  }

  void decreaseQuantity(String productId) {
    final index = state.indexWhere((item) => item.product.id == productId);
    if (index == -1) return;

    if (state[index].quantity > 1) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == index) state[i].copyWith(quantity: state[i].quantity - 1) else state[i]
      ];
    } else {
      removeProduct(productId);
      return; 
    }
    _saveCart();
  }

  void removeProduct(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
    _saveCart();
  }

  void clear() {
    state = [];
    _saveCart();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) => CartNotifier());

final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
});

final cartCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (sum, item) => sum + item.quantity);
});