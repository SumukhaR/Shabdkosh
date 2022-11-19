// ignore_for_file: avoid_print, avoid_unnecessary_containers

import 'package:audioplayers/audioplayers.dart';
import 'package:dictionary_app/Model/model.dart';
import 'package:dictionary_app/Services/service.dart';
import 'package:dictionary_app/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Splash(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();

  AudioPlayer? audioPlayer;

  @override
  void initState() {
    super.initState();
    setState(() {
      audioPlayer = AudioPlayer();
    });
  }

  void playAudio(String music) {
    audioPlayer!.stop();

    audioPlayer!.play(music);
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SHABDKOSH'),
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: const Color.fromARGB(255, 231, 217, 13),
        toolbarHeight: 100,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        decoration: const InputDecoration(
                          label: Text('Search Query'),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          setState(() {});
                        }
                      },
                      icon: const Icon(Icons.search),
                    )
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              ///FutureBuilder
              controller.text.isEmpty
                  ? const SizedBox(child: Text('Search for something'))
                  : FutureBuilder(
                      future:
                          DictionaryService().getMeaning(word: controller.text),
                      builder: (context,
                          AsyncSnapshot<List<DictionaryModel>> snapshot) {
                        print("Data $snapshot");
                        if (snapshot.hasData) {
                          return Expanded(
                            child: ListView(
                              children:
                                  List.generate(snapshot.data!.length, (index) {
                                final data = snapshot.data![index];
                                try {
                                  final temp = data.meanings![index]
                                      .definitions![index].definition;
                                  return Container(
                                    child: Column(
                                      children: [
                                        Container(
                                          child: ListTile(
                                            title: Text(data.word!),
                                            subtitle: Text(
                                                data.phonetics![index].text!),
                                          ),
                                        ),
                                        Container(
                                          child: ListTile(
                                            title: Text(
                                              data
                                                  .meanings![index]
                                                  .definitions![index]
                                                  .definition!,
                                            ),
                                            subtitle: (data.meanings![index]
                                                        .partOfSpeech) !=
                                                    null
                                                ? Text(data.meanings![index]
                                                    .partOfSpeech!)
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } catch (e) {
                                  return const Text("");
                                }
                              }),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          //  return Text(snapshot.error.toString());
                          return const Text("No definitions found");
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
