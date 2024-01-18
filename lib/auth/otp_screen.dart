import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gap/gap.dart';
import 'package:medallyproapp/constants/mycolors.dart';
import 'package:medallyproapp/screens/prescription_list.dart';
import '../widgets/custom_button.dart';
import 'auth_manager_class.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key, this.verificationId}) : super(key: key);
  final String? verificationId;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(6, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(80),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: textBlackColor,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0, top: 30),
              child: Text(
                'Verification',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                'Please enter the 4 digit OTP code that has been\nsent to 79******01',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: textBlackColor.withOpacity(0.7),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xff10A173),
                      width: 1,
                    ),
                  ),
                  child: TextFormField(
                    controller: otpControllers[index],
                    focusNode: focusNodes[index],
                    textInputAction: index < 5 ? TextInputAction.next : TextInputAction.done,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    cursorColor: primaryColor,
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                      }
                    },
                    decoration: const InputDecoration(
                      counterText: '',
                      enabledBorder: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(
              height: 45,
            ),
            Center(
              child: GestureDetector(
                onTap: () async {
                  try {
                    String enteredOtp = otpControllers.map((controller) => controller.text).join();
                    // PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.verificationId!, smsCode: enteredOtp);
                    // await FirebaseAuth.instance.signInWithCredential(credential);
                    // Set login status to true
                    await AuthManager.setLoggedIn(true);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrescriptionListScreen(),
                      ),
                    );

                  } catch (ex) {
                    print(ex.toString());
                  }
                },
                // onTap: (){
                //   Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => const PrescriptionListScreen(),
                //     ),
                //   );
                // },
                child: CustomButton(text: "Submit"),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                'Didn\'t receive any code?',
                style: TextStyle(
                  fontSize: 14,
                  color: textBlackColor.withOpacity(0.5),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Resend Code',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff10A173),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


