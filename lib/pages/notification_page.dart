import 'package:bluetooth_attendance/pages/common.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<dynamic> notifications = [];
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    setState(() {
      isLoading = true; // Set loading to true
    });

    final response = await supabase
        .from('notification_table')
        .select('notification_detail')
        .eq('notification_read', false)
        .eq('prn', StudentPRN!);

    setState(() {
      notifications = response.isNotEmpty ? response : [];
      isLoading = false; // Set loading to false
    });

    if (notifications.isEmpty) {
      print('No notifications found');
    }
  }

  Future<void> markAsRead() async {
    // Deleting notifications marked as read without showing loading
    await supabase
        .from('notification_table')
        .delete()
        .eq('notification_read', false)
        .eq('prn', StudentPRN!);

    // Pop the notification page directly
    Navigator.pop(context); // Close the current page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications',style: TextStyle(color: Colors.white),),
        backgroundColor: Color.fromRGBO(92, 89, 145, 87), // Set app bar color
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
          isLoading
              ? Center(child: CircularProgressIndicator()) // Loading indicator
              : notifications.isEmpty
                  ? Center(child: Text('No notifications'))
                  : Padding( // Add horizontal padding to the body
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: SingleChildScrollView( // Allow the list to be scrollable
                        child: Column(
                          children: notifications.map((notification) {
                            return Container( // Use Container for fixed width
                              width: MediaQuery.of(context).size.width * 1, // Fixed width
                              margin: EdgeInsets.symmetric(vertical: 8), // Margin between cards
                              child: Card( // Use Card for better UI
                                elevation: 6, // Increase elevation for a more pronounced shadow
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12), // Rounded corners
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0), // Add padding to the card
                                  child: Text(
                                    notification['notification_detail'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16, // Increased font size for better readability
                                      color: Colors.black87, // Change text color
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: markAsRead,
        child: Icon(Icons.check),
        tooltip: 'Mark all as read',
      ),
    );
  }
}
