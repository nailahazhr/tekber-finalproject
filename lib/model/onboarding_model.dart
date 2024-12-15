import 'package:ns_apps/constants/images.dart';
import 'package:ns_apps/constants/text.dart';

class OnBoardingModel {
  final String image;
  final String title;
  final String subtitle;

  OnBoardingModel(this.image, this.title, this.subtitle);
}

class OnBoardingItems{
  List<OnBoardingModel> items = [
    OnBoardingModel(tOnBoardingImage1, tOnBoardingTitle1, tOnBoardingSubTitle1),
    OnBoardingModel(tOnBoardingImage2, tOnBoardingTitle2, tOnBoardingSubTitle2),
    OnBoardingModel(tOnBoardingImage3, tOnBoardingTitle3, tOnBoardingSubTitle3),
  ];
}