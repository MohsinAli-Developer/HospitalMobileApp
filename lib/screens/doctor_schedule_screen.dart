import 'package:flutter/material.dart';
import '../models/doctor_schedule_model.dart';
import '../models/doctors_model.dart';
import '../services/doctors_service.dart';

class DoctorScheduleScreen extends StatefulWidget {
  final int doctorId;
  final String doctorName;

  const DoctorScheduleScreen({
    super.key,
    required this.doctorId,
    required this.doctorName,
  });

  @override
  State<DoctorScheduleScreen> createState() => _DoctorScheduleScreenState();
}

class _DoctorScheduleScreenState extends State<DoctorScheduleScreen> {
  final DoctorService _doctorService = DoctorService();
  List<DoctorSchedule> schedules = [];
  List<Doctor> doctors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    try {
      // Load both schedule and doctor details
      final scheduleData = await _doctorService.getDoctorSchedule(widget.doctorId);
      final doctorsData = await _doctorService.getDoctors();
      
      // Filter current doctor from list
      final currentDoctor = doctorsData.where((d) => d.id == widget.doctorId).toList();

      setState(() {
        schedules = scheduleData;
        doctors = currentDoctor;
        isLoading = false;
      });
    } catch (e) {
      print("Data Load Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? "PM" : "AM";
    return "$hour:$minute $period";
  }

  // Group schedules by day
// Group schedules by day
Map<String, List<DoctorSchedule>> groupSchedulesByDay() {
  Map<String, List<DoctorSchedule>> grouped = {};
  
  // Day order for sorting
  final dayOrder = {
    'Monday': 1,
    'Tuesday': 2,
    'Wednesday': 3,
    'Thursday': 4,
    'Friday': 5,
    'Saturday': 6,
    'Sunday': 7,
  };
  
  for (var schedule in schedules) {
    if (!grouped.containsKey(schedule.dayName)) {
      grouped[schedule.dayName] = [];
    }
    grouped[schedule.dayName]!.add(schedule);
  }
  
  // Sort days
  var sortedKeys = grouped.keys.toList()
    ..sort((a, b) => (dayOrder[a] ?? 0).compareTo(dayOrder[b] ?? 0));
  
  Map<String, List<DoctorSchedule>> sortedGrouped = {};
  for (var key in sortedKeys) {
    // Fix: Use null-aware operator with fallback to empty list
    sortedGrouped[key] = grouped[key] ?? [];
  }
  
  return sortedGrouped;
}

  @override
  Widget build(BuildContext context) {
    final doctor = doctors.isNotEmpty ? doctors.first : null;
    final groupedSchedules = groupSchedulesByDay();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.doctorName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1FC9C0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1FC9C0)),
              ),
            )
          : doctor == null
              ? const Center(child: Text("Doctor details not found"))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Doctor Profile Card
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1FC9C0),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1FC9C0).withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                // Doctor Image
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: doctor.doctorImagePath != null && 
                                           doctor.doctorImagePath!.isNotEmpty
                                        ? Image.network(
                                            doctor.doctorImagePath!,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return Container(
                                                color: Colors.white,
                                                child: const Center(
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor: AlwaysStoppedAnimation<Color>(
                                                      Color(0xFF1FC9C0),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.white,
                                                child: const Icon(
                                                  Icons.person,
                                                  size: 60,
                                                  color: Color(0xFF1FC9C0),
                                                ),
                                              );
                                            },
                                          )
                                        : Container(
                                            color: Colors.white,
                                            child: const Icon(
                                              Icons.person,
                                              size: 60,
                                              color: Color(0xFF1FC9C0),
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                                // Doctor Name
                                Text(
                                  doctor.doctorName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                
                                // Specialization
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    doctor.specializationName ?? 'General Doctor',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                
                                // Doctor Description (if available)
                                if (doctor.doctorDescription != null && 
                                    doctor.doctorDescription!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      doctor.doctorDescription!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      // Schedule Header
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1FC9C0).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.calendar_month,
                                color: Color(0xFF1FC9C0),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Weekly Schedule',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Schedule Cards
                      groupedSchedules.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(40),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.event_busy,
                                      size: 80,
                                      color: Colors.grey[300],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No schedule available',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Check back later for appointment slots',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: groupedSchedules.length,
                              itemBuilder: (context, index) {
                                final day = groupedSchedules.keys.elementAt(index);
                                final daySchedules = groupedSchedules[day]!;
                                
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Day Header
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF1FC9C0).withOpacity(0.1),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              _getDayIcon(day),
                                              color: const Color(0xFF1FC9C0),
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              day,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Color(0xFF1FC9C0),
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              '${daySchedules.length} slot${daySchedules.length > 1 ? 's' : ''}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      // Time Slots
                                      ListView.separated(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: const EdgeInsets.all(16),
                                        itemCount: daySchedules.length,
                                        separatorBuilder: (_, __) => const Divider(
                                          height: 16,
                                          thickness: 1,
                                          indent: 8,
                                          endIndent: 8,
                                        ),
                                        itemBuilder: (context, slotIndex) {
                                          final schedule = daySchedules[slotIndex];
                                          return Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF1FC9C0).withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: const Icon(
                                                  Icons.access_time,
                                                  color: Color(0xFF1FC9C0),
                                                  size: 20,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${formatTime(schedule.timeFrom)} - ${formatTime(schedule.timeTo)}',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      'OPD Session',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[500],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 6,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.green.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: const Text(
                                                  'Available',
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                      
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
    );
  }

  IconData _getDayIcon(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return Icons.wb_sunny;
      case 'tuesday':
        return Icons.wb_sunny;
      case 'wednesday':
        return Icons.wb_sunny;
      case 'thursday':
        return Icons.wb_sunny;
      case 'friday':
        return Icons.wb_sunny;
      case 'saturday':
        return Icons.weekend;
      case 'sunday':
        return Icons.bed;
      default:
        return Icons.calendar_today;
    }
  }
}