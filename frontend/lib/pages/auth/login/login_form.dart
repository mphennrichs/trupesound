import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/auth/provider/auth_provider.dart';
import 'package:trupe_sound/pages/custom/custom_text_input.dart';
import 'package:trupe_sound/pages/custom/custom_title.dart';

class LoginForm extends HookConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final identifierController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);

    Future<void> submit() async {
      isLoading.value = true;
      errorMessage.value = null;
      try {
        await ref.read(authProvider.notifier).login(
              identifierController.text.trim(),
              passwordController.text,
            );
        if (context.mounted) context.go('/plays');
      } on DioException catch (e) {
        final errorCode = e.response?.data is Map
            ? (e.response?.data as Map)['errorCode'] as String?
            : null;
        if (context.mounted) {
          errorMessage.value = errorCode == 'INVALID_CREDENTIALS'
              ? l10n.invalidCredentials
              : l10n.genericError;
        }
      } finally {
        if (context.mounted) {
          isLoading.value = false;
        }
      }
    }

    return Container(
      width: 400,
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: AppThemes.colors.cardColor,
        borderRadius: AppThemes.borders.defaultBorderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTitle(title: l10n.loginTitle, description: l10n.loginDescription),
          AppThemes.spacings.singleSpace,
          CustomTextInput(
            title: l10n.emailOrUsernameLabel,
            exampleText: l10n.emailOrUsernameHint,
            controller: identifierController,
          ),
          AppThemes.spacings.singleSpace,
          CustomTextInput(
            title: l10n.passwordLabel,
            exampleText: l10n.passwordHint,
            controller: passwordController,
            obscureText: true,
          ),
          if (errorMessage.value != null) ...[
            AppThemes.spacings.singleSpace,
            Text(
              errorMessage.value!,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ],
          AppThemes.spacings.doubleSpace,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: AppThemes.buttons.primaryButtonStyle,
              onPressed: isLoading.value ? null : submit,
              child: isLoading.value
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.loginButton),
            ),
          ),
          AppThemes.spacings.singleSpace,
          TextButton(
            onPressed: () => context.go('/register'),
            child: Text(
              l10n.dontHaveAccount,
              style: TextStyle(color: AppThemes.colors.textColor),
            ),
          ),
        ],
      ),
    );
  }
}
