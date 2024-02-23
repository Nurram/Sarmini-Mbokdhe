import 'package:sarmini_mbokdhe/core_imports.dart';
import 'package:sarmini_mbokdhe/models/voucher_response.dart';
import 'package:sarmini_mbokdhe/network/api_provider.dart';

class VoucherController extends BaseController {
  final vouchers = <VoucherDatum>[].obs;

  getVouchers() async {
    isLoading(true);

    try {
      final vouchersResponse = await ApiProvider().get(endpoint: '/vouchers');
      final vouchers = VoucherResponse.fromJson(vouchersResponse);

      this.vouchers(vouchers.data);
      isLoading(false);
    } catch (e) {
      isLoading(false);
      Utils.showGetSnackbar(e.toString(), false);
    }
  }

  @override
  void onInit() {
    getVouchers();
    super.onInit();
  }
}
