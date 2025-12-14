import 'package:flutter/material.dart';
import '../../../../../../core/constants/App_Colors.dart';
import 'package:kids_guard/core/constants/services/medication_service.dart';
import 'package:intl/intl.dart';

class MedicationCard extends StatefulWidget {
  final MedicationDose dose;
  final bool showMedicName;
  final VoidCallback onTapCheck;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MedicationCard({
    Key? key,
    required this.dose,
    this.showMedicName = true,
    required this.onTapCheck,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<MedicationCard> createState() => _MedicationCardState();
}

class _MedicationCardState extends State<MedicationCard> with SingleTickerProviderStateMixin {
  bool _showOptions = false;
  late AnimationController _animationController;
  late Animation<double> _optionsAnimation;
  late Animation<double> _deleteAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _optionsAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _deleteAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleOptions() {
    setState(() {
      _showOptions = !_showOptions;
      if (_showOptions) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xFFFFF0F0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.medical_services_outlined,
                  size: 32,
                  color: Color(0xFFE57373),
                ),
              ),
              
              const SizedBox(height: 16),
              

              const Text(
                'Delete Medication?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              
              const SizedBox(height: 8),
              

              Text(
                'Are you sure you want to delete "${widget.dose.medName}"?',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              
              const SizedBox(height: 24),
              

              Row(
                children: [

                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.grey.shade100,
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onDelete();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Color(0xFFFF6B6B),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete_outline, size: 18, color: Colors.white),
                          SizedBox(width: 6),
                          Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
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
  }

  bool _getIsLate() {
    if (widget.dose.taken) return false;
    
    final now = DateTime.now();
    final scheduledTime = DateTime(
      widget.dose.date.year,
      widget.dose.date.month,
      widget.dose.date.day,
      widget.dose.time.hour,
      widget.dose.time.minute,
    );
    
    return now.isAfter(scheduledTime.add(const Duration(minutes: 30)));
  }

  bool _getIsUpcoming() {
    if (widget.dose.taken) return false;
    
    final now = DateTime.now();
    final scheduledTime = DateTime(
      widget.dose.date.year,
      widget.dose.date.month,
      widget.dose.date.day,
      widget.dose.time.hour,
      widget.dose.time.minute,
    );
    
    final difference = scheduledTime.difference(now);
    return difference.inMinutes <= 30 && difference.inMinutes > 0;
  }

  @override
  Widget build(BuildContext context) {
    final scheduled = TimeOfDay(
      hour: widget.dose.time.hour,
      minute: widget.dose.time.minute,
    ).format(context);
    
    final taken = widget.dose.taken;
    final isLate = _getIsLate();
    final isUpcoming = _getIsUpcoming();
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          GestureDetector(
            onTap: _toggleOptions,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: taken ? Colors.grey.shade50 : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: isLate ? Color(0xFFFFE0E0) : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onTapCheck,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: taken ? AppColors.lightBlue.withOpacity(0.2) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: taken ? AppColors.lightBlue : Colors.grey.shade300,
                          width: taken ? 2 : 1.5,
                        ),
                        boxShadow: taken ? [
                          BoxShadow(
                            color: AppColors.lightBlue.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          )
                        ] : null,
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: taken
                              ? Icon(
                                  Icons.check_rounded,
                                  color: AppColors.lightBlue,
                                  size: 24,
                                  key: const ValueKey('checked'),
                                )
                              : Icon(
                                  Icons.circle_outlined,
                                  color: isLate ? Color(0xFFFF6B6B) : Colors.grey.shade400,
                                  size: 24,
                                  key: const ValueKey('unchecked'),
                                ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 14),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // اسم الدواء
                        Row(
                          children: [
                            Text(
                              widget.dose.medName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: taken ? Colors.grey.shade600 : Colors.black87,
                                decoration: taken ? TextDecoration.lineThrough : TextDecoration.none,
                              ),
                            ),
                            
                            const SizedBox(width: 6),
                            
                            if (isLate && !taken)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFE0E0),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Late',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFFFF6B6B),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            
                            if (isUpcoming && !taken)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Color(0xFFE3F2FD),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Soon',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.lightBlue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        
                        const SizedBox(height: 4),
                        
                        RichText(
                          text: TextSpan(
                            children: [

                              TextSpan(
                                text: widget.dose.dosage,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: taken ? Colors.grey.shade500 : Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              

                              TextSpan(
                                text: ' • ',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: taken ? Colors.grey.shade400 : Colors.grey.shade500,
                                ),
                              ),
                              

                              WidgetSpan(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.access_time_rounded,
                                      size: 14,
                                      color: taken ? Colors.grey.shade400 : Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      scheduled,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: taken ? Colors.grey.shade500 : Colors.black54,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        if (taken && widget.dose.takenAt != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Taken at ${DateFormat('h:mm a').format(widget.dose.takenAt!)}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.lightBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  

                  AnimatedRotation(
                    duration: const Duration(milliseconds: 300),
                    turns: _showOptions ? 0.5 : 0,
                    child: Icon(
                      Icons.arrow_drop_down_rounded,
                      color: AppColors.lightBlue,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SizeTransition(
            sizeFactor: _optionsAnimation,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: widget.onEdit,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Color(0xFFE8F4FD),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit_rounded,
                              size: 18,
                              color: AppColors.lightBlue,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Edit',
                              style: TextStyle(
                                color: AppColors.lightBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  Expanded(
                    child: GestureDetector(
                      onTap: _showDeleteConfirmation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFF0F0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete_outline_rounded,
                              size: 18,
                              color: Color(0xFFFF6B6B),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Delete',
                              style: TextStyle(
                                color: Color(0xFFFF6B6B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}