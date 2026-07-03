import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_disclaimer.dart';
import '../../shared/widgets/elite_screen_background.dart';
import '../../shared/widgets/premium_button.dart';
import '../../shared/widgets/premium_plane_marker.dart';

class DemoLoginScreen extends StatefulWidget {
  const DemoLoginScreen({super.key});

  @override
  State<DemoLoginScreen> createState() => _DemoLoginScreenState();
}

class _DemoLoginScreenState extends State<DemoLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _codeController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: AppStrings.loginDemoEmail);
    _codeController = TextEditingController(text: AppStrings.loginDemoCode);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _fillDemoCredentials() {
    _emailController.text = AppStrings.loginDemoEmail;
    _codeController.text = AppStrings.loginDemoCode;
    _formKey.currentState?.validate();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false) || _isSubmitting) {
      return;
    }

    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 360));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final compact = size.height < 720;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const EliteScreenBackground(
            redGlowFraction: 0.58,
            redGlowAlpha: 0.18,
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    compact ? AppSpacing.md : AppSpacing.lg,
                    compact ? AppSpacing.md : AppSpacing.xl,
                    compact ? AppSpacing.md : AppSpacing.lg,
                    AppSpacing.md,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight:
                          constraints.maxHeight -
                          (compact ? AppSpacing.xl : AppSpacing.xxl),
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 430),
                        child: Column(
                          mainAxisAlignment: compact
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _LoginBrandHeader(compact: compact),
                            SizedBox(
                              height: compact ? AppSpacing.md : AppSpacing.xl,
                            ),
                            _AccessPanel(
                              formKey: _formKey,
                              emailController: _emailController,
                              codeController: _codeController,
                              compact: compact,
                              onSubmit: _submit,
                              onFillDemo: _fillDemoCredentials,
                            ),
                            SizedBox(
                              height: compact ? AppSpacing.md : AppSpacing.lg,
                            ),
                            const AppDisclaimer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginBrandHeader extends StatelessWidget {
  const _LoginBrandHeader({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: compact ? 58 : 82,
          height: compact ? 58 : 82,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.softRed, AppColors.airlineRed],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.13)),
            boxShadow: [
              BoxShadow(
                color: AppColors.airlineRed.withValues(alpha: 0.32),
                blurRadius: 34,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: PremiumPlaneMarker(
            size: compact ? 26 : 35,
            rotation: -0.08,
            variant: PlaneMarkerVariant.route,
            color: Colors.white,
            glow: false,
          ),
        ),
        SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),
        Text(
          AppStrings.loginTitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.display.copyWith(
            fontSize: compact ? 27 : 34,
            height: 1.04,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          AppStrings.loginSubtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            color: Colors.white.withValues(alpha: 0.62),
            fontSize: compact ? 13 : 14,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _AccessPanel extends StatelessWidget {
  const _AccessPanel({
    required this.formKey,
    required this.emailController,
    required this.codeController,
    required this.compact,
    required this.onSubmit,
    required this.onFillDemo,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController codeController;
  final bool compact;
  final VoidCallback onSubmit;
  final VoidCallback onFillDemo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 14 : AppSpacing.lg,
        vertical: compact ? AppSpacing.md : AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.055),
        borderRadius: AppRadius.xlRadius,
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.34),
            blurRadius: 34,
            offset: const Offset(0, 18),
          ),
          BoxShadow(
            color: AppColors.airlineRed.withValues(alpha: 0.10),
            blurRadius: 32,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const _AccessIdentityRow(),
            SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),
            _DemoTextField(
              controller: emailController,
              label: AppStrings.loginEmailLabel,
              icon: Icons.alternate_email_rounded,
              compact: compact,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? AppStrings.loginEmailError
                  : null,
            ),
            SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
            _DemoTextField(
              controller: codeController,
              label: AppStrings.loginCodeLabel,
              icon: Icons.confirmation_number_outlined,
              compact: compact,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.done,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9-]')),
                _UppercaseInputFormatter(),
              ],
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? AppStrings.loginCodeError
                  : null,
              onFieldSubmitted: (_) => onSubmit(),
            ),
            SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),
            PremiumButton(
              label: AppStrings.loginPrimaryCta,
              icon: compact ? null : Icons.arrow_forward_rounded,
              onPressed: onSubmit,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton.icon(
              onPressed: onFillDemo,
              icon: const Icon(Icons.auto_awesome_rounded, size: 17),
              label: const Text(AppStrings.loginFillDemo),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white.withValues(alpha: 0.74),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              ),
            ),
            if (!compact) ...[
              const SizedBox(height: AppSpacing.sm),
              const _AccessStats(),
            ],
          ],
        ),
      ),
    );
  }
}

