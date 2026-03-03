import 'package:flutter/material.dart';
import '../../domain/entities/rfq_quote.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart';

class QuoteListItem extends StatelessWidget {
  final RfqQuote quote;
  final VoidCallback onTap;

  const QuoteListItem({super.key, required this.quote, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isAccepted = quote.status == 'accepted';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${quote.price.toStringAsFixed(2)}',
                    style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isAccepted
                          ? AppColors.success.withValues(alpha: 0.1)
                          : AppColors.surface.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isAccepted
                            ? AppColors.success
                            : AppColors.divider,
                      ),
                    ),
                    child: Text(
                      isAccepted
                          ? 'factory.status_accepted'.tr()
                          : 'factory.status_pending'.tr(),
                      style: AppTextStyles.caption.copyWith(
                        color: isAccepted
                            ? AppColors.success
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (quote.notes != null && quote.notes!.isNotEmpty) ...[
                Text(
                  quote.notes!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
              ],
              Row(
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${quote.leadTime} days',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat.yMMMd().format(quote.createdAt),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
