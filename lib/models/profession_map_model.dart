class ProfessionMap {
  String id;
  String name;
  String type;

  ProfessionMap({required this.id, required this.name, required this.type});

  ProfessionMap.fromJson(Map<String, dynamic> json)
      : id = json['professionsmap_id'] ?? '',
        name = json['map_name'] ?? '',
        type = json['maptype_name'] ?? '';
}