class _AccessIdentityRow extends StatelessWidget {
  const _AccessIdentityRow();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 330;
        final profile = Row(
          children: [
            const _AvatarMark(),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.loginProfileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.subtitle.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppStrings.loginProfileTier,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white.withValues(alpha: 0.50),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              profile,
              const SizedBox(height: AppSpacing.sm),
              const _ReadyPill(),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: profile),
            const SizedBox(width: AppSpacing.sm),
            const _ReadyPill(),
          ],
        );
      },
    );
  }
}

class _AvatarMark extends StatelessWidget {
  const _AvatarMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.airlineRed.withValues(alpha: 0.18),
        border: Border.all(color: AppColors.softRed.withValues(alpha: 0.32)),
      ),
      child: Text(
        'EÖ',
        style: AppTextStyles.subtitle.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ReadyPill extends StatelessWidget {
  const _ReadyPill();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppStrings.loginStatusReady,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.airlineRed.withValues(alpha: 0.12),
          borderRadius: AppRadius.pillRadius,
          border: Border.all(color: AppColors.softRed.withValues(alpha: 0.22)),
        ),
        child: Text(
          'HAZIR',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.softRed,
            fontSize: 9.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

class _DemoTextField extends StatelessWidget {
  const _DemoTextField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.compact,
    required this.validator,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool compact;
  final FormFieldValidator<String> validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      cursorColor: AppColors.softRed,
      style: AppTextStyles.subtitle.copyWith(
        color: Colors.white,
        fontSize: compact ? 15 : 16,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.caption.copyWith(
          color: Colors.white.withValues(alpha: 0.48),
          fontWeight: FontWeight.w700,
          letterSpacing: 0.7,
        ),
        prefixIcon: Icon(icon, color: Colors.white.withValues(alpha: 0.56)),
        filled: true,
        fillColor: Colors.black.withValues(alpha: 0.16),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: compact ? 13 : 17,
        ),
        errorStyle: AppTextStyles.caption.copyWith(color: AppColors.softRed),
        enabledBorder: _fieldBorder(Colors.white.withValues(alpha: 0.10)),
        focusedBorder: _fieldBorder(AppColors.softRed.withValues(alpha: 0.58)),
        errorBorder: _fieldBorder(AppColors.softRed.withValues(alpha: 0.62)),
        focusedErrorBorder: _fieldBorder(AppColors.softRed),
      ),
    );
  }

  OutlineInputBorder _fieldBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: AppRadius.lgRadius,
      borderSide: BorderSide(color: color),
    );
  }
}

class _AccessStats extends StatelessWidget {
  const _AccessStats();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: _StatBlock(label: 'UÇUŞ', value: 'AV 1821'),
        ),
        _DividerDot(color: Colors.white.withValues(alpha: 0.18)),
        const Expanded(
          child: _StatBlock(label: 'KOLTUK', value: '12A'),
        ),
        _DividerDot(color: Colors.white.withValues(alpha: 0.18)),
        const Expanded(
          child: _StatBlock(label: 'DURUM', value: 'ONAYLI'),
        ),
      ],
    );
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.36),
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.78),
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _DividerDot extends StatelessWidget {
  const _DividerDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      color: color,
    );
  }
}

class _UppercaseInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
