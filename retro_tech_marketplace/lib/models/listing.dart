import '../constants/assets.dart';

class Listing {
  const Listing({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.price,
    required this.condition,
    required this.description,
    required this.storage,
    required this.battery,
    required this.connector,
    required this.imageAsset,
    required this.status,
    required this.views,
    this.seller = 'RetroTech Collector',
    this.rating = 4.9,
    this.reviews = 128,
  });

  final String id;
  final String title;
  final String subtitle;
  final String category;
  final double price;
  final String condition;
  final String description;
  final String storage;
  final String battery;
  final String connector;
  final String imageAsset;
  final String status;
  final int views;
  final String seller;
  final double rating;
  final int reviews;

  String get priceLabel => 'RM ${price.toStringAsFixed(2)}';
  String get shortTitle => subtitle.isEmpty ? title : '$title\n$subtitle';
  List<String> get detailImageAssets {
    switch (imageAsset) {
      case Assets.v60:
        return const [Assets.v60, Assets.v60GallerySide, Assets.v60GalleryBack];
      case Assets.ipodFront:
        return const [
          Assets.ipodFront,
          Assets.ipodGallerySide,
          Assets.ipodGalleryBack,
        ];
      case Assets.discmanHome:
        return const [
          Assets.discmanHome,
          Assets.discmanGallerySide,
          Assets.discmanGalleryBack,
        ];
      case Assets.walkman:
        return const [
          Assets.walkman,
          Assets.walkmanGallerySide,
          Assets.walkmanGalleryBack,
        ];
      case Assets.minidisc:
        return const [
          Assets.minidisc,
          Assets.minidiscGallerySide,
          Assets.minidiscGalleryBack,
        ];
      case Assets.gameboy:
        return const [
          Assets.gameboy,
          Assets.gameboyGallerySide,
          Assets.gameboyGalleryBack,
        ];
      case Assets.camera:
        return const [
          Assets.camera,
          Assets.cameraGallerySide,
          Assets.cameraGalleryBack,
        ];
      case Assets.imac:
        return const [
          Assets.imac,
          Assets.imacGallerySide,
          Assets.imacGalleryBack,
        ];
      case Assets.palm:
        return const [
          Assets.palm,
          Assets.palmGallerySide,
          Assets.palmGalleryBack,
        ];
      case Assets.watch:
        return const [
          Assets.watch,
          Assets.watchGallerySide,
          Assets.watchGalleryBack,
        ];
    }
    return [imageAsset];
  }

  Listing copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? category,
    double? price,
    String? condition,
    String? description,
    String? storage,
    String? battery,
    String? connector,
    String? imageAsset,
    String? status,
    int? views,
    String? seller,
    double? rating,
    int? reviews,
  }) {
    return Listing(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      category: category ?? this.category,
      price: price ?? this.price,
      condition: condition ?? this.condition,
      description: description ?? this.description,
      storage: storage ?? this.storage,
      battery: battery ?? this.battery,
      connector: connector ?? this.connector,
      imageAsset: imageAsset ?? this.imageAsset,
      status: status ?? this.status,
      views: views ?? this.views,
      seller: seller ?? this.seller,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
    );
  }

  Map<String, Object?> toMap({int? sortOrder}) {
    final map = <String, Object?>{
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'category': category,
      'price': price,
      'condition': condition,
      'description': description,
      'storage': storage,
      'battery': battery,
      'connector': connector,
      'imageAsset': imageAsset,
      'status': status,
      'views': views,
      'seller': seller,
      'rating': rating,
      'reviews': reviews,
    };
    if (sortOrder != null) {
      map['sortOrder'] = sortOrder;
    }
    return map;
  }

  factory Listing.fromMap(Map<String, Object?> map) {
    return Listing(
      id: map['id'] as String,
      title: map['title'] as String,
      subtitle: map['subtitle'] as String? ?? '',
      category: map['category'] as String? ?? 'Audio',
      price: (map['price'] as num).toDouble(),
      condition: map['condition'] as String? ?? 'Used - Excellent',
      description: map['description'] as String? ?? '',
      storage: map['storage'] as String? ?? '40GB',
      battery: map['battery'] as String? ?? '14h',
      connector: map['connector'] as String? ?? '30-Pin',
      imageAsset: map['imageAsset'] as String? ?? Assets.ipod,
      status: map['status'] as String? ?? 'Published',
      views: map['views'] as int? ?? 0,
      seller: map['seller'] as String? ?? 'RetroTech Collector',
      rating: (map['rating'] as num?)?.toDouble() ?? 4.9,
      reviews: map['reviews'] as int? ?? 128,
    );
  }
}
