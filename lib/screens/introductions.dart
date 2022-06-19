import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi/logIn/logIn.dart';

List<PageViewModel> getPages() {
  return [
    PageViewModel(
      title: "Title of first page",
      body:
          "Here you can write the description of the page, to explain someting...",
      image: const Center(child: Icon(Icons.android)),
      decoration: const PageDecoration(
        pageColor: Colors.white,
      ),
    ),
    PageViewModel(
      decoration: const PageDecoration(
        pageColor: Colors.white,
      ),
      title: "Title of first page",
      bodyWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("Click on "),
          Icon(Icons.edit),
          Text(" to edit a post"),
        ],
      ),
      image: const Center(child: Icon(Icons.android)),
    )
  ];
}

class Introduction extends StatelessWidget {
  const Introduction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IntroductionScreen(
      pages: getPages(),
      onDone: () async {
        final prefs = await SharedPreferences.getInstance();

        prefs.setBool('userLoggedIn', true);
        // When done button is press
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LogInPage(),
          ),
        );
      },
      showBackButton: false,
      showNextButton: false,
      skip: const Icon(Icons.skip_next),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Colors.red,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0))),
    ));
  }
}
