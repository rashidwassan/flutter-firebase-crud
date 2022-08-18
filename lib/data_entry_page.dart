import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/components/blur_container.dart';
import 'package:flutter_firebase/components/buttons.dart';
import 'package:flutter_firebase/constants/images.dart';
import 'package:flutter_firebase/models/user.dart';
import 'package:flutter_firebase/users_list.dart';
import 'package:velocity_x/velocity_x.dart';

import 'components/textfields.dart';

class DataEntryScreen extends StatefulWidget {
  const DataEntryScreen({super.key});

  @override
  State<DataEntryScreen> createState() => _DataEntryScreenState();
}

class _DataEntryScreenState extends State<DataEntryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _blurAnimationController;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController educationalYearsController =
      TextEditingController();

  @override
  void initState() {
    _blurAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      lowerBound: 0,
      upperBound: 5,
    );
    super.initState();
    _blurAnimationController.forward();
    _blurAnimationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _blurAnimationController.dispose();
    nameController.dispose();
    ageController.dispose();
    educationalYearsController.dispose();
  }

  // method for extracting the data from text fields and saving it to firebase storage

  // initializing Firestore instance pointing towards the students collection
  final studentsCollection = FirebaseFirestore.instance.collection('students');

  saveUserData() async {
    final User user = User(
      name: nameController.text,
      age: int.parse(ageController.text),
      educationalYears: int.parse(educationalYearsController.text),
    );

    final userDataInJsonFormat = user.toJson();
    await studentsCollection.doc(nameController.text).set(userDataInJsonFormat);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => StudentListPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                Images.loginBg,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        BlurContainer(value: _blurAnimationController.value),
        SafeArea(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                double.infinity.widthBox,
                const Spacer(),
                _buildTitleText(context),
                const Spacer(),
                PrimaryTextField(
                  controller: nameController,
                  hintText: 'Name',
                  prefixIcon: Icons.person,
                ),
                24.heightBox,
                PrimaryTextField(
                  controller: ageController,
                  hintText: 'Age',
                  prefixIcon: CupertinoIcons.padlock,
                ),
                24.heightBox,
                PrimaryTextField(
                  controller: educationalYearsController,
                  hintText: 'Educational Years',
                  prefixIcon: CupertinoIcons.mail_solid,
                ),
                const Spacer(),
                buildSignInGradientButtonRow(
                  context,
                  'Save Data',
                  saveUserData,
                ),
              ],
            ).p(24),
          ),
        ),
      ]),
    );
  }

  Column _buildTitleText(BuildContext context) {
    return Column(
      children: [
        Text(
          'Add User Data',
          softWrap: true,
          style: Theme.of(context).textTheme.headline4!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
