import 'package:flutter/material.dart';
import 'package:pawltest/core/utils/screen_utils.dart';

class NetworkUnavailableSheet extends StatelessWidget {
  const NetworkUnavailableSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: const CommonModalSheet(
        title: 'No Internet Connection',
        subtitle:
            'Oops! it seems your internet is unstable/ disconnected. Please ensure you are connected to Internet',
        isButtonAvailable: false,
        iconPath: Icon(
          Icons.wifi_off,
          size: 40,
          color: Colors.pinkAccent
        ),
      ),
    );
  }
}

class NetworkAvailableSheet extends StatelessWidget {
  const NetworkAvailableSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: const CommonModalSheet(
        title: 'Internet Connection is back',
        // subtitle: 'Enjoy Zyggy',
        isButtonAvailable: false,

        iconPath: Icon(Icons.wifi, size: 60, color: Colors.green),
      ),
    );
  }
}
class CommonModalSheet extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isButtonAvailable;
  final Function()? buttonOnTap;
  final String? buttonTitle;
  final Widget? iconPath;
  final Widget? loadingWidget;
  final Color? buttonFontColor;

  final Widget? subtitleWidget;
  final Widget? titleWidget;

  final Widget? buttonWidget;

  const CommonModalSheet(
      {super.key,
      required this.title,
      this.subtitle,
      this.isButtonAvailable = false,
      this.buttonOnTap,
      this.buttonTitle = "OK",
      this.iconPath,
      this.loadingWidget,
      this.buttonFontColor,
      this.subtitleWidget,
      this.titleWidget,
      this.buttonWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width(context),
      margin: EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24)),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 32,
          ),
          loadingWidget != null ? loadingWidget! : const SizedBox.shrink(),
          iconPath != null ? iconPath! : const SizedBox.shrink(),
          //     ? Image.asset(
          //   '$imagePath',
          //   width: 80,
          //   height: 80,
          // ) : const SizedBox(),
          const SizedBox(
            height: 12,
          ),
          titleWidget ??
              Text(
                title,
                textAlign: TextAlign.center,
               
              ),
          const SizedBox(
            height: 6,
          ),
          subtitleWidget != null
              ? subtitleWidget!
              : subtitle != null
                  ? Text(
                      '$subtitle',
                      textAlign: TextAlign.center,
               
                    )
                  : const SizedBox(),
          const SizedBox(
            height: 32,
          ),
          
        ],
      ),
    );
  }
}