import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ControllerMainPage extends StatefulWidget {
  const ControllerMainPage({super.key});

  @override
  State<ControllerMainPage> createState() => _ControllerMainPageState();
}

class _ControllerMainPageState extends State<ControllerMainPage> {

  List<Map<String, dynamic>> items = [
    {'baslik': 'Başlık 1', 'aciklama': 'Açıklama metni 1', 'time': 'Time'},
    {'baslik': 'Başlık 1', 'aciklama': 'Açıklama metni 1', 'time': 'Time'},
    {'baslik': 'Başlık 1', 'aciklama': 'Açıklama metni 1', 'time': 'Time'},
    {'baslik': 'Başlık 1', 'aciklama': 'Açıklama metni 1', 'time': 'Time'},
    {'baslik': 'Başlık 1', 'aciklama': 'Açıklama metni 1', 'time': 'Time'},
    {'baslik': 'Başlık 1', 'aciklama': 'Açıklama metni 1', 'time': 'Time'},
    // Diğer öğelerinizi buraya ekleyin
  ];
  List<Map<String, dynamic>> itemsLog = [
    {'musteriName': 'Musteri Adı', 'işlemTipi': 'İşi Emri İşlem Tipi', 'time': 'Time'},
    {'musteriName': 'Musteri Adı', 'işlemTipi': 'İşi Emri İşlem Tipi', 'time': 'Time'},
    {'musteriName': 'Musteri Adı', 'işlemTipi': 'İşi Emri İşlem Tipi', 'time': 'Time'},
    {'musteriName': 'Musteri Adı', 'işlemTipi': 'İşi Emri İşlem Tipi', 'time': 'Time'},
    {'musteriName': 'Musteri Adı', 'işlemTipi': 'İşi Emri İşlem Tipi', 'time': 'Time'},
    {'musteriName': 'Musteri Adı', 'işlemTipi': 'İşi Emri İşlem Tipi', 'time': 'Time'},
    {'musteriName': 'Musteri Adı', 'işlemTipi': 'İşi Emri İşlem Tipi', 'time': 'Time'},
    {'musteriName': 'Musteri Adı', 'işlemTipi': 'İşi Emri İşlem Tipi', 'time': 'Time'},
    // Diğer öğelerinizi buraya ekleyin
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Son İşlemler"),
        automaticallyImplyLeading: false,
      ),
      body: Row( // 'const' kaldırıldı
        children: [
          Expanded( // Ekranın sol tarafı
            child: Column(
              children: [
                const Text("Son İşlemler", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Divider(),
                Expanded(
                  child: lastTransactionRecord(context),
                ),
              ],
            ),
          ),
          const VerticalDivider( // İki panel arasına dikey çizgi
            width: 20,
            thickness: 1,
            color: Colors.grey,
          ),
          Expanded(
            child: Column(
              children: [
                const Text("Beklemedeki İşlemler", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(),
                Expanded(
                  child: buildAdditionalContent(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  ///Beklemedeki işlemler Widget
  Widget buildAdditionalContent(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: (){
            print("tıklandı");
          },
          child: Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          items[index]['baslik'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Row'un sadece içeriğinin genişliğini kullanmasını sağlar
                          children: <Widget>[
                            Icon(
                              Icons.access_time, // İkon olarak saat ikonunu kullandık
                              size: 18.0, // İkon boyutu
                            ),
                            SizedBox(width: 4), // İkon ile metin arasında biraz boşluk bırakır
                            Text(
                              items[index]['time'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const Divider(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      items[index]['aciklama'],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Card(
                          elevation: 10,
                          child: ElevatedButton(
                            onPressed: () {
                              // Button 1 eylemi
                              print("Button 1 eylemi");
                            },
                            child: Text('İade Edildi',style: TextStyle(color: Colors.white),),
                            style: ButtonStyle(

                              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed))
                                    return Colors.white; // Buton basıldığında koyu mavi olacak
                                  return Colors.red; // Diğer durumlarda normal mavi olacak
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10), // Butonlar arası boşluk
                      Expanded(
                        child: Card(
                          elevation: 10,
                          child: ElevatedButton(

                            onPressed: () {
                              // Button 2 eylemi
                            },
                            child: const Text('İşlemi Tamamla',style: TextStyle(color: Colors.white)),

                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed))
                                    return Colors.white; // Buton basıldığında koyu mavi olacak
                                  return Colors.green; // Diğer durumlarda normal mavi olacak
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ///Son İşlemler işlemler Widget
  Widget lastTransactionRecord(BuildContext context) {
    return ListView.builder(
      itemCount: itemsLog.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: (){
            print("tıklandı");
          },
          child: Card(

            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          itemsLog[index]['musteriName'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Row'un sadece içeriğinin genişliğini kullanmasını sağlar
                          children: <Widget>[
                            Icon(
                              Icons.access_time, // İkon olarak saat ikonunu kullandık
                              size: 18.0, // İkon boyutu
                            ),
                            SizedBox(width: 4), // İkon ile metin arasında biraz boşluk bırakır
                            Text(
                              itemsLog[index]['time'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const Divider(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      itemsLog[index]['işlemTipi'],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 30,),


                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
