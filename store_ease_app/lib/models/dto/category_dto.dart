import '../category.dart';

class CategoryDto {
  CategoryDto({
    this.id,
    required this.identifier,
    this.isDefault,
    required this.title,
  });

  final int? id;
  final String identifier;
  final bool? isDefault;
  final String title;

  factory CategoryDto.fromModel(Category category) {
    return CategoryDto(
      identifier: category.identifier,
      title: category.title,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "identifier": identifier,
      "title": title,
    };
  }

  factory CategoryDto.fromJson(Map<String, dynamic> map) {
    return CategoryDto(
      id: map['id'],
      identifier: map['identifier'],
      isDefault: map['isDefault'],
      title: map['title'],
    );
  }
  Category toModel() {
    return Category(
      id: id,
      identifier: identifier,
      isDefault: isDefault,
      title: title,
    );
  }
}
