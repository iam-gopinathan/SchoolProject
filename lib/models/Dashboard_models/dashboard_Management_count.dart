class DashboardManagementCount {
  final int curriculamManagementCount;
  final int facilitiesManagementCount;
  final int performanceMetricsCount;
  final int parentsFeedbackCount;

  DashboardManagementCount({
    required this.curriculamManagementCount,
    required this.facilitiesManagementCount,
    required this.performanceMetricsCount,
    required this.parentsFeedbackCount,
  });

  factory DashboardManagementCount.fromJson(Map<String, dynamic> json) {
    return DashboardManagementCount(
      curriculamManagementCount: json['curriculamManagement'][0]['count'],
      facilitiesManagementCount: json['facilitiesManagement'][0]['count'],
      performanceMetricsCount: json['performanceMetrics'][0]['count'],
      parentsFeedbackCount: json['parentsFeedback'][0]['count'],
    );
  }
}
