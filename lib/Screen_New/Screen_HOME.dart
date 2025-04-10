import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movieappprj/Controllers/Dotnavigation_Controller.dart';
import 'package:movieappprj/Utils/constants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Dotnavigation_Controller());
    final dark = Util.isDarkMode(context);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: controller.pagecontroller,
              onPageChanged: controller.UpdateIndicator,
              children: [
                _FirstLook(
                  image: Util.Logo,
                  bigTitle: "Dive into the Action!",
                  subTitle:
                      "Engage users directly by making them feel involved",
                ),
                _FirstLook(
                  image: Util.Logo1,
                  bigTitle: "Your Movie Journey Awaits!",
                  subTitle:
                      "Personalize the experience, emphasizing ownership and choice",
                ),
                _FirstLook(
                  image: Util.Logo2,
                  bigTitle: "Join the Movie Lovers Community!",
                  subTitle:
                      "reate a sense of community and shared experience among users",
                ),
              ],
            ),

            const _SkipButton(),

            const _DotNaviGator(),

            const _nextPage_button(),
          ],
        ),
      ),
    );
  }
}

class _nextPage_button extends StatelessWidget {
  const _nextPage_button({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final bool dark = Util.isDarkMode(context);

    return Positioned(
      top: Util.getAppBarHeight() - 30,
      right: Util.defaultSpace,
      child: TextButton(
        onPressed: () {
          Dotnavigation_Controller.instance.nextPage();
        },
        style: TextButton.styleFrom(
          backgroundColor: dark ? Colors.white : Colors.blue ,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Icon(Icons.skip_next, color: dark ? Colors.blue : Colors.white),
      ),
    );
  }
}

class _DotNaviGator extends StatelessWidget {
  const _DotNaviGator({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Util.isDarkMode(context);
    final controller = Dotnavigation_Controller.instance;

    return Positioned(
      bottom: Util.getBottomNavigationBarHeight(),
      left: Util.defaultSpace,
      child: SmoothPageIndicator(
        effect: ExpandingDotsEffect(
          activeDotColor: dark ? Colors.white : Colors.blue,
          dotHeight: 6,
        ),
        controller: controller.pagecontroller,
        onDotClicked: controller.dotNavigatorClick,
        count: 3,
      ),
    );
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Util.isDarkMode(context);
    return Positioned(
      bottom: Util.getAppBarHeight() - 10,
      right: Util.defaultSpace,
      child: TextButton(
        onPressed: () {
          Dotnavigation_Controller.instance.SkipButton(context);
        },
        style: TextButton.styleFrom(
          backgroundColor: dark ? Colors.white : Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          "Login Now",
          style: TextStyle(
            color: dark ? Colors.blue : Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _FirstLook extends StatelessWidget {
  const _FirstLook({
    super.key,
    required this.image,
    required this.bigTitle,
    required this.subTitle,
  });

  final String image, bigTitle, subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: AssetImage(image), fit: BoxFit.cover),
          Text(
            bigTitle,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Util.sizeBtw2Text),
          Text(
            subTitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
