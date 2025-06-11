// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:sizer/sizer.dart';

// import '../widgets/custom_error_widget.dart';
// import 'core/app_export.dart';

// void main() async {
//   await dotenv.load();
//   WidgetsFlutterBinding.ensureInitialized();
//   ErrorWidget.builder = (FlutterErrorDetails details) {
//     return CustomErrorWidget(
//       errorDetails: details,
//     );
//   };
//   Future.wait([
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
//   ]).then((value) {
//     runApp(MyApp());
//   });
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Sizer(builder: (context, orientation, screenType) {
//       return MaterialApp(
//         title: 'edushare',
//         theme: AppTheme.lightTheme,
//         darkTheme: AppTheme.darkTheme,
//         themeMode: ThemeMode.light,
//         builder: (context, child) {
//           return MediaQuery(
//             data: MediaQuery.of(context).copyWith(
//               textScaler: TextScaler.linear(1.0),
//             ),
//             child: child!,
//           );
//         },
//         debugShowCheckedModeBanner: false,
//         routes: AppRoutes.routes,
//         initialRoute: AppRoutes.initial,
//       );
//     });
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../widgets/custom_error_widget.dart';
import 'core/app_export.dart';
import 'provider/theme_toggle_provider.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return CustomErrorWidget(
      errorDetails: details,
    );
  };

  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  ]).then((value) {
    runApp(
      ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, screenType) {
      return Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            title: 'edushare',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode:
                themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(1.0),
                ),
                child: child!,
              );
            },
            debugShowCheckedModeBanner: false,
            routes: AppRoutes.routes,
            initialRoute: AppRoutes.initial,
          );
        },
      );
    });
  }
}
