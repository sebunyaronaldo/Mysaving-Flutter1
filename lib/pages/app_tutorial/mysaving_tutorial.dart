import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:mysavingapp/common/styles/mysaving_styles.dart';
import 'package:mysavingapp/common/utils/mysaving_colors.dart';
import 'package:mysavingapp/pages/app_tutorial/saldo_screen.dart';

class MySavingTutorial extends StatefulWidget {
  const MySavingTutorial({super.key});
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => MySavingTutorial());
  }

  @override
  State<MySavingTutorial> createState() => _MySavingTutorialState();
}

class _MySavingTutorialState extends State<MySavingTutorial> {
  final introKey = GlobalKey<IntroductionScreenState>();
  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => SaldoScreen()),
    );
  }

  static const bodyStyle = TextStyle(fontSize: 17.0, color: Color(0xff4D5284));
  static var pageDecoration = PageDecoration(
    bodyFlex: 4,
    imageFlex: 6,

    titlePadding: EdgeInsets.fromLTRB(16.0, 30, 16.0, 20), // Zmniejszono górną i dolną wartość
    titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700, color: MySavingColors.defaultDarkText),
    bodyTextStyle: bodyStyle,
    bodyPadding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0), // Zmniejszono górną i dolną wartość
    pageColor: Colors.white,
    imagePadding: EdgeInsets.zero,
  );

  @override
  Widget build(BuildContext context) {
    var msstyles = MySavingStyles(context);
    return IntroductionScreen(
        globalFooter: Padding(
          padding: EdgeInsets.only(bottom: 76),
          child: Container(
            width: 250,
            height: 50,
            decoration: msstyles.mysavingButtonContainerStyles,
            child: ElevatedButton(
              style: msstyles.mysavingButtonStyles,
              child: const Text(
                'Pomiń',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              onPressed: () => _onIntroEnd(context),
            ),
          ),
        ),
        key: introKey,
        globalBackgroundColor: Colors.white,
        allowImplicitScrolling: true,
        pages: [
          PageViewModel(
            title: "Monitoruj swoje finanse",
            body:
                "Bez trudu zapisuj swoje wydatki i nadawaj im kategorie, aby lepiej zrozumieć swoje nawyki finansowe.",
            image: SizedBox(
              width: 300,
              height: 300,
              child: Lottie.asset('assets/animations/expenses.json'),
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
              title: "Utrzymuj kontrolę nad finansami",
              body:
                  "Dzięki przejrzystemu interfejsowi śledź, jak wydajesz pieniądze oraz jak rosną Twoje oszczędności.",
              image: SizedBox(
                width: 300,
                height: 300,
                child: Lottie.asset('assets/animations/analitycs.json'),
              ),
              decoration: pageDecoration),
          PageViewModel(
              title: "Osiągaj swoje cele",
              body:
                  "Dzięki gromadzeniu oszczędności, masz szansę spełnić swoje marzenia i zrealizować to, o czym zawsze marzyłeś.",
              image: SizedBox(
                width: 300,
                height: 300,
                child: Lottie.asset('assets/animations/savings.json'),
              ),
              decoration: pageDecoration),
        ],
        onDone: () => _onIntroEnd(context),
        onSkip: () => _onIntroEnd(context), // You can override onSkip callback
        showSkipButton: false,
        skipOrBackFlex: 0,
        nextFlex: 0,
        showNextButton: false,
        showBackButton: false,
        showDoneButton: false,
        showBottomPart: true,
        back: const Icon(
          Icons.arrow_back,
          color: Color(0xff806FF1),
        ),
        skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF444FFF))),
        next: const Icon(
          Icons.arrow_forward,
          color: Color(0xff806FF1),
        ),
        done: Text('Go Earn', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF444FFF))),
        curve: Curves.fastLinearToSlowEaseIn,
        controlsMargin: const EdgeInsets.only(bottom: 56),
        dotsDecorator: DotsDecorator(
          size: Size(20.0, 10.0),
          color: Color(0xFFBDBDBD),
          activeSize: Size(22.0, 10.0),
          activeColor: MySavingColors.defaultBlueButton,
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        dotsContainerDecorator: const ShapeDecoration(
          color: Color.fromARGB(221, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ));
  }
}
