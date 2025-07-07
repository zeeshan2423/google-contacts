import 'package:google_contacts/core/constants/imports.dart';

class AppWidgets {
  AppWidgets._();

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
  customSnackBar({
    required BuildContext context,
    required String text,
  }) {
    final colorScheme = context.theme.colorScheme;
    final textTheme = context.theme.textTheme;
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        content: Align(
          alignment: Alignment.bottomCenter,
          child: IntrinsicWidth(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.outlineVariant,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 12,
                children: [
                  SvgPicture.asset(AppAssets.logo, width: 24),
                  Flexible(
                    child: Text(
                      text,
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget customTextFormField({
    required BuildContext context,
    required FIELDS type,
    required TextEditingController controller,
    FocusNode? focusNode,
    String? selectedDialCode,
    void Function(CountryCode)? onChanged,
  }) {
    final textTheme = context.theme.textTheme;
    final colorScheme = context.theme.colorScheme;
    String? labelText;
    List<TextInputFormatter>? inputFormatters;
    var keyboardType = TextInputType.name;
    void Function()? onTap;
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    switch (type) {
      case FIELDS.firstName:
        labelText = 'First name';
        inputFormatters = [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
          FirstLetterUppercaseFormatter(),
        ];
      case FIELDS.middleName:
        labelText = 'Middle name';
        inputFormatters = [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
          FirstLetterUppercaseFormatter(),
        ];
      case FIELDS.lastName:
        labelText = 'Surname';
        inputFormatters = [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
          FirstLetterUppercaseFormatter(),
        ];
      case FIELDS.company:
        labelText = 'Company';
        inputFormatters = [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
          FirstLetterUppercaseFormatter(),
        ];
        keyboardType = TextInputType.text;
      case FIELDS.department:
        labelText = 'Department';
        inputFormatters = [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
          FirstLetterUppercaseFormatter(),
        ];
        keyboardType = TextInputType.text;
      case FIELDS.jobTitle:
        labelText = 'Title';
        inputFormatters = [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
          FirstLetterUppercaseFormatter(),
        ];
        keyboardType = TextInputType.text;
      case FIELDS.phone:
        labelText = 'Phone (Mobile)';
        inputFormatters = [FilteringTextInputFormatter.digitsOnly];
        keyboardType = TextInputType.phone;
      case FIELDS.email:
        labelText = 'Email';
        inputFormatters = [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._\-]')),
        ];
        keyboardType = TextInputType.emailAddress;
      case FIELDS.birthday:
        labelText = 'Birthdate';
        keyboardType = TextInputType.datetime;
        onTap = () async {
          await showCustomDatePickerDialog(
            context: context,
            controller: controller,
          );
          if (context.mounted) FocusScope.of(context).unfocus();
        };

      case FIELDS.address:
        labelText = 'Address';
        inputFormatters = [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
          FirstLetterUppercaseFormatter(),
        ];
        keyboardType = TextInputType.text;
      case FIELDS.notes:
        labelText = 'Notes';
        keyboardType = TextInputType.multiline;
    }
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      maxLines: type == FIELDS.notes ? 3 : 1,
      onTap: onTap,
      readOnly: type == FIELDS.birthday,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onTapOutside: (e) {
        FocusScope.of(context).unfocus();
      },
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
        labelStyle: textTheme.titleMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        alignLabelWithHint: true,
        suffixIcon: type == FIELDS.birthday ? const Icon(Icons.event) : null,
        prefix: type == FIELDS.phone
            ? CountryCodePicker(
                builder: (e) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8,
                    children: [
                      if (e!.flagUri != null)
                        Image.asset(
                          e.flagUri!,
                          package: 'country_code_picker',
                          width: 20,
                        ),
                      SvgPicture.asset(
                        AppAssets.arrowDropDown,
                        height: 4,
                      ),
                      Text(
                        e.dialCode ?? '',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                onChanged: onChanged,
                initialSelection: selectedDialCode ?? 'IN',
                favorite: const ['+91'],
                flagWidth: 16,
                showDropDownButton: true,
                headerText: null,
                hideSearch: true,
                hideHeaderText: true,
                hideCloseIcon: true,
                dialogSize: Size(deviceWidth * 0.8, deviceHeight * 0.5),
              )
            : null,
      ),
    );
  }

  static Future<void> showCustomDatePickerDialog({
    required BuildContext context,
    required TextEditingController controller,
  }) async {
    final textTheme = context.theme.textTheme;
    final colorScheme = context.theme.colorScheme;

    final now = DateTime.now();
    final selectedYear = ValueNotifier<int>(now.year);
    final selectedMonth = ValueNotifier<int>(now.month);
    final selectedDay = ValueNotifier<int>(now.day);
    final includeYear = ValueNotifier<bool>(true);

    final years = List.generate(200, (i) => 1900 + i);
    final months = List.generate(12, (i) => i + 1);
    final days = List.generate(31, (i) => i + 1);

    DateTime currentDate() {
      return DateTime(
        includeYear.value ? selectedYear.value : 2000,
        selectedMonth.value,
        selectedDay.value,
      );
    }

    await showDialog<AlertDialog>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          contentPadding: const EdgeInsets.only(top: 24, right: 24, left: 24),
          actionsPadding: const EdgeInsets.all(12),
          title: ValueListenableBuilder3<int, int, int, bool>(
            first: selectedYear,
            second: selectedMonth,
            third: selectedDay,
            fourth: includeYear,
            builder: (context, year, month, day, incYear, _) {
              final date = DateTime(incYear ? year : 2000, month, day);
              return Text(
                incYear
                    ? DateFormat.yMMMd().format(date)
                    : DateFormat.MMMd().format(date),
                style: textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                ),
              );
            },
          ),
          actions: [
            TextButton(
              style: const ButtonStyle(
                visualDensity: VisualDensity.compact,
              ),
              child: Text(
                'Cancel',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              style: const ButtonStyle(
                visualDensity: VisualDensity.compact,
              ),
              child: Text(
                'OK',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                final date = currentDate();
                controller.text = includeYear.value
                    ? DateFormat('M/d/yy').format(date)
                    : DateFormat('MMMM d').format(date);
                Navigator.pop(context);
              },
            ),
          ],
          content: SizedBox(
            height: 180,
            child: Column(
              spacing: 16,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _picker(
                        context: context,
                        items: months,
                        initialItem: selectedMonth.value - 1,
                        onSelectedItemChanged: (val) =>
                            selectedMonth.value = months[val],
                        itemBuilder: (i) => Text(
                          DateFormat.MMM().format(DateTime(0, months[i])),
                          style: textTheme.titleMedium,
                        ),
                      ),
                      _picker(
                        context: context,
                        items: days,
                        initialItem: selectedDay.value - 1,
                        onSelectedItemChanged: (val) =>
                            selectedDay.value = days[val],
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: includeYear,
                        builder: (context, incYear, _) {
                          return incYear
                              ? _picker(
                                  context: context,
                                  items: years,
                                  initialItem: selectedYear.value - 1900,
                                  onSelectedItemChanged: (val) =>
                                      selectedYear.value = years[val],
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  spacing: 4,
                  children: [
                    Text(
                      'Include year',
                      style: context.theme.textTheme.titleMedium,
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: includeYear,
                      builder: (context, value, _) => Switch(
                        value: value,
                        onChanged: (val) => includeYear.value = val,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _picker({
    required List<int> items,
    required int initialItem,
    required void Function(int) onSelectedItemChanged,
    required BuildContext context,
    Widget Function(int)? itemBuilder,
  }) {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 35,
            left: 0,
            right: 0,
            child: _buildSegmentedDivider(context),
          ),
          Positioned(
            bottom: 35,
            left: 0,
            right: 0,
            child: _buildSegmentedDivider(context),
          ),
          ListWheelScrollView.useDelegate(
            itemExtent: 50,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: onSelectedItemChanged,
            overAndUnderCenterOpacity: 0.5,
            controller: FixedExtentScrollController(initialItem: initialItem),
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: items.length,
              builder: (context, index) {
                final textTheme = context.theme.textTheme;

                return Center(
                  child: itemBuilder != null
                      ? itemBuilder(index)
                      : Text(
                          items[index].toString(),
                          style: textTheme.titleMedium,
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildSegmentedDivider(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return Row(
      children: List.generate(1, (_) {
        return Expanded(
          child: Container(
            height: 2,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            color: colorScheme.onSurfaceVariant,
          ),
        );
      }),
    );
  }
}
