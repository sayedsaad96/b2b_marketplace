import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/factory_profile_cubit.dart';
import '../bloc/factory_profile_state.dart';
import '../widgets/photo_grid.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _specializationController = TextEditingController();
  final _moqController = TextEditingController();
  final _avgLeadTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FactoryProfileCubit>().loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _specializationController.dispose();
    _moqController.dispose();
    _avgLeadTimeController.dispose();
    super.dispose();
  }

  void _populateControllers(FactoryProfileLoaded state) {
    if (_nameController.text.isEmpty) {
      _nameController.text = state.profile.name;
      _locationController.text = state.profile.location;
      _specializationController.text = state.profile.specialization.join(', ');
      _moqController.text = state.profile.moq.toString();
      _avgLeadTimeController.text = state.profile.avgLeadTime.toString();
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<FactoryProfileCubit>().saveProfile(
        name: _nameController.text,
        location: _locationController.text,
        specialization: _specializationController.text
            .split(',')
            .map((s) => s.trim())
            .toList(),
        moq: int.parse(_moqController.text),
        avgLeadTime: int.parse(_avgLeadTimeController.text),
      );
    }
  }

  Future<void> _pickPhotos() async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage(imageQuality: 70);
    if (images.isNotEmpty && mounted) {
      context.read<FactoryProfileCubit>().uploadPhotos(images);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'), // Will add to en.json if needed
      ),
      body: BlocConsumer<FactoryProfileCubit, FactoryProfileState>(
        listener: (context, state) {
          if (state is FactoryProfileSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile saved successfully')),
            );
          } else if (state is FactoryProfileError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is FactoryProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FactoryProfileLoaded) {
            _populateControllers(state);

            return Stack(
              children: [
                Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Factory Name',
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          labelText: 'Location',
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _specializationController,
                        decoration: const InputDecoration(
                          labelText: 'Specializations (comma separated)',
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _moqController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'MOQ',
                              ),
                              validator: (value) =>
                                  value!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _avgLeadTimeController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Avg Lead Time (days)',
                              ),
                              validator: (value) =>
                                  value!.isEmpty ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Factory Photos',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      PhotoGrid(
                        photos: state.profile.photos,
                        onAddPhoto: _pickPhotos,
                        onDelete: (url) {
                          context.read<FactoryProfileCubit>().deletePhoto(url);
                        },
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: state.isSaving ? null : _saveProfile,
                        child: const Text('Save Profile'),
                      ),
                    ],
                  ),
                ),
                if (state.isSaving)
                  Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
