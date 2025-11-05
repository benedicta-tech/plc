import 'package:flutter/material.dart';
import 'package:plc/theme/spacing.dart';

class CorePage extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const CorePage(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.white,
          forceMaterialTransparency: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.only(
                left: mediumSpacing,
                right: mediumSpacing,
                bottom: mediumSpacing,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(
                                context,
                              ).textTheme.headlineSmall?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              subtitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: smallSpacing),
                            // SearchPreachersBar(inSearch: inSearch),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(child: child)
            // chil
          ],
        ));
  }
}
