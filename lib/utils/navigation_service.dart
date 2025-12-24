// import 'package:flutter/material.dart';

// class NavigationService {
//   static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//   static Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
//     return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
//   }

//   static Future<dynamic> navigateToAndReplace(String routeName, {Object? arguments}) {
//     return navigatorKey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
//   }

//   static Future<dynamic> navigateToAndClearStack(String routeName, {Object? arguments}) {
//     return navigatorKey.currentState!.pushNamedAndRemoveUntil(
//       routeName,
//       (Route<dynamic> route) => false,
//       arguments: arguments,
//     );
//   }

//   static void goBack([dynamic result]) {
//     return navigatorKey.currentState!.pop(result);
//   }

//   static bool canGoBack() {
//     return navigatorKey.currentState!.canPop();
//   }

//   static Future<bool> showExitDialog(BuildContext context) async {
//     return await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Exit App'),
//         content: const Text('Are you sure you want to exit the CAD Diagnosis Assistant?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             child: const Text('Exit'),
//           ),
//         ],
//       ),
//     ) ?? false;
//   }

//   static void showSnackBar(String message, {Color? backgroundColor, Duration? duration}) {
//     final context = navigatorKey.currentContext;
//     if (context != null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: backgroundColor,
//           duration: duration ?? const Duration(seconds: 3),
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//       );
//     }
//   }

//   static void showErrorSnackBar(String message) {
//     showSnackBar(
//       message,
//       backgroundColor: Colors.red.shade600,
//       duration: const Duration(seconds: 4),
//     );
//   }

//   static void showSuccessSnackBar(String message) {
//     showSnackBar(
//       message,
//       backgroundColor: Colors.green.shade600,
//       duration: const Duration(seconds: 3),
//     );
//   }

//   static void showInfoSnackBar(String message) {
//     showSnackBar(
//       message,
//       backgroundColor: Colors.blue.shade600,
//       duration: const Duration(seconds: 3),
//     );
//   }

//   static Future<void> showLoadingDialog(BuildContext context, {String? message}) async {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const CircularProgressIndicator(),
//             const SizedBox(height: 16),
//             Text(message ?? 'Processing...'),
//           ],
//         ),
//       ),
//     );
//   }

//   static void hideLoadingDialog() {
//     final context = navigatorKey.currentContext;
//     if (context != null && Navigator.of(context).canPop()) {
//       Navigator.of(context).pop();
//     }
//   }

//   static Future<bool?> showConfirmationDialog({
//     required BuildContext context,
//     required String title,
//     required String content,
//     String confirmText = 'Confirm',
//     String cancelText = 'Cancel',
//   }) async {
//     return await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(title),
//         content: Text(content),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: Text(cancelText),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             child: Text(confirmText),
//           ),
//         ],
//       ),
//     );
//   }
// }