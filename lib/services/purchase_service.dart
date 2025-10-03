import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseService {
  static const String premiumProductId = 'premium_tier'; // replace with your store id

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _sub;

  Future<bool> isAvailable() async => _iap.isAvailable();

  Future<ProductDetails?> loadPremiumProduct() async {
    final available = await isAvailable();
    if (!available) return null;
    final response = await _iap.queryProductDetails({premiumProductId});
    if (response.error != null || response.productDetails.isEmpty) return null;
    return response.productDetails.first;
  }

  Future<void> buyPremium(ProductDetails product, void Function(PurchaseDetails) onUpdate) async {
    // Listen for purchase updates
    await _sub?.cancel();
    _sub = _iap.purchaseStream.listen((purchases) {
      for (final p in purchases) {
        onUpdate(p);
      }
    });

    final purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> completeIfPending(PurchaseDetails p) async {
    if (p.status == PurchaseStatus.purchased || p.status == PurchaseStatus.restored) {
      if (p.pendingCompletePurchase) {
        await _iap.completePurchase(p);
      }
    }
  }

  Future<void> dispose() async {
    await _sub?.cancel();
  }
}
