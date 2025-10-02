import 'package:flutter/material.dart';
import 'package:galleria_app/services/product_api.dart';
import 'package:galleria_app/theme/app_theme.dart';
import 'product_detail_screen.dart';
import 'all_products_screen.dart'; // <-- add

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late Future<List<Product>> _future;

  @override
  void initState() {
    super.initState();
    _future = ProductApi.fetchAll();
  }

  Future<void> _reload() async => setState(() => _future = ProductApi.fetchAll());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 16,
        title: const Text(
          'Marketplace • Hypercars',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.search, color: AppTheme.textSecondary),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.showroomGradient),
        child: RefreshIndicator(
          color: AppTheme.accentEnd,
          onRefresh: _reload,
          child: FutureBuilder<List<Product>>(
            future: _future,
            builder: (ctx, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              }
              if (snap.hasError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Failed to load products', style: TextStyle(color: AppTheme.textPrimary)),
                      const SizedBox(height: 8),
                      Text('${snap.error}', textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textSecondary)),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _reload,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentEnd,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              final items = snap.data ?? [];
              final hypercars = items.where((p) => p.category.toLowerCase() == 'hypercar').take(4).toList();
              final sports = items.where((p) => p.category.toLowerCase() == 'sport').take(4).toList();

              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 22),
                children: [
                  _HeaderBanner(
                    total: items.length,
                    onBrowseAll: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AllProductsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _SectionHeader(title: 'Hypercars', count: hypercars.length),
                  const SizedBox(height: 10),
                  _HorizontalList(items: hypercars),
                  const SizedBox(height: 18),
                  _SectionHeader(title: 'Sport Cars', count: sports.length),
                  const SizedBox(height: 10),
                  _HorizontalList(items: sports),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HeaderBanner extends StatelessWidget {
  final int total;
  final VoidCallback onBrowseAll; // <-- add
  const _HeaderBanner({required this.total, required this.onBrowseAll});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1C22), Color(0xFF101217)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 22, offset: const Offset(0, 12)),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            right: -30,
            top: -20,
            child: Icon(Icons.sports_motorsports, size: 160, color: Colors.white12),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Marketplace to buy and sell cars',
                    style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text('$total cars listed', style: const TextStyle(color: AppTheme.textSecondary)),
                const Spacer(),
                Material( // <-- make it tappable with ripple
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onBrowseAll,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: AppTheme.accentGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: AppTheme.accentEnd.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 6)),
                        ],
                      ),
                      child: const Text('Browse all',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  const _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ShaderMask(
          shaderCallback: (r) => AppTheme.accentGradient.createShader(r),
          child: const Icon(Icons.directions_car_filled, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
        const Spacer(),
        Text('$count', style: const TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _HorizontalList extends StatelessWidget {
  final List<Product> items;
  const _HorizontalList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox(height: 160, child: Center(child: Text('No items', style: TextStyle(color: AppTheme.textSecondary))));
    }
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (ctx, i) => _CarCard(product: items[i]),
      ),
    );
  }
}

class _CarCard extends StatelessWidget {
  final Product product;
  const _CarCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final p = product;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_, a, __) => ProductDetailScreen(productId: p.id, heroTag: 'car_${p.id}'),
            transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
            transitionDuration: const Duration(milliseconds: 280),
          ),
        );
      },
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 22, offset: const Offset(0, 12))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image
            SizedBox(
              height: 130,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'car_${p.id}',
                      child: p.image.isNotEmpty
                          ? Image.network(p.image, fit: BoxFit.cover)
                          : Container(color: const Color(0xFF2A2D34)),
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Color(0x88000000), Colors.transparent],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      bottom: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: AppTheme.accentGradient,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: AppTheme.accentEnd.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 6))],
                        ),
                        child: Text('\$${p.price.toStringAsFixed(0)}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // title + tags
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      p.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF23252B),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Text(
                      p.category.toUpperCase(),
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Row(
                children: const [
                  Icon(Icons.place, color: Colors.white24, size: 16),
                  SizedBox(width: 6),
                  Text('Europe', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}