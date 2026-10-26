import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_providers.dart';
import '../../app/theme/app_colors.dart';
import '../../core/notifications/notification_permission_service.dart';
import '../../shared/widgets/bunny_mascot.dart';
import 'legal_document_page.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _usernameController = TextEditingController();
  bool _accepted = false;
  int _step = 0;
  bool _saving = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (_step == 0) {
      if (!_accepted) return;
      setState(() => _step = 1);
      return;
    }
    if (_step == 1) {
      if (_usernameController.text.trim().isEmpty ||
          _usernameController.text.trim().length > 40) return;
      setState(() => _step = 2);
      return;
    }
    setState(() => _saving = true);
    await ref.read(notificationPermissionServiceProvider).requestAll();
    try {
      await ref
          .read(preferencesStoreProvider)
          .completeOnboarding(username: _usernameController.text.trim());
      if (mounted) context.go('/home');
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('We could not save your profile yet. Please try again.')));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
            child: Column(
              children: [
                Expanded(
                    child: _step == 0
                        ? _terms(context)
                        : _step == 1
                            ? _username(context)
                            : _notifications(context)),
                _button()
              ],
            ),
          ),
        ),
      );

  Widget _button() => FilledButton(
        onPressed: _saving ? null : _continue,
        style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            backgroundColor: AppColors.strawberryPink,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            padding: const EdgeInsets.symmetric(horizontal: 22)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(_step == 2 ? 'Continue to RoutineBunny' : 'Continue'),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, size: 18)
        ]),
      );

  Widget _terms(BuildContext context) => Column(children: [
        const SizedBox(height: 8),
        const Text('Welcome to',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.cocoaBrown)),
        const SizedBox(height: 2),
        const Text('RoutineBunny',
            style: TextStyle(
                fontSize: 27,
                height: .95,
                fontWeight: FontWeight.w900,
                color: AppColors.rosePink)),
        const SizedBox(height: 8),
        const Text('Your little space for a more\nconsistent, happier you ♡',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 11, height: 1.35, color: AppColors.cocoaBrown)),
        const SizedBox(height: 2),
        const BunnyMascot(size: 154, expression: 'happy'),
        Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: AppColors.borderPink)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 8, 7),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Terms of Use',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              const Text(
                  'Please read and accept our Terms of Use to continue. By using this app, you agree to our Terms of Use and Privacy Policy.',
                  style: TextStyle(fontSize: 13, height: 1.45)),
              const SizedBox(height: 10),
              _legalRow(context, Icons.description_outlined, 'Terms of Use',
                  LegalDocumentPage.terms),
              const Divider(height: 1, color: AppColors.borderPink),
              _legalRow(context, Icons.lock_outline, 'Privacy Policy',
                  LegalDocumentPage.privacy),
              CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  visualDensity:
                      const VisualDensity(horizontal: -4, vertical: -4),
                  value: _accepted,
                  onChanged: (value) =>
                      setState(() => _accepted = value ?? false),
                  title: const Text(
                      'I have read and agree to the Terms of Use and Privacy Policy.',
                      style: TextStyle(fontSize: 12, height: 1.3)),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppColors.rosePink),
            ]),
          ),
        ),
      ]);

  Widget _legalRow(BuildContext context, IconData icon, String title,
          List<(String, String)> sections) =>
      SizedBox(
        height: 35,
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          leading: Icon(icon, size: 15, color: AppColors.cocoaBrown),
          title: Text(title,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          trailing: const Icon(Icons.chevron_right,
              size: 17, color: AppColors.rosePink),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) =>
                  LegalDocumentPage(title: title, sections: sections))),
        ),
      );

  Widget _username(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
                onPressed: () => setState(() => _step = 0),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.chevron_left,
                    size: 24, color: AppColors.cocoaBrown))),
        const SizedBox(height: 24),
        Text("Let's get to know you! ♡",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800, color: AppColors.cocoaBrown)),
        const SizedBox(height: 11),
        const Text('What should we call you?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: AppColors.cocoaBrown)),
        const SizedBox(height: 21),
        SizedBox(
            height: 55,
            child: TextField(
                controller: _usernameController,
                maxLength: 40,
                autofocus: true,
                style:
                    const TextStyle(fontSize: 13, color: AppColors.cocoaBrown),
                decoration: const InputDecoration(
                    counterText: '',
                    labelText: 'Username',
                    labelStyle:
                        TextStyle(fontSize: 10, color: AppColors.mutedBrown),
                    hintText: 'Luna',
                    hintStyle: TextStyle(fontSize: 13),
                    contentPadding: EdgeInsets.fromLTRB(14, 7, 14, 7)))),
        Expanded(
            child: Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
              const Padding(
                  padding: EdgeInsets.only(bottom: 2),
                  child: BunnyMascot(size: 196, expression: 'encouraging')),
              Positioned(
                  right: 0,
                  bottom: 110,
                  child: Container(
                      width: 104,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 12),
                      decoration: BoxDecoration(
                          color: AppColors.softWhite,
                          border: Border.all(color: AppColors.borderPink),
                          borderRadius: BorderRadius.circular(50)),
                      child: const Text('A cute name\nfor your\nnew journey! ♡',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 10,
                              height: 1.3,
                              color: AppColors.cocoaBrown)))),
            ])),
      ]);

  Widget _notifications(BuildContext context) => ListView(children: [
        const SizedBox(height: 32),
        Row(children: [
          IconButton(
              onPressed: () => setState(() => _step = 1),
              icon: const Icon(Icons.chevron_left)),
          const Spacer(),
          const Text('3 of 3', style: TextStyle(color: AppColors.mutedBrown)),
          const Spacer(),
          const SizedBox(width: 48)
        ]),
        const SizedBox(height: 34),
        const BunnyMascot(size: 160, expression: 'encouraging'),
        const SizedBox(height: 18),
        Text('Gentle reminders, when you need them',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        const Text(
            'RoutineBunny can send ordinary notifications and, when you choose, alarm-like reminders for scheduled activities.',
            textAlign: TextAlign.center),
        const SizedBox(height: 20),
        const Card(
            child: Padding(
                padding: EdgeInsets.all(18),
                child: Text(
                    'Android may ask for notification and exact-alarm permissions. You can decline and enable them later in Settings; your routines will remain available.'))),
      ]);
}
