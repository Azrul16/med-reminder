import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicine_reminder/constants.dart';
import 'package:medicine_reminder/global_bloc.dart';
import 'package:medicine_reminder/models/medicine.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MedicineDetails extends StatefulWidget {
  const MedicineDetails(this.medicine, {Key? key}) : super(key: key);
  final Medicine medicine;

  @override
  State<MedicineDetails> createState() => _MedicineDetailsState();
}

class _MedicineDetailsState extends State<MedicineDetails> {
  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Medicine Details',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade200, Colors.purple.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            MainSection(medicine: widget.medicine),
            SizedBox(height: 2.h),
            Expanded(child: ExtendedSection(medicine: widget.medicine)),
            SizedBox(
              width: 100.w,
              height: 7.h,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: kSecondaryColor,
                  shape: const StadiumBorder(),
                  splashFactory: InkRipple.splashFactory,
                ),
                onPressed: () {
                  openAlertBox(context, _globalBloc);
                },
                child: Text(
                  'Delete',
                  style: TextStyle(fontSize: 16.sp, color: kScaffoldColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  // Delete medicine alert dialog
  openAlertBox(BuildContext context, GlobalBloc _globalBloc) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kScaffoldColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          contentPadding: EdgeInsets.only(top: 1.h),
          title: Text(
            'Delete This Reminder?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(fontSize: 14.sp)),
            ),
            TextButton(
              onPressed: () {
                _globalBloc.removeMedicine(widget.medicine);
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: Text(
                'OK',
                style: TextStyle(fontSize: 14.sp, color: kSecondaryColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}

// 🔹 Main Section
class MainSection extends StatelessWidget {
  const MainSection({Key? key, this.medicine}) : super(key: key);
  final Medicine? medicine;

  Widget makeIcon(double size) {
    String asset = '';
    switch (medicine!.medicineType) {
      case 'Bottle':
        asset = 'assets/icons/bottle.svg';
        break;
      case 'Pill':
        asset = 'assets/icons/pill.svg';
        break;
      case 'Syringe':
        asset = 'assets/icons/syringe.svg';
        break;
      case 'Tablet':
        asset = 'assets/icons/tablet.svg';
        break;
      default:
        asset = '';
    }

    return Hero(
      tag: '${medicine!.medicineName}${medicine!.medicineType}',
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: Colors.purple.shade100,
        child: asset.isNotEmpty
            ? SvgPicture.asset(
          asset,
          height: size * 0.6,
          colorFilter: ColorFilter.mode(kOtherColor, BlendMode.srcIn),
        )
            : Icon(Icons.error, color: kOtherColor, size: size * 0.6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        makeIcon(14.w),
        SizedBox(width: 4.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: medicine!.medicineName!,
              child: Material(
                color: Colors.transparent,
                child: MainInfoTab(
                    fieldTitle: 'Medicine Name',
                    fieldInfo: medicine!.medicineName!,
                    titleSize: 16.sp,
                    infoSize: 20.sp),
              ),
            ),
            SizedBox(height: 1.h),
            MainInfoTab(
              fieldTitle: 'Dosage',
              fieldInfo: medicine!.dosage == 0
                  ? 'Not Specified'
                  : "${medicine!.dosage} mg",
              titleSize: 16.sp,
              infoSize: 18.sp,
            ),
          ],
        ),
      ],
    );
  }
}

class MainInfoTab extends StatelessWidget {
  const MainInfoTab(
      {Key? key,
        required this.fieldTitle,
        required this.fieldInfo,
        this.titleSize = 14,
        this.infoSize = 16})
      : super(key: key);
  final String fieldTitle;
  final String fieldInfo;
  final double titleSize;
  final double infoSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldTitle,
          style: TextStyle(fontSize: titleSize, color: Colors.purple.shade700),
        ),
        SizedBox(height: 0.5.h),
        Text(
          fieldInfo,
          style: TextStyle(fontSize: infoSize, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// 🔹 Extended Section
class ExtendedSection extends StatelessWidget {
  const ExtendedSection({Key? key, this.medicine}) : super(key: key);
  final Medicine? medicine;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ExtendedInfoTab(
          fieldTitle: 'Medicine Type',
          fieldInfo: medicine!.medicineType! == 'None'
              ? 'Not Specified'
              : medicine!.medicineType!,
          titleSize: 16.sp,
          infoSize: 18.sp,
        ),
        ExtendedInfoTab(
          fieldTitle: 'Dose Interval',
          fieldInfo:
          'Every ${medicine!.interval} hours | ${medicine!.interval == 24 ? "Once a day" : "${(24 / medicine!.interval!).floor()} times a day"}',
          titleSize: 16.sp,
          infoSize: 18.sp,
        ),
        ExtendedInfoTab(
          fieldTitle: 'Start Time',
          fieldInfo:
          '${medicine!.startTime![0]}${medicine!.startTime![1]}:${medicine!.startTime![2]}${medicine!.startTime![3]}',
          titleSize: 16.sp,
          infoSize: 18.sp,
        ),
      ],
    );
  }
}

class ExtendedInfoTab extends StatelessWidget {
  const ExtendedInfoTab(
      {Key? key,
        required this.fieldTitle,
        required this.fieldInfo,
        this.titleSize = 14,
        this.infoSize = 16})
      : super(key: key);
  final String fieldTitle;
  final String fieldInfo;
  final double titleSize;
  final double infoSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldTitle,
            style: TextStyle(fontSize: titleSize, color: Colors.purple.shade800),
          ),
          SizedBox(height: 0.5.h),
          Text(
            fieldInfo,
            style: TextStyle(
                fontSize: infoSize,
                color: kSecondaryColor,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
