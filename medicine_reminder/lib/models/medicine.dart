class Medicine {
  final List<dynamic>? notificationIDs;
  final String? medicineName;
  final int? dosage;
  final String? medicineType;
  final int? interval;
  final String? startTime;
  final bool? notificationsEnabled;

  Medicine({
    this.notificationIDs,
    this.medicineName,
    this.dosage,
    this.medicineType,
    this.startTime,
    this.interval,
    this.notificationsEnabled,
  });

  String get getName => medicineName!;
  int get getDosage => dosage!;
  String get getType => medicineType!;
  int get getInterval => interval!;
  String get getStartTime => startTime!;
  List<dynamic> get getIDs => notificationIDs!;
  bool get areNotificationsEnabled => notificationsEnabled ?? true;

  Map<String, dynamic> toJson() {
    return {
      'ids': notificationIDs,
      'name': medicineName,
      'dosage': dosage,
      'type': medicineType,
      'interval': interval,
      'start': startTime,
      'notificationsEnabled': notificationsEnabled ?? true,
    };
  }

  factory Medicine.fromJson(Map<String, dynamic> parsedJson) {
    return Medicine(
      notificationIDs: parsedJson['ids'],
      medicineName: parsedJson['name'],
      dosage: parsedJson['dosage'],
      medicineType: parsedJson['type'],
      interval: parsedJson['interval'],
      startTime: parsedJson['start'],
      notificationsEnabled: parsedJson['notificationsEnabled'] ?? true,
    );
  }

  // Create a copy with updated notification status
  Medicine copyWith({bool? notificationsEnabled}) {
    return Medicine(
      notificationIDs: notificationIDs,
      medicineName: medicineName,
      dosage: dosage,
      medicineType: medicineType,
      interval: interval,
      startTime: startTime,
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled ?? true,
    );
  }
}
