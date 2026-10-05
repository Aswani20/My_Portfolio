import 'package:flutter/material.dart';
import 'package:portfolio_app/theme/app_theme.dart';
import 'package:portfolio_app/widgets/common/contact_form.dart';
import 'package:portfolio_app/widgets/common/contact_info_tile.dart';
import 'package:portfolio_app/widgets/common/scroll_reveal.dart';
import 'package:portfolio_app/widgets/common/section_container.dart';
import 'package:portfolio_app/widgets/common/social_icon_button.dart';
import 'package:url_launcher/url_launcher.dart';


class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  static const String heading = "Let's Talk";
  static const String subtitle =
      "Have a project in mind or just want to say hi? I'd love to hear from you.";

  // ---- Placeholder content — swap these for your real info ----
  static const String email = 'abdelrahmanyoussef511997@gmail.com';
  static const String phone = '+20 100 190 4592';
  static const String location = 'Giza, Egypt';

  static const String githubUrl = 'https://github.com/Aswani20';
  static const String linkedinUrl = 'https://www.linkedin.com/in/abdelrahman-youssef/';
  static const String whatsappUrl = 'https://wa.me/201001904592';
  // ----------------------------------------------------------------

  Future<void> _open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final useSideBySide = AppBreakpoints.isDesktop(width);
    final colors = context.colors;

    final infoColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScrollReveal(
          child: Text(
            heading,
            textAlign: TextAlign.left,
            style: AppTextStyles.h2.copyWith(color: colors.textPrimary),
          ),
        ),
        const SizedBox(height: 12),
        ScrollReveal(
          delay: const Duration(milliseconds: 80),
          child: Text(
            subtitle,
            textAlign: TextAlign.left,
            style: AppTextStyles.body.copyWith(color: colors.textSecondary),
          ),
        ),
        const SizedBox(height: 32),
        Column(
          children: [
            ScrollReveal(
              delay: const Duration(milliseconds: 140),
              scaleFrom: 0.96,
              child: ContactInfoTile(
                icon: Icons.email_outlined,
                label: 'Email',
                value: email,
                onTap: () => _open('mailto:$email'),
              ),
            ),
            const SizedBox(height: 16),
            ScrollReveal(
              delay: const Duration(milliseconds: 220),
              scaleFrom: 0.96,
              child: ContactInfoTile(
                icon: Icons.phone_outlined,
                label: 'Phone',
                value: phone,
                onTap: () => _open('tel:${phone.replaceAll(' ', '')}'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            ScrollReveal(
              delay: const Duration(milliseconds: 280),
              scaleFrom: 0.9,
              child: SocialIconButton(
                assetPath: 'assets/icons/github.svg',
                tooltip: 'GitHub',
                onTap: () => _open(githubUrl),
              ),
            ),
            ScrollReveal(
              delay: const Duration(milliseconds: 340),
              scaleFrom: 0.9,
              child: SocialIconButton(
                assetPath: 'assets/icons/linkedin.svg',
                tooltip: 'LinkedIn',
                onTap: () => _open(linkedinUrl),
              ),
            ),
            ScrollReveal(
              delay: const Duration(milliseconds: 400),
              scaleFrom: 0.9,
              child: SocialIconButton(
                assetPath: 'assets/icons/whatsapp.svg',
                tooltip: 'WhatsApp',
                onTap: () => _open(whatsappUrl),
              ),
            ),
          ],
        ),
      ],
    );

    final formColumn = ScrollReveal(
      delay: const Duration(milliseconds: 180),
      slideFrom: const Offset(24, 16),
      scaleFrom: 0.98,
      child: const ContactForm(recipientEmail: email),
    );

    return SectionContainer(
      sectionKey: const ValueKey('contact'),
      child: useSideBySide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: infoColumn),
                const SizedBox(width: 56),
                SizedBox(width: 420, child: formColumn),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                infoColumn,
                const SizedBox(height: 48),
                formColumn,
              ],
            ),
    );
  }
}
