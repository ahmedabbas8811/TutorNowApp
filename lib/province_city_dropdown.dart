import 'package:flutter/material.dart';

class ProvinceCityDropdown extends StatefulWidget {
  final Function(String) onProvinceSelected;
  final Function(String) onCitySelected;

  const ProvinceCityDropdown({
    Key? key,
    required this.onProvinceSelected,
    required this.onCitySelected,
  }) : super(key: key);

  @override
  _ProvinceCityDropdownState createState() => _ProvinceCityDropdownState();
}

class _ProvinceCityDropdownState extends State<ProvinceCityDropdown> {
  String? selectedProvince;
  String? selectedCity;

  // Sample data: Provinces and related cities
  final Map<String, List<String>> provinceCityMap = {
    'Punjab': [
    'Lahore', 'Faisalabad', 'Rawalpindi', 'Multan', 'Gujranwala', 'Sialkot', 
    'Bahawalpur', 'Sargodha', 'Jhang', 'Sheikhupura', 'Rahim Yar Khan', 
    'Dera Ghazi Khan', 'Gujrat', 'Sahiwal', 'Okara', 'Kasur', 'Mianwali', 
    'Chiniot', 'Vehari', 'Muzaffargarh', 'Attock', 'Bahawalnagar', 'Burewala', 
    'Hafizabad', 'Khanewal', 'Kot Addu', 'Muridke', 'Pakpattan', 'Narowal', 
    'Jhelum', 'Toba Tek Singh', 'Layyah', 'Khushab', 'Samundri', 'Shakargarh', 
    'Fort Abbas', 'Haroonabad', 'Kabirwala', 'Kamalia', 'Khanpur', 'Alipur', 
    'Arifwala', 'Daska', 'Chichawatni', 'Jaranwala', 'Jampur', 'Mandi Bahauddin', 
    'Dipalpur', 'Tando Muhammad Khan', 'Hasilpur', 'Mailsi'
     ],

    'Sindh': [
    'Karachi', 'Hyderabad', 'Sukkur', 'Larkana', 'Mirpur Khas', 'Nawabshah', 
    'Khairpur', 'Dadu', 'Jacobabad', 'Shikarpur', 'Thatta', 'Badin', 'Tando Adam', 
    'Tando Allahyar', 'Umerkot', 'Kashmore', 'Ghotki', 'Matiari', 'Kamber Ali Khan', 
    'Hala', 'Tando Muhammad Khan', 'Mehar', 'Sanghar', 'Kotri', 'Tharparkar', 
    'Sehwan', 'Ranipur', 'Nasirabad', 'Sakrand', 'Ratodero', 'Garhi Yasin', 
    'Shahdadkot', 'Mirpur Mathelo', 'Jamshoro', 'Khipro', 'Dhoronaro', 'Digri', 
    'Pithoro', 'Bulri Shah Karim', 'Sinjhoro', 'Shahdadpur', 'Qambar', 'Gharo', 
    'Kunri', 'Mirpur Bathoro', 'Tando Bago', 'Gambat', 'Tangwani', 'Chohar Jamali', 
    'New Saeedabad', 'Johi'
     ],

    'KP': [
    'Peshawar', 'Mardan', 'Abbottabad', 'Swat', 'Mansehra', 'Kohat', 'Dera Ismail Khan', 
    'Haripur', 'Nowshera', 'Bannu', 'Charsadda', 'Hangu', 'Timergara', 'Mingora', 
    'Tank', 'Lakki Marwat', 'Karak', 'Batkhela', 'Shangla', 'Chitral', 'Dir', 
    'Upper Dir', 'Lower Dir', 'Swabi', 'Parachinar', 'Buner', 'Torghar', 'Alpuri', 
    'Mardan Khas', 'Thall', 'Shabqadar', 'Tangi', 'Matta', 'Bara', 'Kabal', 
    'Kulachi', 'Jandola', 'Khalabat', 'Dargai', 'Havelian', 'Nathiagali', 'Kalam', 
    'Balakot', 'Galiyat', 'Bisham', 'Lora', 'Barikot', 'Landi Kotal', 'Jamrud', 
    'Akora Khattak'
     ],
    'Balochistan': [
    'Quetta', 'Turbat', 'Gwadar', 'Khuzdar', 'Chaman', 'Dera Murad Jamali', 
    'Hub', 'Sibi', 'Zhob', 'Pishin', 'Kalat', 'Loralai', 'Nushki', 'Mastung', 
    'Dera Allah Yar', 'Musakhel', 'Kharan', 'Washuk', 'Qila Saifullah', 
    'Qila Abdullah', 'Panjgur', 'Lasbela', 'Usta Mohammad', 'Duki', 'Surab', 
    'Harani', 'Barkhan', 'Awaran', 'Chagai', 'Dalbandin', 'Pasni', 'Ormara', 
    'Jiwani', 'Kohlu', 'Ziarat', 'Mach', 'Kalmat', 'Sohbatpur', 'Gandawa', 
    'Hoshab', 'Shahrag', 'Naal', 'Wadh', 'Besima', 'Mekran', 'Buleda', 
    'Kund Malir', 'Uthal', 'Nok Kundi', 'Panjpai'
     ]

  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Province Dropdown
        DropdownButtonFormField<String>(
          value: selectedProvince,
          hint: const Text('Select Province'),
          items: provinceCityMap.keys.map((province) {
            return DropdownMenuItem(
              value: province,
              child: Text(province),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedProvince = value;
              selectedCity = null; // Reset city dropdown
            });
            widget.onProvinceSelected(value!);
          },
        ),
        const SizedBox(height: 15),

        // City Dropdown
        DropdownButtonFormField<String>(
          value: selectedCity,
          hint: const Text('Select City'),
          items: (selectedProvince != null)
              ? provinceCityMap[selectedProvince]!
                  .map((city) => DropdownMenuItem(
                        value: city,
                        child: Text(city),
                      ))
                  .toList()
              : [],
          onChanged: (value) {
            setState(() {
              selectedCity = value;
            });
            widget.onCitySelected(value!);
          },
        ),
      ],
    );
  }
}
