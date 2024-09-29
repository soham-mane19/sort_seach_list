import 'package:comment_sort_search/home.dart';
import 'package:flutter/material.dart'; 
import 'package:google_fonts/google_fonts.dart'; // Importing Google Fonts package for custom fonts


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State createState() => SplashScreenState(); 
}


class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController controller; // Animation controller to manage the animation
  late Animation<Offset> animation; // Animation for slide transition

  @override
  void initState() {
    super.initState(); 

    // Initializing the animation controller with a duration of 2 seconds
    controller = AnimationController(
      vsync: this, 
      duration: const Duration(seconds: 2), 
    );

    // Defining the animation to slide from the bottom to the center
    animation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), 
      end: const Offset(0.0, 0.0),   
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut), // Applying a curve to the animation
    );

    controller.forward(); // Start the animation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20), // Adding padding around the content
        child: Column(
          children: [
            Expanded(
            
              child: SlideTransition(
                position: animation, // Applying the animation to the logo
                child: Image.asset(
                  'assets/splashlogo.png', 
                  height: MediaQuery.of(context).size.height * 0.4, 
                  width: double.infinity, 
                ),
              ),
            ),
            // Elevated button to navigate to the HomeScreen
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blueAccent), // Button background color
                minimumSize: WidgetStatePropertyAll(Size(double.infinity, 50)), // Minimum button size
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) {
                    return const HomeScreen(); // Navigating to HomeScreen on button press
                  },
                ));
              },
              child: Text(
                "Continue",
                style: GoogleFonts.poppins(
                  fontSize: 30, 
                  fontWeight: FontWeight.w600, 
                  color: Colors.white, 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
