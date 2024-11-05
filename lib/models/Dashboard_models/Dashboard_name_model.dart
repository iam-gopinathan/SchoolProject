// dashboard_name_model.dart

class DashboardName {
  final UserDetails userDetails;
  final Map<String, List<MenuDetail>> menusDetails;
  final Counts counts;

  DashboardName({
    required this.userDetails,
    required this.menusDetails,
    required this.counts,
  });

  factory DashboardName.fromJson(Map<String, dynamic> json) {
    return DashboardName(
      userDetails: UserDetails.fromJson(json['userDetails']),
      menusDetails: (json['menusDetails'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>)
              .map((item) => MenuDetail.fromJson(item))
              .toList(),
        ),
      ),
      counts: Counts.fromJson(json['counts']),
    );
  }
}

class UserDetails {
  final String username;
  final String usertype;
  final String filepath;

  UserDetails({
    required this.username,
    required this.usertype,
    required this.filepath,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      username: json['username'] ?? '',
      usertype: json['usertype'] ?? '',
      filepath: json['filepath'] ?? '',
    );
  }
}

class MenuDetail {
  final String parentMenus;
  final String childMenus;
  final int access;

  MenuDetail({
    required this.parentMenus,
    required this.childMenus,
    required this.access,
  });

  factory MenuDetail.fromJson(Map<String, dynamic> json) {
    return MenuDetail(
      parentMenus: json['parentMenus'] ?? '',
      childMenus: json['childMenus'] ?? '',
      access: json['access'] ?? 0,
    );
  }
}

class Counts {
  final int dashboardCount;

  Counts({required this.dashboardCount});

  factory Counts.fromJson(Map<String, dynamic> json) {
    return Counts(
      dashboardCount: json['dashboardCount'] ?? 0,
    );
  }
}
