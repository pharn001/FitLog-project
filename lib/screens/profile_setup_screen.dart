// profile_setup_screen.dart
//
// A premium multi-step wizard for setting up and updating the user's
// body profile and fitness/nutrition goals. Integrates with ProfileBloc.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/profile/profile_bloc.dart';
import '../blocs/profile/profile_event.dart';
import '../blocs/profile/profile_state.dart';
import '../theme/app_colors.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 5;

  // Form values
  String _gender = 'male';
  double _weight = 70.0;
  double _height = 170.0;
  int _age = 25;
  String _activityLevel = 'moderate';
  String _goal = 'maintain';

  @override
  void initState() {
    super.initState();
    // Pre-populate if profile is already loaded
    final state = context.read<ProfileBloc>().state;
    if (state is ProfileLoaded) {
      _gender = state.profile.gender;
      _weight = state.profile.weight;
      _height = state.profile.height;
      _age = state.profile.age;
      _activityLevel = state.profile.activityLevel;
      _goal = state.profile.goal;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _saveProfile();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _saveProfile() {
    context.read<ProfileBloc>().add(
          SaveProfile(
            gender: _gender,
            weight: _weight,
            height: _height,
            age: _age,
            activityLevel: _activityLevel,
            goal: _goal,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('ບັນທຶກຂໍ້ມູນຮ່າງກາຍສຳເລັດແລ້ວ 💪'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.primary,
            ),
          );
          Navigator.pop(context);
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('ເກີດຂໍ້ຜິດພາດ: ${state.message} ⚠️'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ຕັ້ງຄ່າຂໍ້ມູນຮ່າງກາຍ'),
          elevation: 0,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Progress indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ຂັ້ນຕອນທີ ${_currentStep + 1} ຈາກ $_totalSteps',
                          style: TextStyle(
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${((_currentStep + 1) / _totalSteps * 100).round()}%',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: (_currentStep + 1) / _totalSteps,
                        minHeight: 8,
                        backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              // Step content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (page) {
                    setState(() {
                      _currentStep = page;
                    });
                  },
                  children: [
                    _buildGenderStep(isDark),
                    _buildWeightHeightStep(isDark),
                    _buildAgeStep(isDark),
                    _buildActivityStep(isDark),
                    _buildGoalStep(isDark),
                  ],
                ),
              ),
              // Navigation buttons
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _prevStep,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text('ຢ້ອນກັບ'),
                        ),
                      ),
                    if (_currentStep > 0) const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _nextStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        child: Text(_currentStep == _totalSteps - 1 ? 'ບັນທຶກສຳເລັດ' : 'ຕໍ່ໄປ'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // STEP 1: GENDER
  Widget _buildGenderStep(bool isDark) {
    return _buildStepContainer(
      title: 'ລະບຸເພດຂອງທ່ານ 👤',
      subtitle: 'ເພື່ອໃຊ້ວິເຄາະອັດຕາການເຜົາຜານພື້ນຖານ (BMR) ທີ່ເໝາະສົມ',
      child: Row(
        children: [
          Expanded(
            child: _buildGenderCard(
              genderValue: 'male',
              label: 'ຜູ້ຊາຍ',
              icon: Icons.male,
              color: Colors.blue.shade400,
              isSelected: _gender == 'male',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildGenderCard(
              genderValue: 'female',
              label: 'ຜູ້ຍິງ',
              icon: Icons.female,
              color: Colors.pink.shade400,
              isSelected: _gender == 'female',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderCard({
    required String genderValue,
    required String label,
    required IconData icon,
    required Color color,
    required bool isSelected,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        setState(() {
          _gender = genderValue;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : (isDark ? AppColors.darkCard : Colors.white),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? color : (isDark ? AppColors.darkDivider : Colors.grey.shade200),
            width: 2.5,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: color.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: isSelected ? color : Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? color : (isDark ? Colors.white : Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // STEP 2: WEIGHT & HEIGHT
  Widget _buildWeightHeightStep(bool isDark) {
    return _buildStepContainer(
      title: 'ນ້ຳໜັກ ແລະ ສ່ວນສູງ 📏',
      subtitle: 'ໃຊ້ຄຳນວນດັດສະນີມວນກາຍ (BMI) ແລະ ປະລິມານພະລັງງານທີ່ຮ່າງກາຍຕ້ອງການ',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Height Slider
          _buildSliderCard(
            title: 'ສ່ວນສູງ (Height)',
            value: _height,
            min: 100,
            max: 220,
            unit: 'cm',
            onChanged: (val) {
              setState(() {
                _height = double.parse(val.toStringAsFixed(1));
              });
            },
          ),
          const SizedBox(height: 20),
          // Weight Slider
          _buildSliderCard(
            title: 'ນ້ຳໜັກ (Weight)',
            value: _weight,
            min: 30,
            max: 180,
            unit: 'kg',
            onChanged: (val) {
              setState(() {
                _weight = double.parse(val.toStringAsFixed(1));
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSliderCard({
    required String title,
    required double value,
    required double min,
    required double max,
    required String unit,
    required ValueChanged<double> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.darkDivider : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: value.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    TextSpan(
                      text: ' $unit',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Slider(
            value: value,
            min: min,
            max: max,
            activeColor: AppColors.primary,
            inactiveColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  // STEP 3: AGE
  Widget _buildAgeStep(bool isDark) {
    return _buildStepContainer(
      title: 'ອາຍຸເທົ່າໃດແລ້ວ? 🎂',
      subtitle: 'ການເຜົາຜານຈະແປຜັນຕາມອາຍຸທີ່ເພີ່ມຂຶ້ນ',
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 260),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: isDark ? AppColors.darkDivider : Colors.grey.shade200),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$_age',
                style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const Text(
                'ປີ (Years)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildRoundButton(
                    icon: Icons.remove,
                    onPressed: () {
                      if (_age > 1) {
                        setState(() => _age--);
                      }
                    },
                  ),
                  _buildRoundButton(
                    icon: Icons.add,
                    onPressed: () {
                      if (_age < 120) {
                        setState(() => _age++);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoundButton({required IconData icon, required VoidCallback onPressed}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
        ),
        child: Icon(icon, size: 28, color: AppColors.primary),
      ),
    );
  }

  // STEP 4: ACTIVITY LEVEL
  Widget _buildActivityStep(bool isDark) {
    return _buildStepContainer(
      title: 'ກິດຈະກຳໃນແຕ່ລະວັນຂອງທ່ານ 🏃',
      subtitle: 'ເລືອກພຶດຕິກຳທີ່ກົງກັບຊີວິດປະຈຳວັນຂອງທ່ານຫຼາຍທີ່ສຸດ',
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildSelectionCard(
              value: 'sedentary',
              title: 'ນັ່ງເຮັດວຽກເປັນຫຼັກ',
              desc: 'ອອກກຳລັງກາຍເລັກນ້ອຍ ຫຼື ແທບບໍ່ໄດ້ອອກເລີຍ',
              icon: Icons.desk,
              isSelected: _activityLevel == 'sedentary',
            ),
            const SizedBox(height: 10),
            _buildSelectionCard(
              value: 'light',
              title: 'ຂະຫຍັບຕົວໜ້ອຍ',
              desc: 'ອອກກຳລັງກາຍເບົາໆ 1-3 ວັນ/ອາທິດ',
              icon: Icons.directions_walk,
              isSelected: _activityLevel == 'light',
            ),
            const SizedBox(height: 10),
            _buildSelectionCard(
              value: 'moderate',
              title: 'ອອກກຳລັງກາຍປານກາງ',
              desc: 'ອອກກຳລັງກາຍປານກາງ 3-5 ວັນ/ອາທິດ',
              icon: Icons.fitness_center,
              isSelected: _activityLevel == 'moderate',
            ),
            const SizedBox(height: 10),
            _buildSelectionCard(
              value: 'active',
              title: 'ອອກກຳລັງກາຍໜັກ',
              desc: 'ອອກກຳລັງກາຍໜັກ 6-7 ວັນ/ອາທິດ',
              icon: Icons.run_circle_outlined,
              isSelected: _activityLevel == 'active',
            ),
            const SizedBox(height: 10),
            _buildSelectionCard(
              value: 'veryActive',
              title: 'ນັກກິລາ / ວຽກໃຊ້ແຮງງານໜັກ',
              desc: 'ອອກກຳລັງກາຍໜັກຫຼາຍ ຊ້ອມວັນລະ 2 ຄັ້ງ',
              icon: Icons.bolt,
              isSelected: _activityLevel == 'veryActive',
            ),
          ],
        ),
      ),
    );
  }

  // STEP 5: GOAL
  Widget _buildGoalStep(bool isDark) {
    return _buildStepContainer(
      title: 'ເປົ້າໝາຍສູງສຸດຂອງທ່ານແມ່ນຫຍັງ? 🎯',
      subtitle: 'ພວກເຮົາຈະຄຳນວນແຄລໍຣີທີ່ແນະນຳໃຫ້ສອດຄ່ອງກັບເປົ້າໝາຍນີ້',
      child: Column(
        children: [
          _buildSelectionCard(
            value: 'lose',
            title: 'ຫຼຸດນ້ຳໜັກ (Lose Weight)',
            desc: 'ທານໜ້ອຍກວ່າຄ່າເຜົາຜານ 500 kcal ເພື່ອດຶງໄຂມັນມາໃຊ້',
            icon: Icons.trending_down,
            isSelected: _goal == 'lose',
          ),
          const SizedBox(height: 12),
          _buildSelectionCard(
            value: 'maintain',
            title: 'ຮັກສາສົມດຸນ (Maintain Weight)',
            desc: 'ທານເທົ່າຄ່າເຜົາຜານ TDEE ເພື່ອຮັກສານ້ຳໜັກ ແລະ ສຸຂະພາບ',
            icon: Icons.balance,
            isSelected: _goal == 'maintain',
          ),
          const SizedBox(height: 12),
          _buildSelectionCard(
            value: 'gain',
            title: 'ເພີ່ມກ້າມຊີ້ນ / ນ້ຳໜັກ (Gain Muscle)',
            desc: 'ທານຫຼາຍກວ່າຄ່າເຜົາຜານ 300 kcal ຄວບຄູ່ກັບເວດເທຣນນິງ',
            icon: Icons.trending_up,
            isSelected: _goal == 'gain',
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionCard({
    required String value,
    required String title,
    required String desc,
    required IconData icon,
    required bool isSelected,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_currentStep == 3) {
            _activityLevel = value;
          } else {
            _goal = value;
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : (isDark ? AppColors.darkCard : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : (isDark ? AppColors.darkDivider : Colors.grey.shade200),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.grey.shade300.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContainer({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(child: child),
        ],
      ),
    );
  }
}
