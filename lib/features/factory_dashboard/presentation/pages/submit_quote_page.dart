import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/constants/app_routes.dart';
import '../bloc/submit_quote_cubit.dart';
import '../bloc/submit_quote_state.dart';

class SubmitQuotePage extends StatefulWidget {
  final String rfqId;

  const SubmitQuotePage({super.key, required this.rfqId});

  @override
  State<SubmitQuotePage> createState() => _SubmitQuotePageState();
}

class _SubmitQuotePageState extends State<SubmitQuotePage> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _leadTimeController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _priceController.dispose();
    _leadTimeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitQuote() {
    if (_formKey.currentState!.validate()) {
      context.read<SubmitQuoteCubit>().submitQuote(
        rfqId: widget.rfqId,
        price: double.parse(_priceController.text),
        leadTime: int.parse(_leadTimeController.text),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('factory.submit_quote'.tr())),
      body: BlocConsumer<SubmitQuoteCubit, SubmitQuoteState>(
        listener: (context, state) {
          if (state is SubmitQuoteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('factory.validation.quote_submitted'.tr()),
              ),
            );
            // Replace with chat page to start negotiating immediately
            context.pushReplacementNamed(
              AppRoutes.chat,
              pathParameters: {'id': widget.rfqId},
            );
          } else if (state is SubmitQuoteError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isLoading = state is SubmitQuoteSubmitting;

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                TextFormField(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'factory.quote_price'.tr(),
                    prefixText: '\$ ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'common.validation.required'.tr();
                    }
                    if (double.tryParse(value) == null) {
                      return 'Must be a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _leadTimeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'factory.lead_time_days'.tr(),
                    suffixText: ' days',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'common.validation.required'.tr();
                    }
                    if (int.tryParse(value) == null) {
                      return 'Must be an integer';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'factory.notes_optional'.tr(),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submitQuote,
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text('factory.submit_quote'.tr()),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
