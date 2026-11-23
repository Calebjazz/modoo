import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/outfit.dart';

enum OutfitAction { rename, duplicate, delete }

/// Result of the save dialog. [asNew] is false when updating the open outfit.
typedef OutfitSaveRequest = ({String name, bool asNew});

abstract final class OutfitDialogs {
  /// Asks for an outfit name. When [canUpdate] is true the user can choose
  /// between updating the open outfit and saving a new copy.
  static Future<OutfitSaveRequest?> save(
    BuildContext context, {
    required String initialName,
    String title = 'Save outfit',
    String confirmLabel = 'SAVE',
    bool canUpdate = false,
  }) {
    final formKey = GlobalKey<FormState>();
    var enteredName = initialName;

    void submit(BuildContext dialogContext, {required bool asNew}) {
      if (formKey.currentState!.validate()) {
        Navigator.pop<OutfitSaveRequest>(dialogContext, (
          name: enteredName.trim(),
          asNew: asNew,
        ));
      }
    }

    return showDialog<OutfitSaveRequest>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Form(
          key: formKey,
          child: TextFormField(
            initialValue: initialName,
            onChanged: (value) => enteredName = value,
            autofocus: true,
            maxLength: 40,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Outfit name'),
            validator: (value) =>
                value == null || value.trim().isEmpty ? 'Enter a name' : null,
            onFieldSubmitted: (_) => submit(dialogContext, asNew: !canUpdate),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('CANCEL'),
          ),
          if (canUpdate)
            TextButton(
              onPressed: () => submit(dialogContext, asNew: true),
              child: const Text('SAVE AS NEW'),
            ),
          FilledButton(
            onPressed: () => submit(dialogContext, asNew: !canUpdate),
            child: Text(canUpdate ? 'UPDATE' : confirmLabel),
          ),
        ],
      ),
    );
  }

  static Future<bool> confirmDelete(BuildContext context, Outfit outfit) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete outfit'),
        content: Text('Delete "${outfit.name}" from your saved looks?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  static Future<OutfitAction?> options(BuildContext context, Outfit outfit) =>
      showModalBottomSheet<OutfitAction>(
        context: context,
        backgroundColor: AppColors.white,
        showDragHandle: true,
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Text(
                  outfit.name.toUpperCase(),
                  style: AppTextStyles.label,
                ),
              ),
              if (!outfit.isCurated)
                _option(
                  context,
                  Icons.edit_outlined,
                  'Rename',
                  OutfitAction.rename,
                ),
              _option(
                context,
                Icons.copy_rounded,
                outfit.isCurated ? 'Save copy to my looks' : 'Duplicate',
                OutfitAction.duplicate,
              ),
              if (!outfit.isCurated)
                _option(
                  context,
                  Icons.delete_outline_rounded,
                  'Delete',
                  OutfitAction.delete,
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );

  static Widget _option(
    BuildContext context,
    IconData icon,
    String label,
    OutfitAction action,
  ) => ListTile(
    leading: Icon(icon, color: AppColors.black),
    title: Text(label, style: AppTextStyles.tileTitle),
    onTap: () => Navigator.pop(context, action),
  );
}
