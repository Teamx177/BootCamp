import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hrms/core/themes/padding.dart';
import 'package:hrms/pages/views/profile/profile_view.dart';

//
class JobFormView extends StatefulWidget {
  const JobFormView({Key? key}) : super(key: key);

  @override
  State<JobFormView> createState() => _JobFormViewState();
}

String dropdownvalue = 'Kadın';
String dropdownvaluet = '1';
String dropdownvaluety = 'Çalışma Şekli:';
String dropdownvalloc = 'Konum:';
final List<String> items = ['Erkek', 'Kadın', 'Diğer'];

//süre
final List<String> itemst = ['1', '2-5', '5-10 ', '10-15'];
//ilan türü
final List<String> itemtype = [
  'Çalışma Şekli:',
  'Uzaktan',
  'İşyerinde',
  'Hibrit'
];
// konum
final List<String> itemloc = ['Konum:', 'Ankara', 'İstanbul', 'İzmir'];

//yaş aralığı

TextEditingController jobReport = TextEditingController(); //başlık
TextEditingController jobReportexp = TextEditingController(); //ilan açıklaması
TextEditingController jobReportmat = TextEditingController(); //gerekli ekipman

class _JobFormViewState extends State<JobFormView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.black,
        title: const Text('İş İlanı Formu'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: ProjectPadding.pagePaddingAll,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 100,
                  height: 50,
                  child: AnimatedButton(
                    text: 'Soru 1:',
                    pressEvent: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.QUESTION,
                        headerAnimationLoop: false,
                        // animType: AnimType.,
                        title: 'a',
                        desc: 'Yasadiginiz il',
                        buttonsTextStyle: const TextStyle(color: Colors.black),
                        showCloseIcon: true,
                        body: Column(
                          children: [
                            const Text('Soru 1:'),
                            const Text('Cinsiyet'),
                            DropdownButton(
                              elevation: 2,
                              isExpanded: false,
                              items: items.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              value: dropdownvalue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvalue = newValue!;
                                });
                              },
                            ),
                          ],
                        ),

                        btnCancelOnPress: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ProfileView(),
                            ),
                          );
                        },
                        btnOkOnPress: () {},
                      ).show();
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 100,
                  height: 50,
                  child: AnimatedButton(
                    text: 'Soru 2:',
                    pressEvent: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.QUESTION,
                        headerAnimationLoop: false,
                        // animType: AnimType.,
                        // title: 'a',
                        // desc: 'Yasadiginiz il',
                        buttonsTextStyle: const TextStyle(color: Colors.black),
                        showCloseIcon: true,
                        body: Column(
                          children: [
                            const Text('Soru 2:'),
                            const Text('Çalışma Süresi:(gün)'),
                            DropdownButton(
                              elevation: 2,
                              isExpanded: false,
                              items: itemst.map((String itemst) {
                                return DropdownMenuItem(
                                  value: itemst,
                                  child: Text(itemst),
                                );
                              }).toList(),
                              value: dropdownvaluet,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvaluet = newValue!;
                                });
                              },
                            ),
                          ],
                        ),

                        btnCancelOnPress: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ProfileView(),
                            ),
                          );
                        },
                        btnOkOnPress: () {},
                      ).show();
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 100,
                  height: 50,
                  child: AnimatedButton(
                    text: 'Soru 3:',
                    pressEvent: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.QUESTION,
                        headerAnimationLoop: false,
                        // animType: AnimType.,
                        // title: 'a',
                        // desc: 'Yasadiginiz il',
                        buttonsTextStyle: const TextStyle(color: Colors.black),
                        showCloseIcon: true,
                        body: Column(
                          children: [
                            const Text('Soru 3:'),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 100,
                              width: 300,
                              child: TextField(
                                controller: jobReport,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'İş İlanınızın Başlığını Giriniz',
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        btnCancelOnPress: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ProfileView(),
                            ),
                          );
                        },
                        btnOkOnPress: () {},
                      ).show();
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 100,
                  height: 50,
                  child: AnimatedButton(
                    text: 'Soru 4:',
                    pressEvent: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.QUESTION,
                        headerAnimationLoop: false,
                        // animType: AnimType.,
                        // title: 'a',
                        // desc: 'Yasadiginiz il',
                        buttonsTextStyle: const TextStyle(color: Colors.black),
                        showCloseIcon: true,
                        body: Column(
                          children: [
                            const Text('Soru 4:'),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 180,
                              width: 300,
                              child: TextField(
                                controller: jobReportexp,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText:
                                      'İş İlanınızın Açıklamasını Giriniz',
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        btnCancelOnPress: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ProfileView(),
                            ),
                          );
                        },
                        btnOkOnPress: () {},
                      ).show();
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 100,
                  height: 50,
                  child: AnimatedButton(
                    text: 'Soru 5:',
                    pressEvent: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.QUESTION,
                        headerAnimationLoop: false,
                        // animType: AnimType.,
                        // title: 'a',
                        // desc: 'Yasadiginiz il',
                        buttonsTextStyle: const TextStyle(color: Colors.black),
                        showCloseIcon: true,
                        body: Column(
                          children: [
                            const Text('Soru 5:'),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 100,
                              width: 300,
                              child: TextField(
                                controller: jobReportmat,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText:
                                      'İş İlanınızın Gerekliliklerini Giriniz:',
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        btnCancelOnPress: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ProfileView(),
                            ),
                          );
                        },
                        btnOkOnPress: () {},
                      ).show();
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 100,
                  height: 50,
                  child: AnimatedButton(
                    text: 'Soru 6:',
                    pressEvent: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.QUESTION,
                        headerAnimationLoop: false,
                        buttonsTextStyle: const TextStyle(color: Colors.black),
                        showCloseIcon: true,
                        body: Column(
                          children: [
                            const Text('Soru 6:'),
                            const Text('Çalışma Şekli:'),
                            DropdownButtonFormField(
                              items: itemtype.map((String itemtype) {
                                return DropdownMenuItem(
                                  value: itemtype,
                                  child: Text(itemtype),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvaluety = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                        btnCancelOnPress: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ProfileView(),
                            ),
                          );
                        },
                        btnOkOnPress: () {},
                      ).show();
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 100,
                  height: 50,
                  child: AnimatedButton(
                    text: 'Soru 7:',
                    pressEvent: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.QUESTION,
                        headerAnimationLoop: false,
                        buttonsTextStyle: const TextStyle(color: Colors.black),
                        showCloseIcon: true,
                        body: Column(
                          children: [
                            const Text('Soru 7:'),
                            const Text('Konum:'),
                            DropdownButton(
                              elevation: 2,
                              isExpanded: false,
                              items: itemloc.map((String itemloc) {
                                return DropdownMenuItem(
                                  value: itemloc,
                                  child: Text(itemloc),
                                );
                              }).toList(),
                              value: dropdownvalloc,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvalloc = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                        btnCancelOnPress: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ProfileView(),
                            ),
                          );
                        },
                        btnOkOnPress: () {},
                      ).show();
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/main');
                  },
                  child: const Text('Kaydet'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
