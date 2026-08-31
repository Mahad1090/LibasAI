import 'package:flutter/material.dart';
import '../app_scope.dart';
import '../theme.dart';
import '../widgets.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 64, 28, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.22),
                      blurRadius: 26,
                      offset: const Offset(0, 12)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.asset('assets/libasai-logo.png', width: 100, height: 100, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 22),
            Text('Welcome to LibasAI', style: heading(28)),
            const SizedBox(height: 8),
            Text(
              'Your AI shopping concierge for Pakistani fashion — every brand, one place.',
              textAlign: TextAlign.center,
              style: body(14, color: AppColors.inkSecondary, height: 1.55),
            ),
            const SizedBox(height: 34),
            SizedBox(width: 300, child: PrimaryButton('Create Account', onTap: () => go(context, '/signup'))),
            const SizedBox(height: 12),
            SizedBox(width: 300, child: SecondaryButton('Sign In', onTap: () => go(context, '/signin'))),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: () => goAndReset(context, '/home'),
              child: Text('Continue as Guest',
                  style: body(13.5, weight: FontWeight.w600, color: AppColors.mutedRose)),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthScaffold extends StatelessWidget {
  final String title, subtitle;
  final List<Widget> children;
  const _AuthScaffold({required this.title, required this.subtitle, required this.children});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, kTopInset, 20, 0),
            child: GestureDetector(
              onTap: () => goBack(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(Icons.chevron_left, size: 18),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(title, style: heading(25)),
                  const SizedBox(height: 6),
                  Text(subtitle, style: body(13.5, color: AppColors.inkSecondary)),
                  const SizedBox(height: 24),
                  ...children,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label, hint;
  final bool obscure;
  const _Field(this.label, this.hint, {this.obscure = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: body(12.5, weight: FontWeight.w600)),
          const SizedBox(height: 7),
          TextField(
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: body(14, color: AppColors.inkFaint),
              filled: true,
              fillColor: AppColors.bg,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.button),
                borderSide: BorderSide(color: AppColors.border, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.button),
                borderSide: BorderSide(color: AppColors.border, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.button),
                borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return _AuthScaffold(
      title: 'Create Account',
      subtitle: 'Join LibasAI for personalized style recommendations.',
      children: [
        const _Field('Full Name', 'Ayesha Khan'),
        const _Field('Email', 'you@email.com'),
        const _Field('Password', '••••••••', obscure: true),
        const _Field('Confirm Password', '••••••••', obscure: true),
        const SizedBox(height: 9),
        PrimaryButton('Create Account', onTap: () => go(context, '/pref1')),
        const SizedBox(height: 18),
        Center(
          child: GestureDetector(
            onTap: () => go(context, '/signin'),
            child: Text.rich(TextSpan(
              text: 'Already have an account? ',
              style: body(13, color: AppColors.inkSecondary),
              children: [
                TextSpan(text: 'Sign In', style: body(13, weight: FontWeight.w700, color: AppColors.accent)),
              ],
            )),
          ),
        ),
      ],
    );
  }
}

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return _AuthScaffold(
      title: 'Welcome Back',
      subtitle: 'Sign in to continue your style journey.',
      children: [
        const _Field('Email', 'you@email.com'),
        const _Field('Password', '••••••••', obscure: true),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(value: false, onChanged: (_) {}, activeColor: AppColors.accent),
              ),
              const SizedBox(width: 7),
              Text('Remember me', style: body(12.5, color: AppColors.inkSecondary)),
            ]),
            GestureDetector(
              onTap: () => go(context, '/forgotpw'),
              child: Text('Forgot password?',
                  style: body(12.5, weight: FontWeight.w700, color: AppColors.accent)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        PrimaryButton('Sign In', onTap: () => goAndReset(context, '/home')),
        const SizedBox(height: 18),
        Center(
          child: GestureDetector(
            onTap: () => go(context, '/signup'),
            child: Text.rich(TextSpan(
              text: "Don't have an account? ",
              style: body(13, color: AppColors.inkSecondary),
              children: [
                TextSpan(
                    text: 'Create Account',
                    style: body(13, weight: FontWeight.w700, color: AppColors.accent)),
              ],
            )),
          ),
        ),
      ],
    );
  }
}

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return _AuthScaffold(
      title: 'Reset Password',
      subtitle: "Enter your email and we'll send a link to reset your password.",
      children: [
        if (state.resetSent)
          Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppColors.sand, borderRadius: BorderRadius.circular(AppRadius.card)),
            child: Column(children: [
              const Icon(Icons.check, size: 26, color: AppColors.accent),
              const SizedBox(height: 10),
              Text('Reset link sent', style: body(14.5, weight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text('Check your inbox for instructions to reset your password.',
                  textAlign: TextAlign.center, style: body(12.5, color: AppColors.inkSecondary)),
            ]),
          )
        else ...[
          const _Field('Email', 'you@email.com'),
          const SizedBox(height: 9),
          PrimaryButton('Send Reset Link', onTap: () => state.set(() => state.resetSent = true)),
        ],
      ],
    );
  }
}
