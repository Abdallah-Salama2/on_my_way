// import 'package:flutter/material.dart';

// import '../../../../core/styles/app_colors.dart';

// class TripDetailsSheet extends StatelessWidget {
//   const TripDetailsSheet({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: DraggableScrollableSheet(
//         initialChildSize: 0.3,
//         minChildSize: 0.15,
//         maxChildSize: 0.8,
//         expand: false,
//         builder: (context, scrollController) => LayoutBuilder(
//           builder: (context, constraints) => DecoratedBox(
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 AppColors.boxShadowBlack26,
//               ],
//               borderRadius: BorderRadius.vertical(
//                 top: Radius.circular(22),
//               ),
//             ),
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.only(top: 12),
//               controller: scrollController,
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(
//                   minWidth: constraints.maxWidth,
//                   minHeight: constraints.maxHeight,
//                 ),
//                 child: IntrinsicHeight(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       Container(
//                         height: 4.5,
//                         width: 75,
//                         decoration: BoxDecoration(
//                           color: AppColors.azureishWhite,
//                           borderRadius: BorderRadius.circular(80),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       const Spacer(),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           minimumSize: const Size.fromHeight(52),
//                           backgroundColor: AppColors.orangeRed,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(25),
//                           ),
//                         ),
//                         onPressed: () {},
//                         child: const Text('Cancel'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
