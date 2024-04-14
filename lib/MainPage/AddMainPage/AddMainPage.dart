// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mysql1/mysql1.dart';



class AddMainPage extends StatefulWidget {
  const AddMainPage({super.key});

  @override
  State<AddMainPage> createState() => _AddMainMageState();
}

class _AddMainMageState extends State<AddMainPage> {


  late String dropdownValue=""; //Seçilen element burada tutulur, sunucuya verilecek değer.
  late List<Widget> myTabs;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _RepairDevicesNameController = TextEditingController();
  final TextEditingController _ProcessTypeController = TextEditingController(); //işlem tipi
  final TextEditingController _PriceGivenController = TextEditingController(); //Verilen Fiyat
  final TextEditingController _CostController = TextEditingController(); //Maliyet
  final TextEditingController _ProfitAchievedController = TextEditingController(); //Elde Edilen Kâr
  final TextEditingController _AdditionalinfoController = TextEditingController(); //Ek Bilgi
  Color profitTextColor = Colors.green; // kar ve zarar textin Başlangıçta varsayılan renk
  String profitLabel = "Elde Edilen Kâr"; //kar ve zarar textin Başlangıçta varsayılan etiket


  ///Sıfır Alış ekranı Text Fled
  final TextEditingController _PurchasedProductController = TextEditingController(); //Satın Alınan Ürün
  final TextEditingController _PriceReceivedController = TextEditingController(); //Maliyet Alınan Fiyat
  final TextEditingController _WhereTheWatchWasPurchasedController = TextEditingController(); //Saatın Alınan Yer
  final TextEditingController _AdditionalinfoOzelliklerController = TextEditingController(); //Özellikler için ek bilgi
  bool _switchValue = false;
  String _switchStringType = "2.EL ÜRÜN GİRİŞİ";
  late String _DrowCameraWalue="";//Camera Tutucu
  late String _DrowRenkWalue="";//Renk Tutucu
  late String _DrowRamWalue="";//Ram Tutucu
  late String _DrowDepolamaWalue="";//Dempolama Tutucu

  /// 2.El Saataın Alım
  final TextEditingController _tecceIDnumberController = TextEditingController(); //TC kimlik No
  final TextEditingController _controllerPhone = TextEditingController(); //Phone Number textFled Sunucuya atılmayacak sadece tutuyor
  late String _controllerPhoneTutucu = "";// Telefon bilgisi sunucuya atıalcak
  late String _DrowKasaWalue="";//Kasa Tutucu
  late String _DrowEkranWalue="";//Ekran Tutucu
  late String _DrowBataryaWalue="";//Batarya Tutucu


