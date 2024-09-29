import 'dart:convert'; 
import 'package:flutter/material.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

 
  List data = [];
  List searchData = [];

  
  bool isacceding = true;

  // initState method is called when the widget is first created
  @override
  void initState() {
    super.initState();
    fetchdata(); // Fetch data from the API when the screen initializes
  }

  // Method for fetch data from an API
  void fetchdata() async {
    
    http.Response response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/comments'));

  
    if (response.statusCode == 200) {
      setState(() {
        
        data = json.decode(response.body);
        searchData = data;
      });
    }
  }

  // Method for when user search see the result
  void searchdata(String query) {
   
    List newlist = data.where((element) {
      String id = element['id'].toString();
      String postid = element['postId'].toString();
      String name = element['name'].toLowerCase();
      String email = element['email'].toLowerCase();
      String body = element['body'].toLowerCase();

      // Return true if any of these fields contain the query
      return id.contains(query) || postid.contains(query) || name.contains(query) || email.contains(query) || body.contains(query);
    }).toList();

    // Update the search results
    setState(() {
      searchData = newlist;
    });
  }

  // Method for sort the list 
  void sortdata(bool isacceding) {
    setState(() {
     
      searchData.sort((a, b) => isacceding
          ? a['id'].compareTo(b['id']) 
          : b['id'].compareTo(a['id'])); 
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
        child: Column(
          children: [
            
            Row(
              children: [
             
                Expanded(
                  child: TextFormField(
                   
                    decoration: InputDecoration(
                      labelText: 'search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                    ),
                    
                    onChanged: (value) {
                      searchdata(value);
                    },
                  ),
                ),
                // Sort button to toggle between ascending and descending order
                IconButton(
                  onPressed: () {
                    setState(() {
                      isacceding = !isacceding; 
                    });
                    sortdata(isacceding); 
                  },
                  icon: const Icon(
                    Icons.sort,
                    size: 35,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04, 
            ),
            // Show a loading indicator when data is not fetched or loading 
            searchData.isEmpty
                ? const CircularProgressIndicator()
                : Expanded(
                    // ListView to display data
                    child: ListView.builder(
                      itemCount: searchData.length, 
                      itemBuilder: (context, index) {
                       
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 166, 197, 223),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.black),
                            ),
                            
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                               
                                Text(
                                  "ID : ${searchData[index]['id']}",
                                  style: GoogleFonts.poppins(
                                      fontSize: 23, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                               
                                Text("Comment id  : ${searchData[index]['postId']}"),
                                const SizedBox(
                                  height: 7,
                                ),
                               
                                Text("Name  : ${searchData[index]['name']}"),
                                const SizedBox(
                                  height: 7,
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                              
                                Text("Email  : ${searchData[index]['email']}"),
                                const SizedBox(
                                  height: 7,
                                ),
                              
                                Text("Comment  : ${searchData[index]['body']}"),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
          ],
        ),
      ),
      // Floating action button to open an external website
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Container(
          width: double.infinity,
          child: FloatingActionButton(
            backgroundColor: Colors.blue,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
           
            onPressed: () async {
              final Uri url = Uri.parse('https://neosao.com/');
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                throw 'Could not launch $url';
              }
            },
            
            child: Text(
              "Website",
              style: GoogleFonts.poppins(
                  fontSize: 25, color: Colors.black, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // Center the floating action button
    );
  }
}
