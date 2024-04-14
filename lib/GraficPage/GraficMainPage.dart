
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trservis/GraficPage/Model/DailyFinancialDevelopment.dart';
import 'package:trservis/GraficPage/Model/WeeklyFinancialDevelopment.dart';
import 'package:trservis/GraficPage/Model/YearlyModel.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:trservis/GraficPage/Model/NonthlyFinancialModel.dart';

class GraficMainPage extends StatefulWidget {
  const GraficMainPage({super.key});

  @override
  State<GraficMainPage> createState() => _GraficMainPageState();
}

class _GraficMainPageState extends State<GraficMainPage> {
  bool isChecked = false;
  //Yıllık veri listesi
  List<YearlyModel> data = [
    YearlyModel("OCAK", 300, Colors.blue),
    YearlyModel("ŞUBAT", 400, Colors.blue),
    YearlyModel("MART", 500, Colors.blue),
    YearlyModel("NİSAN", 600, Colors.blue),
    YearlyModel("MAYIS", 700, Colors.blue),
    YearlyModel("HAZİRAN", 1000, Colors.blue),
    YearlyModel("TEMUZ", 900, Colors.blue),
    YearlyModel("AĞUSTOS", 800, Colors.blue),
    YearlyModel("EYLÜL", 700, Colors.blue),
    YearlyModel("EKİM", 900, Colors.blue),
    YearlyModel("KASIM", 1600, Colors.blue),
    YearlyModel("ARALIK", 1800, Colors.blue),
  ];
  // Aylık Veri listesi
  List<NonthlyFinancialModel> dataAy = [
    NonthlyFinancialModel(DateTime(2023,1,1), 0),
    NonthlyFinancialModel(DateTime(2023,1,2), 20),
    NonthlyFinancialModel(DateTime(2023,1,3), 200),
    NonthlyFinancialModel(DateTime(2023,1,4), 100),
    NonthlyFinancialModel(DateTime(2023,1,5), 150),
    NonthlyFinancialModel(DateTime(2023,1,6), 50),

  ];
  //Haftalık veri listesi
  List<WeeklyFinancialDevelopment> createWeeklyData() {
    List<WeeklyFinancialDevelopment> weeklyData = [];
    DateTime startDate = DateTime.now(); // Mevcut tarihten başlayarak

    for (int week = 0; week < 7; week++) { // 52 hafta için
      DateTime date = startDate.add(Duration(days: week));
      int sales = Random().nextInt(100); // Örnek olarak rastgele bir gelir değeri
      weeklyData.add(WeeklyFinancialDevelopment(date, sales));
    }

    return weeklyData;
  }
  //Saatlik
  List<DailyFinancialDevelopment> createHourlyData() {
    List<DailyFinancialDevelopment> hourlyData = [];
    DateTime today = DateTime.now();
    DateTime startOfToday = DateTime(today.year, today.month, today.day);
    for (int hour = 0; hour < 24; hour++) {
      DateTime hourTime = startOfToday.add(Duration(hours: hour));
      int sales = Random().nextInt(100); // Rastgele gelir değeri
      hourlyData.add(DailyFinancialDevelopment(hourTime, sales));
    }
    return hourlyData;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("İşletmenizin Gelişimini Takip Edin"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width*0.4,
          //    color: Colors.white,
              child: OnePage(),
            ),
            Divider(),
            SizedBox(height: 20,),
            IntrinsicHeight(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width*0.2,
                     // color: Colors.white,
                      child: TwoPage(),
                    ),
                  ),
                  const VerticalDivider( // İki panel arasına dikey çizgi
                    width: 20,
                    thickness: 1,
                    color: Colors.grey,
                  ),

                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width*0.2,
                   //   color: Colors.white,
                      child: TreePage(),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width*0.2,
             // color: Colors.white,
              child: FourPage(),
            ),
          ],
        ),
      ),
    );
  }
  Widget OnePage() {
    List<charts.Series<YearlyModel, String>> series = [
      charts.Series(
        id: "financial",
        data: data,
        domainFn: (YearlyModel series, _) => series.year,
        measureFn: (YearlyModel series, _) => series.financial,
        colorFn: (YearlyModel series, _) => charts.ColorUtil.fromDartColor(Colors.lightBlueAccent),
      )
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // Başlığın genişliğini sağa sola yaymak için
        children: <Widget>[
          // Grafik başlığı
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Yıllık Finansal Gelişim', // Başlık metniniz
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Row(
                children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios_new)),
                  IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_rounded)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20), // Başlık ve grafik arasında boşluk
          Expanded(
            child: charts.BarChart(
              series,
              animate: true,
            ),
          ),
        ],
      ),
    );
  }
  Widget TwoPage() {
    // Veri serisini DateTime'a göre oluştur
    List<charts.Series<NonthlyFinancialModel, DateTime>> series = [
      charts.Series<NonthlyFinancialModel, DateTime>(
        id: "Financial",
        data: dataAy,
        domainFn: (NonthlyFinancialModel row, _) => row.time,
        measureFn: (NonthlyFinancialModel row, _) => row.financial,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      )
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text(
            'Aylık Finansal Gelişim', // Başlık metniniz
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20), // Başlık ve grafik arasında boşluk
          Expanded(
            child: charts.TimeSeriesChart(
              series,
              animate: true,
              // Çizgi grafiğe özgü diğer özellikler burada tanımlanabilir
            ),
          ),
        ],
      ),
    );
  }
  Widget TreePage() {
    // Haftalık veri seti ile seriyi oluştur
    List<charts.Series<WeeklyFinancialDevelopment, DateTime>> seriesList = [
      charts.Series<WeeklyFinancialDevelopment, DateTime>(
        id: 'Daily Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (WeeklyFinancialDevelopment sales, _) => sales.time,
        measureFn: (WeeklyFinancialDevelopment sales, _) => sales.financial,
        data: createWeeklyData(), // Haftalık verileri burada kullanıyoruz
      )
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text(
            'Haftalık Finansal Gelişim', // Başlık metniniz
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20), // Başlık ve grafik arasında boşluk
          Expanded(
            child: charts.TimeSeriesChart(
              seriesList,
              animate: true,
              // Çizgi grafiğe özgü diğer özellikler burada tanımlanabilir
            ),
          ),
        ],
      ),
    );
  }
  Widget FourPage() {
    // Haftalık veri seti ile seriyi oluştur
    List<charts.Series<DailyFinancialDevelopment, DateTime>> createChartSeries() {
      return [
        charts.Series<DailyFinancialDevelopment, DateTime>(
          id: 'Hourly Sales',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (DailyFinancialDevelopment sales, _) => sales.time,
          measureFn: (DailyFinancialDevelopment sales, _) => sales.financial,
          data: createHourlyData(),
        )
      ];
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text(
            'Saaatlik Finansal Gelişim', // Başlık metniniz
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20), // Başlık ve grafik arasında boşluk
          Expanded(
            child: charts.TimeSeriesChart(
              createChartSeries(),
              animate: true,
              dateTimeFactory: const charts.LocalDateTimeFactory(),
              // Çizgi grafiğe özgü diğer özellikler burada tanımlanabilir
            ),
          ),
        ],
      ),
    );
  }


}
