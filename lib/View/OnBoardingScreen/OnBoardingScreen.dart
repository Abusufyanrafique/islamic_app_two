import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/Utils/Constants/AllText.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../Utils/Constants/AllColors.dart';
import '../../Utils/Constants/SizeConfig.dart';
import '../../Widgets/BottomNavigationBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoardingState {
  final int currentIndex;
  final bool isLastPage;

  OnBoardingState({
    this.currentIndex = 0, 
    this.isLastPage = false
    });
}

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit() : super(OnBoardingState());

  void updatePageIndex(int index) {
    emit(OnBoardingState(
      currentIndex: index,
      isLastPage: index == 2, 
    ));
  }
}


class OnBoardingScreen extends StatelessWidget {
  OnBoardingScreen({super.key});

  
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return BlocProvider(
      create: (context) => OnBoardingCubit(),
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                AllImages.imgbackflower,
                fit: BoxFit.cover,
              ),
            ),
            BlocBuilder<OnBoardingCubit, OnBoardingState>(
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:  EdgeInsets.symmetric(
                        horizontal: getWidth(10),
                        ),
                      child: Image.asset(
                        AllImages.upperimage,
                         fit: BoxFit.cover,
                         ),
                    ),
                    SizedBox(
                      height: getHeight(398),
                      child: PageView(
                        controller: controller,
                        onPageChanged: (index) {

                          context.read<OnBoardingCubit>().updatePageIndex(index);
                        },
                        children: [
                          buildPage(
                            image: AllImages.kahba,
                            heading: AllText.onboarding_Heading1,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            subHeading: AllText.onboarding_subHeading1,
                            padding:  EdgeInsets.only(right: 30),
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(100),
                              topRight: Radius.circular(100),
                            ),
                          ),
                          buildPage(
                            image: AllImages.mosque,
                            heading: AllText.onboarding_Heading2,
                            subHeading: AllText.onboarding_subHeading2,
                            borderRadius: BorderRadius.circular(80),
                            padding:  EdgeInsets.symmetric(horizontal: getWidth(30)),
                          ),
                          buildPage(
                            image: AllImages.quran,
                            heading: AllText.onboarding_Heading3,
                            subHeading: AllText.onboarding_subHeading3,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            padding: const EdgeInsets.only(left: 30),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(100),
                              topLeft: Radius.circular(100),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: getHeight(20)),
                    Center(
                      child: SmoothPageIndicator(
                        effect: WormEffect(
                          spacing: 15,
                          dotWidth: 6, 
                          dotHeight: 6,
                          dotColor: Colors.cyan.shade100,
                          activeDotColor: AppColors.primaryColor,
                        ),
                        onDotClicked: (index) {
                          controller.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.bounceInOut,
                          );
                        },
                        controller: controller,
                        count: 3,
                      ),
                    ),
                    SizedBox(height: getHeight(10)),
                    button(
                      state.isLastPage ? "Get Started" : "Next",
                          () async {
                        if (state.isLastPage) {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool("isFirstTime", false);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BottomNavScreen(),
                            ),
                          );
                        } else {
                          controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.bounceIn,
                          );
                        }
                      },
                    ),
                    
                  ],
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding:  EdgeInsets.symmetric(
            horizontal: getWidth(10)
            ),
          child: Image.asset(
            AllImages.bottomimage, 
            fit: BoxFit.cover,
            ),
        ),
      ),
    );
  }

  // Same buildPage method with exact same styles
  Widget buildPage({
    required String image,
    required String heading,
    required String subHeading,
    required BorderRadius borderRadius,
    EdgeInsetsGeometry padding = const EdgeInsets.only(),
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Padding(
          padding: padding,
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Image.asset(
              image,
              width: double.infinity,
              height: getHeight(200),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: getHeight(20)),
        Center(
          child: Padding(
            padding:  EdgeInsets.only(
              left: 20.0,
              right: 20,
              ),
            child: Text(
              heading,
              textAlign: TextAlign.center,
              style:  AppColors().customTextStyle20().copyWith(
                fontSize: getFont(24)
              )
            ),
          ),
        ),
        SizedBox(height: getHeight(10)),
        Center(
          child: Padding(
            padding:  EdgeInsets.only(
              left: getWidth(40),
              right: getWidth(40),
              
              ),
            child: Text(
              subHeading,
              textAlign: TextAlign.center,
              style: AppColors().customTextStyle14()
            ),
          ),
        ),
      ],
    );
  }

  // Same button widget with exact same styles
  Widget button(String title, VoidCallback ontap) {
    return Padding(
      padding:  EdgeInsets.symmetric(
        horizontal: getWidth(12)),
      child: SizedBox(
        width: double.infinity,
        height: getHeight(53),
        child: InkWell(
          onTap: ontap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.primaryColor,
            ),
            child: Center(
              child: Text(
                title,
                style: AppColors().customTextStyleBold16(
                  color: AppColors.white
                )
              ),
            ),
          ),
        ),
      ),
    );
  }
}


