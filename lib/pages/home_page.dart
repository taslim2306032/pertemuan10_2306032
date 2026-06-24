import 'package:flutter/material.dart';
import 'package:pertemuan10_2306032/pages/product_page.dart';
import 'package:pertemuan10_2306032/pages/product_detail_page.dart';
import 'package:pertemuan10_2306032/widgets/product_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = '';

  // variable utama dari daftar product
  List<ProductModel> allProducts = [];
  List<ProductModel> products = [];
  int totalProduk = 0;

  @override
  void initState() {
    super.initState();
    getUser();
    loadProducts();
  }

  //load product
  Future<void> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> productList = prefs.getStringList('products') ?? [];
    setState(() {
      allProducts = productList.map((item) => ProductModel.fromJson(item)).toList();
      totalProduk = allProducts.length;
      products = allProducts
          .reversed
          .take(5)
          .toList();
    });
  }

  Future<void> saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> productList = allProducts.map((item) => item.toJson()).toList();
    await prefs.setStringList('products', productList);
  }

  Future<void> addProduct(ProductModel product) async {
    setState(() {
      allProducts.add(product);
    });
    await saveProducts();
    await loadProducts();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Produk berhasil ditambahkan")),
    );
  }

  Future<void> updateProduct(ProductModel oldProduct, ProductModel newProduct) async {
    int index = allProducts.indexOf(oldProduct);
    if (index != -1) {
      setState(() {
        allProducts[index] = newProduct;
      });
      await saveProducts();
      await loadProducts();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Produk berhasil diperbarui")),
      );
    }
  }

  Future<void> deleteProduct(ProductModel product) async {
    // Show confirmation dialog before delete
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Produk"),
        content: Text("Apakah Anda yakin ingin menghapus produk '${product.name}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ) ?? false;

    if (confirm) {
      int index = allProducts.indexOf(product);
      if (index != -1) {
        setState(() {
          allProducts.removeAt(index);
        });
        await saveProducts();
        await loadProducts();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Produk berhasil dihapus")),
        );
      }
    }
  }

  void showForm({ProductModel? product}) {
    TextEditingController nameController = TextEditingController(
      text: product?.name ?? "",
    );
    TextEditingController descriptionController = TextEditingController(
      text: product?.description ?? "",
    );
    TextEditingController priceController = TextEditingController(
      text: product?.price.toString() ?? "",
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(product == null ? "Tambah Produk" : "Edit Produk"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Nama",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: "Deskripsi",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: "Harga",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Nama produk tidak boleh kosong")),
                );
                return;
              }
              final newProduct = ProductModel(
                name: nameController.text,
                description: descriptionController.text,
                price: int.tryParse(priceController.text) ?? 0,
                image: product?.image ?? "",
              );
              if (product == null) {
                addProduct(newProduct);
              } else {
                updateProduct(product, newProduct);
              }
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }
  
  Future<void> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLogin');
    await prefs.remove('username');
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Widget Scaffold sebagai kerangka utama halaman Home
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      // Widget SafeArea untuk memastikan konten berada dalam area aman layar (bebas notch/status bar)
      body: SafeArea(
        // Widget Padding untuk memberikan margin di sekeliling konten halaman utama
        child: Padding(
          padding: const EdgeInsets.all(20),
          // Widget Column untuk menyusun header profil, info total, list produk secara vertikal
          child: Column(
            children: [
              // Widget Container sebagai kotak pembungkus profil pengguna dengan bayangan
              Container(
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    // Widget BoxShadow untuk memberikan efek bayangan pada kotak profil
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                // Widget Row untuk menyusun avatar, info nama, dan tombol logout secara horizontal
                child: Row(
                  children: [
                    // Widget CircleAvatar untuk menampilkan gambar profil lingkaran
                    const CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage("https://picsum.photos/200"),
                    ),
                    const SizedBox(width: 15),
                    // Widget Expanded agar informasi teks menggunakan ruang tersisa di tengah
                    Expanded(
                      // Widget Column untuk menyusun teks sambutan dan username secara vertikal
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Widget Text untuk salam selamat datang
                          Text(
                            "Hai, Selamat Datang!",
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 5),
                          // Widget Row untuk menyusun nama pengguna dan ikon verifikasi secara horizontal
                          Row(
                            children: [
                              // Widget Text untuk menampilkan username
                              Text(
                                username,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 6),
                              // Widget Icon sebagai lencana verifikasi akun
                              const Icon(
                                  Icons.verified,
                                  color: Colors.green,
                                  size: 20,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Widget GestureDetector untuk mendeteksi tap pada tombol logout
                    GestureDetector(
                      onTap: logout,
                      // Widget Stack untuk menumpuk elemen tombol logout jika diperlukan
                      child: Stack(
                        children: [
                          // Widget Container sebagai latar belakang tombol logout
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                // Widget BoxShadow untuk bayangan tombol logout
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            // Widget Icon keluar/logout berwarna merah
                            child: const Icon(
                              Icons.logout,
                              size: 28,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Widget Row untuk menyusun teks total produk dan tombol Lihat Selengkapnya secara horizontal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Widget Text untuk jumlah total produk terdaftar
                  Text("Total Produk : ${totalProduk.toString()}"),
                  // Widget TextButton sebagai tombol untuk navigasi ke halaman daftar produk lengkap
                  TextButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProductPage()
                        )
                      );
                      loadProducts();
                    },
                    // Widget Text sebagai label tombol
                    child: const Text("Lihat Selengkapnya"),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Menampilkan daftar 5 produk terakhir yang baru ditambahkan
              Expanded(
                child: products.isEmpty
                    ? Center(
                        child: Text(
                          "Belum ada produk yang ditambahkan",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[500],
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductCard(
                            product: product,
                            number: index + 1,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailPage(product: product),
                                ),
                              );
                              loadProducts();
                            },
                          );
                        },
                      ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
