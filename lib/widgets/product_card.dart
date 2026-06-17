import 'package:flutter/material.dart';
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
        // Widget Column untuk menyusun harga dan deskripsi secara vertikal
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            // Widget Text untuk harga produk
            Text("Rp ${product.price}"),
            const SizedBox(height: 5),
            // Widget Text untuk deskripsi produk
            Text(product.description),
          ],
        ),
        // Menampilkan nomor urut dan tombol Edit di sisi depan jika parameter onEdit disediakan
        leading: onEdit != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (number != null)
                    // Widget Text untuk menampilkan nomor urut produk
                    Text(
                      "$number.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  if (number != null) const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.orange,
                    ),
                    onPressed: onEdit,
                  ),
                ],
              )
            : null,
        // Menampilkan tombol Hapus di sisi belakang jika parameter onDelete disediakan
        trailing: onDelete != null
            ? IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: onDelete,
              )
            : null,
      ),
    );
  }
}
