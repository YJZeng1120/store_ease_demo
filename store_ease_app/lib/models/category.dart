class Category {
  Category({
    this.id,
    required this.identifier,
    this.isDefault,
    required this.title,
  });
  final int? id;
  final String identifier;
  final bool? isDefault;
  final String title;

  factory Category.empty() {
    return Category(
      id: null,
      identifier: '',
      isDefault: null,
      title: '',
    );
  }

  Category copyWith({
    int? id,
    String? identifier,
    bool? isDefault,
    String? title,
  }) {
    return Category(
      id: id ?? this.id,
      identifier: identifier ?? this.identifier,
      isDefault: isDefault ?? this.isDefault,
      title: title ?? this.title,
    );
  }
}
