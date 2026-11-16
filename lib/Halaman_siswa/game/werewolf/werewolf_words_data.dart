import 'werewolf_models.dart';

/// Bank Data Pasangan Kosakata Bahasa Inggris untuk Game Tebak Serigala (Wolf vs Sheep)
/// Menyediakan pasangan kata tematik yang berkaitan erat sehingga seru untuk ditebak dan diperdebatkan.
class WerewolfWordsData {
  static const List<WerewolfWordPair> pairs = [
    // 1. Makanan & Manis
    WerewolfWordPair(
      id: 'pair_1',
      theme: 'Food & Sweet',
      dombaWord: 'BANANA',
      dombaMeaning: 'Pisang',
      serigalaWord: 'CHOCOLATE',
      serigalaMeaning: 'Coklat',
      botDombaClues: [
        'It is a sweet fruit that grows in clusters.',
        'It has a yellow peel that you take off before eating.',
        'Monkeys really love to eat this.',
        'It is rich in potassium and great for energy.',
      ],
      botSerigalaClues: [
        'It is sweet and loved by many kids and adults.',
        'It is often brown and melts in your mouth.',
        'People eat it as a delicious dessert or snack.',
        'It is commonly used as a topping or flavor.',
      ],
      explanation: 'Banana is a yellow tropical fruit, while Chocolate is a sweet food made from roasted cacao beans.',
    ),

    // 2. Hewan Kucing-Kucingan
    WerewolfWordPair(
      id: 'pair_2',
      theme: 'Animals',
      dombaWord: 'CAT',
      dombaMeaning: 'Kucing',
      serigalaWord: 'TIGER',
      serigalaMeaning: 'Harimau',
      botDombaClues: [
        'It is a small furry pet that lives with humans.',
        'It makes a gentle purring sound when happy.',
        'It loves catching mice and playing with yarn.',
        'It has whiskers and soft paws.',
      ],
      botSerigalaClues: [
        'It is a powerful animal with sharp claws and teeth.',
        'It belongs to the feline family and loves meat.',
        'It has beautiful orange fur with dark stripes.',
        'It hunts prey quietly in the wilderness.',
      ],
      explanation: 'Cat is a small domesticated pet, while Tiger is the largest wild cat species with stripes.',
    ),

    // 3. Alat Musik Petik
    WerewolfWordPair(
      id: 'pair_3',
      theme: 'Musical Instruments',
      dombaWord: 'GUITAR',
      dombaMeaning: 'Gitar',
      serigalaWord: 'VIOLIN',
      serigalaMeaning: 'Biola',
      botDombaClues: [
        'It usually has six strings and a wooden body.',
        'You play it by strumming or plucking with fingers.',
        'Very popular in pop, acoustic, and rock music bands.',
        'It has frets along its long neck.',
      ],
      botSerigalaClues: [
        'It has four strings and produces a high pitch.',
        'You often use a horsehair bow to produce sound.',
        'Very famous in classical orchestra concerts.',
        'You rest it between your shoulder and chin to play.',
      ],
      explanation: 'Guitar has six strings and is strummed, while Violin has four strings and is played using a bow.',
    ),

    // 4. Minuman Hangat
    WerewolfWordPair(
      id: 'pair_4',
      theme: 'Beverages',
      dombaWord: 'COFFEE',
      dombaMeaning: 'Kopi',
      serigalaWord: 'TEA',
      serigalaMeaning: 'Teh',
      botDombaClues: [
        'It is a dark brew made from roasted beans.',
        'Many adults drink it in the morning to stay awake.',
        'It has caffeine and a strong aromatic smell.',
        'People often add milk, sugar, or creamer to it.',
      ],
      botSerigalaClues: [
        'It is made by soaking dried leaves in hot water.',
        'Very popular in Asian and British culture in the afternoon.',
        'It can be green, black, or herbal with a soothing taste.',
        'People drink it hot or iced with lemon.',
      ],
      explanation: 'Coffee is brewed from ground coffee beans, while Tea is brewed by steeping Camellia sinensis leaves.',
    ),

    // 5. Transportasi Udara
    WerewolfWordPair(
      id: 'pair_5',
      theme: 'Transportation',
      dombaWord: 'AIRPLANE',
      dombaMeaning: 'Pesawat Terbang',
      serigalaWord: 'HELICOPTER',
      serigalaMeaning: 'Helikopter',
      botDombaClues: [
        'It has fixed wings and travels between long-distance cities.',
        'It takes off and lands on a long airport runway.',
        'It carries hundreds of passengers high in the sky.',
        'It has jet engines under its wings.',
      ],
      botSerigalaClues: [
        'It can take off and land vertically without a runway.',
        'It has large rotating blades spinning on top of it.',
        'It can hover stationary in mid-air during rescue missions.',
        'Used often in police patrols and medical evacuations.',
      ],
      explanation: 'Airplane has fixed wings and needs a runway, while Helicopter uses spinning overhead rotors to hover and take off vertically.',
    ),

    // 6. Tenaga Medis
    WerewolfWordPair(
      id: 'pair_6',
      theme: 'Occupations',
      dombaWord: 'DOCTOR',
      dombaMeaning: 'Dokter',
      serigalaWord: 'NURSE',
      serigalaMeaning: 'Perawat',
      botDombaClues: [
        'A medical professional who diagnoses illnesses and writes prescriptions.',
        'Often wears a white coat and carries a stethoscope.',
        'Studies medicine for many years to perform surgery or treatments.',
        'Works in hospitals and clinics treating patients.',
      ],
      botSerigalaClues: [
        'Cares for hospital patients daily by taking vital signs.',
        'Assists physicians and administers prescribed medication.',
        'Wears medical scrubs and checks patient recovery.',
        'Known for kindness and empathy toward sick people.',
      ],
      explanation: 'Doctor diagnoses illnesses and prescribes medical treatment, while Nurse provides hands-on care and patient monitoring.',
    ),

    // 7. Benda Langit
    WerewolfWordPair(
      id: 'pair_7',
      theme: 'Astronomy',
      dombaWord: 'SUN',
      dombaMeaning: 'Matahari',
      serigalaWord: 'MOON',
      serigalaMeaning: 'Bulan',
      botDombaClues: [
        'It is the gigantic star at the center of our solar system.',
        'It provides warmth and bright daylight to Earth.',
        'Plants need its light for photosynthesis.',
        'It rises in the east and sets in the west.',
      ],
      botSerigalaClues: [
        'It is Earth\'s natural satellite seen clearly at night.',
        'It reflects sunlight and changes its visible phases.',
        'Astronauts landed on its dusty surface in 1969.',
        'It causes ocean tides with its gravitational pull.',
      ],
      explanation: 'Sun is a bright luminous star providing daylight, while Moon is a rocky satellite that orbits Earth and reflects sunlight.',
    ),

    // 8. Buah Segar
    WerewolfWordPair(
      id: 'pair_8',
      theme: 'Fruits',
      dombaWord: 'APPLE',
      dombaMeaning: 'Apel',
      serigalaWord: 'ORANGE',
      serigalaMeaning: 'Jeruk',
      botDombaClues: [
        'It is a round fruit with red or green smooth skin.',
        'It has a crunchy texture and white juicy flesh inside.',
        'Famous quote says eating one a day keeps the doctor away.',
        'Newton got inspired about gravity when it fell.',
      ],
      botSerigalaClues: [
        'It is a citrus fruit with a textured peel and segments.',
        'Rich in vitamin C with a sweet and sour citrus flavor.',
        'People frequently squeeze it to make fresh juice.',
        'Its name is also the name of a bright warm color.',
      ],
      explanation: 'Apple is a crunchy fruit with edible thin skin, while Orange is a citrus fruit with thick peel and segmented pulp.',
    ),

    // 9. Kendaraan Roda Dua
    WerewolfWordPair(
      id: 'pair_9',
      theme: 'Vehicles',
      dombaWord: 'BICYCLE',
      dombaMeaning: 'Sepeda',
      serigalaWord: 'MOTORCYCLE',
      serigalaMeaning: 'Sepeda Motor',
      botDombaClues: [
        'Has two wheels and pedals that you push with your legs.',
        'Eco-friendly transport that does not use gasoline.',
        'Has handlebars, a bell, and a chain to drive the wheels.',
        'Great for exercise and leisurely riding in the park.',
      ],
      botSerigalaClues: [
        'Has two wheels and an engine that runs on fuel.',
        'Much faster transport that requires wearing a helmet.',
        'Has an exhaust pipe and throttle on the handlebar.',
        'Commonly used for daily commuting on city roads.',
      ],
      explanation: 'Bicycle is human-powered by pedaling, while Motorcycle is powered by an internal combustion engine or battery.',
    ),

    // 10. Sumber Air Alam
    WerewolfWordPair(
      id: 'pair_10',
      theme: 'Nature',
      dombaWord: 'RIVER',
      dombaMeaning: 'Sungai',
      serigalaWord: 'OCEAN',
      serigalaMeaning: 'Samudra / Laut',
      botDombaClues: [
        'A natural flowing stream of fresh water.',
        'It flows across lands from mountains down to the sea.',
        'People can go rafting or fish along its muddy banks.',
        'Has riverbanks and a continuous flowing current.',
      ],
      botSerigalaClues: [
        'A vast body of saltwater that covers most of planet Earth.',
        'Home to coral reefs, whales, sharks, and deep sea life.',
        'Has gigantic rolling waves and sandy beaches on its shores.',
        'Ships sail across its deep and mysterious expanse.',
      ],
      explanation: 'River is a freshwater body flowing along a channel, while Ocean is a massive saltwater body covering over 70% of Earth.',
    ),

    // 11. Olahraga Bola
    WerewolfWordPair(
      id: 'pair_11',
      theme: 'Sports',
      dombaWord: 'BASKETBALL',
      dombaMeaning: 'Bola Basket',
      serigalaWord: 'VOLLEYBALL',
      serigalaMeaning: 'Bola Voli',
      botDombaClues: [
        'Played by dribbling an orange ball and shooting into an elevated hoop.',
        'Players bounce the ball on a wooden indoor court.',
        'Famous league is the NBA with 5 players per team.',
        'You score 2 or 3 points when the ball goes through the net.',
      ],
      botSerigalaClues: [
        'Played over a tall net without letting the ball hit the floor.',
        'Players bump, set, and spike the ball with their hands.',
        'Often played on sand at the beach or on indoor gym courts.',
        'Each team has a maximum of three touches before passing over.',
      ],
      explanation: 'Basketball involves dribbling and shooting into an elevated hoop, while Volleyball involves hitting a ball over a high net without catching.',
    ),

    // 12. Media Bacaan
    WerewolfWordPair(
      id: 'pair_12',
      theme: 'Education',
      dombaWord: 'BOOK',
      dombaMeaning: 'Buku',
      serigalaWord: 'NEWSPAPER',
      serigalaMeaning: 'Koran',
      botDombaClues: [
        'Contains written pages bound together with a cover spine.',
        'You borrow it from libraries or read novels and textbooks.',
        'Can have chapters, an author, and hundreds of printed sheets.',
        'Students use it to study subjects in school.',
      ],
      botSerigalaClues: [
        'Printed on large thin paper sheets published daily or weekly.',
        'Contains current news reports, articles, weather, and headlines.',
        'People read it in the morning alongside breakfast.',
        'Has big black bold headlines on the front page.',
      ],
      explanation: 'Book is bound pages of permanent literature or knowledge, while Newspaper is a daily/weekly periodical report on current events.',
    ),

    // 13. Perabot Tempat Duduk
    WerewolfWordPair(
      id: 'pair_13',
      theme: 'Furniture',
      dombaWord: 'CHAIR',
      dombaMeaning: 'Kursi',
      serigalaWord: 'SOFA',
      serigalaMeaning: 'Sofa',
      botDombaClues: [
        'A piece of furniture designed for one person to sit on.',
        'Usually has four legs and a firm backrest.',
        'Found at dining tables, study desks, and classrooms.',
        'Made of wood, plastic, or metal.',
      ],
      botSerigalaClues: [
        'A large upholstered couch that seats two or more people.',
        'Very comfortable with soft cushions and armrests.',
        'Located in the living room for relaxing and watching TV.',
        'People can lie down and take a nap on it.',
      ],
      explanation: 'Chair is a single-seat piece of furniture, while Sofa is a cushioned multi-person seating unit found in living rooms.',
    ),

    // 14. Alas Kaki
    WerewolfWordPair(
      id: 'pair_14',
      theme: 'Clothing',
      dombaWord: 'SHOES',
      dombaMeaning: 'Sepatu',
      serigalaWord: 'SANDALS',
      serigalaMeaning: 'Sandal',
      botDombaClues: [
        'Footwear that covers your entire foot and often ties with laces.',
        'You wear them with socks for school, sports, or formal events.',
        'Protects your feet completely from dirt, stones, and weather.',
        'Made of leather, canvas, or synthetic rubber.',
      ],
      botSerigalaClues: [
        'Open footwear held onto the foot by straps or thongs.',
        'Leaves your toes and heels exposed to the cool breeze.',
        'Commonly worn at home, on the beach, or on casual sunny days.',
        'Quick and easy to slip on without tying shoelaces.',
      ],
      explanation: 'Shoes enclose the entire foot and are worn with socks, while Sandals are open-toed footwear secured by straps.',
    ),

    // 15. Cuaca Dingin & Basah
    WerewolfWordPair(
      id: 'pair_15',
      theme: 'Weather',
      dombaWord: 'RAIN',
      dombaMeaning: 'Hujan',
      serigalaWord: 'SNOW',
      serigalaMeaning: 'Salju',
      botDombaClues: [
        'Liquid water drops that fall from grey storm clouds.',
        'You need an umbrella or raincoat to stay dry outside.',
        'Makes the ground wet and creates puddles on the street.',
        'Accompanied by thunder, lightning, and cool breeze.',
      ],
      botSerigalaClues: [
        'Frozen white ice crystals that gently float down in winter.',
        'Covers the land, roofs, and trees in a blanket of soft white.',
        'Children build snowmen and throw snowballs with it.',
        'It occurs only when temperatures drop below freezing point.',
      ],
      explanation: 'Rain is liquid water droplets falling from clouds, while Snow consists of frozen crystalline water droplets falling in winter.',
    ),
  ];

  /// Mengambil 1 pasangan kata acak untuk sesi permainan baru
  static WerewolfWordPair getRandomPair() {
    final list = List<WerewolfWordPair>.from(pairs)..shuffle();
    return list.first;
  }
}
