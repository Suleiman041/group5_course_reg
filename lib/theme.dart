import 'package:flutter/material.dart';

/// Apple-inspired design system. All colours and shared widgets live here,
/// so the whole app's look can be changed from this one file.
/// Colours follow Apple's iOS system palette.
const Color accent = Color(0xFF007AFF);     // iOS system blue
const Color success = Color(0xFF34C759);    // iOS green
const Color warning = Color(0xFFFF9500);    // iOS orange
const Color danger = Color(0xFFFF3B30);     // iOS red
const Color background = Color(0xFFF2F2F7); // iOS grouped background
const Color label = Color(0xFF1C1C1E);      // main text
const Color secondaryLabel = Color(0xFF8E8E93);
const Color separator = Color(0xFFE5E5EA);

/// Path of the BUK logo. Change it here if the file name changes.
const String logoPath = 'assets/buk_logo.jpg';

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: accent, primary: accent),
    scaffoldBackgroundColor: background,
  );
}

/// Flat, borderless top bar like iOS.
AppBar appleAppBar(String title, {List<Widget>? actions}) {
  return AppBar(
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
    centerTitle: true,
    backgroundColor: background,
    surfaceTintColor: Colors.transparent,
    foregroundColor: accent,
    elevation: 0,
    actions: actions,
  );
}

/// Big bold page title, like the "Large Title" in iOS apps.
class LargeTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  const LargeTitle(this.title, {super.key, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 32, fontWeight: FontWeight.bold, color: label, letterSpacing: -0.5)),
          if (subtitle != null)
            Text(subtitle!, style: const TextStyle(fontSize: 15, color: secondaryLabel)),
        ],
      ),
    );
  }
}

/// Small grey heading above a group of rows, like iOS Settings.
class SectionHeader extends StatelessWidget {
  final String text;
  const SectionHeader(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 6),
        child: Text(text.toUpperCase(),
            style: const TextStyle(fontSize: 13, color: secondaryLabel, letterSpacing: 0.3)),
      );
}

/// White rounded card that groups content, like an iOS inset grouped list.
class GroupCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const GroupCard({super.key, required this.child, this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: padding,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: child,
      );
}

/// Clean text box with no outline, used inside a GroupCard.
InputDecoration fieldStyle(String label, IconData icon) {
  return InputDecoration(
    hintText: label,
    hintStyle: const TextStyle(color: secondaryLabel),
    prefixIcon: Icon(icon, color: secondaryLabel, size: 20),
    border: InputBorder.none,
    contentPadding: const EdgeInsets.symmetric(vertical: 16),
  );
}

/// Thin divider between rows inside a GroupCard.
const Widget rowDivider = Divider(height: 1, thickness: 1, indent: 52, color: separator);

/// Big blue rounded button for the main action on a screen.
ButtonStyle primaryButton() => FilledButton.styleFrom(
      backgroundColor: accent,
      foregroundColor: Colors.white,
      minimumSize: const Size.fromHeight(52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
    );

/// The BUK logo in a white circle with a soft shadow.
/// Falls back to a school icon if the file is missing.
class LogoBadge extends StatelessWidget {
  final double size;
  const LogoBadge({super.key, this.size = 84});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Color(0x22000000), blurRadius: 18, offset: Offset(0, 6))],
      ),
      child: ClipOval(
        child: Image.asset(
          logoPath,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(Icons.school, size: size * 0.6, color: accent),
        ),
      ),
    );
  }
}
