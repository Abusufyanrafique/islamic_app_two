import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_notification/Utils/Constants/AllColors.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';


class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Custom Header ──────────────────────────────────
          _buildHeader(context, appColors),

          // ── Scrollable Body ────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Intro Card
                  _buildIntroCard(appColors),

                  // Sections
                  const SizedBox(height: 8),
                  _buildSection(
                    appColors: appColors,
                    number: '01',
                    title: 'Information We Collect',
                    subsections: [
                      _SubSection(
                        icon: Icons.location_on_rounded,
                        title: 'Location Information',
                        content:
                            'With your permission, we access your device\'s GPS location solely to calculate accurate prayer times (Salah), determine the Qibla direction toward the Kaaba in Mecca, and display relevant Islamic calendar events for your region.\n\nYour location is processed locally on your device and is never stored on our servers or shared with any third party.',
                      ),
                      _SubSection(
                        icon: Icons.notifications_rounded,
                        title: 'Notification Preferences',
                        content:
                            'We collect your notification settings to send Adhan (prayer call) reminders for all five prayers (Fajr, Dhuhr, Asr, Maghrib, Isha), notify you of Islamic events such as Ramadan, Eid al-Fitr, Eid al-Adha, and deliver daily Quran verses and Dhikr reminders if enabled by you.',
                      ),
                      _SubSection(
                        icon: Icons.phone_android_rounded,
                        title: 'Device & Technical Information',
                        content:
                            'To ensure the App functions properly, we may automatically collect device model, OS version, app version number, crash reports, and general performance diagnostics. This information does not include any personally identifiable information.',
                      ),
                      _SubSection(
                        icon: Icons.person_rounded,
                        title: 'Account Information (if applicable)',
                        content:
                            'If you create an account, we may collect your display name, email address (encrypted), and profile preferences such as your preferred madhab and prayer time calculation method.',
                      ),
                    ],
                  ),

                  _buildSection(
                    appColors: appColors,
                    number: '02',
                    title: 'How We Use Your Information',
                    content:
                        'We use the information collected to deliver core App features including prayer times, Qibla direction, Quran reading, and Hadith browsing. We personalize your experience by supporting your preferred prayer calculation method, language (Urdu, Arabic, English), and notification schedule.\n\nWe also send timely reminders including Adhan alerts, Ramadan Sehr and Iftar times, and Islamic occasion notifications. We maintain and improve App performance by analyzing crash reports and usage patterns.\n\nWe will NEVER use your information for purposes unrelated to the operation or improvement of this application.',
                  ),

                  _buildSection(
                    appColors: appColors,
                    number: '03',
                    title: 'Data Storage & Security',
                    content:
                        'We take the protection of your personal data very seriously and implement the following security measures:',
                    bulletPoints: [
                      'All data transmitted is encrypted using SSL/TLS protocols.',
                      'Account passwords are stored using bcrypt hashing — plain-text passwords are never retained.',
                      'Access to user data on our servers is restricted to authorized personnel only.',
                      'We conduct periodic security reviews to address potential vulnerabilities.',
                      'Your location data is processed entirely on your device and never uploaded to our servers.',
                    ],
                  ),

                  _buildSection(
                    appColors: appColors,
                    number: '04',
                    title: 'Third-Party Services',
                    content:
                        'To provide a reliable experience, the App may integrate with the following third-party services:',
                    thirdPartyServices: [
                      _ThirdParty('Google Play Services', 'App distribution & updates (Android)'),
                      _ThirdParty('Apple App Store', 'App distribution & updates (iOS)'),
                      _ThirdParty('Firebase (Google)', 'Crash reporting & performance monitoring'),
                      _ThirdParty('Google AdMob', 'In-app advertising (if enabled)'),
                    ],
                  ),

                  _buildSection(
                    appColors: appColors,
                    number: '05',
                    title: 'Children\'s Privacy',
                    content:
                        'The Islamic App is suitable for users of all ages; however, we do not knowingly collect personal data from children under the age of 13.\n\nIf you are a parent or guardian and believe your child has provided personal information without your consent, please contact us immediately at contact@example.com. We will promptly investigate and delete any such information from our records.',
                  ),

                  _buildSection(
                    appColors: appColors,
                    number: '06',
                    title: 'Your Rights & Choices',
                    content: 'Depending on your location, you have the following rights:',
                    bulletPoints: [
                      'Right to Access: Request a copy of your personal data.',
                      'Right to Correction: Request correction of inaccurate information.',
                      'Right to Deletion: Request deletion of your personal data at any time.',
                      'Right to Withdraw Consent: Disable location/notifications via device Settings → Apps → Islamic App → Permissions.',
                      'Right to Data Portability: Request your data in a portable format.',
                      'Right to Object: Object to certain types of data processing.',
                    ],
                  ),

                  _buildSection(
                    appColors: appColors,
                    number: '07',
                    title: 'Data Retention',
                    content: 'We retain your personal data only as long as necessary:',
                    bulletPoints: [
                      'Account data: Retained during your account lifetime, deleted within 30 days of account deletion.',
                      'Crash logs & performance data: Retained for up to 90 days for debugging.',
                      'Location data: Not retained — processed in real time and discarded immediately.',
                    ],
                  ),

                  _buildSection(
                    appColors: appColors,
                    number: '08',
                    title: 'International Data Transfers',
                    content:
                        'If you are accessing the App from outside the country where our servers are located, please be aware that your data may be transferred internationally. We ensure that any such transfers comply with applicable data protection laws and have appropriate safeguards in place.',
                  ),

                  // Islamic Commitment Card
                  _buildIslamicCard(appColors),

                  _buildSection(
                    appColors: appColors,
                    number: '10',
                    title: 'Changes to This Policy',
                    content:
                        'We may update this Privacy Policy from time to time to reflect changes in our practices, technology, or legal requirements. When we make significant changes, we will:',
                    bulletPoints: [
                      'Update the "Last Updated" date at the top of this page.',
                      'Display an in-app notification informing you of the update.',
                      'Where required by law, seek your renewed consent.',
                    ],
                  ),

                  // Contact Card
                  _buildContactCard(appColors),

                  // Footer
                  _buildFooter(appColors),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────
