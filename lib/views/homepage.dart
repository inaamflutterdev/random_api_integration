import 'package:demo_api_integration/models/post.dart';
import 'package:demo_api_integration/services/remote_services.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post>? posts;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    //fetch data from API
    getData();
  }

  getData() async {
    posts = await RemoteService().getPost();
    if (posts != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  Future<bool> _confirmExit() async {
    bool? shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.amber,
          title: const Text('Confirm Exit'),
          content: const Text('Are you sure you want to close the app?'),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop(true); // Close the app
              },
              child: const Text('Yes'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // ignore: avoid_print
            print("Menu Button Pressed");
          },
          icon: const Icon(Icons.menu),
        ),
        foregroundColor: Colors.amberAccent,
        backgroundColor: Colors.black,
        elevation: 5,
        title: const Text("API Integration"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              bool shouldExit = await _confirmExit();
              if (shouldExit) {
                // Close the app
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Visibility(
          visible: isLoaded,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: ListView.builder(
            itemCount: posts?.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.amber,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            posts![index].title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            posts![index].body ?? '',
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
