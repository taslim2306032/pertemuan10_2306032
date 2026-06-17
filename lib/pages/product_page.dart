import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:pertemuan10_2306032/models/product_model.dart";
import "package:pertemuan10_2306032/widgets/product_card.dart";
import "package:pertemuan10_2306032/pages/product_detail_page.dart";

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProducts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProducts();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> productList = prefs.getStringList('products') ?? [];
    setState(() {
      allProducts = productList.map((item) => ProductModel.fromJson(item)).toList();
      _filterProducts();
    });
  }

  void _onSearchChanged() {
    _filterProducts();
  }

  void _filterProducts() {
    String query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredProducts = allProducts.reversed.toList();
      } else {
        filteredProducts = allProducts.reversed
            .where((product) =>
                product.name.toLowerCase().contains(query) ||
                product.description.toLowerCase().contains(query))
            .toList();
      }
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
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Hapus Produk"),
        content: Text("Apakah Anda yakin ingin menghapus produk '${product.name}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
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

  @override
  Widget build(BuildContext context) {
    // Widget Scaffold sebagai kerangka utama halaman
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      // Widget AppBar sebagai header halaman
      appBar: AppBar(
        // Widget Text untuk judul halaman
        title: const Text(
          "Daftar Produk",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 2, 209, 50),
        // Widget IconButton untuk tombol navigasi kembali
        leading: IconButton(
          // Widget Icon untuk ikon panah kembali
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 25),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // Widget Column untuk menyejajarkan pencarian dan list produk secara vertikal
      body: Column(
        children: [
          // Widget Padding untuk memberikan margin di sekitar bilah pencarian
          Padding(
            padding: const EdgeInsets.all(15.0),
            // Widget Container untuk dekorasi latar belakang dan bayangan kolom pencarian
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  // Widget BoxShadow untuk memberikan efek bayangan lembut
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              // Widget TextField untuk input teks pencarian produk
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Cari produk...",
                  // Widget Icon sebagai ikon pencarian di sisi depan
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  // Widget IconButton untuk menghapus teks pencarian (hanya muncul saat ada teks)
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          // Widget Icon silang untuk hapus pencarian
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () => searchController.clear(),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
            ),
          ),
          
          // Widget Expanded untuk membungkus list produk agar memenuhi sisa tinggi layar
          Expanded(
            child: filteredProducts.isEmpty
                // Widget Center untuk memposisikan konten kosong di tengah layar
                ? Center(
                    // Widget Column untuk menata ikon dan teks kosong secara vertikal
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Widget Icon untuk simbol status kosong / tidak ditemukan
                        Icon(
                          searchController.text.isNotEmpty
                              ? Icons.search_off_rounded
                              : Icons.shopping_bag_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        // Widget Text untuk deskripsi status kosong
                        Text(
                          searchController.text.isNotEmpty
                              ? "Produk tidak ditemukan"
                              : "Belum ada produk",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                // Widget ListView.builder untuk merender daftar produk secara efisien
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      // Widget ProductCard yang reusable untuk menampilkan data produk dan menangani navigasi detail serta aksi edit/hapus
                      return ProductCard(
                        product: product,
                        number: index + 1,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailPage(product: product),
                          ),
                        ),
                        onEdit: () => showForm(
                          product: product,
                        ),
                        onDelete: () => deleteProduct(product),
                      );
                    },
                  ),
          ),
        ],
      ),
      // Widget FloatingActionButton untuk tombol cepat menambah produk baru
      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(),
        backgroundColor: const Color.fromARGB(255, 2, 209, 50),
        // Widget Icon tambah untuk tombol melayang
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
