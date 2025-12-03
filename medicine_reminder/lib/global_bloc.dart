import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/medicine.dart';
import 'local_notification.dart';

class GlobalBloc {
  BehaviorSubject<List<Medicine>>? _medicineList$;
  BehaviorSubject<List<Medicine>>? get medicineList$ => _medicineList$;

  GlobalBloc() {
    _medicineList$ = BehaviorSubject<List<Medicine>>.seeded([]);
    makeMedicineList();
  }

  Future removeMedicine(Medicine tobeRemoved) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    List<String> medicineJsonList = [];

    var blockList = _medicineList$!.value;
    blockList.removeWhere(
      (medicine) => medicine.medicineName == tobeRemoved.medicineName,
    );

    // Cancel all notifications for the removed medicine
    await LocalNotification.cancelMedicineNotifications(tobeRemoved);

    if (blockList.isNotEmpty) {
      for (var blockMedicine in blockList) {
        String medicineJson = jsonEncode(blockMedicine.toJson());
        medicineJsonList.add(medicineJson);
      }
    }

    sharedUser.setStringList('medicines', medicineJsonList);
    _medicineList$!.add(blockList);
  }

  Future updateMedicineList(Medicine newMedicine) async {
    var blocList = _medicineList$!.value;
    blocList.add(newMedicine);
    _medicineList$!.add(blocList);

    Map<String, dynamic> tempMap = newMedicine.toJson();
    SharedPreferences? sharedUser = await SharedPreferences.getInstance();
    String newMedicineJson = jsonEncode(tempMap);
    List<String> medicineJsonList = [];
    if (sharedUser.getStringList('medicines') == null) {
      medicineJsonList.add(newMedicineJson);
    } else {
      medicineJsonList = sharedUser.getStringList('medicines')!;
      medicineJsonList.add(newMedicineJson);
    }
    sharedUser.setStringList('medicines', medicineJsonList);
  }

  Future toggleMedicineNotifications(Medicine medicine) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    List<String> medicineJsonList = [];

    var blocList = _medicineList$!.value;
    int index = blocList.indexWhere(
      (m) => m.medicineName == medicine.medicineName,
    );

    if (index != -1) {
      // Toggle notification status
      bool newStatus = !medicine.areNotificationsEnabled;
      Medicine updatedMedicine = medicine.copyWith(
        notificationsEnabled: newStatus,
      );

      blocList[index] = updatedMedicine;
      _medicineList$!.add(blocList);

      // Update notifications
      if (newStatus) {
        // Enable notifications
        await LocalNotification.scheduleMedicineNotifications(updatedMedicine);
      } else {
        // Disable notifications
        await LocalNotification.cancelMedicineNotifications(updatedMedicine);
      }

      // Save to SharedPreferences
      for (var blockMedicine in blocList) {
        String medicineJson = jsonEncode(blockMedicine.toJson());
        medicineJsonList.add(medicineJson);
      }
      sharedUser.setStringList('medicines', medicineJsonList);
    }
  }

  Future makeMedicineList() async {
    SharedPreferences? sharedUser = await SharedPreferences.getInstance();
    List<String>? jsonList = sharedUser.getStringList('medicines');
    List<Medicine> prefList = [];

    if (jsonList == null) {
      return;
    } else {
      for (String jsonMedicine in jsonList) {
        dynamic userMap = jsonDecode(jsonMedicine);
        Medicine tempMedicine = Medicine.fromJson(userMap);
        prefList.add(tempMedicine);
      }
      //state update
      _medicineList$!.add(prefList);

      // Reschedule only enabled notifications when app restarts
      List<Medicine> enabledMedicines = prefList
          .where((m) => m.areNotificationsEnabled)
          .toList();
      await LocalNotification.rescheduleAllMedicines(enabledMedicines);
    }
  }

  void dispose() {
    _medicineList$!.close();
  }
}
