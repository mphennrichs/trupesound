import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trupe_sound/common/app_themes.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final bool isSelectable;

  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    this.isSelectable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppThemes.spacings.singleValue),
      decoration: BoxDecoration(
        color: AppThemes.colors.cardColor,
        borderRadius: AppThemes.borders.defaultBorderRadius,
        border: Border.all(color: AppThemes.colors.borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppThemes.colors.primaryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.fingerprint,
              color: AppThemes.colors.primaryColor,
              size: 22,
            ),
          ),
          SizedBox(width: AppThemes.spacings.singleValue),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppThemes.colors.hintTextColor,
                    fontSize: AppThemes.texts.smallFontSize,
                  ),
                ),
                isSelectable
                    ? SelectableText(
                        value,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppThemes.texts.normalFontSize,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'monospace',
                        ),
                      )
                    : Text(
                        value,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppThemes.texts.normalFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppThemes.colors.hintTextColor,
                    fontSize: AppThemes.texts.smallFontSize,
                  ),
                ),
              ],
            ),
          ),
          if (isSelectable)
            _CopyButton(value: value),
        ],
      ),
    );
  }
}

class _CopyButton extends StatefulWidget {
  final String value;
  const _CopyButton({required this.value});

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.value));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _copy,
      icon: Icon(
        _copied ? Icons.check : Icons.copy_outlined,
        size: 18,
        color: _copied
            ? Colors.greenAccent
            : AppThemes.colors.hintTextColor,
      ),
      tooltip: 'Copy',
    );
  }
}
