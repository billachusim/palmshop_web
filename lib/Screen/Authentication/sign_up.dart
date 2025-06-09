import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:salespro_admin/Provider/general_setting_provider.dart';
import 'package:salespro_admin/Screen/Authentication/log_in.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;

import '../../Repository/signup_repo.dart';
import '../../Route/static_string.dart';
import '../../const.dart';
import '../Widgets/Constant Data/constant.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  static const String route = '/signup';

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool passwordShow = false;
  String? givenPassword;
  String? givenPassword2;

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate() && givenPassword == givenPassword2) {
      form.save();
      return true;
    }
    return false;
  }

  bool hidePassword = false;
  bool hideConfirmPassword = false;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tabAndMobileScreen = isMobileAndTab(screenWidth);
    final kLargeFontSize = responsiveValue<double>(context, xs: 24, md: 24, lg: 40);
    final kRegularFontSize = responsiveValue<double>(context, xs: 14, md: 14, lg: 20);
    final kSmallFontSize = responsiveValue<double>(context, xs: 14, md: 14, lg: 18);
    return Scaffold(
        backgroundColor: kMainColor,
        body: Consumer(builder: (context, ref, watch) {
          final auth = ref.watch(signUpProvider);
          final settingProvider = ref.watch(generalSettingProvider);
          return settingProvider.when(data: (setting) {
            final dynamicNameLogo = setting.commonHeaderLogo.isNotEmpty ? setting.commonHeaderLogo : null;
            final dynamicAppsName = setting.commonHeaderLogo.isNotEmpty ? setting.title : appsName;
            return Padding(
              padding: screenWidth < 400 ? const EdgeInsets.all(8) : const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: mobileScreen?20: 76,width:mobileScreen?200:255,child: SvgPicture.asset(nameLogo,fit: BoxFit.contain,)),
                    dynamicNameLogo != null ? Image.network(dynamicNameLogo, height: 50) : SvgPicture.asset(nameLogo, height: 50),
                    Center(
                      child: ResponsiveGridRow(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        ResponsiveGridCol(
                            lg: 6,
                            md: 6,
                            sm: 12,
                            xs: 12,
                            child: Center(
                              child: Container(
                                height: tabAndMobileScreen ? MediaQuery.of(context).size.width / 1.1 : MediaQuery.of(context).size.height / 1.2,
                                decoration: BoxDecoration(image: DecorationImage(image: AssetImage(tabAndMobileScreen ? 'images/loginLogo2.png' : 'images/login logo.png'))),
                              ),
                            )),
                        // ResponsiveGridCol(
                        //     lg:6,
                        //     md: 6,
                        //     xs: 12,
                        //     child: SvgPicture.asset(loginLogo)),
                        ResponsiveGridCol(
                          md: 6,
                          sm: 12,
                          lg: 6,
                          xs: 12,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 25),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(tabAndMobileScreen ? 20 : 40),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                        text: TextSpan(text: 'Welcome to ', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: kLargeFontSize, color: kTitleColor, fontWeight: FontWeight.bold), children: [
                                      TextSpan(
                                        text: dynamicAppsName,
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: kLargeFontSize, color: kMainColor, fontWeight: FontWeight.bold),
                                      )
                                    ])),
                                    Text(
                                      'Create an Account to continue',
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: kRegularFontSize, color: kNeutral500),
                                    ),
                                    SizedBox(height: tabAndMobileScreen ? 20 : 40.0),
                                    // Text(
                                    //   '$appsName Login Panel',
                                    //   style: kTextStyle.copyWith(color: kGreyTextColor, fontWeight: FontWeight.bold, fontSize: 21.0),
                                    //   textAlign: TextAlign.center,
                                    // ),
                                    // const SizedBox(height: 10.0),
                                    Form(
                                      key: globalKey,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          AppTextField(
                                            showCursor: true,
                                            cursorColor: kTitleColor,
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Email can\'n be empty';
                                              } else if (!value.contains('@')) {
                                                return 'Please enter a valid email';
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {
                                              auth.email = value;
                                            },
                                            textFieldType: TextFieldType.EMAIL,
                                            decoration: InputDecoration(
                                              labelText: lang.S.of(context).email,
                                              hintText: lang.S.of(context).enterYourEmailAddress,
                                            ),
                                          ),
                                          const SizedBox(height: 20.0),
                                          ResponsiveGridRow(children: [
                                            ResponsiveGridCol(
                                              xs: 12,
                                              md: 12,
                                              lg: 6,
                                              child: Padding(
                                                padding: EdgeInsets.only(bottom: 10, right: screenWidth > 1240 ? 10 : 0),
                                                child: AppTextField(
                                                  showCursor: true,
                                                  cursorColor: kTitleColor,
                                                  textFieldType: TextFieldType.PASSWORD,
                                                  obscureText: hidePassword,
                                                  // suffix: const SizedBox(
                                                  //   width: 20,
                                                  // ),
                                                  validator: (value) {
                                                    if (value == null || value.isEmpty) {
                                                      return 'Password can\'t be empty';
                                                    } else if (value.length < 4) {
                                                      return 'Please enter a bigger password';
                                                    } else if (value.length < 4) {
                                                      return 'Please enter a bigger password';
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (value) {
                                                    auth.password = value;
                                                    givenPassword = value;
                                                  },
                                                  decoration: InputDecoration(
                                                    labelText: lang.S.of(context).password,
                                                    suffixIcon: IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            hidePassword = !hidePassword;
                                                          });
                                                        },
                                                        icon: Icon(
                                                          hidePassword ? FeatherIcons.eyeOff : FeatherIcons.eye,
                                                          color: kGreyTextColor,
                                                        )),
                                                    hintText: lang.S.of(context).enterYourPassword,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ResponsiveGridCol(
                                                xs: 12,
                                                md: 12,
                                                lg: 6,
                                                child: Padding(
                                                  padding: EdgeInsets.only(bottom: 10, left: screenWidth > 1240 ? 10 : 0),
                                                  child: AppTextField(
                                                    showCursor: true,
                                                    cursorColor: kTitleColor,
                                                    textFieldType: TextFieldType.PASSWORD,
                                                    onChanged: (value) {
                                                      givenPassword2 = value;
                                                    },
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        return 'Password can\'t be empty';
                                                      } else if (value.length < 4) {
                                                        return 'Please enter a bigger password';
                                                      } else if (givenPassword != givenPassword2) {
                                                        return 'Password Not mach';
                                                      }
                                                      return null;
                                                    },
                                                    obscureText: hidePassword,
                                                    decoration: InputDecoration(
                                                      labelText: lang.S.of(context).confirmPassword,
                                                      suffixIcon: IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              hidePassword = !hidePassword;
                                                            });
                                                          },
                                                          icon: Icon(
                                                            hidePassword ? FeatherIcons.eyeOff : FeatherIcons.eye,
                                                            color: kGreyTextColor,
                                                          )),
                                                      hintText: lang.S.of(context).enterYourPasswordAgain,
                                                    ),
                                                  ),
                                                )),
                                          ]),
                                          const SizedBox(height: 20.0),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: Size(screenWidth, 48),
                                              ),
                                              onPressed: (() {
                                                if (validateAndSave()) {
                                                  auth.signUp(context);
                                                }
                                              }),
                                              child: Text(lang.S.of(context).registration)),
                                          const SizedBox(height: 20.0),
                                          Center(
                                            child: RichText(
                                              text: TextSpan(
                                                text: '${lang.S.of(context).alreadyHaveAnAccounts} ',
                                                style: kTextStyle.copyWith(color: kTitleColor, fontSize: kSmallFontSize),
                                                children: [
                                                  TextSpan(
                                                    text: lang.S.of(context).login,
                                                    style: kTextStyle.copyWith(color: kGreenTextColor, fontSize: kSmallFontSize),
                                                  )
                                                ],
                                              ),
                                            ).onTap(() => context.go(EmailLogIn.route)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ]),
                    ),
                  ],
                ),
              ),
            );
          }, error: (e, stack) {
            return Text(e.toString());
          }, loading: () {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
        }));
  }
}
