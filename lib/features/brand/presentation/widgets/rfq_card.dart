import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/rfq_request.dart';
import '../../../pdf_export/presentation/bloc/pdf_export_cubit.dart';
import '../../../pdf_export/presentation/bloc/pdf_export_state.dart';

class RfqCard extends StatelessWidget {
  final RfqRequest rfq;

  const RfqCard({super.key, required this.rfq});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    rfq.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  DateFormat.yMMMd().format(rfq.createdAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              rfq.description,
              style: TextStyle(fontSize: 14, color: Colors.black87),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${'brand.rfq_form.quantity'.tr()}: ${rfq.quantity}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Row(
                  children: [
                    if (rfq.photoUrls.isNotEmpty) ...[
                      Icon(Icons.photo, size: 16, color: Colors.grey),
                      SizedBox(width: 4.w),
                      Text(
                        '${rfq.photoUrls.length}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(width: 8.w),
                    ],
                    BlocBuilder<PdfExportCubit, PdfExportState>(
                      builder: (context, state) {
                        final isGenerating = state is PdfExportGenerating;
                        return IconButton(
                          icon: isGenerating
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.picture_as_pdf, size: 20),
                          tooltip: 'Export PDF',
                          onPressed: isGenerating
                              ? null
                              : () {
                                  context.read<PdfExportCubit>().generateRfqPdf(
                                    rfqId: rfq.id,
                                    rfqTitle: rfq.title,
                                    rfqDescription: rfq.description,
                                    quantity: rfq.quantity,
                                    brandName: 'My Company',
                                    brandEmail: '',
                                    factoryName: null,
                                    createdAt: rfq.createdAt,
                                  );
                                },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
