import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'languages.dart';
import 'translation_api.dart';

class Translate extends StatefulWidget {
  const Translate({super.key});

  @override
  _TranslateUIState createState() => _TranslateUIState();
}

class _TranslateUIState extends State<Translate> {
  String? selectedValue1; // English
  String? selectedValue2; // Hindi

  String searchString = '';
  String resultString = '';

  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController inputTextEditingController =
      TextEditingController();

  // Common styles and properties
  final buttonStyleData = ButtonStyleData(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    height: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: Colors.black26,
      ),
      color: Colors.white,
    ),
  );
  final dropdownStyleData = const DropdownStyleData(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      color: Color(0xffffffff),
    ),
    maxHeight: 300,
  );
  final menuItemStyleData = const MenuItemStyleData(
    height: 50,
  );
  late DropdownSearchData<String> dropdownSearchData;

  @override
  void initState() {
    super.initState();
    dropdownSearchData = DropdownSearchData(
      searchController: textEditingController,
      searchInnerWidgetHeight: 50,
      searchInnerWidget: Container(
        height: 50,
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 8,
          right: 8,
          left: 8,
        ),
        child: TextFormField(
          expands: true,
          maxLines: null,
          controller: textEditingController,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            hintText: 'Select a language',
            hintStyle: const TextStyle(fontSize: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      searchMatchFn: (item, searchValue) {
        return item.value
            .toString()
            .toLowerCase()
            .contains(searchValue.toLowerCase());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0E1219),
      appBar: AppBar(
        title: Text(
          "Translate",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        backgroundColor: const Color(0xff0E1219),
        iconTheme: const IconThemeData(color: Color(0xffffffff)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: const Text(
                            'Pick Language',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                          items: languages.entries
                              .map((item) => DropdownMenuItem(
                                    value: item.value,
                                    child: Text(
                                      item.value,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          value: selectedValue1,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedValue1 = value;
                              });
                            }
                          },
                          buttonStyleData: buttonStyleData,
                          dropdownStyleData: dropdownStyleData,
                          menuItemStyleData: menuItemStyleData,
                          dropdownSearchData: dropdownSearchData,
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              textEditingController.clear();
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: const Text(
                            'Pick Language',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                          items: languages.entries
                              .map((item) => DropdownMenuItem(
                                    value: item.value,
                                    child: Text(
                                      item.value,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          value: selectedValue2,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedValue2 = value;
                              });
                            }
                          },
                          buttonStyleData: buttonStyleData,
                          dropdownStyleData: dropdownStyleData,
                          menuItemStyleData: menuItemStyleData,
                          dropdownSearchData: dropdownSearchData,
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              textEditingController.clear();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  onChanged: (value) => {
                    setState(() {
                      searchString = value;
                    })
                  },
                  maxLines: 5,
                  autocorrect: true,
                  controller: inputTextEditingController,
                  decoration: InputDecoration(
                    hintText: 'Enter text to translate',
                    hintStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final value1 = languages.entries
                          .firstWhere(
                              (element) => element.value == selectedValue1)
                          .key;
                      final value2 = languages.entries
                          .firstWhere(
                              (element) => element.value == selectedValue2)
                          .key;

                      if (searchString.isNotEmpty) {
                        final response = await fetchTranslation(
                          searchString.toString(),
                          fromLanguage: value1.isNotEmpty ? value1 : 'auto',
                          toLanguage: value2.isNotEmpty ? value2 : 'en',
                        );
                        setState(() {
                          resultString = response;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffF7C84C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(12),
                    ),
                    child: const Text(
                      'Translate',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: TextEditingController(text: resultString),
                  readOnly: true,
                  maxLines: 5,
                  autocorrect: true,
                  decoration: InputDecoration(
                    hintText: 'Translated Text',
                    hintStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
