import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_app/blocs/vendor/vendor_bloc.dart';
import 'package:event_app/blocs/vendor/vendor_event.dart';
import 'package:event_app/blocs/vendor/vendor_state.dart';
import 'package:event_app/models/vendor_model.dart';
import 'package:event_app/repositories/vendor_repository.dart';

class VendorItemsScreen extends StatelessWidget {
  final String userId; // ✅ Accept userId from VendorDashboardScreen

  const VendorItemsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Debugging the userId
    print('🟢 User ID passed to VendorItemsScreen: $userId');

    return RepositoryProvider(
      create: (_) => VendorRepository(),
      child: BlocProvider(
        create: (context) {
          // Debugging the userId being passed to the event
          print('🟢 User ID passed to LoadVendorItemsByUserEvent: $userId');
          return VendorBloc(
            vendorRepository: RepositoryProvider.of<VendorRepository>(context),
          )..add(LoadVendorItemsByUserEvent(userId)); // ✅ Custom event for vendor's items
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Your Items')),
          body: BlocBuilder<VendorBloc, VendorState>(
            builder: (context, state) {
              if (state is VendorLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is VendorLoaded) {
                final List<VendorModel> posts = state.vendors;
                if (posts.isEmpty) {
                  return const Center(child: Text('No posts found.'));
                }
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return ListTile(
                      leading: post.imageUrl.isNotEmpty
                          ? Image.network(
                        post.imageUrl,
                        width: 50, // Adjust the width to fit your UI
                        height: 50, // Adjust the height to fit your UI
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error, size: 50); // Placeholder for error
                        },// Make sure the image fits properly
                      )
                          : const Icon(Icons.image), // Placeholder icon if imageUrl is empty
                      title: Text(
                        (post.businessName?.isNotEmpty ?? false)
                            ? post.businessName!
                            : (post.venueName ?? 'Unnamed Venue'),
                      ),
                      subtitle: Text(post.category),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteDialog(context, post.id);
                        },
                      ),
                      onTap: () {
                        // TODO: Navigate to edit item screen
                      },

                    );
                  },
                );
              } else if (state is VendorError) {
                return Center(child: Text('Error: ${state.message}'));
              } else {
                return const Center(child: Text('Unexpected state.'));
              }
            },
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              BlocProvider.of<VendorBloc>(context).vendorRepository.deleteVendorPost(postId);
              Navigator.of(context).pop();
              // Reload only current vendor's posts
              BlocProvider.of<VendorBloc>(context).add(LoadVendorItemsByUserEvent(userId));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
