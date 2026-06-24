import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/product_model.dart';

// Widget StatelessWidget Reusable untuk kartu tampilan produk
class ProductCard extends StatelessWidget {
  // Parameter data produk
  final ProductModel product;
  // Aksi ketika kartu produk ditekan
  final VoidCallback onTap;
  // Aksi opsional ketika tombol edit ditekan (jika null, tombol edit tidak tampil)
  final VoidCallback? onEdit;
  // Aksi opsional ketika tombol hapus ditekan (jika null, tombol hapus tidak tampil)
  final VoidCallback? onDelete;
  // Parameter opsional untuk nomor urut produk
  final int? number;

  // Konstruktor widget dengan parameter yang dibutuhkan
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onEdit,
    this.onDelete,
    this.number,
  });

  @override
  Widget build(BuildContext context) {
    // Widget Card sebagai kartu kontainer produk
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      // Widget ListTile untuk memformat letak elemen kartu secara terstruktur
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(15),
        // Widget Text untuk nama produk
        title: Text(
          product.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        // Widget Column untuk menyusun gambar, harga, dan deskripsi secara vertikal
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            product.image.isNotEmpty
                ? Image.memory(
                    base64Decode(product.image),
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.image, size: 120),
            const SizedBox(height: 5),
            // Widget Text untuk harga produk
            Text("Rp ${product.price}"),
            const SizedBox(height: 5),
            // Widget Text untuk deskripsi produk
            Text(product.description),
          ],
        ),
        // Menampilkan nomor urut di sisi depan jika disediakan
        leading: number != null
            ? Text(
                "$number.",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              )
            : null,
        // Menampilkan tombol Edit dan Hapus di sisi belakang
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.green,
                ),
                onPressed: () => onEdit!(),
              ),
            const SizedBox(width: 10),
            if (onDelete != null)
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () => onDelete!(),
              ),
          ],
        ),
      ),
    );
  }
}
