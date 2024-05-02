import 'package:abc_test/personal_plan/personal_plan_analyzing.dart';
import 'package:abc_test/personal_plan/personal_plan_ready.dart';
import 'package:flutter/material.dart';

import 'diagnostic_test_result/diagnostic_test_result.dart';
import 'exam_time_setup/exam_date_select_pages.dart';
import 'intro_study_plan_pages/intro_study_plan_pages.dart';
import 'login_pages/main_login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final tabDataList = <LoginDataItem>[
      LoginDataItem(
          image: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset('assets/images/login_1_1.png'),
              Image.asset('assets/images/login_1_2.png')
            ],
          ),
          detail:
              "Log in now to receive personalized recommendations for practice and sync progress across devices."),
      LoginDataItem(
          image: Image.asset('assets/images/login_2.png'),
          detail:
              "Please enter the verification code we sent to your email address within 30 minutes. If you don't see it, check your spam folder.")
    ];
    final tabList = <IntroStudyPlanData>[
      IntroStudyPlanData(
          index: 0,
          title: 'Exam-Like Questions',
          subtitle:
              'We offer a wide range of questions compiled by experts that closely resemble the real exam.',
          image: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset('assets/images/intro_1_1.png'),
              Image.asset('assets/images/intro_1_2.png'),
            ],
          )),
      IntroStudyPlanData(
          index: 1,
          title: 'Powerful Learning Method',
          subtitle:
              'We use a combination of active recall, spaced repetition, and interleaving to strengthen memory retention.',
          image: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset('assets/images/intro_2_1.png'),
              Image.asset('assets/images/intro_2_2.png'),
            ],
          )),
      IntroStudyPlanData(
          index: 2,
          title: 'Personalized Study Plan',
          subtitle:
              'Based on your exam date and Diagnostic Test, we build a personalized study plan for you, maximizing your chances of exam success.',
          image: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset('assets/images/intro_3_1.png'),
              Image.asset('assets/images/intro_3_2.png'),
              Image.asset('assets/images/intro_3_3.png'),
            ],
          ))
    ];
    final pageImages = [
      Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/images/exam_date_1_1.png'),
          Image.asset('assets/images/exam_date_1_2.png'),
        ],
      ),
      Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/images/exam_date_1_1.png'),
          Image.asset('assets/images/exam_date_1_2.png'),
        ],
      ),
      Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/images/exam_date_3_1.png'),
          Image.asset('assets/images/exam_date_3_2.png'),
        ],
      ),
      Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/images/exam_date_4_1.png'),
          Image.asset('assets/images/exam_date_4_2.png'),
        ],
      ),
    ];
    final subjectDataList = <SubjectResultData>[
      SubjectResultData(
          'Arithmetic Reasoning', 10, 'assets/images/subject_icon.svg'),
      SubjectResultData(
          'Electrical Engineering', 30, 'assets/images/subject_icon.svg'),
      SubjectResultData('Haz Mat', 15, 'assets/images/subject_icon.svg'),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => IntroStudyPlanPages(
                          tabList: tabList, onFinish: () {})));
                },
                child: const Text('Intro personal plan')),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LoginPages(
                          tabDataList: tabDataList,
                          onRequestCodeClick: (String email) {},
                          onSkip: () {},
                          onSubmit: (String otp) {},
                        )));
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ExamDateSelectPages(
                        pageImages: pageImages,
                        onStartDiagnostic: () {},
                        onSkipDiagnostic: () {},
                        onSelectExamDate: (date) {},
                        onSelectReminderTime: (time) {})));
              },
              child: const Text('Exam time setup'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DiagnosticTestResult(
                          subjectList: subjectDataList,
                          beginnerImage: 'assets/images/level_beginner.png',
                          intermediateImage: 'assets/images/level_inter.png',
                          advancedImage: 'assets/images/level_advanced.png',
                          onNext: () {},
                          testDate: DateTime.now(),
                          mainProgress: 60,
                        )));
              },
              child: const Text('Diagnostic result'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        StudyPlanAnalyzingScreen(onFinish: () {})));
              },
              child: const Text('Analyzing'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => StudyPlanReadyScreen(
                        questions: 69,
                        passingScore: 89,
                        onStartLearning: () {})));
              },
              child: const Text('Personal plan ready'),
            ),
          ],
        ),
      ),
    );
  }
}
