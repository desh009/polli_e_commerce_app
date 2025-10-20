// import 'package:flutter/material.dart';

// class FooterSection extends StatelessWidget {
//   const FooterSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Container(
//         color: const Color(0xFFE6F5E6), // light green background
//         padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//         child: Column(
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Get In Touch
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Get In Touch",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Container(
//                       height: 2,
//                       width: 50,
//                       color: Colors.yellow[700],
//                       margin: const EdgeInsets.symmetric(vertical: 6),
//                     ),
//                     const Text("No dolore ipsum accusam no lorem."),
//                     const Text("123 Street, New York, USA"),
//                     const Text("exampl@example.com"),
//                     const Text("000 000 0000"),
//                   ],
//                 ),
//                 const SizedBox(width: 40),

//                 // Important Links
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Important Links",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Container(
//                       height: 2,
//                       width: 50,
//                       color: Colors.yellow[700],
//                       margin: const EdgeInsets.symmetric(vertical: 6),
//                     ),
//                     const Text("About"),
//                     const Text("Contact Us"),
//                     const Text("Privacy"),
//                     const Text(
//                       "Terms & Conditions",
//                       style: TextStyle(color: Colors.orange),
//                     ),
//                     const Text("Refund Policy"),
//                   ],
//                 ),
//                 const SizedBox(width: 40),

//                 // Logo + Social Media
//                 Column(
//                   children: [
//                     Image.asset(
//                       "assets/images/footer_logo.png",
//                       width: 100,
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.facebook, color: Colors.green[800]),
//                           onPressed: () {},
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.twitter, color: Colors.green[800]),
//                           onPressed: () {},
//                         ),
//                         IconButton(
//                           icon: Icon(
//                             Icons.camera_alt,
//                             color: Colors.green[800],
//                           ),
//                           onPressed: () {},
//                         ),
//                         IconButton(
//                           icon: Icon(
//                             Icons.linked_camera,
//                             color: Colors.green[800],
//                           ),
//                           onPressed: () {},
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),

//             const SizedBox(height: 20),

//             // Copyright
//             Container(
//               color: Colors.green[800],
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 10),
//               child: const Center(
//                 child: Text(
//                   "© Copyright 2025 Amazing Shop. All Rights Reserved",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class Fottersction extends StatefulWidget {
  const Fottersction({super.key});

  @override
  State<Fottersction> createState() => _FottersctionState();
}

class _FottersctionState extends State<Fottersction> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        color: const Color(0xFFE6F5E6),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const Text('Get In Touch'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Get In Touch',

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: 2,
                      width: 50,
                      color: Colors.yellow[700],
                      margin: const EdgeInsets.symmetric(vertical: 6),
                    ),
                    const Text('No dolore ipsum accusam no lorem,'),
                    const Text('123 Street, New York, USA'),
                    const Text('example@example.com'),
                    const Text('0000000000'),
                  ],
                ),
                const SizedBox(width: 40),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Important Links',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: 2,
                      width: 50,
                      color: Colors.yellow[700],
                      margin: const EdgeInsets.symmetric(vertical: 6),
                    ),
                    const Text('About'),
                    const Text('Contact Us'),
                    const Text('Privacy'),
                    const Text(
                      'Terms & Conditions',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
