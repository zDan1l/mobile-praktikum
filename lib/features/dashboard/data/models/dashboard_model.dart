/// Model statistik di dashboard
class DashboardStats {
  final String title;
  final String value;
  final String subtitle;
  // final double percentage;
  // final bool isIncrease;

  DashboardStats({
    required this.title,
    required this.value,
    required this.subtitle,
    // required this.percentage,
    // required this.isIncrease,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      title: json['title'] ?? '',
      value: json['value'] ?? '0',
      subtitle: json['subtitle'] ?? '',
      // percentage: (json['percentage'] ?? 0).toDouble(),
      // isIncrease: json['isIncrease'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'value': value,
      'subtitle': subtitle,
      // 'percentage': percentage,
      // 'isIncrease': isIncrease,
    };
  }
}

/// Model data dashboard
class DashboardData {
  final List<DashboardStats> stats;
  final String userName;
  final DateTime lastUpdate;

  DashboardData({
    required this.stats,
    required this.userName,
    required this.lastUpdate,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      stats:
          (json['stats'] as List?)
              ?.map((e) => DashboardStats.fromJson(e))
              .toList() ??
          [],
      userName: json['userName'] ?? 'User',
      lastUpdate: DateTime.parse(
        json['lastUpdate'] ?? DateTime.now().toString(),
      ),
    ); // DashboardData
  }

  Map<String, dynamic> toJson() {
    return {
      'stats': stats.map((e) => e.toJson()).toList(),
      'userName': userName,
      'lastUpdate': lastUpdate.toIso8601String(),
    };
  }

  // Copy with method
  DashboardData copyWith({
    List<DashboardStats>? stats,
    String? userName,
    DateTime? lastUpdate,
  }) {
    return DashboardData(
      stats: stats ?? this.stats,
      userName: userName ?? this.userName,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}
