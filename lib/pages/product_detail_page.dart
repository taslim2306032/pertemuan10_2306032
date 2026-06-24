import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/product_model.dart';

// Widget StatelessWidget untuk menampilkan halaman detail produk
class ProductDetailPage extends StatelessWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Widget Scaffold sebagai kerangka utama halaman detail
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      // Widget AppBar sebagai header halaman detail
      appBar: AppBar(
        title: const Text(
          "Detail Produk",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 2, 209, 50),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 25),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // Widget Padding untuk memberikan jarak tepi di sekeliling informasi produk
      body: Padding(
        padding: const EdgeInsets.all(20),
        // Widget Column untuk menyejajarkan nama, harga, dan deskripsi produk secara vertikal
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            product.image.isNotEmpty
                ? Image.memory(
                    base64Decode(product.image),
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.image, size: 250),
            const SizedBox(height: 20),
            // Widget Text untuk menampilkan nama produk dengan ukuran besar dan tebal
            Text(
              product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            // Widget Text untuk menampilkan harga produk berwarna hijau
            Text(
              "Rp ${product.price}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 2, 209, 50),
              ),
            ),
            const SizedBox(height: 15),
            // Widget Text untuk menampilkan deskripsi lengkap produk
            Text(
              product.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
