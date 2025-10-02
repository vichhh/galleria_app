import 'package:flutter/material.dart';
import 'package:galleria_app/services/product_api.dart';
import 'package:galleria_app/theme/app_theme.dart';

class ProductDetailScreen extends StatelessWidget {
  final int productId;
  final String heroTag;
  const ProductDetailScreen({super.key, required this.productId, this.heroTag = ''});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg2,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.accentEnd),
          splashRadius: 22,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Product Detail', style: TextStyle(color: AppTheme.textPrimary)),
        centerTitle: true,
      ),
      body: FutureBuilder<Product>(
        future: ProductApi.fetchById(productId),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          if (snap.hasError || !snap.hasData) {
            return Center(
              child: Text('Failed to load (#$productId)\n${snap.error}',
                  textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textSecondary)),
            );
          }
          final p = snap.data!;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Hero(
                      tag: heroTag.isNotEmpty ? heroTag : 'car_${p.id}',
                      child: p.image.isNotEmpty
                          ? Image.network(p.image, height: 220, width: double.infinity, fit: BoxFit.cover)
                          : Container(height: 220, color: const Color(0xFF2A2D34)),
                    ),
                    const Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Color(0xAA000000), Colors.transparent]),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 14,
                      bottom: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          gradient: AppTheme.accentGradient,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [BoxShadow(color: AppTheme.accentEnd.withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 8))],
                        ),
                        child: Text('\$${p.price.toStringAsFixed(0)}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 0.6)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(p.name, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 24, fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              Text(p.detail.isNotEmpty ? p.detail : 'European hypercar. Limited production.',
                  style: const TextStyle(color: AppTheme.textSecondary, height: 1.4)),
              const SizedBox(height: 16),

              // spec list
              _SpecTile(label: 'Year', value: (p.year?.toString() ?? 'N/A')),
              _SpecTile(label: 'Body Type', value: (p.bodyType ?? 'Coupe')),
              _SpecTile(label: 'Power', value: p.power != null ? '${p.power} HP' : 'N/A'),
              _SpecTile(label: 'No. of Cylinders', value: p.cylinders?.toString() ?? 'N/A'),
              _SpecTile(label: 'Top speed', value: p.topSpeed != null ? '${p.topSpeed} km/h' : 'N/A'),
              _SpecTile(label: 'Fuel Type', value: p.fuelType ?? 'Gasoline'),
              const SizedBox(height: 18),

              // contact buttons
              Row(
                children: [
                  Expanded(
                    child: _OutlinedAction(
                      icon: Icons.chat_bubble_outline,  // <- replace from Icons.whatsapp
                      label: 'WhatsApp',
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: _OutlinedAction(icon: Icons.call, label: 'Call', onTap: () {})),
                  const SizedBox(width: 10),
                  Expanded(child: _OutlinedAction(icon: Icons.email, label: 'Email', onTap: () {})),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  onPressed: () {},
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: AppTheme.accentGradient,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: AppTheme.accentEnd.withOpacity(0.35), blurRadius: 18, offset: const Offset(0, 6))],
                    ),
                    child: const Center(
                      child: Text('ADD TO GARAGE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SpecTile extends StatelessWidget {
  final String label;
  final String value;
  const _SpecTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textSecondary)),
          const Spacer(),
          Text(value, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _OutlinedAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _OutlinedAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.textPrimary,
        side: const BorderSide(color: Colors.white24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}