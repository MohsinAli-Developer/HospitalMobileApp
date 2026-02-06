import 'package:btih_andriod_app/screens/dashboard_screen.dart';
import 'package:btih_andriod_app/screens/home_screen.dart';
import 'package:btih_andriod_app/screens/profile_screen.dart';
import 'package:btih_andriod_app/services/apointment_service.dart';
import 'package:flutter/material.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  int _currentIndex = 1; // Dashboard selected
  int selectedTab = 1; // 0 = Info, 1 = Booking
  // Calendar state
  late DateTime _focusedMonth; // month being shown in header
  late DateTime _displayWeekStart; // Monday of the displayed week
  late DateTime _selectedDate; // currently selected date
  String selectedTime = '1:00 AM';

  // Time picker state
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _periodController;

  final List<int> _hours = List.generate(12, (i) => i + 1); // 1..12
  final List<String> _minutes = ['00', '30'];
  final List<String> _periods = ['AM', 'PM'];

  int _selectedHourIndex = 0; // default to 1:00 AM
  int _selectedMinuteIndex = 0;
  int _selectedPeriodIndex = 0;

  late Appointment appointment;

  @override
  void initState() {
    super.initState();
    _hourController = FixedExtentScrollController(
      initialItem: _selectedHourIndex,
    );
    _minuteController = FixedExtentScrollController(
      initialItem: _selectedMinuteIndex,
    );
    _periodController = FixedExtentScrollController(
      initialItem: _selectedPeriodIndex,
    );
    // initialize displayed time and calendar
    _updateSelectedTime();
    _selectedDate = DateTime.now();
    _focusedMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    _displayWeekStart = _startOfWeek(_selectedDate);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _periodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: const Color(0xFFEEF9F7),
                      child: CircleAvatar(
                        radius: 38,
                        backgroundColor: Colors.grey.shade200,
                        child: const Icon(
                          Icons.person,
                          size: 44,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Dr. Ali Khan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Cardiologist',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _segmentItem('Info', 0),
                      const SizedBox(width: 8),
                      _segmentItem('Booking', 1),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select day',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6FA),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.chevron_left),
                                  onPressed: () {
                                    setState(() {
                                      _focusedMonth = DateTime(
                                        _focusedMonth.year,
                                        _focusedMonth.month - 1,
                                        1,
                                      );
                                      // show week containing first of month
                                      _displayWeekStart = _startOfWeek(
                                        _focusedMonth,
                                      );
                                    });
                                  },
                                ),
                                Text(
                                  _formatMonthYear(_focusedMonth),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.chevron_right),
                                  onPressed: () {
                                    setState(() {
                                      _focusedMonth = DateTime(
                                        _focusedMonth.year,
                                        _focusedMonth.month + 1,
                                        1,
                                      );
                                      _displayWeekStart = _startOfWeek(
                                        _focusedMonth,
                                      );
                                    });
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(7, (i) {
                                final date = _displayWeekStart.add(
                                  Duration(days: i),
                                );
                                final dayNum = date.day;
                                final isSelected = _isSameDay(
                                  date,
                                  _selectedDate,
                                );
                                return Column(
                                  children: [
                                    Text(
                                      ['M', 'T', 'W', 'T', 'F', 'S', 'S'][i],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    GestureDetector(
                                      onTap: () => setState(() {
                                        _selectedDate = date;
                                        _focusedMonth = DateTime(
                                          date.year,
                                          date.month,
                                          1,
                                        );
                                      }),
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? const Color(0xFF1FC9C0)
                                              : Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: isSelected
                                              ? []
                                              : [
                                                  BoxShadow(
                                                    color: Colors.black,
                                                    blurRadius: 6,
                                                    offset: const Offset(0, 3),
                                                  ),
                                                ],
                                        ),
                                        child: Text(
                                          '$dayNum',
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.grey.shade800,
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Select time',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Time selector (wheel pickers for hour, minute and AM/PM)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          children: [
                            // display the selected time above picker
                            Text(
                              selectedTime,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 120,
                                  child: ListWheelScrollView.useDelegate(
                                    controller: _hourController,
                                    itemExtent: 36,
                                    perspective: 0.002,
                                    physics: const FixedExtentScrollPhysics(),
                                    onSelectedItemChanged: (i) {
                                      setState(() {
                                        _selectedHourIndex = i;
                                        _updateSelectedTime();
                                      });
                                    },
                                    childDelegate:
                                        ListWheelChildBuilderDelegate(
                                          builder: (context, index) {
                                            final hour =
                                                _hours[index % _hours.length];
                                            return Center(
                                              child: Text(
                                                hour.toString(),
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            );
                                          },
                                          childCount: _hours.length,
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 60,
                                  height: 120,
                                  child: ListWheelScrollView.useDelegate(
                                    controller: _minuteController,
                                    itemExtent: 36,
                                    perspective: 0.002,
                                    physics: const FixedExtentScrollPhysics(),
                                    onSelectedItemChanged: (i) {
                                      setState(() {
                                        _selectedMinuteIndex = i;
                                        _updateSelectedTime();
                                      });
                                    },
                                    childDelegate:
                                        ListWheelChildBuilderDelegate(
                                          builder: (context, index) {
                                            final min =
                                                _minutes[index %
                                                    _minutes.length];
                                            return Center(
                                              child: Text(
                                                min,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            );
                                          },
                                          childCount: _minutes.length,
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 60,
                                  height: 120,
                                  child: ListWheelScrollView.useDelegate(
                                    controller: _periodController,
                                    itemExtent: 36,
                                    perspective: 0.002,
                                    physics: const FixedExtentScrollPhysics(),
                                    onSelectedItemChanged: (i) {
                                      setState(() {
                                        _selectedPeriodIndex = i;
                                        _updateSelectedTime();
                                      });
                                    },
                                    childDelegate:
                                        ListWheelChildBuilderDelegate(
                                          builder: (context, index) {
                                            final p =
                                                _periods[index %
                                                    _periods.length];
                                            return Center(
                                              child: Text(
                                                p,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            );
                                          },
                                          childCount: _periods.length,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: SizedBox(
                                width: 200,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // TODO: implement booking action
                                    final appointment = Appointment(
                                      doctorId: 'doc_123',
                                      date: _selectedDate,
                                      time: selectedTime,
                                      userId: 'user_456',
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1FC9C0),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: const Text(
                                    'Book now',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
      bottomNavigationBar: Material(
        elevation: 10,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: BottomNavigationBar(
            backgroundColor: const Color(0xFF1FC9C0),
            currentIndex: _currentIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              if (index == 0) {
                // Home
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              } else if (index == 1) {
                // Dashboard (current)
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardScreen(),
                  ),
                );
              } else if (index == 2) {
                // Profile
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(mrNo: '',),
                  ),
                );
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _segmentItem(String label, int idx) {
    final active = selectedTab == idx;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = idx),
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF1FC9C0) : Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.grey.shade800,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _updateSelectedTime() {
    final hour = _hours[_selectedHourIndex];
    final minute = _minutes[_selectedMinuteIndex];
    final period = _periods[_selectedPeriodIndex];
    setState(() {
      selectedTime = '$hour:$minute $period';
    });
  }

  DateTime _startOfWeek(DateTime date) {
    // Returns the Monday of the week containing the given date
    final daysToMonday = date.weekday - 1; // Monday is 1, so subtract 1
    return date.subtract(Duration(days: daysToMonday));
  }

  String _formatMonthYear(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