  late StreamController<String> dropdownValueController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropdownValueController = StreamController<String>.broadcast();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    dropdownValueController.close();


  }

  File? _image;

  void _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _image = File(result.files.single.path!);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _image = null;
    });
  }


  void changeDropdownValue(String newValue) {
    dropdownValueController.add(newValue); // Stream'e yeni değer gönder
  }

  void DBSorgu()async {
    //Database bağlan
    var settings = ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'root',
        db: 'berkay'
    );
    var conn = await MySqlConnection.connect(settings);

    
    var results = await conn.query('SELECT * FROM musteri_giris');
    for (var row in results) {
      print('Veri: ${row[0]}, ${row[1]}');

    }
    // Bağlantıyı kapat
    await conn.close();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Müşteri Giriş"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row( // Ana düzenleyici Row olarak kalıyor
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sol Column (%60 genişlik) - TextField ve Dropdown
              Expanded(
                flex: 6, // Genişliği biraz daha fazla yapabilirsiniz
                child: Column( // TextField ve Dropdown için Column
                  children: [
                    _CustomerTextFled(),
                    const SizedBox(height: 5,),
                    _DropdownTextFieldRepair(),
                    const SizedBox(height: 5,),
                    _ControllerDropDown(),
                   // _DeviceInfo()
                  ],
                ),
              ),

              // Sağ Column (%40 genişlik) - Güncellenen Bilgiler
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(left: 50, right: 10,),
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  const Text('Müşteri Adı: '),
                                  ValueListenableBuilder(
                                    valueListenable: _userNameController,
                                    builder: (context, value, child) {
                                      return Text(_userNameController.text);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  const Text("İşlem Tipi: "),
                                  StreamBuilder<String>(
                                    stream: dropdownValueController.stream,
                                    initialData: dropdownValue,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(snapshot.data!);
                                      }
                                      return Text(dropdownValue);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            // Buraya diğer Row'lar ekleyebilirsiniz
                            const Divider(),
                            Logcontroller(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      // Buraya diğer Row'lar ekleyebilirsiniz
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5, // Ekran genişliğinin yarısını alır
                        height: MediaQuery.of(context).size.height * 0.2, // Ekran yüksekliğinin %20'sini alır
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                        ),
                        child: InkWell(
                          splashColor: Colors.blueAccent,
                          onTap: () async {
                            // Burada butona tıklandığında yapılacak işlemleri ekleyin
                            print('ImageButton tıklandı!');
                            DBSorgu();

                          },
                          child: Image.asset(
                            'images/m_gris_btn.png', // Burada kendi resim yolunuzu kullanın
                            fit: BoxFit.cover, // Resmi container'ın tamamına yaymak için

                          ),
                        ),
                      )


                    ],
                  ),
                ),
              ),
              
            ],
          ),
        ),
      ),

    );
  }
  Widget _CustomerTextFled(){
    return  TextField(
      controller: _userNameController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Müşteri Adı',
        prefixIcon: Icon(Icons.person),
      ),
    );
  }
  Widget _DropdownTextFieldRepair(){
    const List<String> list = <String>['TAMİR', 'ALIŞ'];
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width*1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: <Widget>[
                    Icon(CupertinoIcons.archivebox_fill),
                    SizedBox(width: 8),
                    Text(
                      "İŞLEM TİPİ",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 20,
              child: DropdownMenu<String>(
                initialSelection: list.first,
                onSelected: (String? value) {
                  if (value != null) {
                    changeDropdownValue(value);
                  }
                },
                dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ControllerDropDown() {
    return StreamBuilder<String>(
      stream: dropdownValueController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String dropdownValue = snapshot.data!;
          switch (dropdownValue) {
            case 'TAMİR':
              return _DeviceRepairInfo();
            case 'ALIŞ':
            // Burada ALIŞ durumu için bir widget döndürebilirsiniz.
              return  _Buying_a_deviceInfo();
            default:
              return const Text('Bir seçim yapın');
          }
        } else {
          // Stream'den henüz veri gelmediyse veya bir hata varsa
          return const Text('Bir seçim yapın');
        }
      },
    );
  }
  /// Tamir seçildiğinde acılacak textfletler
  Widget _DeviceRepairInfo(){

   return Column(
     children: [
       TextField(
          controller: _RepairDevicesNameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Servise Alınan Cihaz',
            prefixIcon: Icon(CupertinoIcons.device_phone_portrait),
          ),
        ),
       const SizedBox(height: 8,),
       TextField(
         controller: _ProcessTypeController,
         decoration: const InputDecoration(
           border: OutlineInputBorder(),
           labelText: 'İşlem (Örn : Ekran Değişimi)',
           prefixIcon: Icon(CupertinoIcons.arrow_2_circlepath),
         ),
       ),
       const SizedBox(height: 8,),
       TextField(
         controller: _PriceGivenController,
         keyboardType: TextInputType.number, // Sayısal klavye
         inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Yalnızca rakam girilmesini sağlar
         decoration: const InputDecoration(
           border: OutlineInputBorder(),
           labelText: 'Verilen Fiyat (Örn : 400TL)',
           prefixIcon: Icon(CupertinoIcons.money_dollar),

         ),
         onChanged: (value) => calculateProfit(_PriceGivenController.text,_CostController.text),
       ),
       const SizedBox(height: 8,),
       TextField(
         controller: _CostController,
         keyboardType: TextInputType.number, // Sayısal klavye
         inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Yalnızca rakam girilmesini sağlar
         decoration: const InputDecoration(
           border: OutlineInputBorder(),
           labelText: 'Maliyet (Örn : 200TL)',
           prefixIcon: Icon(CupertinoIcons.money_dollar_circle),
         ),
         onChanged: (value) => calculateProfit(_PriceGivenController.text,_CostController.text),
       ),
       const SizedBox(height: 8,),

       TextField(
         controller: _ProfitAchievedController,
         readOnly: true,
         style: TextStyle(
           color: profitTextColor, // Dinamik renk
         ),
         decoration: InputDecoration(
           border: const OutlineInputBorder(),
           labelText: profitLabel, // Dinamik etiket
           prefixIcon: const Icon(CupertinoIcons.graph_circle),
         ),
       ),
       const SizedBox(height: 8,),
       TextField(
         controller: _AdditionalinfoController,
         maxLines: null, // Çok satırlı metin için
         keyboardType: TextInputType.multiline, // Çok satırlı metin girişi için klavye türü
         decoration: const InputDecoration(
           border: OutlineInputBorder(),
           labelText: 'Ek Bilgi Girmek İstermisiniz ? (Zorunlu Değil)',
           prefixIcon: Icon(CupertinoIcons.info),
           contentPadding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0), // Yüksekliği artırmak için
         ),
         style: const TextStyle(
           fontSize: 16, // Metin boyutunu ayarlayabilirsiniz
         ),
       ),


     ],
   );
  }
  /// Alış Seçildiğinde Acılacak textfletler
  Widget _Buying_a_deviceInfo(){
    return Column(
      children: [
        ListTile(
          leading: Icon(_switchValue ? CupertinoIcons.news : CupertinoIcons.news_solid), // Sol ikon
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(_switchValue ? "SIFIR ÜRÜN GİRİŞİ":"2.EL ÜRÜN GİRİŞİ",
                    overflow: TextOverflow.ellipsis),
              ),
              Switch(
                value: _switchValue,
                onChanged: (bool value) {
                  setState(() {
                    _switchValue = value;
                    if(value){
                      _switchStringType = "SIFIR ÜRÜN GİRİŞİ";
                    }else{
                      _switchStringType = "2.EL ÜRÜN GİRİŞİ";
                    }
                  });
                },
              ),
              const Icon(Icons.touch_app), // Sağ ikon
            ],
          ),
        ),
        if(_switchStringType =="SIFIR ÜRÜN GİRİŞİ")
          _sifirUrunGirisiWidget()
        else
          _ikinciElUrunGirisiWidget(),
      ],
    );
  }
  /// Sıfır ürün girişi widget'ı
  Widget _sifirUrunGirisiWidget() {
    return Column(
      children: [
        TextField(
          controller: _PurchasedProductController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Satın Alınan Cihaz',
            prefixIcon: Icon(CupertinoIcons.device_phone_portrait),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _PriceReceivedController,
          keyboardType: TextInputType.number, // Sayısal klavye
          inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Yalnızca rakam girilmesini sağlar
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Satın Alınan Fiyat',
            suffixText: 'TL', // Kullanıcı girişinin sonuna "TL" ekler
            prefixIcon: Icon(CupertinoIcons.money_dollar),

          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _WhereTheWatchWasPurchasedController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Satın Alınan Yer (Örn : *** Bai)',
            prefixIcon: Icon(CupertinoIcons.right_chevron),
          ),
        ),

        const SizedBox(height: 20),


        //---------- Cihaz Özellikleri ----------
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 1,
                  color: Colors.black,
                ),
              ),
              const Text("Cihaz özellikleri"),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 1,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10,),
        _DropdownOzellikTextField(),
        const SizedBox(height: 10,),
        TextField(
          controller: _AdditionalinfoOzelliklerController,
          maxLines: null, // Çok satırlı metin için
          keyboardType: TextInputType.multiline, // Çok satırlı metin girişi için klavye türü
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Ek Bilgi Girmek İstermisiniz ? (Zorunlu Değil)',
            prefixIcon: Icon(CupertinoIcons.info),
            contentPadding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0), // Yüksekliği artırmak için
          ),
          style: const TextStyle(
            fontSize: 16, // Metin boyutunu ayarlayabilirsiniz
          ),
        ),

        const SizedBox(height: 20),
        //----------  Resim Yükle ------------
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 1,
                  color: Colors.black,
                ),
              ),
              const Text("Resim Ekle"),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 1,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4, // Yükseklik
              width: MediaQuery.of(context).size.width * 0.55, // Genişlik
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1), // Kenarlık
              ),
              child: Center(
                child: _image == null
                    ? ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Resim Seç'),
                )
                    : Stack(
                  alignment: Alignment.topRight,
                  children: [
                    // Resmi sığdırmak için
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.file(
                        _image!,
                        fit: BoxFit.cover, // veya BoxFit.contain
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: _removeImage,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),


      ],
    );
  }
  /// Cihaz özellikleri acılır kapanır menuler
  Widget _DropdownOzellikTextField(){
    const List<String> listCamere = <String>['16 MP', '32 MP','50 MP','62 MP','108 MP','200 MP'];
    const List<String> listRenk = <String>['Siyah', 'Beyaz','Gümüş','Altın','Pembe','Mavi'];
    const List<String> listRam = <String>['2 GB', '4 GB','6 GB','8 GB','12 GB','16 GB'];
    const List<String> listDepolama = <String>['16 GB', '32 GB','64 GB','128 GB','256 GB','512 RAM','1 TB'];


    return Column(
      children: [
        Row(

          children: [
            const Expanded(
              // Text widget ekleniyor
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Kamera:",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width*0.3),
            Expanded(
              // DropdownMenu widget için Container veya SizedBox kullanılıyor
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1), // Padding ekleyerek taşmayı önleyebiliriz
                child: DropdownMenu<String>(
                  inputDecorationTheme: const InputDecorationTheme(
                    border: InputBorder.none,  // Çerçeveyi kaldırır
                    // Diğer stil özelliklerini burada tanımlayabilirsiniz

                  ),
                  initialSelection: listCamere.first,
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      _DrowCameraWalue = value!;
                    });

                  },
                  dropdownMenuEntries: listCamere.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(value: value, label: value);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(
              // Text widget ekleniyor
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Cihaz Rengi:",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width*0.3),
            Expanded(
              // DropdownMenu widget için Container veya SizedBox kullanılıyor
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1), // Padding ekleyerek taşmayı önleyebiliriz
                child: DropdownMenu<String>(
                  inputDecorationTheme: const InputDecorationTheme(
                    border: InputBorder.none,  // Çerçeveyi kaldırır
                    // Diğer stil özelliklerini burada tanımlayabilirsiniz
                  ),
                  initialSelection: listRenk.first,
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      _DrowRenkWalue = value!;
                    });
                  },
                  dropdownMenuEntries: listRenk.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(value: value, label: value);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(
              // Text widget ekleniyor
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Cihaz Ram:",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width*0.3),
            Expanded(
              // DropdownMenu widget için Container veya SizedBox kullanılıyor
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1), // Padding ekleyerek taşmayı önleyebiliriz
                child: DropdownMenu<String>(
                  inputDecorationTheme: const InputDecorationTheme(
                    border: InputBorder.none,  // Çerçeveyi kaldırır
                    // Diğer stil özelliklerini burada tanımlayabilirsiniz
                  ),
                  initialSelection: listRam.first,
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      _DrowRamWalue = value!;
                    });
                  },
                  dropdownMenuEntries: listRam.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(value: value, label: value);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(
              // Text widget ekleniyor
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Cihaz Depolama:",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width*0.3),
            Expanded(
              // DropdownMenu widget için Container veya SizedBox kullanılıyor
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1), // Padding ekleyerek taşmayı önleyebiliriz
                child: DropdownMenu<String>(
                  inputDecorationTheme: const InputDecorationTheme(
                    border: InputBorder.none,  // Çerçeveyi kaldırır
                    // Diğer stil özelliklerini burada tanımlayabilirsiniz
                  ),
                  initialSelection: listDepolama.first,
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      _DrowDepolamaWalue = value!;
                    });
                  },
                  dropdownMenuEntries: listDepolama.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(value: value, label: value);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  /// Cihaz Durum acılır kapanır menuler
  Widget _DropdownDurumTextField(){
    const List<String> listKasa = <String>['Yeni','Yeni Gibi','Darbeli'];
    const List<String> listEkran = <String>['Yeni', 'Cizik Var','Kırık'];
    const List<String> listBatara = <String>['Orjinal','Değiştirilmiş','Değiştirilmesi Gerek'];


    return Column(
      children: [
        Row(

          children: [
            const Expanded(
              // Text widget ekleniyor
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Kasa Durumu:",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width*0.3),
            Expanded(
              // DropdownMenu widget için Container veya SizedBox kullanılıyor
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1), // Padding ekleyerek taşmayı önleyebiliriz
                child: DropdownMenu<String>(
                  inputDecorationTheme: const InputDecorationTheme(
                    border: InputBorder.none,  // Çerçeveyi kaldırır
                    // Diğer stil özelliklerini burada tanımlayabilirsiniz

                  ),
                  initialSelection: listKasa.first,
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      _DrowKasaWalue = value!;
                    });

                  },
                  dropdownMenuEntries: listKasa.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(value: value, label: value);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(
              // Text widget ekleniyor
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Ekran Durumu:",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width*0.3),
            Expanded(
              // DropdownMenu widget için Container veya SizedBox kullanılıyor
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1), // Padding ekleyerek taşmayı önleyebiliriz
                child: DropdownMenu<String>(
                  inputDecorationTheme: const InputDecorationTheme(
                    border: InputBorder.none,  // Çerçeveyi kaldırır
                    // Diğer stil özelliklerini burada tanımlayabilirsiniz
                  ),
                  initialSelection: listEkran.first,
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      _DrowEkranWalue = value!;
                    });
                  },
                  dropdownMenuEntries: listEkran.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(value: value, label: value);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(
              // Text widget ekleniyor
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Batarya Durumu:",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width*0.309),
            Expanded(
              // DropdownMenu widget için Container veya SizedBox kullanılıyor
                child: DropdownMenu<String>(
                  inputDecorationTheme: const InputDecorationTheme(
                    border: InputBorder.none,  // Çerçeveyi kaldırır
                    // Diğer stil özelliklerini burada tanımlayabilirsiniz
                  ),
                  initialSelection: listBatara.first,
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      _DrowBataryaWalue = value!;
                    });
                  },
                  dropdownMenuEntries: listBatara.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(value: value, label: value);
                  }).toList(),
                ),
            ),
          ],
        ),

      ],
    );
  }
  /// İkinci el ürün girişi widget'ı
  Widget _ikinciElUrunGirisiWidget() {
    return Column(
      children: [
        TextField(
          controller: _PurchasedProductController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Satın Alınan Cihaz',
            prefixIcon: Icon(CupertinoIcons.device_phone_portrait),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _PriceReceivedController,
          keyboardType: TextInputType.number, // Sayısal klavye
          inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Yalnızca rakam girilmesini sağlar
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Satın Alınan Fiyat',
            suffixText: 'TL', // Kullanıcı girişinin sonuna "TL" ekler
            prefixIcon: Icon(CupertinoIcons.money_dollar),

          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _WhereTheWatchWasPurchasedController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Satın Alınan Kişi',
            prefixIcon: Icon(CupertinoIcons.person),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _tecceIDnumberController,
          maxLength: 11,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Satın Alınan Kişinin TC Kimlik Numarası (Zorunlu değil)',
            prefixIcon: Icon(CupertinoIcons.number),
            suffixText: 'TC', // Kullanıcı girişinin sonuna "TL" ekler

          ),
        ),
        const SizedBox(height: 10),
        IntlPhoneField(
          initialCountryCode: 'TR',
          controller: _controllerPhone,
          onChanged: (phone) {
              print(phone.completeNumber);
              _controllerPhoneTutucu = phone.completeNumber;
          },
          decoration: InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 20),

        //---------- Cihaz Durumu ----------
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 1,
                  color: Colors.black,
                ),
              ),
              const Text("Cihaz Durumu"),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 1,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        _DropdownDurumTextField(),
        //---------- Cihaz Özellikleri ----------
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 1,
                  color: Colors.black,
                ),
              ),
              const Text("Cihaz özellikleri"),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 1,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10,),
        _DropdownOzellikTextField(),
        const SizedBox(height: 10,),
        TextField(
          controller: _AdditionalinfoOzelliklerController,
          maxLines: 6, // Çok satırlı metin için
          keyboardType: TextInputType.multiline, // Çok satırlı metin girişi için klavye türü

          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Ek Bilgi Girmek İstermisiniz ? (Zorunlu Değil)',
            prefixIcon: Icon(CupertinoIcons.info),
            contentPadding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0), // Yüksekliği artırmak için
          ),
          style: const TextStyle(
            fontSize: 16, // Metin boyutunu ayarlayabilirsiniz
          ),
        ),

        const SizedBox(height: 20),
        //----------  Resim Yükle ------------
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 1,
                  color: Colors.black,
                ),
              ),
              const Text("Satın Aldığına Dair belge ekle"),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 1,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4, // Yükseklik
              width: MediaQuery.of(context).size.width * 0.58, // Genişlik
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1), // Kenarlık
              ),
              child: Center(
                child: _image == null
                    ? IconButton(
                  onPressed: _pickImage,
                    icon: const Icon(CupertinoIcons.doc_text_viewfinder,size: 75,),
                )
                    : Stack(
                  alignment: Alignment.topRight,
                  children: [
                    // Resmi sığdırmak için
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.file(
                        _image!,
                        fit: BoxFit.cover, // veya BoxFit.contain
                      ),
                    ),
                    IconButton(
                      icon: const Icon(CupertinoIcons.clear_fill,size: 35,color: Colors.yellow,),
                      onPressed: _removeImage,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),


      ],
    );

  }
  /// Log ekranı Kontrol
  Widget Logcontroller(){
    return StreamBuilder<String>(
      stream: dropdownValueController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String dropdownValue = snapshot.data!;
          switch (dropdownValue) {
            case 'TAMİR':
              return TamirLog();
            case 'ALIŞ':
              switch(_switchStringType){
                case 'SIFIR ÜRÜN GİRİŞİ':
                  return SifirAlisLog();
                case '2.EL ÜRÜN GİRİŞİ':
                  return ikinciElAlisLog();
              }
            // Burada ALIŞ durumu için bir widget döndürebilirsiniz.
              return Text("");
            default:
              return const Text('Bir seçim yapın');
          }
        } else {
          // Stream'den henüz veri gelmediyse veya bir hata varsa
          return const Text('Bir seçim yapın');
        }
      },
    );
  }
  ///tamir seçildiğinde girilen textlerin görüntülenmesi
  Widget TamirLog(){
    return Container(
      // color: Colors.green, // Renk sadece görsel amaçlı
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Servise Alınan Cihaz: '),
                ValueListenableBuilder(
                  valueListenable: _RepairDevicesNameController,
                  builder: (context, value, child) {
                    return Text(_RepairDevicesNameController.text);
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('İşlem: '),
                ValueListenableBuilder(
                  valueListenable: _ProcessTypeController,
                  builder: (context, value, child) {
                    return Text(_ProcessTypeController.text);
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Verilen Fiyat: '),
                ValueListenableBuilder(
                  valueListenable: _PriceGivenController,
                  builder: (context, value, child) {
                    return Text(_PriceGivenController.text);
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Maliyet: '),
                ValueListenableBuilder(
                  valueListenable: _CostController,
                  builder: (context, value, child) {
                    return Text(_CostController.text);
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Kâr & Zarar: '),
                ValueListenableBuilder(
                  valueListenable: _ProfitAchievedController,
                  builder: (context, value, child) {
                    return Text(_ProfitAchievedController.text);
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Ek Bilgi: '),
                ValueListenableBuilder(
                  valueListenable: _AdditionalinfoController,
                  builder: (context, value, child) {
                    return Flexible(
                      child: Text(
                        _AdditionalinfoController.text,
                        softWrap: true, // İçerik yeni satıra taşsın
                        overflow: TextOverflow.visible, // İçerik sığmazsa görünür olsun
                      ),
                    );
                  },
                ),

              ],
            ),
          ),
          // Buraya diğer Row'lar ekleyebilirsiniz
        ],
      ),
    );
  }
  ///Sıfır Cihaz alındığında acılan Log ekranı
  Widget SifirAlisLog(){

    return Container(
      // color: Colors.green, // Renk sadece görsel amaçlı
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Cihaz Durumu: '),
                ValueListenableBuilder(
                  valueListenable: _RepairDevicesNameController,
                  builder: (context, value, child) {
                    return Text(_switchStringType);
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Satın Alınan Cihaz: '),
                ValueListenableBuilder(
                  valueListenable: _PurchasedProductController,
                  builder: (context, value, child) {
                    return Text(_PurchasedProductController.text);
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Satın Alınan Fiyat: '),
                ValueListenableBuilder(
                  valueListenable: _PriceReceivedController,
                  builder: (context, value, child) {
                    return Text(_PriceReceivedController.text);
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Satın Alınan Yer: '),
                ValueListenableBuilder(
                  valueListenable: _WhereTheWatchWasPurchasedController,
                  builder: (context, value, child) {
                    return Text(_WhereTheWatchWasPurchasedController.text);
                  },
                ),
              ],
            ),
          ),

          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Kamera: '),
                ValueListenableBuilder(
                  valueListenable: _WhereTheWatchWasPurchasedController,
                  builder: (context, value, child) {
                    return Text(_DrowCameraWalue.toString());
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Cihaz Rengi: '),
                ValueListenableBuilder(
                  valueListenable: _WhereTheWatchWasPurchasedController,
                  builder: (context, value, child) {
                    return Text(_DrowRenkWalue.toString());
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Cihaz Ram: '),
                ValueListenableBuilder(
                  valueListenable: _WhereTheWatchWasPurchasedController,
                  builder: (context, value, child) {
                    return Text(_DrowRamWalue.toString());
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Cihaz Depolama: '),
                ValueListenableBuilder(
                  valueListenable: _WhereTheWatchWasPurchasedController,
                  builder: (context, value, child) {
                    return Text(_DrowDepolamaWalue.toString());
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Ciha Özellikleri Ek Bilgi: '),
                ValueListenableBuilder(
                  valueListenable: _AdditionalinfoOzelliklerController,
                  builder: (context, value, child) {
                    return Flexible(
                      child: Text(
                        _AdditionalinfoOzelliklerController.text,
                        softWrap: true, // İçerik yeni satıra taşsın
                        overflow: TextOverflow.visible, // İçerik sığmazsa görünür olsun
                      ),
                    );
                  },
                ),

              ],
            ),
          ),
          // Buraya diğer Row'lar ekleyebilirsiniz
        ],
      ),
    );
  }
  ///2. El cihaz alındığında acılan log ekranı
  Widget ikinciElAlisLog(){

    return Container(
      // color: Colors.green, // Renk sadece görsel amaçlı
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Cihaz Durumu: '),
                ValueListenableBuilder(
                  valueListenable: _RepairDevicesNameController,
                  builder: (context, value, child) {
                    return Text(_switchStringType);
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Satın Alınan Cihaz: '),
                ValueListenableBuilder(
                  valueListenable: _PurchasedProductController,
                  builder: (context, value, child) {
                    return Text(_PurchasedProductController.text);
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Satın Alınan Fiyat: '),
                ValueListenableBuilder(
                  valueListenable: _PriceReceivedController,
                  builder: (context, value, child) {
                    return Text(_PriceReceivedController.text);
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Satın Alınan Kişi: '),
                ValueListenableBuilder(
                  valueListenable: _WhereTheWatchWasPurchasedController,
                  builder: (context, value, child) {
                    return Text(_WhereTheWatchWasPurchasedController.text);
                  },
                ),
              ],
            ),
          ),

          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('TC Kimlik Numarası: '),
                ValueListenableBuilder(
                  valueListenable: _tecceIDnumberController,
                  builder: (context, value, child) {
                    return Text(_tecceIDnumberController.text);
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Telefon Numarası: '),
                ValueListenableBuilder(
                  valueListenable: _controllerPhone,
                  builder: (context, value, child) {
                    return Text(_controllerPhoneTutucu);
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Kasa Durumu: '),
                ValueListenableBuilder(
                  valueListenable: _controllerPhone,
                  builder: (context, value, child) {
                    return Text(_DrowKasaWalue);
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Ekran Durumu: '),
                ValueListenableBuilder(
                  valueListenable: _controllerPhone,
                  builder: (context, value, child) {
                    return Text(_DrowEkranWalue);
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Batarya Durumu: '),
                ValueListenableBuilder(
                  valueListenable: _controllerPhone,
                  builder: (context, value, child) {
                    return Text(_DrowBataryaWalue);
                  },
                ),
              ],
            ),
          ),
          const Divider(),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Cihaz Rengi: '),
                ValueListenableBuilder(
                  valueListenable: _WhereTheWatchWasPurchasedController,
                  builder: (context, value, child) {
                    return Text(_DrowRenkWalue.toString());
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Kamera: '),
                ValueListenableBuilder(
                  valueListenable: _WhereTheWatchWasPurchasedController,
                  builder: (context, value, child) {
                    return Text(_DrowCameraWalue.toString());
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Cihaz Ram: '),
                ValueListenableBuilder(
                  valueListenable: _WhereTheWatchWasPurchasedController,
                  builder: (context, value, child) {
                    return Text(_DrowRamWalue.toString());
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Cihaz Depolama: '),
                ValueListenableBuilder(
                  valueListenable: _WhereTheWatchWasPurchasedController,
                  builder: (context, value, child) {
                    return Text(_DrowDepolamaWalue.toString());
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Ciha Özellikleri Ek Bilgi: '),
                ValueListenableBuilder(
                  valueListenable: _AdditionalinfoOzelliklerController,
                  builder: (context, value, child) {
                    return Flexible(
                      child: Text(
                        _AdditionalinfoOzelliklerController.text,
                        softWrap: true, // İçerik yeni satıra taşsın
                        overflow: TextOverflow.visible, // İçerik sığmazsa görünür olsun
                      ),
                    );
                  },
                ),

              ],
            ),
          ),
          // Buraya diğer Row'lar ekleyebilirsiniz
        ],
      ),
    );
  }
  ///Kar ve zarar Hesaplama
  void calculateProfit(String priceGivenString, String costString) {
    int priceGiven = int.tryParse(priceGivenString) ?? 0;
    int cost = int.tryParse(costString) ?? 0;

    int profit = priceGiven - cost;

    // Renk ve etiketi güncelleme
    if (profit < 0) {
      profitTextColor = Colors.red;
      profitLabel = "Zarar";
    } else {
      profitTextColor = Colors.green;
      profitLabel = "Elde Edilen Kâr";
    }

    // Varsayılan olarak _ProfitAchievedController'ın tanımlandığını varsayıyorum.
    _ProfitAchievedController.text = "$profit TL";

    // Ekrandaki widget'ları yeniden inşa etmek için setState çağrısı
    // Bu kısım StatefulWidget içinde olmalıdır.
    setState(() {
      // Burada, profitTextColor, profitLabel vb. değişkenleri kullanarak UI'ı güncelleyin.
      // Örneğin:
      // this.profitTextColor = profitTextColor;
      // this.profitLabel = profitLabel;
    });
  }

}