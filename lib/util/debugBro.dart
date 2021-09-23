import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

/// error
void elog(msg) {
  logger.e(msg);
}

/// info
void ilog(msg) {
  logger.i(msg);
}

/// warning
void wlog(msg) {
  logger.w(msg);
}
