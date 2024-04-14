
// ignore_for_file: camel_case_types


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trservis/Companent/my_button.dart';
import 'package:trservis/MainActivity/Bar.dart';





class Login_screen extends StatefulWidget {
  const Login_screen({super.key});

  @override
  State<Login_screen> createState() => _Login_screenState();
}

class _Login_screenState extends State<Login_screen> {
  final TextEditingController _userNamecontroller = TextEditingController();
  final TextEditingController _PassNcontroller = TextEditingController();
  String? _errorMesage;
  String? _errorPassMesage;
  late final bool loggedIn;



  void _validateInput() async {
    if (_userNamecontroller.text.isNotEmpty) {
      _errorMesage = null;
      if (_PassNcontroller.text.isNotEmpty) {
        _errorPassMesage = null;


        Navigator.push(context, MaterialPageRoute(builder: (context) => Bar()));

      } else {
        setState(() {
          _errorPassMesage = "Şifre Boş Bırakılamaz";
        });
      }
    } else {
      setState(() {
        _errorMesage = "Mail Boş Bırakılamaz";
      });
    }
  }

  bool passToggle = true;


  Future<void> main() async {

//...
  }

  @override
  Widget build(BuildContext context) {
    // Tema verisini al
    ThemeData theme = Theme.of(context);
    return Material(
      color: theme.scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40,),
              Padding(padding: const EdgeInsets.all(20),
                child: Image.asset("images/login.png"),),
              const SizedBox(height: 10,),
               Container(
                 width: MediaQuery.of(context).size.width*0.5,
                 child: Card(
                  elevation: 30,
                  child: Column(
                    children: [
                      Padding(padding: const EdgeInsets.all(10),
                        child: TextField(
                          controller: _userNamecontroller,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            label: const Text("E-mail Addresi Girin"),
                            prefixIcon: const Icon(Icons.person),
                            errorText: _errorMesage,
                          ),
                        ),
                      ),
                      Padding(padding: const EdgeInsets.all(10),
                        child: TextField(
                          controller: _PassNcontroller,
                          obscureText: passToggle ? true : false,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            label: const Text("Şifrenizi Girin"),
                            prefixIcon: const Icon(Icons.lock),
                            errorText: _errorPassMesage,
                            suffixIcon: InkWell(
                                onTap: (){
                                  if(passToggle == true){
                                    passToggle = false;
                                  }else{
                                    passToggle = true;
                                  }
                                  setState(() {});
                                },
                                child: passToggle
                                    ? const Icon(CupertinoIcons.eye_slash_fill)
                                    : const Icon(CupertinoIcons.eye_fill)
                            ),

                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            GestureDetector(
                              onTap: () {

                              },
                              child: const Text("Hesap Başvurusunda Bulunun."),
                            ),

                          ],
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          width: double.infinity,
                          child: MyButton(
                            onTap: () {

                              _validateInput();

                            },

                            buttonText: "GİRİŞ",
                            buttonColor: Colors.black,
                            textColor: Colors.white,
                            buttonHeight: MediaQuery.of(context).size.height*0.01,
                            buttonWeight: MediaQuery.of(context).size.width*0.05,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,),
                        ),
                      ),

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
}


