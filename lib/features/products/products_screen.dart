import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/utils/currency_utils.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/repository_providers.dart';

/// Lista todos os produtos cadastrados com seus códigos/PLU
/// (ver escopo, item 3).
///
/// Quando [selectable] é `true` (aberta a partir da tela de pesagem),
/// tocar em um produto o devolve via `Navigator.pop` para seleção
/// rápida. Quando `false` (aberta a partir da Home), é apenas consulta.
class ProductsScreen extends ConsumerStatefulWidget {
  final bool selectable;

  const ProductsScreen({super.key, this.selectable = false});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(_allActiveProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spaceMd),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value.trim().toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Pesquisar por código ou nome...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      ),
              ),
            ),
          ),
          Expanded(
            child: productsAsync.when(
              data: (products) {
                final filtered = _query.isEmpty
                    ? products
                    : products
                        .where((p) =>
                            p.codigo.toLowerCase().contains(_query) ||
                            p.descricao.toLowerCase().contains(_query))
                        .toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('Nenhum produto encontrado.'));
                }

                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) => _ProductRow(
                    product: filtered[index],
                    onTap: widget.selectable
                        ? () => Navigator.of(context).pop(filtered[index])
                        : null,
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Erro ao carregar produtos: $error')),
            ),
          ),
        ],
      ),
    );
  }
}

final _allActiveProductsProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(productRepositoryProvider).watchAll();
});

class _ProductRow extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const _ProductRow({required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: AppColors.surfaceAlt,
        foregroundColor: AppColors.primary,
        child: Text(
          product.codigo.length > 3 ? product.codigo.substring(0, 3) : product.codigo,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(product.descricao),
      subtitle: Text('PLU/Código: ${product.codigo}'),
      trailing: Text(
        '${CurrencyUtils.format(product.preco)}/${product.unidade}',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
