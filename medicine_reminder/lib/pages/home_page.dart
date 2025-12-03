import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicine_reminder/constants.dart';
import 'package:medicine_reminder/global_bloc.dart';
import 'package:medicine_reminder/models/medicine.dart';
import 'package:medicine_reminder/pages/auth/login_screen.dart';
import 'package:medicine_reminder/pages/bmi_calculator.dart';
import 'package:medicine_reminder/pages/medicine_details/medicine_details.dart';
import 'package:medicine_reminder/pages/medicine_list/medicine_list.dart';
import 'package:medicine_reminder/pages/new_entry/new_entry_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> scheduleNotificationInOneMinute(
  dynamic UILocalNotificationDateInterpretation,
) async {
  tz.initializeTimeZones();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  final now = DateTime.now();
  final scheduledDate = tz.TZDateTime.from(
    now.add(const Duration(minutes: 1)),
    tz.local,
  );

  const androidDetails = AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    channelDescription: 'your_channel_description',
    importance: Importance.max,
    priority: Priority.high,
  );

  const platformDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Scheduled Notification',
    'This notification was scheduled to appear 1 minute after now!',
    scheduledDate,
    platformDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.status;

  if (!status.isGranted) {
    final result = await Permission.notification.request();
    if (result.isGranted) {
      debugPrint("Notification permission granted.");
    } else if (result.isDenied) {
      debugPrint("Notification permission denied.");
    } else if (result.isPermanentlyDenied) {
      debugPrint("Notification permission permanently denied.");
      openAppSettings();
    }
  } else {
    debugPrint("Notification permission already granted.");
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text("MediBar"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade300, Colors.blue.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Column(
            children: [
              const TopContainer(),
              SizedBox(height: 2.h),
              const Flexible(child: BottomContainer()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewEntryPage()),
          );
        },
        child: const Icon(Icons.add_outlined, size: 30),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(color: kPrimaryColor),
            child: Text(
              'MedFlicks',
              style: TextStyle(color: Colors.white, fontSize: 24.sp),
            ),
          ),
          _drawerItem(Icons.home, 'MediStart', () => Navigator.pop(context)),
          _drawerItem(Icons.health_and_safety, 'BMI Calculator', () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => BMICalculatorScreen()),
            );
          }),
          _drawerItem(Icons.medication_outlined, 'Medicine List', () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => MedicineListPage()));
          }),
          _drawerItem(Icons.logout, 'Sign Out', () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          }),
        ],
      ),
    );
  }

  ListTile _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
  }
}

// 🔹 Top Container
class TopContainer extends StatelessWidget {
  const TopContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Live healthier with MedFlicks.',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          'Your health assistant awaits!',
          style: TextStyle(fontSize: 17.sp, color: Colors.white70),
        ),
        SizedBox(height: 2.h),
        StreamBuilder<List<Medicine>>(
          stream: globalBloc.medicineList$,
          builder: (context, snapshot) {
            return Text(
              !snapshot.hasData ? '0' : snapshot.data!.length.toString(),
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          },
        ),
      ],
    );

    // 🔹 Bottom Container
  }
}

class BottomContainer extends StatelessWidget {
  const BottomContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);

    return StreamBuilder<List<Medicine>>(
      stream: globalBloc.medicineList$,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No Medicine Added',
              style: TextStyle(fontSize: 14.sp, color: Colors.white70),
            ),
          );
        } else {
          return GridView.builder(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return MedicineCard(medicine: snapshot.data![index]);
            },
          );
        }
      },
    );
  }
}

// 🔹 Medicine Card
class MedicineCard extends StatelessWidget {
  const MedicineCard({Key? key, required this.medicine}) : super(key: key);
  final Medicine medicine;

  Hero makeIcon(double size) {
    String? assetPath;
    switch (medicine.medicineType) {
      case 'Bottle':
        assetPath = 'assets/icons/bottle.svg';
        break;
      case 'Pill':
        assetPath = 'assets/icons/pill.svg';
        break;
      case 'Syringe':
        assetPath = 'assets/icons/syringe.svg';
        break;
      case 'Tablet':
        assetPath = 'assets/icons/tablet.svg';
        break;
    }

    if (assetPath != null) {
      return Hero(
        tag: '${medicine.medicineName}${medicine.medicineType}',
        child: SvgPicture.asset(
          assetPath,
          colorFilter: ColorFilter.mode(kOtherColor, BlendMode.srcIn),
          height: size,
        ),
      );
    }

    return Hero(
      tag: '${medicine.medicineName}${medicine.medicineType}',
      child: Icon(Icons.error, color: kOtherColor, size: size),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder<void>(
            pageBuilder: (context, animation, secondaryAnimation) {
              return FadeTransition(
                opacity: animation,
                child: MedicineDetails(medicine),
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(2.w),
        margin: EdgeInsets.all(1.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3.h),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 4.h), // Space for notification button
                makeIcon(7.h),
                const Spacer(),
                Hero(
                  tag: medicine.medicineName!,
                  child: Text(
                    medicine.medicineName!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  "Every ${medicine.interval} hour(s)",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10.sp, color: Colors.grey[700]),
                ),
              ],
            ),
            // Notification toggle button at the top right
            Positioned(
              top: 0,
              right: 0,
              child: StreamBuilder<List<Medicine>>(
                stream: globalBloc.medicineList$,
                builder: (context, snapshot) {
                  bool isEnabled = medicine.areNotificationsEnabled;
                  if (snapshot.hasData) {
                    final updatedMedicine = snapshot.data!.firstWhere(
                      (m) => m.medicineName == medicine.medicineName,
                      orElse: () => medicine,
                    );
                    isEnabled = updatedMedicine.areNotificationsEnabled;
                  }

                  return GestureDetector(
                    onTap: () {
                      globalBloc.toggleMedicineNotifications(medicine);
                    },
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2.h),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 3,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                      child: Icon(
                        isEnabled
                            ? Icons.notifications_active
                            : Icons.notifications_off,
                        color: isEnabled ? kOtherColor : Colors.grey,
                        size: 18.sp,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
