import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:medallyproapp/screens/add_prescription.dart';
import 'package:medallyproapp/screens/mydrawer_screen.dart';
import 'package:medallyproapp/screens/scredule_screen.dart';
import 'package:medallyproapp/widgets/glowingfloatingbutton.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/mycolors.dart';
import '../model/medicine_model_class.dart';
import '../notifications/notification_service.dart';
import 'package:timezone/timezone.dart' as tz;

class PrescriptionListScreen extends StatefulWidget {
  const PrescriptionListScreen({super.key});

  @override
  State<PrescriptionListScreen> createState() => _PrescriptionListScreenState();
}

class _PrescriptionListScreenState extends State<PrescriptionListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  User? user = FirebaseAuth.instance.currentUser;
  String? name;
  String? relation;

  NotificationServices notificationServices = NotificationServices();

  String cleanTimeString(String time) {
    // Remove leading and trailing whitespaces
    String trimmedTime = time.trim();

    // Remove any non-breaking spaces
    trimmedTime = trimmedTime.replaceAll('\u00A0', ' ');

    return trimmedTime;
  }

  // void followMe(List<String> timeList) {
  //   print("FollowMe Running");
  //   print("FollowMe $timeList");
  //
  //   List<tz.TZDateTime?> formattedNotificationTimes = timeList.map((time) {
  //     DateTime now = DateTime.now();
  //     String timeString = time.trim(); // Remove leading and trailing whitespaces
  //     DateTime parsedTime;
  //
  //     try {
  //       parsedTime = DateFormat('h:mm a').parse(timeString);
  //     } catch (e) {
  //       print("Error parsing time: $e");
  //       return null; // Skip this entry if there's an error
  //     }
  //
  //     // Set the correct am/pm based on the current time
  //     int hour = parsedTime.hour;
  //     if (now.hour > 12) {
  //       hour += 12;
  //     }
  //
  //     // Create a TZDateTime for the parsed time
  //     tz.TZDateTime scheduledTime = tz.TZDateTime(
  //       tz.local,
  //       now.year,
  //       now.month,
  //       now.day,
  //       hour,
  //       parsedTime.minute,
  //     );
  //
  //     // If the scheduled date is in the past, add a day to it
  //     if (scheduledTime.isBefore(now)) {
  //       scheduledTime = scheduledTime.add(const Duration(days: 1));
  //     }
  //
  //     return scheduledTime;
  //   }).where((time) => time != null).toList(); // Remove null entries
  //   print("Formatted Times: $formattedNotificationTimes");
  //
  //   notificationServices.scheduleNotification(
  //     formattedNotificationTimes.cast<DateTime>(), // Cast to List<DateTime>
  //     'Your Title',
  //     'Your Body',
  //   );
  // }

  void followMe(List<String> timeList) {
    print("FollowMe Running");
    print("FollowMe $timeList");

    List<tz.TZDateTime?> formattedNotificationTimes = timeList
        .map((time) {
          DateTime now = tz.TZDateTime.now(tz.local);
          String timeString = time.trim();

          try {
            DateTime parsedTime = DateFormat('h:mm a').parse(timeString);
            tz.TZDateTime scheduledTime = tz.TZDateTime(
              tz.local,
              now.year,
              now.month,
              now.day,
              parsedTime.hour,
              parsedTime.minute,
            );

            // Do not add a day if the scheduled time is before the current time
            if (scheduledTime.isBefore(now)) {
              // Remove this line to prevent adding a day
              // scheduledTime = scheduledTime.add(const Duration(days: 1));
            }

            return scheduledTime;
          } catch (e) {
            print("Error parsing time: $e");
            return null;
          }
        })
        .where((time) => time != null)
        .toList();
    print("Formatted Times: $formattedNotificationTimes");

    notificationServices.scheduleNotification(
      formattedNotificationTimes,
      'Your Title',
      'Your Body',
    );
  }

  void scheduleTime(BuildContext context) {
    final String time = DateTime.now()
        .add(Duration(seconds: (int.tryParse(dlay.text) ?? 0)))
        .toString();
    print(time);
    notificationServices.newcheduleNotification(
      tz.TZDateTime.parse(tz.local, time),
      'New Notification',
      'This is a notification for $time',
    );
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Notification for $time'),
      duration: const Duration(seconds: 10),
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.initializeNotifications();
    Future.delayed(const Duration(seconds: 4), () {
      // followMe();
    });
  }
  TextEditingController dlay = TextEditingController(text: '10');
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: primaryColor,
        key: _scaffoldKey,
        drawer: const MyDrawerScreen(),
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 10.0,
          backgroundColor: primaryColor,
        ),
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Container(
            height: height,
            width: width,
            margin: const EdgeInsets.only(top: 10.0),
            decoration: const BoxDecoration(
              color: textColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const Gap(30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        icon: const Icon(
                          Icons.sort,
                          color: textBlackColor,
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "Modallypro",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'GT Walsheim Trial',
                              color: primaryColor,
                              letterSpacing: 0.3),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          print('Im here o');
                          List<TimeOfDay> notificationTimes = [
                            const TimeOfDay(hour: 6, minute: 16),
                            const TimeOfDay(hour: 6, minute: 17),
                            const TimeOfDay(hour: 6, minute: 18),
                          ];

                          List<DateTime> formattedNotificationTimes =
                              notificationTimes.map((time) {
                            DateTime now = DateTime.now();
                            // Set the correct am/pm based on the current time
                            int hour = time.hour;
                            if (now.hour > 12) {
                              hour += 12;
                            }
                            return tz.TZDateTime(
                              tz.local,
                              now.year,
                              now.month,
                              now.day,
                              hour,
                              time.minute,
                            );
                          }).toList();

                          // notificationServices.scheduleNotification(
                          //   formattedNotificationTimes,
                          //   'Your Title',
                          //   'Your Body',
                          // );
                        },
                        icon: const Icon(
                          Icons.notifications_none_sharp,
                          color: textBlackColor,
                        ),
                      ),
                    ],
                  ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.of(context).push(MaterialPageRoute(
                  //         builder: (context) => const ScheduleScreenText(),
                  //       ));
                  //     },
                  //     child: const Text('move to schedule page')),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: TextField(
                      controller: dlay,
                      decoration: const InputDecoration(hintText: 'Delay'),
                    ),
                  ),

                

                  ElevatedButton(
                      onPressed: () async {
                        scheduleTime(context);
                        //                 const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
                        // 'your channel id', 'your channel name',
                        // channelDescription: 'your channel description',
                        // importance: Importance.max,
                        // priority: Priority.high,
                        // ticker: 'ticker');
                        // const NotificationDetails notificationDetails =
                        //     NotificationDetails(android: androidNotificationDetails);
                        //     notificationServices.scheduleNotification(notificationTimes, title, body)
                        // await notificationServices
                        //     .show(id++, 'plain title', 'plain body', notificationDetails, payload: 'item x');
                      },
                      child: const Text('schedule now')),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('medicineDetail')
                        .doc(user!.uid)
                        .collection('medicines')
                        .where('userId', isEqualTo: user?.uid)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("Error"),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        );
                      }

                      if (snapshot.data == null ||
                          snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text("No data available"),
                        );
                      }

                      try {
                        List<MedicineModel> medicines =
                            snapshot.data!.docs.map((doc) {
                          return MedicineModel(
                              userID: doc.id,
                              userName: doc['userName'],
                              doctorName: doc['doctorName'],
                              doctorImage: doc['doctorImage'],
                              member: doc['member'],
                              medicineName: doc['medicineName'],
                              intake: doc['intake'],
                              time: doc['time'],
                              typeOfMedicine: doc['typeOfMedicine'],
                              duration: doc['duration'],
                              notes: doc['note'],
                              fronImage: doc['frontImage'],
                              backImage: doc['backImage']);
                        }).toList();

                        medicines = medicines.reversed.toList();

                        // Extracting timeList from medicines
                        List<String> timeList = [];

                        try {
                          timeList = medicines
                              .map((medicineTime) => medicineTime.time
                                  .toString()
                                  .replaceAll('[', '')
                                  .replaceAll(
                                      ']', '')) // Remove square brackets
                              .toList();
                          for (var time in timeList) {
                            try {
                              DateFormat('h:mm a').parse(time);
                            } catch (e) {
                              print("Invalid date format: $time");
                            }
                          }
                          // Schedule notifications using followMe function
                          followMe(timeList);
                        } catch (e) {
                          print("Error creating Member instances: $e");
                        }

                        return Container(
                          height: height,
                          width: width,
                          margin: const EdgeInsets.only(top: 10.0),
                          decoration: const BoxDecoration(
                            color: textColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),
                            ),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.separated(
                                  itemCount: medicines.length,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    RegExp regex =
                                        RegExp(r'^(.*?)\s*\((.*?)\)$');
                                    RegExpMatch? match = regex.firstMatch(
                                        medicines[index].member.toString());
                                    print("Match $match");

                                    if (match != null) {
                                      name = match.group(1) ?? "";
                                      relation = match.group(2) ?? "";
                                      print("Name: $name");
                                      print("Relation: $relation");
                                    }

                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          border: Border.all(
                                              color: containerBorderColor
                                                  .withOpacity(0.3),
                                              width: 1.0)),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 70,
                                            width: width,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: CircleAvatar(
                                                    radius: 20.0,
                                                    backgroundColor:
                                                        primaryColor
                                                            .withOpacity(0.2),
                                                    child: FutureBuilder<void>(
                                                      future: precacheImage(
                                                        NetworkImage(
                                                            medicines[index]
                                                                .doctorImage
                                                                .toString()),
                                                        context,
                                                      ),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .done) {
                                                          return CircleAvatar(
                                                            radius: 20.0,
                                                            backgroundImage:
                                                                NetworkImage(
                                                              medicines[index]
                                                                  .doctorImage
                                                                  .toString(),
                                                            ),
                                                          );
                                                        } else {
                                                          return Shimmer
                                                              .fromColors(
                                                            baseColor: Colors
                                                                .grey[300]!,
                                                            highlightColor:
                                                                Colors
                                                                    .grey[100]!,
                                                            child:
                                                                const CircleAvatar(
                                                              radius: 20.0,
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: height,
                                                  width: 155,
                                                  child: ListTile(
                                                    title: Text(
                                                      name.toString(),
                                                      style: const TextStyle(
                                                          color: primaryColor,
                                                          fontFamily:
                                                              'GT Walsheim Trial',
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    subtitle: Text(
                                                      medicines[index]
                                                          .doctorName
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: textBlackColor
                                                            .withOpacity(0.3),
                                                        fontFamily:
                                                            'GT Walsheim Trial',
                                                        fontSize: 12.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  width: 80,
                                                  alignment: Alignment.center,
                                                  margin: const EdgeInsets.only(
                                                      bottom: 10.0, right: 20),
                                                  decoration: BoxDecoration(
                                                      color: primaryColor
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3.0)),
                                                  child: Text(
                                                    relation.toString(),
                                                    style: const TextStyle(
                                                        fontSize: 8.0,
                                                        color: primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Container(
                                                    height: 25,
                                                    width: 25,
                                                    alignment: Alignment.center,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            containerBorderColor
                                                                .withOpacity(
                                                                    0.2),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    20.0)),
                                                    child: const Icon(
                                                      Icons.edit,
                                                      color: textBlackColor,
                                                      size: 15.0,
                                                    ))
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15.0),
                                            child: Divider(
                                              color: containerBorderColor
                                                  .withOpacity(0.7),
                                              height: 2.0,
                                            ),
                                          ),
                                          const Gap(10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 30.0),
                                                child: Text(
                                                  "Upcoming",
                                                  style: TextStyle(
                                                    color: textBlackColor
                                                        .withOpacity(0.3),
                                                    fontFamily:
                                                        'GT Walsheim Trial',
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "Time",
                                                style: TextStyle(
                                                  color: textBlackColor
                                                      .withOpacity(0.3),
                                                  fontFamily:
                                                      'GT Walsheim Trial',
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                              Text(
                                                "Intake",
                                                style: TextStyle(
                                                  color: textBlackColor
                                                      .withOpacity(0.3),
                                                  fontFamily:
                                                      'GT Walsheim Trial',
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0),
                                                child: CircleAvatar(
                                                  radius: 8.0,
                                                  backgroundColor: primaryColor
                                                      .withOpacity(0.2),
                                                  child: FutureBuilder<void>(
                                                    future: precacheImage(
                                                      NetworkImage(
                                                          medicines[index]
                                                              .fronImage
                                                              .toString()),
                                                      context,
                                                    ),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .done) {
                                                        return CircleAvatar(
                                                          radius: 8.0,
                                                          backgroundImage:
                                                              NetworkImage(
                                                            medicines[index]
                                                                .fronImage
                                                                .toString(),
                                                          ),
                                                        );
                                                      } else {
                                                        return Shimmer
                                                            .fromColors(
                                                          baseColor:
                                                              Colors.grey[300]!,
                                                          highlightColor:
                                                              Colors.grey[100]!,
                                                          child:
                                                              const CircleAvatar(
                                                            radius: 20.0,
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Container(
                                                  width:
                                                      150, // Set your specific width
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  decoration:
                                                      const BoxDecoration(),
                                                  child: Text(
                                                    medicines[index]
                                                        .medicineName
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 45.0),
                                                child: Text(
                                                  medicines[index]
                                                      .time[0]
                                                      .toString(),
                                                  style: const TextStyle(
                                                    color: textBlackColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        'GT Walsheim Trial',
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20.0),
                                                  child: Text(
                                                    "${medicines[index].intake} ${medicines[index].typeOfMedicine}",
                                                    style: const TextStyle(
                                                      color: textBlackColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily:
                                                          'GT Walsheim Trial',
                                                      fontSize: 14.0,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: ListTile(
                                              title: Text(
                                                "Notes",
                                                style: TextStyle(
                                                  color: textBlackColor
                                                      .withOpacity(0.3),
                                                  fontFamily:
                                                      'GT Walsheim Trial',
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                              subtitle: Text(
                                                medicines[index]
                                                    .notes
                                                    .toString(),
                                                style: const TextStyle(
                                                  color: textBlackColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      'GT Walsheim Trial',
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 15.0);
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                            ],
                          ),
                        );
                      } catch (e) {
                        print("Error creating Member instances: $e");
                        return const Center(
                          child: Text("Error loading data"),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: GlowingFloatingActionButton(onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPrescriptionScreen(),
            ),
          );
        }));
  }
}
