import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoFillix extends StatelessWidget {
  final double fontSize;

  const LogoFillix({super.key, this.fontSize = 32});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Fillix",
      style: GoogleFonts.montserrat(
        textStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold, // Montserrat Bold
          color: const Color(0xFFC29B38), // Warna emas solid sesuai instruksi
          backgroundColor: Colors.transparent, // Transparan agar fleksibel ditaruh di mana saja
          letterSpacing: -1.0, // Dibuat lebih rapat agar solid dan premium
        ),
      ),
    );
  }
}
