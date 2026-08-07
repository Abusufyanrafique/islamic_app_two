





/// Determines media type string from file path
String _getMediaType(String path, {bool? isVideo}) {
  if (isVideo != null) return isVideo ? 'video' : 'image';
  final lower = path.toLowerCase();
  if (lower.endsWith('.mp4') || lower.endsWith('.mov') || lower.endsWith('.avi')) {
    return 'video';
  } else if (lower.endsWith('.mp3') || lower.endsWith('.ogg') || lower.endsWith('.opus')) {
    return 'audio';
  }
  return 'image';
}

// /// Saves any media (image/video/audio) permanently to local storage + Hive DB
// Future<void> saveMedia(
//     BuildContext context,
//     String originalPath, {
//       bool? isVideo,   // pass true for video, false for image, null for audio (auto-detect)
//       bool isAudio = false, // explicit audio flag
//     }) async
// {
//   try {
//     final newPath = await saveFilePermanently(originalPath);
//
//     if (newPath == null) {
//       debugPrint("Save failed ❌ - could not copy file");
//       if (context.mounted) {
//         showAppSnackBar(
//       context: context,
//       title: 'Failed',
//       message:"Save failed ❌",
//           contentType: ContentType.failure,
//     );
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   const SnackBar(content: Text("Save failed ❌")),
//         // );
//       }
//       return;
//     }
//
//     final box = Hive.box<SavedItem>('saved_items');
//
//     // Duplicate check — don't save same file twice
//     final alreadyExists = box.values.any((item) => item.path == newPath);
//
//     if (!alreadyExists) {
//       // Determine type
//       String type;
//       if (isAudio) {
//         type = 'audio';
//       } else if (isVideo != null) {
//         type = isVideo ? 'video' : 'image';
//       } else {
//         type = _getMediaType(originalPath);
//       }
//
//       await box.add(SavedItem(
//         path: newPath,
//         type: type,
//         dateTime: DateTime.now(),
//       ));
//
//       debugPrint("Saved ✅ type=$type path=$newPath");
//
//       if (context.mounted) {
//         showAppSnackBar(
//           context: context,
//           title: "Saved",
//           message:"${type[0].toUpperCase()}${type.substring(1)} Saved ✅",
//           contentType: ContentType.success,
//         );
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   SnackBar(content: Text("${type[0].toUpperCase()}${
//         //   type.substring(1)} Saved ✅")),
//         // );
//       }
//     } else {
//       debugPrint("Already saved ⚠️");
//       if (context.mounted) {
//         showAppSnackBar(
//           context: context,
//           title: "Saved",
//           message:"Already saved ⚠️",
//           contentType: ContentType.warning,
//         );
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   const SnackBar(content: Text("Already saved ⚠️")),
//         // );
//       }
//     }
//   } catch (e) {
//     debugPrint("Save error: $e");
//     if (context.mounted) {
//
//       showAppSnackBar(
//         context: context,
//         title: 'Failed',
//         message:"Error: $e",
//         contentType: ContentType.failure,
//       );
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   SnackBar(content: Text("Error: $e")),
//       // );
//     }
//   }
// }
//
// Future<void> deleteItem(BuildContext context, String path,
//     {bool deleteFromDisk = true}) async
// {
//   // Show confirmation dialog first
//   final bool? confirmed = await showDialog<bool>(
//     context: context,
//     builder: (ctx) => AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       title: const Text(
//         "Delete File",
//         style: TextStyle(fontWeight: FontWeight.bold),
//       ),
//       content: const Text("Are you sure you want to delete this file?"),
//       actions: [
//         // Cancel button
//         TextButton(
//           onPressed: () => Navigator.pop(ctx, false),
//           child: const Text(
//             "Cancel",
//             style: TextStyle(color: Colors.grey),
//           ),
//         ),
//         // Confirm/Delete button
//         ElevatedButton(
//           onPressed: () => Navigator.pop(ctx, true),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.red,
//             foregroundColor: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           child: const Text("Delete"),
//         ),
//       ],
//     ),
//   );
//
//   // User pressed Cancel or dismissed dialog
//   if (confirmed != true) return;
//
//   try {
//     // Delete from disk
//     if (deleteFromDisk) {
//       final file = File(path);
//       if (await file.exists()) {
//         await file.delete();
//         debugPrint("File deleted from disk ✅");
//       }
//     }
//
//     // Delete from Hive
//     final box = Hive.box<SavedItem>('saved_items');
//     final item = box.values.firstWhere(
//           (element) => element.path == path,
//       orElse: () => throw Exception("Item not found in DB"),
//     );
//     await item.delete();
//     debugPrint("Deleted from Hive ✅");
//
//     if (context.mounted) {
//       showAppSnackBar(
//         context: context,
//         title: "Deleted",
//         message: "Successfully Deleted ✅",
//         contentType: ContentType.success,
//       );
//     }
//   } catch (e) {
//     debugPrint("Delete error: $e");
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     }
//   }
// }




