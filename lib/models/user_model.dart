enum UserRole { farmer, expert, admin }

class AppUser {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final UserRole role;
  final String? avatarUrl;
  final String? village;
  final String? district;
  final String preferredLanguage;
  final List<String> crops;

  const AppUser({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.role = UserRole.farmer,
    this.avatarUrl,
    this.village,
    this.district,
    this.preferredLanguage = 'en',
    this.crops = const [],
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      role: UserRole.values.firstWhere(
        (r) => r.name == (json['role'] ?? 'farmer'),
        orElse: () => UserRole.farmer,
      ),
      avatarUrl: json['avatarUrl'] as String?,
      village: json['village'] as String?,
      district: json['district'] as String?,
      preferredLanguage: json['preferredLanguage'] as String? ?? 'en',
      crops: (json['crops'] as List?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'role': role.name,
        'avatarUrl': avatarUrl,
        'village': village,
        'district': district,
        'preferredLanguage': preferredLanguage,
        'crops': crops,
      };
}
