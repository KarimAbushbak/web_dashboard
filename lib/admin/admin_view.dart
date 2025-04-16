import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AdminView extends StatefulWidget {
  const AdminView({Key? key}) : super(key: key);

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  Uint8List? imageBytes;
  String? fileName;
  bool isLoading = false;

  Future<void> pickImage() async {
    final data = await ImagePickerWeb.getImageAsBytes();
    if (data != null) {
      setState(() {
        imageBytes = data;
        fileName = const Uuid().v4();
      });
    }
  }

  Future<void> uploadPost() async {
    if (titleController.text.isEmpty || contentController.text.isEmpty || imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() => isLoading = true);
    try {
      final path = 'posts/$fileName.png';

      await Supabase.instance.client.storage.from('posts').uploadBinary(path, imageBytes!);
      final imageUrl = Supabase.instance.client.storage.from('posts').getPublicUrl(path);

      await Supabase.instance.client.from('posts').insert({
        'title': titleController.text,
        'content': contentController.text,
        'image_url': imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Post uploaded!')));
      titleController.clear();
      contentController.clear();
      setState(() {
        imageBytes = null;
        fileName = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'Content'),
            ),
            const SizedBox(height: 16),
            if (imageBytes != null)
              Image.memory(imageBytes!, height: 150),
            OutlinedButton(
              onPressed: pickImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : uploadPost,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Upload Post"),
            ),
          ],
        ),
      ),
    );
  }
}
