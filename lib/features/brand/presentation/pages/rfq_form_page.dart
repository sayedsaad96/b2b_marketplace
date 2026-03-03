import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../injection_container.dart';
import '../bloc/rfq_cubit.dart';
import '../bloc/rfq_state.dart';

class RfqFormPage extends StatefulWidget {
  final String? factoryId;

  const RfqFormPage({super.key, this.factoryId});

  @override
  State<RfqFormPage> createState() => _RfqFormPageState();
}

class _RfqFormPageState extends State<RfqFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();

  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<RfqCubit>().submitRfqRequest(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        quantity: int.parse(_quantityController.text.trim()),
        factoryId: widget.factoryId,
        images: _selectedImages,
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RfqCubit>(),
      child: Scaffold(
        appBar: AppBar(title: Text('brand.rfq_form.title'.tr())),
        body: BlocConsumer<RfqCubit, RfqState>(
          listener: (context, state) {
            if (state is RfqSubmittedSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('brand.rfq_form.success'.tr())),
              );
              context.goNamed('myRfqs');
            } else if (state is RfqError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            final isLoading = state is RfqSubmitting;

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'brand.rfq_form.rfq_title'.tr(),
                        border: const OutlineInputBorder(),
                      ),
                      enabled: !isLoading,
                      validator: (value) => value!.isEmpty
                          ? 'brand.rfq_form.required'.tr()
                          : null,
                    ),
                    SizedBox(height: 16.h),

                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'brand.rfq_form.description'.tr(),
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 4,
                      enabled: !isLoading,
                      validator: (value) => value!.isEmpty
                          ? 'brand.rfq_form.required'.tr()
                          : null,
                    ),
                    SizedBox(height: 16.h),

                    TextFormField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        labelText: 'brand.rfq_form.quantity'.tr(),
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      enabled: !isLoading,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'brand.rfq_form.required'.tr();
                        }
                        if (int.tryParse(value) == null ||
                            int.parse(value) <= 0) {
                          return 'brand.rfq_form.invalid_quantity'.tr();
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.h),

                    Text(
                      'brand.rfq_form.photos'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    if (_selectedImages.isNotEmpty)
                      SizedBox(
                        height: 100.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedImages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(right: 8.w),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: Image.file(
                                      File(_selectedImages[index].path),
                                      width: 100.w,
                                      height: 100.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () => _removeImage(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          size: 16,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                    SizedBox(height: 8.h),
                    OutlinedButton.icon(
                      onPressed: isLoading ? null : _pickImages,
                      icon: const Icon(Icons.add_photo_alternate),
                      label: Text('brand.rfq_form.add_photo'.tr()),
                    ),

                    SizedBox(height: 32.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () => _submitForm(context),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text('brand.rfq_form.submit'.tr()),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
