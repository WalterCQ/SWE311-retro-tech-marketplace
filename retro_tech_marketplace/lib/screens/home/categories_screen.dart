import 'package:flutter/material.dart';
import '../../constants/assets.dart';
import '../../constants/theme.dart';
import '../../models/listing.dart';
import '../../store/listing_store.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/liquid_button.dart';
import '../../widgets/logo_mark.dart';
import '../../widgets/navigation.dart';
import '../product/category_detail_screen.dart';
import 'home_screen.dart';

class CategoriesSearchController extends ChangeNotifier {
  void openSearch() => notifyListeners();
}

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.store, this.searchTrigger});

  final ListingStore store;
  final CategoriesSearchController? searchTrigger;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  String _query = '';
  bool _searchVisible = false;

  @override
  void initState() {
    super.initState();
    widget.store.addListener(_refreshCounts);
    widget.searchTrigger?.addListener(_openSearch);
  }

  @override
  void didUpdateWidget(covariant CategoriesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.store != widget.store) {
      oldWidget.store.removeListener(_refreshCounts);
      widget.store.addListener(_refreshCounts);
    }
    if (oldWidget.searchTrigger != widget.searchTrigger) {
      oldWidget.searchTrigger?.removeListener(_openSearch);
      widget.searchTrigger?.addListener(_openSearch);
    }
  }

  @override
  void dispose() {
    widget.store.removeListener(_refreshCounts);
    widget.searchTrigger?.removeListener(_openSearch);
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _refreshCounts() {
    if (!mounted) return;
    setState(() {});
  }

  void _setQuery(String value) {
    _searchController.text = value;
    _searchController.selection = TextSelection.collapsed(
      offset: _searchController.text.length,
    );
    setState(() {
      _query = value;
      _searchVisible = value.trim().isNotEmpty;
    });
    if (_searchVisible) {
      _focusSearchAfterLayout();
    } else {
      _searchFocus.unfocus();
    }
  }

  void _openSearch() {
    if (!mounted) return;
    if (!_searchVisible) {
      setState(() => _searchVisible = true);
    }
    _focusSearchAfterLayout();
  }

  void _focusSearchAfterLayout() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _searchFocus.requestFocus();
    });
  }

  void _closeSearch() {
    _searchController.clear();
    _searchFocus.unfocus();
    setState(() {
      _query = '';
      _searchVisible = false;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _query = '');
    _focusSearchAfterLayout();
  }

  @override
  Widget build(BuildContext context) {
    final metrics = ResponsiveMetrics.of(context);
    final categoryColumns = metrics.categoryColumns;
    _CategoryData category(String name, IconData icon, String asset) {
      final count = widget.store.byCategory(name).length;
      return _CategoryData(
        name,
        '$count ${count == 1 ? 'item' : 'items'}',
        icon,
        asset,
      );
    }

    final categories = [
      category('Phones', Icons.phone_iphone_rounded, Assets.v60),
      category('Audio', Icons.headphones_rounded, Assets.discmanHome),
      category('Gaming', Icons.videogame_asset_rounded, Assets.gameboy),
      category('Cameras', Icons.camera_alt_rounded, Assets.camera),
      category('Computing', Icons.desktop_mac_rounded, Assets.imac),
      category('Wearables', Icons.watch_rounded, Assets.watch),
    ];
    final query = _query.trim();
    final searching = query.isNotEmpty;
    final searchResults = searching
        ? widget.store.listings
              .where((listing) => _matchesListing(listing, query))
              .toList(growable: false)
        : const <Listing>[];
    return ListView(
      padding: metrics.pageInsetsWithNav,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final buttonSize = metrics.compact ? 42.0 : 46.0;
            final searchWidth = constraints.maxWidth - buttonSize - 12;
            return Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                  width: _searchVisible ? searchWidth : buttonSize,
                  height: buttonSize,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: _searchVisible
                        ? GlassCard(
                            key: const ValueKey('category-search-expanded'),
                            radius: buttonSize / 2,
                            padding: const EdgeInsets.only(left: 14, right: 6),
                            child: TextField(
                              key: const ValueKey('category-search-field'),
                              controller: _searchController,
                              focusNode: _searchFocus,
                              onChanged: (value) =>
                                  setState(() => _query = value),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppTheme.ink,
                              ),
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.search_rounded,
                                  color: AppTheme.muted,
                                  size: 18,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    query.isEmpty
                                        ? Icons.close_rounded
                                        : Icons.clear_rounded,
                                    color: AppTheme.muted,
                                    size: 18,
                                  ),
                                  onPressed: query.isEmpty
                                      ? _closeSearch
                                      : _clearSearch,
                                ),
                                hintText: 'Search retro devices',
                                hintStyle: AppTheme.body,
                                border: InputBorder.none,
                              ),
                            ),
                          )
                        : CircleGlassButton(
                            key: const ValueKey('category-search-button'),
                            icon: Icons.search_rounded,
                            size: buttonSize,
                            onTap: _openSearch,
                          ),
                  ),
                ),
                if (!_searchVisible)
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('Categories', style: AppTheme.h2),
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 12),
                CircleGlassButton(
                  icon: Icons.tune_rounded,
                  size: buttonSize,
                  onTap: () => _showCategoryFilter(context, categories),
                ),
              ],
            );
          },
        ),
        SizedBox(height: 22),
        if (searching) ...[
          if (searchResults.isEmpty)
            GlassCard(
              child: Text('No retro devices found.', style: AppTheme.body),
            )
          else
            ...searchResults.map(
              (listing) => ListingCard(
                listing: listing,
                openStore: widget.store,
                onTap: () => Navigator.pushNamed(
                  context,
                  '/product',
                  arguments: listing,
                ),
              ),
            ),
        ] else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: categoryColumns,
              childAspectRatio: metrics.categoryCardAspectRatio,
              crossAxisSpacing: metrics.gutter,
              mainAxisSpacing: metrics.gutter,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];
              return OpenMotionContainer(
                radius: metrics.cardRadius,
                routeSettings: RouteSettings(
                  name: '/category',
                  arguments: category.name,
                ),
                openPage: CategoryDetailScreen(
                  store: widget.store,
                  category: category.name,
                ),
                closedBuilder: (openContainer) => LiquidPressable(
                  onTap: openContainer,
                  borderRadius: BorderRadius.circular(metrics.cardRadius),
                  glowColor: AppTheme.blue,
                  child: GlassCard(
                    key: ValueKey('category-card-${category.name}'),
                    padding: EdgeInsets.all(metrics.compact ? 8 : 10),
                    radius: metrics.cardRadius,
                    opacity: 0.24,
                    blur: 38,
                    borderOpacity: 0.88,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: ProductImage(
                                    asset: category.asset,
                                    width: 152,
                                    height: 122,
                                    heroTag: categoryHeroTag(category.name),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: metrics.compact ? 4 : 6),
                            Text(
                              category.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTheme.label.copyWith(
                                color: AppTheme.red,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              category.count,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTheme.body.copyWith(fontSize: 11),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  bool _matchesListing(Listing listing, String rawQuery) {
    final query = _normalizeSearchText(rawQuery);
    if (query.isEmpty) return true;
    final primaryFields = [
      listing.title,
      listing.subtitle,
      listing.category,
      listing.seller,
    ];
    final secondaryFields = [
      listing.description,
      listing.condition,
      listing.status,
      listing.priceLabel,
    ];
    final primaryMatch = primaryFields.any((field) {
      final value = _normalizeSearchText(field);
      return value.contains(query) || _matchesFuzzyWords(field, query);
    });
    if (primaryMatch || query.length < 3) return primaryMatch;
    return secondaryFields.any((field) {
      final value = _normalizeSearchText(field);
      return value.contains(query) || _matchesFuzzyWords(field, query);
    });
  }

  String _normalizeSearchText(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '');
  }

  bool _matchesFuzzyWords(String field, String query) {
    final words = _searchWords(field);
    final initials = words.map((word) => word[0]).join();
    return initials.contains(query) ||
        words.any((word) => _isSubsequence(query, word));
  }

  List<String> _searchWords(String value) {
    final spaced = value.replaceAllMapped(
      RegExp(r'([a-z0-9])([A-Z])'),
      (match) => '${match.group(1)} ${match.group(2)}',
    );
    return spaced
        .toLowerCase()
        .split(RegExp(r'[^a-z0-9]+'))
        .where((word) => word.isNotEmpty)
        .toList(growable: false);
  }

  bool _isSubsequence(String query, String value) {
    if (query.isEmpty) return true;
    var queryIndex = 0;
    for (var index = 0; index < value.length; index += 1) {
      if (value[index] != query[queryIndex]) continue;
      queryIndex += 1;
      if (queryIndex == query.length) return true;
    }
    return false;
  }

  Future<void> _showCategoryFilter(
    BuildContext context,
    List<_CategoryData> categories,
  ) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.white.withValues(alpha: 0.38),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            child: GlassCard(
              radius: 28,
              opacity: 0.84,
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter Categories',
                    style: AppTheme.h2.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 14),
                  _CategoryFilterRow(
                    icon: Icons.apps_rounded,
                    label: 'All categories',
                    active: _query.trim().isEmpty,
                    onTap: () => Navigator.pop(sheetContext, ''),
                  ),
                  for (final category in categories)
                    _CategoryFilterRow(
                      icon: category.icon,
                      label: category.name,
                      active: _query.trim() == category.name,
                      onTap: () => Navigator.pop(sheetContext, category.name),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
    if (selected == null || !mounted) return;
    _setQuery(selected);
  }
}

class _CategoryFilterRow extends StatelessWidget {
  const _CategoryFilterRow({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LiquidPressable(
      onTap: onTap,
      active: active,
      borderRadius: BorderRadius.circular(18),
      glowColor: AppTheme.blue,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: active ? AppTheme.blue : AppTheme.muted),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTheme.label.copyWith(
                  color: active ? AppTheme.blue : AppTheme.ink,
                ),
              ),
            ),
            if (active)
              const Icon(Icons.check_rounded, color: AppTheme.blue, size: 20),
          ],
        ),
      ),
    );
  }
}

class _CategoryData {
  const _CategoryData(this.name, this.count, this.icon, this.asset);

  final String name;
  final String count;
  final IconData icon;
  final String asset;
}
