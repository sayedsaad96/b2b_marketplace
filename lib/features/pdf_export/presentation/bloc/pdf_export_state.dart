import 'package:equatable/equatable.dart';
import 'dart:typed_data';

sealed class PdfExportState extends Equatable {
  const PdfExportState();

  @override
  List<Object?> get props => [];
}

class PdfExportInitial extends PdfExportState {}

class PdfExportGenerating extends PdfExportState {}

class PdfExportReady extends PdfExportState {
  final Uint8List pdfBytes;
  final String fileName;

  const PdfExportReady({required this.pdfBytes, required this.fileName});

  @override
  List<Object?> get props => [pdfBytes, fileName];
}

class PdfExportError extends PdfExportState {
  final String message;

  const PdfExportError(this.message);

  @override
  List<Object?> get props => [message];
}
