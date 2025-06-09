import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as pro;
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_grid/responsive_grid.dart';
import 'package:salespro_admin/Language/language_provider.dart';
import 'package:salespro_admin/Route/app_routes.dart';
import 'package:salespro_admin/Screen/Payment%20Handler/payment_success.dart';
import 'package:salespro_admin/const.dart';
import 'package:url_strategy/url_strategy.dart';

import 'Route/static_string.dart';
import 'Screen/Widgets/Constant Data/constant.dart';
import 'Screen/Widgets/Constant Data/theme.dart';
import 'Screen/currency/currency_provider.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';
import 'model/paypal_info_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ResponsiveGridBreakpoints.value = ResponsiveGridBreakpoints(
    sm: 576,
    md: 1240,
    lg: double.infinity,
  );
  setPathUrlStrategy();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getPaypalInfo();
    return pro.MultiProvider(
      providers: [
        pro.ChangeNotifierProvider<LanguageChangeProvider>(
          create: (context) => LanguageChangeProvider(),
        ),
        pro.ChangeNotifierProvider<CurrencyProvider>(
          create: (context) => CurrencyProvider(),
        ),
      ],
      child: Builder(
        builder: (context) => rf.ResponsiveBreakpoints.builder(
          breakpoints: [
            rf.Breakpoint(
              start: BreakpointName.XS.start,
              end: BreakpointName.XS.end,
              name: BreakpointName.XS.name,
            ),
            rf.Breakpoint(
              start: BreakpointName.SM.start,
              end: BreakpointName.SM.end,
              name: BreakpointName.SM.name,
            ),
            rf.Breakpoint(
              start: BreakpointName.MD.start,
              end: BreakpointName.MD.end,
              name: BreakpointName.MD.name,
            ),
            rf.Breakpoint(
              start: BreakpointName.LG.start,
              end: BreakpointName.LG.end,
              name: BreakpointName.LG.name,
            ),
            rf.Breakpoint(
              start: BreakpointName.XL.start,
              end: BreakpointName.XL.end,
              name: BreakpointName.XL.name,
            ),
          ],
          child: MaterialApp.router(
            locale: pro.Provider.of<LanguageChangeProvider>(context, listen: true).currentLocale,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            builder: EasyLoading.init(),
            debugShowCheckedModeBanner: false,
            title: appsTitle,
            theme: AcnooTheme.kLightTheme(context),
            routerConfig: AcnooAppRoutes.routerConfig,
          ),
        ),
      ),
    );
  }

  Future<void> getPaypalInfo() async {
    DatabaseReference paypalRef = FirebaseDatabase.instance.ref('Admin Panel/Paypal Info');
    final paypalData = await paypalRef.get();
    PaypalInfoModel paypalInfoModel = PaypalInfoModel.fromJson(jsonDecode(jsonEncode(paypalData.value)));

    paypalClientId = paypalInfoModel.paypalClientId;
    paypalClientSecret = paypalInfoModel.paypalClientSecret;
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    var uri = Uri.parse(settings.name!);
    switch (uri.path) {
      case 'success/':
        return MaterialPageRoute(builder: (_) => const PaymentSuccess());
      default:
        return MaterialPageRoute(builder: (_) => const PaymentSuccess());
    }
  }
}

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   ResponsiveGridBreakpoints.value = ResponsiveGridBreakpoints(
//     sm: 576,
//     md: 1240,
//     lg: double.infinity,
//   );
//   setPathUrlStrategy();
//   // html.window.onBeforeUnload.listen((event) async {});
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const ProviderScope(child: MyApp()));
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     getPaypalInfo();
//     // Subscription.getUserLimitsData(context: context,wannaShowMsg: true);
//     return pro.ChangeNotifierProvider<LanguageChangeProvider>(
//         create: (context) => LanguageChangeProvider(),
//         child: Builder(
//             builder: (context) => rf.ResponsiveBreakpoints.builder(
//                   breakpoints: [
//                     rf.Breakpoint(
//                       start: BreakpointName.XS.start,
//                       end: BreakpointName.XS.end,
//                       name: BreakpointName.XS.name,
//                     ),
//                     rf.Breakpoint(
//                       start: BreakpointName.SM.start,
//                       end: BreakpointName.SM.end,
//                       name: BreakpointName.SM.name,
//                     ),
//                     rf.Breakpoint(
//                       start: BreakpointName.MD.start,
//                       end: BreakpointName.MD.end,
//                       name: BreakpointName.MD.name,
//                     ),
//                     rf.Breakpoint(
//                       start: BreakpointName.LG.start,
//                       end: BreakpointName.LG.end,
//                       name: BreakpointName.LG.name,
//                     ),
//                     rf.Breakpoint(
//                       start: BreakpointName.XL.start,
//                       end: BreakpointName.XL.end,
//                       name: BreakpointName.XL.name,
//                     ),
//                   ],
//                   child: MaterialApp.router(
//                     locale: pro.Provider.of<LanguageChangeProvider>(context, listen: true).currentLocale,
//                     localizationsDelegates: const [
//                       S.delegate,
//                       GlobalMaterialLocalizations.delegate,
//                       GlobalWidgetsLocalizations.delegate,
//                       GlobalCupertinoLocalizations.delegate,
//                     ],
//                     supportedLocales: S.delegate.supportedLocales,
//                     builder: EasyLoading.init(),
//                     debugShowCheckedModeBanner: false,
//                     title: appsTitle,
//                     theme: AcnooTheme.kLightTheme(context),
//                     routerConfig: AcnooAppRoutes.routerConfig,
//                     // onGenerateRoute: generateRoute,
//                     // initialRoute: '/',
//                     // routes: {
//                     //   '/': (context) => const EmailLogIn(),
//                     //   // '/': (context) => const MtHomeScreen(),
//                     //   EmailLogIn.route: (context) => const EmailLogIn(),
//                     //   MtHomeScreen.route: (context) => const MtHomeScreen(),
//                     //   PosSale.route: (context) => const PosSale(),
//                     //   Purchase.route: (context) => const Purchase(),
//                     //   Product.route: (context) => const Product(),
//                     //   InventorySales.route: (context) => const InventorySales(),
//                     //   SupplierList.route: (context) => const SupplierList(),
//                     //   CustomerList.route: (context) => const CustomerList(),
//                     //   ExpensesList.route: (context) => const ExpensesList(),
//                     //   IncomeList.route: (context) => const IncomeList(),
//                     //   NewExpense.route: (context) => const NewExpense(),
//                     //   NewIncome.route: (context) => const NewIncome(),
//                     //   SaleReports.route: (context) => const SaleReports(),
//                     //   QuotationList.route: (context) => const QuotationList(),
//                     //   SettingsScreen.route: (context) => const SettingsScreen(),
//                     //   // SMSHome.route: (context) => const SMSHome(),
//                     //   // NidVerification.route: (context) => const NidVerification(),
//                     //   WarrantyScreen.route: (context) => const WarrantyScreen(),
//                     //   // PricingPage.route: (context) =>  PricingPage(),
//                     //   PaymentSuccess.route: (context) => const PaymentSuccess(),
//                     //   PaymentCancel.route: (context) => const PaymentCancel(),
//                     //   SaleList.route: (context) => const SaleList(),
//                     //   SalesReturn.route: (context) => const SalesReturn(),
//                     //   PurchaseReturn.route: (context) => const PurchaseReturn(),
//                     //   PurchaseList.route: (context) => const PurchaseList(),
//                     //   // LogIn.route: (context) => const LogIn(),
//                     //   ForgotPassword.route: (context) => const ForgotPassword(),
//                     //   SignUp.route: (context) => const SignUp(),
//                     //   TabletLogIn.route: (context) => const TabletLogIn(),
//                     //   TabletSignUp.route: (context) => const TabletSignUp(),
//                     //   UserRoleScreen.route: (context) => const UserRoleScreen(),
//                     //   DailyTransactionScreen.route: (context) => const DailyTransactionScreen(),
//                     //
//                     //   LedgerScreen.route: (context) => const LedgerScreen(),
//                     //   LossProfitScreen.route: (context) => const LossProfitScreen(),
//                     //   DueList.route: (context) => const DueList(),
//                     //   SubscriptionPage.route: (context) => const SubscriptionPage(),
//                     //   StockListScreen.route: (context) => const StockListScreen(),
//                     //   BarcodeGenerate.route: (context) => const BarcodeGenerate(),
//                     //   WareHouseList.route: (context) => const WareHouseList(),
//                     //   PaymentScreen.route: (context) => const PaymentScreen(
//                     //         subscriptionPlanModel: null,
//                     //       ),
//                     //   PurchasePlan.route: (context) => const PurchasePlan(initialSelectedPackage: 'Yearly', initPackageValue: 0),
//                     //
//                     //   // TabletSaleReport.route: (context) => const TabletSaleReport(),
//                     //   TaxRates.route: (context) => const TaxRates(),
//                     //   DesignationListScreen.route: (context) => const DesignationListScreen(),
//                     //   EmployeeListScreen.route: (context) => const EmployeeListScreen(),
//                     // },
//                   ),
//                 )));
//   }
//
//   Future<void> getPaypalInfo() async {
//     DatabaseReference paypalRef = FirebaseDatabase.instance.ref('Admin Panel/Paypal Info');
//     final paypalData = await paypalRef.get();
//     PaypalInfoModel paypalInfoModel = PaypalInfoModel.fromJson(jsonDecode(jsonEncode(paypalData.value)));
//
//     paypalClientId = paypalInfoModel.paypalClientId;
//     paypalClientSecret = paypalInfoModel.paypalClientSecret;
//   }
//
//   Route<dynamic> generateRoute(RouteSettings settings) {
//     var uri = Uri.parse(settings.name!);
//     switch (uri.path) {
//       case 'success/':
//         return MaterialPageRoute(builder: (_) => const PaymentSuccess());
//       default:
//         return MaterialPageRoute(builder: (_) => const PaymentSuccess());
//     }
//   }
// }
