import 'package:flutter/material.dart';
import '../../constants/assets.dart';
import '../../constants/theme.dart';
import '../../models/listing.dart';
import '../../store/listing_store.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_input.dart';
import '../../widgets/glass_scaffold.dart';
import '../../widgets/logo_mark.dart';
import 'my_listings_screen.dart';

class ListingFormScreen extends StatefulWidget {
  const ListingFormScreen({super.key, required this.store, this.listing});

  final ListingStore store;
  final Listing? listing;

  @override
  State<ListingFormScreen> createState() => _ListingFormScreenState();
}

class _ListingFormScreenState extends State<ListingFormScreen> {
  late final TextEditingController _title;
  late final TextEditingController _category;
  late final TextEditingController _price;
  late final TextEditingController _condition;
  late final TextEditingController _description;
  late final TextEditingController _storage;
  late final TextEditingController _battery;
  late final TextEditingController _connector;
  late String _asset;

  bool get isEditing => widget.listing != null;

  @override
  void initState() {
    super.initState();
    final listing = widget.listing;
    _title = TextEditingController(text: listing?.title ?? '');
    _category = TextEditingController(
      text: listing?.category ?? 'Music Players',
    );
    _price = TextEditingController(
      text: listing?.price.toStringAsFixed(2) ?? '',
    );
    _condition = TextEditingController(
      text: listing?.condition ?? 'Used - Excellent',
    );
    _description = TextEditingController(text: listing?.description ?? '');
    _storage = TextEditingController(text: listing?.storage ?? '');
    _battery = TextEditingController(text: listing?.battery ?? '');
    _connector = TextEditingController(text: listing?.connector ?? '');
    _asset = listing?.imageAsset ?? Assets.gameboy;
  }

  @override
  void dispose() {
    _title.dispose();
    _category.dispose();
    _price.dispose();
    _condition.dispose();
    _description.dispose();
    _storage.dispose();
    _battery.dispose();
    _connector.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormShell(
      title: isEditing ? 'Edit Listing' : 'Create Listing',
      action: isEditing ? 'Save Changes' : 'Publish Listing',
      onSave: _save,
      dangerAction: isEditing ? 'Delete Listing' : null,
      onDanger: isEditing
          ? () =>
                showDeleteListingDialog(
                  context,
                  widget.store,
                  widget.listing!,
                ).then((_) {
                  if (context.mounted) Navigator.pop(context);
                })
          : null,
      children: [
        GestureDetector(
          onTap: _cycleAsset,
          child: GlassCard(
            height: isEditing ? 124 : 136,
            radius: 26,
            padding: EdgeInsets.all(12),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isEditing)
                    ProductImage(asset: _asset, width: 94, height: 68)
                  else
                    Icon(
                      Icons.add_a_photo_outlined,
                      color: AppTheme.muted,
                      size: 34,
                    ),
                  SizedBox(height: 6),
                  Text(
                    isEditing ? 'Tap to change photo' : 'Add product photos',
                    style: AppTheme.body.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        GlassInput(
          controller: _title,
          hint: 'Product Title',
          icon: Icons.sell_outlined,
        ),
        SizedBox(height: 10),
        GlassInput(
          controller: _category,
          hint: 'Category',
          icon: Icons.category_outlined,
        ),
        SizedBox(height: 10),
        GlassInput(
          controller: _price,
          hint: 'Price RM',
          icon: Icons.paid_outlined,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        GlassInput(
          controller: _condition,
          hint: 'Condition',
          icon: Icons.verified_outlined,
        ),
        SizedBox(height: 10),
        GlassInput(
          controller: _description,
          hint: 'Description',
          icon: Icons.notes_rounded,
          maxLines: 3,
        ),
        SizedBox(height: 10),
        GlassInput(
          controller: _storage,
          hint: 'Storage',
          icon: Icons.sd_storage_outlined,
        ),
        SizedBox(height: 10),
        GlassInput(
          controller: _battery,
          hint: 'Battery Life',
          icon: Icons.battery_5_bar_outlined,
        ),
        SizedBox(height: 10),
        GlassInput(
          controller: _connector,
          hint: 'Connector',
          icon: Icons.cable_outlined,
        ),
      ],
    );
  }

  void _cycleAsset() {
    final assets = [
      Assets.gameboy,
      Assets.ipod,
      Assets.walkman,
      Assets.camera,
      Assets.minidisc,
      Assets.palm,
      Assets.imac,
      Assets.watch,
    ];
    final current = assets.indexOf(_asset);
    setState(() => _asset = assets[(current + 1) % assets.length]);
  }

  Future<void> _save() async {
    final parsedPrice = double.tryParse(_price.text.trim()) ?? 0;
    final title = _title.text.trim().isEmpty
        ? 'Untitled Device'
        : _title.text.trim();
    final listing = Listing(
      id:
          widget.listing?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      subtitle: widget.listing?.subtitle ?? '',
      category: _category.text.trim().isEmpty ? 'Audio' : _category.text.trim(),
      price: parsedPrice,
      condition: _condition.text.trim().isEmpty
          ? 'Used - Excellent'
          : _condition.text.trim(),
      description: _description.text.trim().isEmpty
          ? 'Collector-ready retro device.'
          : _description.text.trim(),
      storage: _storage.text.trim().isEmpty ? '40GB' : _storage.text.trim(),
      battery: _battery.text.trim().isEmpty ? '14h' : _battery.text.trim(),
      connector: _connector.text.trim().isEmpty
          ? '30-Pin'
          : _connector.text.trim(),
      imageAsset: _asset,
      status: 'Published',
      views: widget.listing?.views ?? 0,
    );
    if (isEditing) {
      await widget.store.update(listing);
    } else {
      await widget.store.add(listing);
    }
    if (mounted) Navigator.pop(context);
  }
}
