enum UserRole { farmer, expert, admin }

class AppUser {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final bool isEmailVerified;
  final UserRole role;
  final String? village;
  final String? district;
  final String? state;
  final String preferredLanguage;
  final List<String> crops;

  const AppUser({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.isEmailVerified = false,
    this.role = UserRole.farmer,
    this.village,
    this.district,
    this.state,
    this.preferredLanguage = 'en',
    this.crops = const [],
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      role: UserRole.values.firstWhere(
        (r) => r.name == (json['role'] ?? 'farmer'),
        orElse: () => UserRole.farmer,
      ),
      village: json['village'] as String?,
      district: json['district'] as String?,
      state: json['state'] as String?,
      preferredLanguage: json['preferredLanguage'] as String? ?? 'en',
      crops: (json['crops'] as List?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'isEmailVerified': isEmailVerified,
        'role': role.name,
        'village': village,
        'district': district,
        'state': state,
        'preferredLanguage': preferredLanguage,
        'crops': crops,
      };

  AppUser copyWith({
    String? name,
    String? email,
    bool? isEmailVerified,
    String? village,
    String? district,
    String? state,
    String? preferredLanguage,
    List<String>? crops,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      phone: phone,
      email: email ?? this.email,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      role: role,
      village: village ?? this.village,
      district: district ?? this.district,
      state: state ?? this.state,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      crops: crops ?? this.crops,
    );
  }
}