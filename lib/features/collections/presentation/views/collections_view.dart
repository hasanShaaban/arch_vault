import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../domain/entities/collection_entity.dart';
import '../manager/collections_cubit/collections_cubit.dart';
import '../manager/collections_cubit/collections_state.dart';
import 'widget/collection_card.dart';

class CollectionsView extends StatefulWidget {
  const CollectionsView({super.key});

  @override
  State<CollectionsView> createState() => _CollectionsViewState();
}

class _CollectionsViewState extends State<CollectionsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CollectionsCubit>().load();
    });
  }

  Future<void> _openEditor({CollectionEntity? collection}) async {
    final nameController = TextEditingController(text: collection?.name ?? '');
    final descriptionController =
        TextEditingController(text: collection?.description ?? '');
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.brandSecondarySurface,
          title: Text(
            collection == null ? 'New collection' : 'Edit collection',
            style: AppTextStyles.headlineSm,
          ),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                  controller: nameController,
                  hintText: 'Collection name',
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: descriptionController,
                  hintText: 'Description',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    final name = nameController.text.trim();
    final description = descriptionController.text.trim();
    nameController.dispose();
    descriptionController.dispose();

    if (result != true || !mounted || name.isEmpty) return;

    final cubit = context.read<CollectionsCubit>();
    if (collection == null) {
      await cubit.create(name: name, description: description);
    } else {
      await cubit.update(
        collection: collection,
        name: name,
        description: description,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppTopBar(),
          Expanded(
            child: BlocBuilder<CollectionsCubit, CollectionsState>(
              builder: (context, state) {
                if (state is CollectionsLoading ||
                    state is CollectionsInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is CollectionsFailureState) {
                  return AppErrorState(
                    message: state.message,
                    onRetry: () => context.read<CollectionsCubit>().load(),
                  );
                }
                if (state is! CollectionsLoaded) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.all(24),
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
                                  'My Collections',
                                  style: AppTextStyles.headlineSm,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Organize favorite models into curated sets.',
                                  style: AppTextStyles.bodyMd,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 170,
                            child: PrimaryButton(
                              label: 'New collection',
                              onPressed: () => _openEditor(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: state.collections.isEmpty
                            ? AppEmptyState(
                                icon: Icons.folder_open_outlined,
                                title: 'No collections yet',
                                message:
                                    'Create a collection to organize your favorite models.',
                                actionLabel: 'New collection',
                                onAction: () => _openEditor(),
                              )
                            : GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 340,
                                  mainAxisExtent: 240,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                                itemCount: state.collections.length,
                                itemBuilder: (context, index) {
                                  final collection =
                                      state.collections[index];
                                  return CollectionCard(
                                    collection: collection,
                                    onTap: () => context.go(
                                      AppRoutes.collectionDetailPath(
                                        collection.id,
                                      ),
                                    ),
                                    onEdit: () =>
                                        _openEditor(collection: collection),
                                    onDelete: () async {
                                      final cubit =
                                          context.read<CollectionsCubit>();
                                      final confirmed =
                                          await showDialog<bool>(
                                        context: context,
                                        builder: (dialogContext) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Delete collection?',
                                            ),
                                            content: Text(
                                              'Delete "${collection.name}"? (mock)',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(dialogContext)
                                                        .pop(false),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(dialogContext)
                                                        .pop(true),
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      if (confirmed == true) {
                                        await cubit.delete(collection.id);
                                      }
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
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
