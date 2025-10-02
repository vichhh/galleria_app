import 'package:flutter/material.dart';
import 'package:galleria_app/services/product_api.dart';
import 'package:galleria_app/theme/app_theme.dart';
import 'product_detail_screen.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> with SingleTickerProviderStateMixin {
  late Future<List<Product>> _future;

  @override
  void initState() {
    super.initState();
    _future = ProductApi.fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppTheme.bg2,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.accentEnd),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: const Text('All Cars', style: TextStyle(color: AppTheme.textPrimary)),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: AppTheme.accentEnd,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Hypercars'),
              Tab(text: 'Sport'),
            ],
          ),
        ),
        body: FutureBuilder<List<Product>>(
          future: _future,
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }
            if (snap.hasError) {
              return Center(
                child: Text('Failed to load\n${snap.error}',
                    textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textSecondary)),
              );
            }
            final all = snap.data ?? [];
            final hyper = all.where((p) => p.category.toLowerCase() == 'hypercar').toList();
            final sport = all.where((p) => p.category.toLowerCase() == 'sport').toList();

            return TabBarView(
              children: [
                _Grid(all),
                _Grid(hyper),
                _Grid(sport),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  final List<Product> items;
  const _Grid(this.items);

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('No items', style: TextStyle(color: AppTheme.textSecondary)));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14, childAspectRatio: 0.78),
      itemBuilder: (ctx, i) {
        final p = items[i];
        return InkWell(
          onTap: () => Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, a, __) => ProductDetailScreen(productId: p.id, heroTag: 'car_${p.id}'),
              transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
              transitionDuration: const Duration(milliseconds: 220),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 22, offset: const Offset(0, 12))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.35,
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
                              begin: Alignment.bottomCenter, end: Alignment.topCenter,
                              colors: [Color(0x88000000), Colors.transparent]),
                          ),
                        ),
                        Positioned(
                          left: 10, bottom: 10,
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                  child: Text(
                    p.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w800),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
                  child: Text(p.category.toUpperCase(),
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}