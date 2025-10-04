import 'package:flutter/material.dart';

class ThemeFilterDialog extends StatefulWidget {
  final List<String> availableThemes;
  final List<String> selectedThemes;

  const ThemeFilterDialog({
    super.key,
    required this.availableThemes,
    required this.selectedThemes,
  });

  @override
  State<ThemeFilterDialog> createState() => _ThemeFilterDialogState();
}

class _ThemeFilterDialogState extends State<ThemeFilterDialog> {
  late List<String> _selectedThemes;

  @override
  void initState() {
    super.initState();
    _selectedThemes = List.from(widget.selectedThemes);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filtrar por pregações'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.availableThemes.length,
          itemBuilder: (context, index) {
            final theme = widget.availableThemes[index];
            final isSelected = _selectedThemes.contains(theme);

            return CheckboxListTile(
              title: Text(theme),
              value: isSelected,
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedThemes.add(theme);
                  } else {
                    _selectedThemes.remove(theme);
                  }
                });
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              _selectedThemes.clear();
            });
          },
          child: const Text('Limpar'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_selectedThemes),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Aplicar'),
        ),
      ],
    );
  }
}