Widget _buildHeader(BuildContext context, AppColors appColors) {
  return Container(
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Color(0xFF6B7678),
          width: 0.12,
        ),
      ),
    ),
    child: SafeArea(
      bottom: false,
      child: SizedBox(
        height: getHeight(60),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),

            Expanded(
              child: Center(
                child: Text(
                  'Privacy Policy',
                  style: appColors.customTextStyleBold16(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Title ko perfectly center rakhne ke liye
             SizedBox(width: getWidth(48)),
          ],
        ),
      ),
    ),
  );
}

  // ── Intro Card ──────────────────────────────────────────────
  Widget _buildIntroCard(AppColors appColors) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F9F9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.shield_rounded,
              color: AppColors.primaryColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Privacy Matters to Us',
                  style: appColors.customTextStyleBold16(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Welcome to Islamic App by Developer. This Privacy Policy clearly explains how we collect, use, store, and protect your personal information in accordance with GDPR, CCPA, and our Islamic values of trust (Amanah).',
                  style: appColors.customTextStyle12(
                    color: AppColors.textBlackColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Generic Section Builder ─────────────────────────────────
  Widget _buildSection({
    required AppColors appColors,
    required String number,
    required String title,
    String? content,
    List<String>? bulletPoints,
    List<_SubSection>? subsections,
    List<_ThirdParty>? thirdPartyServices,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FEFE),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.primaryColor.withOpacity(0.15),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    number,
                    style: appColors.customTextStyleBold10(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: appColors.customTextStyleBold16(
                      color: AppColors.textBlackColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (content != null)
                  Text(
                    content,
                    style: appColors.customTextStyle14(
                      color: const Color(0xFF555555),
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                if (bulletPoints != null) ...[
                  const SizedBox(height: 10),
                  ...bulletPoints.map(
                    (point) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              point,
                              style: appColors.customTextStyle14(
                                color: const Color(0xFF555555),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                if (subsections != null)
                  ...subsections.map((sub) => _buildSubSection(appColors, sub)),

                if (thirdPartyServices != null)
                  ...thirdPartyServices.map(
                    (tp) => _buildThirdPartyTile(appColors, tp),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Subsection Widget ───────────────────────────────────────
  Widget _buildSubSection(AppColors appColors, _SubSection sub) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FEFE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(sub.icon, color: AppColors.primaryColor, size: 18),
              const SizedBox(width: 8),
              Text(
                sub.title,
                style: appColors.customTextStyle15(
                  color: AppColors.textBlackColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            sub.content,
            style: appColors.customTextStyle12(
              color: const Color(0xFF666666),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  // ── Third Party Tile ────────────────────────────────────────
  Widget _buildThirdPartyTile(AppColors appColors, _ThirdParty tp) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.link_rounded,
              color: AppColors.primaryColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tp.name,
                  style: appColors.customTextStyle14(
                    color: AppColors.textBlackColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  tp.purpose,
                  style: appColors.customTextStyle12(
                    color: AppColors.lighttextcolor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: AppColors.lighttextcolor,
          ),
        ],
      ),
    );
  }

  // ── Islamic Commitment Card ─────────────────────────────────
  Widget _buildIslamicCard(AppColors appColors) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor,
            AppColors.labbaik,
          ],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('☪️', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Text(
                '09. Our Islamic Commitment',
                style: appColors.customTextStyleBold16(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '"The trustworthy merchant will be with the prophets, the truthful, and the martyrs."\n\n— Prophet Muhammad ﷺ (Tirmidhi)',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                height: 1.6,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'As a team inspired by Islamic principles, we hold ourselves to the highest standard of honesty and trustworthiness (Amanah). We view the protection of your data not merely as a legal obligation, but as a religious and moral duty.',
            style: appColors.customTextStyle12(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  // ── Contact Card ────────────────────────────────────────────
  Widget _buildContactCard(AppColors appColors) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FEFE),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.primaryColor.withOpacity(0.15),
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '11',
                    style: appColors.customTextStyleBold10(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Contact Us',
                  style: appColors.customTextStyleBold16(
                    color: AppColors.textBlackColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildContactTile(
                  appColors,
                  Icons.business_rounded,
                  'Developer / Organization',
                  'Developer',
                ),
                const SizedBox(height: 10),
                _buildContactTile(
                  appColors,
                  Icons.email_rounded,
                  'Email',
                  'contact@example.com',
                ),
                const SizedBox(height: 10),
                _buildContactTile(
                  appColors,
                  Icons.language_rounded,
                  'Website',
                  'www.example.com',
                ),
                const SizedBox(height: 10),
                _buildContactTile(
                  appColors,
                  Icons.timer_rounded,
                  'Response Time',
                  '5–7 business days',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile(
    AppColors appColors,
    IconData icon,
    String label,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FEFE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: appColors.customTextStyle12(
                  color: AppColors.lighttextcolor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                value,
                style: appColors.customTextStyle14(
                  color: AppColors.textBlackColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Footer ──────────────────────────────────────────────────
  Widget _buildFooter(AppColors appColors) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const Divider(color: Color(0xFFEEEEEE)),
          const SizedBox(height: 12),
          Text(
            'جزاكم الله خيرًا',
            style: GoogleFonts.amiri(
              fontSize: 20,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'May Allah reward you with goodness.',
            style: appColors.customTextStyle12(
              color: AppColors.lighttextcolor,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This Privacy Policy was last reviewed and approved\non 15 August 2026.',
            textAlign: TextAlign.center,
            style: appColors.customTextStyle11(
              color: AppColors.lighttextcolor,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ── Helper Data Classes ─────────────────────────────────────
class _SubSection {
  final IconData icon;
  final String title;
  final String content;
  const _SubSection({
    required this.icon,
    required this.title,
    required this.content,
  });
}

class _ThirdParty {
  final String name;
  final String purpose;
  const _ThirdParty(this.name, this.purpose);
}