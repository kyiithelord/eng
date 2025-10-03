import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../widgets/app_scaffold.dart';
import '../../services/purchase_service.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final _purchase = PurchaseService();
  bool _loading = true;
  String? _error;
  ProductDetailsUI? _productUI;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final product = await _purchase.loadPremiumProduct();
      if (!mounted) return;
      setState(() {
        _productUI = product == null ? null : ProductDetailsUI(title: product.title, price: product.price, product: product);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'IAP unavailable: $e';
        _loading = false;
      });
    }
  }

  Future<void> _buy() async {
    final ui = _productUI;
    if (ui == null) return;
    await _purchase.buyPremium(ui.product, (p) async {
      final status = p.status;
      if (status == PurchaseStatus.purchased || status == PurchaseStatus.restored) {
        await _purchase.completeIfPending(p);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Premium activated (demo, server verify TBD)')));
      } else if (status == PurchaseStatus.pending) {
        // no-op for now
      } else if (status == PurchaseStatus.error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Purchase error: ${p.error}')));
      } else if (status == PurchaseStatus.canceled) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Purchase canceled')));
      } else {
        // Fallback for any new/unknown statuses
      }
    });
  }

  @override
  void dispose() {
    _purchase.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Go Premium', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text('• Remove ads\n• Unlock full lessons\n• Enhanced AI feedback'),
            const SizedBox(height: 16),
            if (_loading) const CircularProgressIndicator(),
            if (!_loading && _error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            if (!_loading && _productUI != null)
              ElevatedButton(
                onPressed: _buy,
                child: Text('Upgrade – ${_productUI!.price}'),
              ),
            if (!_loading && _productUI == null && _error == null)
              const Text('Premium not available in store (check product id).'),
          ],
        ),
      ),
    );
  }
}

class ProductDetailsUI {
  final String title;
  final String price;
  final dynamic product; // ProductDetails, kept dynamic to avoid import here
  ProductDetailsUI({required this.title, required this.price, required this.product});
}
