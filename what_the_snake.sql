-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 30, 2025 at 12:08 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `what_the_snake`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddExtractionSafely` (IN `snake_id` INT, IN `extract_amount` DECIMAL(10,2))   BEGIN
    DECLARE snake_exists INT;

    -- Declare error handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION  
    BEGIN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Snake does not exist!';
    END;

    -- Check if snake exists
    SELECT COUNT(*) INTO snake_exists FROM species WHERE species_id = snake_id;

    IF snake_exists = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Snake does not exist!';
    END IF;

    -- Insert extraction record
    INSERT INTO Venom_Extractions (species_id, amount_extracted_ml)
    VALUES (snake_id, extract_amount);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddSnake` (IN `binomial_name` VARCHAR(255), IN `common_name` VARCHAR(255), IN `fam_name` VARCHAR(255))   BEGIN
    INSERT INTO species (binomial, common_name, family)
    VALUES (binomial_name, common_name, fam_name);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteSnakeSafely` (IN `snake_id` INT)   BEGIN
    DECLARE venom_count INT;

    -- Declare error handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION  
    BEGIN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Snake cannot be deleted!';
    END;

    -- Check if snake has venom data
    SELECT COUNT(*) INTO venom_count FROM venom_yield WHERE species_id = snake_id;

    IF venom_count > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Snake has venom records!';
    END IF;

    -- Delete snake if safe
    DELETE FROM species WHERE species_id = snake_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetLowVenomYield` ()   BEGIN
    DECLARE total_rows INT;

    SELECT * FROM venom_yield WHERE dryweight_mg < 10;
    SELECT FOUND_ROWS() INTO total_rows;

    IF total_rows = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No snakes with low venom yield found.';
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetSnakesByFamily` (IN `fam_name` VARCHAR(255))   BEGIN
    SELECT * FROM species
    WHERE family = fam_name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateSnakeFamilySafely` (IN `snake_id` INT, IN `new_family` VARCHAR(255))   BEGIN
    DECLARE family_exists INT;

    -- Declare error handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION  
    BEGIN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Invalid family!';
    END;

    -- Check if family exists
    SELECT COUNT(*) INTO family_exists FROM Families WHERE family_name = new_family;

    IF family_exists = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Family does not exist!';
    END IF;

    -- Update snake family
    UPDATE species SET family = new_family WHERE species_id = snake_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateVenomYield` (IN `snake_id` INT, IN `new_dryweight` DECIMAL(10,2))   BEGIN
    UPDATE venom_yield
    SET dryweight_mg = new_dryweight
    WHERE species_id = snake_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `descriptions`
--

CREATE TABLE `descriptions` (
  `species_id` int(11) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `descriptions`
--

INSERT INTO `descriptions` (`species_id`, `description`) VALUES
(1, 'Naja ashei, known as Ashe’s Spitting Cobra, is the largest spitting cobra in the world, reaching lengths of up to 2.7 meters (8.9 feet). Native to eastern Africa, particularly Kenya, Ethiopia, Somalia, and Tanzania, this cobra inhabits savannas, semi-arid regions, and scrublands. It is typically brown to olive-grey in color with a paler underside, and it displays a broad hood when threatened. Like other spitting cobras, Naja ashei can project venom up to 3 meters (10 feet), aiming for the eyes of potential threats. Its venom is a potent mix of neurotoxins and cytotoxins, capable of causing severe pain, tissue damage, and temporary or permanent blindness if it enters the eyes. Bites may result in necrosis and systemic effects, though fatalities are rare with prompt medical care. This diurnal species is oviparous, laying clutches of 10–22 eggs. Despite its defensive capabilities, it usually prefers escape over confrontation.'),
(2, 'Oxyuranus scutellatus, commonly known as the Coastal Taipan, is one of the most venomous snakes in the world, native to northern and eastern Australia and parts of southern New Guinea. This highly agile and alert elapid can grow up to 2.5 meters (8.2 feet) in length and is easily identified by its slender body, narrow head, and pale snout. Its coloration varies from light brown to dark reddish-brown, often with a lighter underbelly. The Coastal Taipan is diurnal and extremely fast, using its neurotoxic venom—containing taipoxin—to rapidly immobilize prey, mainly small mammals like rats. Without treatment, bites are almost always fatal due to respiratory paralysis and coagulopathy, but modern antivenom has greatly reduced fatalities. This species is oviparous, laying clutches of 7–20 eggs. Despite its fearsome reputation, it generally avoids human contact and will flee if given the chance.'),
(3, 'Bitis rhinoceros, commonly known as the Rhinoceros Viper, is a large and vividly colored venomous viper native to the rainforests and woodlands of West and Central Africa. It is instantly recognizable by the pair of horn-like projections on its snout and its striking geometric pattern of blues, greens, yellows, and blacks. This heavy-bodied, slow-moving ambush predator relies on its excellent camouflage to remain undetected as it waits for prey like rodents, birds, and amphibians. Though bites are rare due to its reclusive nature, its venom contains both hemotoxic and cytotoxic components, capable of causing significant tissue damage. Unlike its relative Bitis gabonica, the Rhinoceros Viper is less likely to be encountered due to its preference for dense, undisturbed habitats. It is ovoviviparous, giving birth to live young, and plays an important role in controlling rodent populations within its ecosystem.'),
(4, 'Vipera ursinii, also known as the Meadow Viper, is a small, venomous viper native to central and southeastern Europe, including France, Italy, Hungary, and the Balkans. It thrives in high-altitude grasslands and meadows, relying on camouflage and a secretive lifestyle. This species is considered Vulnerable due to habitat loss and human activity, and is protected under international law (CITES Appendix I).'),
(5, 'Agkistrodon bilineatus, commonly known as the Cantil, is a highly venomous pit viper native to Mexico and parts of Central America, including Guatemala, El Salvador, and Honduras. Known for its bold coloration and triangular head, it inhabits lowland forests and rocky scrublands. Juveniles display bright green or yellow tail tips used to lure prey. Although feared for its venom, the species is generally shy and avoids confrontation. It is classified as Near Threatened due to habitat loss.'),
(6, 'Naja melanoleuca, the Forest Cobra, is the largest true cobra in Africa, growing up to 3.2 meters (10.5 feet). Native to Central and West Africa, this highly venomous species inhabits lowland forests, moist savannas, and is often found near water. It is a skilled swimmer and climber, feeding on a wide range of prey including fish, amphibians, birds, and small mammals. Although bites are rare, envenomation is dangerous due to strong neurotoxins. Known for its alert and aggressive behavior, especially when cornered, the forest cobra assumes the classic hooded warning posture when threatened.'),
(7, 'Pseudechis australis, commonly called the King Brown Snake or Mulga Snake, is Australia\'s largest terrestrial venomous snake, reaching up to 3.3 meters (11 feet). Despite its name, it is not a true brown snake but part of the black snake genus (Pseudechis). Found throughout most of Australia except Victoria and Tasmania, this robust, highly variable species inhabits a wide range of environments including deserts, grasslands, forests, agricultural zones, and urban outskirts. It is venomous, with a large venom yield that can cause muscle breakdown and blood clotting issues, though fatalities are rare. It is oviparous and known for its adaptability, generalist diet, and cultural significance among Aboriginal Australians.'),
(8, 'The Tiger Snake (Notechis scutatus) is a large, highly venomous Australian elapid known for its distinctive banding that resembles a tiger’s stripes—though coloration varies widely from yellow, olive, grey, to jet-black. Found across southern Australia and Tasmania, this adaptable species thrives in wetlands and coastal habitats, and is often seen near watercourses. It is both a strong swimmer and climber, and can grow up to 2 meters (6.6 feet) in length. Tiger snakes are viviparous, giving birth to live young—with litters ranging from 20 to 30, and sometimes more. Their venom is a potent mix of neurotoxins, myotoxins, and coagulants, with a mortality rate up to 60% if untreated, though antivenom has significantly reduced fatalities. When threatened, they flatten their bodies and raise their heads in a defensive strike posture. Though protected by law, tiger snakes are a leading cause of snakebite incidents in Australia due to their wide distribution.'),
(9, 'The monocled cobra is a highly venomous snake native to South and Southeast Asia, easily recognized by the distinctive O-shaped marking on its hood. This adaptable cobra inhabits a wide range of environments—from rice paddies and wetlands to forests and urban areas—and is known to be both terrestrial and semi-aquatic. It uses potent neurotoxins in its venom, and some populations can spit venom as a defensive mechanism. Though dangerous, it typically avoids confrontation, preferring to escape unless provoked.'),
(10, 'The Mozambique spitting cobra is a highly venomous and temperamental snake native to sub-Saharan Africa. Known for its defensive ability to spit venom with precision up to 3 meters, this cobra inhabits savannas, lowlands, and areas near water. Its venom causes severe tissue damage and can cause blindness if sprayed into the eyes. Despite its danger, it often avoids confrontation and may feign death when threatened. Remarkably, it has been observed scavenging carrion and preying on venomous snakes like the black mamba—against which it has some immunity.'),
(11, 'The Siamese spitting cobra is a medium-sized, highly venomous snake found across Southeast Asia. Known for its distinctive black and white coloration and variable hood markings, this cobra is a “true spitter,” releasing a fine mist of venom rather than a directed stream. Its venom causes both neurotoxic and cytotoxic effects, potentially leading to paralysis or tissue necrosis. While typically timid by day, it becomes bolder and more defensive at night. The species is vulnerable due to habitat disruption and is known to frequent both jungles and human settlements.'),
(12, 'The butterfly viper, also known as the rhinoceros viper or river jack, is a vividly patterned, thick-bodied venomous snake found in the rainforests of West and Central Africa. Easily recognized by the horn-like scales on its nose and striking blue-green and yellow markings, this nocturnal ambush predator is both elusive and well-camouflaged. Though generally docile, it possesses one of the loudest hisses of any African snake and strikes rapidly when provoked. Its hemotoxic venom can cause severe swelling, internal bleeding, and necrosis. Despite its size and appearance, bites are rare due to its reclusive nature and forest habitat.'),
(13, 'The puff adder is one of Africa’s most widespread and deadliest vipers, responsible for more snakebite fatalities across the continent than any other species. Thick-bodied and well-camouflaged, it relies on ambush tactics and a potent cytotoxic venom to subdue its prey. When threatened, it produces a loud hissing sound, coils into a defensive posture, and strikes with remarkable speed and force. Although sluggish by nature, it can move quickly and even climb or swim. With a wide distribution from Morocco to South Africa and parts of Arabia, it thrives in a variety of grassland and savannah habitats.'),
(14, 'The red-bellied black snake is one of eastern Australia\'s most recognized and commonly encountered snakes. Sleek and glossy with black upperparts and vivid red to pink bellies, this species favors wetlands, riverbanks, and woodlands—but it’s also a visitor to suburban backyards. Despite its intimidating appearance, it is relatively shy and non-aggressive, usually retreating from humans. Its venom is potent—containing neurotoxins, myotoxins, and anticoagulants—but no human fatalities have been recorded. It preys mainly on frogs, but will also eat fish, other reptiles, and even other snakes. Though listed as Least Concern, the species is under pressure from urban development and cane toads, a toxic invasive species.'),
(15, 'Oxyuranus microlepidotus, commonly known as the Inland Taipan, Fierce Snake, or Small-scaled Snake, is considered the most venomous snake in the world based on median lethal dose (LD50) values in lab tests. Endemic to Australia, this elusive species averages 1.8 meters (5.9 feet) in length but can grow up to 2.5 meters (8.2 feet). Unlike its coastal cousin, the Inland Taipan is shy and reclusive, rarely encountered due to its remote habitat. It delivers multiple rapid bites in a single attack and almost always injects venom, which is highly specialized for killing mammals. Despite its extreme venom potency, it poses little risk to humans due to its calm temperament and isolated range. It is oviparous, lays up to two dozen eggs, and shows seasonal color changes to aid in thermoregulation. The Inland Taipan is of scientific and cultural significance, with Aboriginal Australians calling it dandarabilla.'),
(16, 'Pseudechis colletti, commonly known as Collett’s Snake, Collett’s Black Snake, or Down’s Tiger Snake, is a vividly patterned venomous snake native to Australia. Reaching lengths up to 2.6 meters (8.5 feet), it is considered the most colorful member of the Pseudechis genus, with distinctive black upperparts and irregular orange-pink crossbands. Although once thought to be only moderately venomous, its bite can cause serious effects such as rhabdomyolysis and kidney injury if untreated. Its venom shares similarities with the mulga and Papuan black snakes, with both cytotoxic and potential neurotoxic properties. Collett’s Snake is oviparous, laying up to 20 eggs per clutch, and is known for successful reproduction in captivity. Despite its venomous nature, it is a popular species in reptile collections due to its striking appearance.'),
(17, 'Pseudonaja affinis, commonly known as the Dugite, is a slender, highly venomous snake endemic to Western Australia. It belongs to the brown snake genus (Pseudonaja) and is known for its variable coloration—ranging from brown, olive, and greenish tones to nearly black—with smooth, semi-glossy scales. Typically reaching up to 1.5 meters (4.9 feet), but sometimes growing as long as 2 meters (6.6 feet), the dugite has a small, indistinct head and a fast, agile body. It is oviparous, laying up to 30 eggs per clutch, with the potential for multiple clutches in a season under optimal conditions. Dugites feed primarily on small mammals, reptiles, and other snakes, and are often found near human dwellings due to the abundance of introduced rodents. While they are generally shy, their potent venom—among the most lethal in the world—can cause severe coagulopathy and paralysis, making bites a medical emergency. Despite their danger, dugites play a vital role in rodent population control and are a familiar presence in both rural and urban environments across southwestern Australia.'),
(18, 'Pseudechis guttatus, commonly known as the Blue-bellied Black Snake or Spotted Black Snake, is a venomous elapid native to eastern Australia. Averaging around 1.2 meters (3.9 feet) in length, with some reaching up to 1.5 meters (4.9 feet), this snake is named for its distinctive bluish-black ventral coloring. Though often confused with the red-bellied black snake due to its similar symptoms of envenomation, P. guttatus is typically shy and reclusive, rarely biting unless provoked. Its venom is the second most toxic among Australian black snakes, capable of causing severe systemic symptoms such as nausea, vomiting, diarrhea, excessive sweating, and painful swelling of lymph nodes. The species is oviparous, laying between 7–12 eggs per clutch during the breeding season. It preys on frogs, lizards, and small mammals and plays an important ecological role in controlling pest populations. While potentially dangerous, this snake prefers to avoid human interaction and is seldom encountered in urban settings.'),
(19, 'Pseudonaja textilis, commonly known as the Eastern Brown Snake or Common Brown Snake, is one of Australia’s most widespread and dangerously venomous land snakes. Reaching up to 2.4 meters (7.9 feet) in length, this slender, fast-moving elapid is highly alert and often found in open areas such as grasslands, woodlands, and farmland, as well as around human settlements where its primary prey, the house mouse, is abundant. Despite its variable coloration—ranging from light brown to nearly black—it is most recognized for its pale underbelly with orange or gray blotches and small head. It is responsible for the highest number of snakebite fatalities in Australia due to its potent neurotoxic and coagulopathic venom, though bites typically occur only when the snake feels threatened. The Eastern Brown Snake is oviparous, laying 10–35 eggs per clutch, and plays a crucial ecological role in rodent population control. Its boldness, speed, and proximity to humans have earned it a formidable reputation, though it generally prefers escape over confrontation.'),
(20, 'Austrelaps superbus, commonly called the Lowland Copperhead, is a highly venomous snake native to southeastern Australia, including Tasmania. Despite its name, it is not closely related to the American copperhead (Agkistrodon contortrix). Typically measuring between 1 to 1.5 meters (3–5 feet), its coloration is highly variable, ranging from coppery brown to grey, reddish, black, or even yellowish tones—though the characteristic copper-colored head is not always present. Preferring habitats with low vegetation near water sources, it feeds on frogs, lizards, and even other snakes, including smaller individuals of its own species. The Lowland Copperhead is venomous with a neurotoxic bite capable of killing an adult human if untreated, although bites are rare and only one fatality has been recorded. It is shy and reclusive, avoiding conflict unless provoked. The species is oviparous and is declining in some areas due to habitat loss from urban development and increased fire activity.'),
(21, 'Hoplocephalus stephensii, known as Stephens\'s Banded Snake, is a highly venomous arboreal elapid native to the east coast of Australia, ranging from Kroombit Tops in southeastern Queensland to the Gosford region in New South Wales. Typically reaching 1 meter (3.3 ft) in length, and sometimes up to 1.2 meters (4 ft), this snake features alternating bands of grey/black and dirty white along its body, aiding in camouflage within forest canopies. It is nocturnal, arboreal, and displays a solitary and defensive nature. This species is viviparous, giving birth to 1–9 live young, with females breeding only every two years. It hunts small mammals, frogs, and lizards using ambush and active-search strategies, often occupying tree hollows where prey frequent. Its venom is procoagulant, causing venom-induced consumption coagulopathy (VICC), leading to internal bleeding. Although no specific antivenom exists, tiger snake antivenom has proven effective in treatment. Only one fatality has been recorded. Stephens\'s banded snake is classified as Near Threatened due to habitat fragmentation, low reproductive rates, and illegal collection. Conservation efforts in New South Wales are underway via the Saving Our Species program.'),
(22, 'Crotalus vegrandis, commonly known as the Uracoan Rattlesnake, is a venomous pit viper species endemic to Venezuela. It belongs to the family Viperidae and the genus Crotalus. This species is notably small for a rattlesnake, with recorded lengths of 636 mm (measured specimen) and a reported maximum of 684 mm. C. vegrandis is geographically restricted to the Maturín Savannah near Uracoa Municipality, in the state of Monagas, Venezuela. Little is known about its ecology or behavior due to its limited distribution and rarity in the wild. Taxonomically, it has previously been classified as a subspecies of Crotalus durissus but is now recognized as a distinct species.'),
(23, 'Pseudonaja inframacula, commonly known as the Peninsula Brown Snake, is a venomous elapid species native to South Australia. First described by Waite in 1925, this snake belongs to the Elapidae family and is part of the Pseudonaja genus, which includes several other highly venomous brown snakes. The IUCN Red List currently classifies this species as Least Concern, indicating it is not considered to be at risk of extinction. However, specific details regarding its habitat preferences, behavior, size, and venom characteristics are limited in the available literature.'),
(24, 'Pseudonaja nuchalis, commonly known as the Northern Brown Snake or Gwardar, is a highly venomous elapid snake native to northern and central Australia. Reaching lengths of up to 1.8 meters (5 ft 11 in), this slender snake exhibits a wide range of color patterns, from plain orange-brown to flecked or banded forms, with some individuals showing striking black markings around the neck or head. Despite its potent venom—capable of causing severe coagulopathy, kidney damage, and other symptoms in humans—P. nuchalis is generally shy, choosing flight over confrontation. However, when threatened, it can be extremely fast and defensive. It inhabits a variety of dry environments, including woodlands, grasslands, and even coastal forests, and is known to hide in crevices, under rocks, or in human-made debris. The northern brown snake feeds on small mammals and reptiles and can kill using both venom and constriction. It is oviparous, laying an average of 11–14 eggs per clutch, though some females may lay up to 38. While poorly understood in terms of lifespan, its ecological role as a predator helps control pest populations in Australia’s diverse landscapes.'),
(25, 'Tropidechis carinatus, commonly known as the Rough-scaled Snake, is a highly venomous elapid found along the eastern coast of Australia, from mid-eastern New South Wales to the northern tip of Queensland. This medium-sized snake grows to around 70 cm in length and is named for its distinctive keeled scales, which give it a rough texture. It has a brown to olive body patterned with irregular darker blotches, and a pale greenish-grey to olive-cream underside. Despite its relatively modest size, the rough-scaled snake delivers a potent venom cocktail containing both pre- and post-synaptic neurotoxins, myotoxins, and coagulants. It is regarded as dangerously venomous and is known for its defensive nature, often striking quickly when provoked. This species is active during both day and night, and while it typically hunts on the ground, it is also a capable climber, pursuing prey like frogs, lizards, birds, and small mammals into low vegetation. Its preference for moist environments such as rainforests and creek systems makes it a rare but serious threat to bushwalkers and nature-goers in these regions. Although human encounters are uncommon, several fatalities have been documented, reinforcing its reputation as one of Australia\'s most dangerous snakes.'),
(26, 'Bungarus candidus, commonly known as the Malayan Krait or Blue Krait, is one of Southeast Asia’s most venomous snakes. This slender and highly distinctive species can grow up to 108 cm (3.5 feet) in length and is easily recognized by its alternating black or bluish-black and white crossbands along the body. An unbanded, all-black variant is also found in parts of West and Central Java. A nocturnal hunter, the Malayan krait prefers damp environments and is often encountered in rural and agricultural areas, especially during the rainy season. During the day, it remains hidden under logs, stones, or debris. At night, it actively searches for prey including other snakes, lizards, frogs, and small mammals. The venom of B. candidus is extremely potent and primarily neurotoxic, capable of causing rapid-onset paralysis and respiratory failure in untreated cases. The mortality rate in untreated human envenomation can be as high as 60–70%. Despite its dangerous venom, the Malayan krait is generally docile and rarely bites unless provoked or handled. With its striking appearance and potent venom, the blue krait is a species of both fascination and caution across its wide Southeast Asian range.'),
(27, 'Pseudechis butleri, commonly known as the Spotted Mulga Snake or Butler\'s Black Snake, is a venomous elapid species native and endemic to the arid interior of Western Australia. Typically growing up to 1.6 meters (5.2 feet) in length, this robust snake resembles the more widespread P. australis (King Brown or Mulga Snake) but can be distinguished by its yellow-spotted or blotched appearance and fewer ventral scales. The snake\'s coloration ranges from completely black to a yellow or greenish pattern over a black base, giving it a distinctive spotted look. The head and neck are solid black, with a slightly broader neck than body. P. butleri inhabits Acacia woodlands and prefers stony, loamy, or rocky environments where it can find shelter and prey. Its venom contains systemic myotoxins, which can cause muscle damage and other systemic effects. Although it’s considered dangerously venomous, antivenom used for the common mulga snake (P. australis) is effective in treating bites from this species as well. P. butleri is oviparous, mating in spring (October–November), laying between 7 and 12 eggs in December, with hatchlings emerging 2–3 months later. It plays a key ecological role in controlling small vertebrate populations and remains a relatively elusive yet iconic species of Western Australia\'s interior.'),
(28, 'Vipera latastei, commonly known as Lataste’s Viper, is a venomous snake native to the Iberian Peninsula and parts of Northwestern Africa. With a typical length under 72 cm (28 in), this small but distinctive viper is easily recognized by its triangular head, upturned snout, and a bold zigzag dorsal pattern on a grey to brownish body. The species often features a yellow-tipped tail, which may be used as a lure to attract prey. This species inhabits dry, rocky, and scrubby environments, favoring hedgerows, forest edges, and stone walls where it can bask or hide. Though mostly terrestrial and often concealed under rocks, V. latastei is both diurnal and nocturnal, depending on temperature and season. Its venom, while not usually fatal to healthy adults, is medically significant and can cause painful swelling, hemorrhage, and systemic effects, especially if untreated. Bites are rare and typically occur when the snake is accidentally provoked. V. latastei is viviparous, giving birth to 2–13 live young, usually once every three years. Unfortunately, due to habitat loss, urban expansion, and human persecution, the species is now listed as Vulnerable by the IUCN. It is also protected under international agreements such as the Berne Convention.'),
(29, 'Atractaspis engaddensis, widely known as the Israeli Mole Viper or Burrowing Asp, is a highly venomous, secretive snake native to desert regions of the Middle East, including Israel, Jordan, Saudi Arabia, and the Sinai Peninsula of Egypt. Reaching lengths of 60–80 cm (24–31 in), it has a uniformly glossy black body, small round eyes, and indistinct head and tail ends—features that add to its stealthy, subterranean lifestyle.cWhat makes this species especially formidable is its unique sideways stabbing mechanism—it can bite laterally with a closed mouth using long, mobile fangs, allowing it to strike without warning even when restrained. Its venom contains sarafotoxins, a class of powerful cardiotoxins that can cause rapid cardiac arrest or A-V block. Despite its venom\'s strength and lack of specific antivenom, fatal bites are rare due to the shallow depth of its fangs and its generally non-aggressive behavior.The Israeli mole viper is nocturnal and thrives in desert burrows, near vegetated springs, and in human outskirts, where it feeds on small snakes, lizards, and young rodents. Reproduction occurs in late summer, with females laying 2–3 large eggs that hatch after about 3 months. Though it\'s one of the most venomous snakes in the region, its reclusive nature and specific habitat preferences mean it’s seldom encountered. Conservation-wise, it\'s currently listed as Least Concern by the IUCN, but caution is always advised when venturing into its native range.'),
(30, 'Pseudonaja guttata, known as the Speckled Brown Snake or Spotted Brown Snake, is a medium-sized venomous elapid native to northeastern inland Australia. Reaching up to 1.4 meters (4 ft 7 in) in length, it is distinguished by its straw-yellow to orange coloration, black-edged scales, and cream or yellow belly often flecked with orange. When the snake moves or bends, its speckled pattern becomes more prominent. This species is found across the dry inland zones of the Northern Territory, Queensland, and South Australia, especially in the Channel Country and surrounding arid landscapes. It preys primarily on frogs, lizards, small mammals, and birds, using its potent venom, which is reported to be 1.6 times more toxic than that of the Indian cobra (Naja naja). Despite this potency, bites to humans are rare due to the snake’s secretive nature. The speckled brown snake lays an average clutch of six eggs, and its preferred habitats include open plains, grasslands, and stony or loamy soils. It may share its environment with other species such as the curl snake (Suta suta), which has even been recorded preying upon it. Although not as infamous as other members of the Pseudonaja genus, P. guttata plays a vital role in Australia’s desert ecosystem, especially in controlling small vertebrate populations.'),
(31, 'Protobothrops flavoviridis, commonly known as the Habu, is a large, highly venomous pit viper endemic to the Ryukyu Islands of Japan, including Okinawa and the Amami Islands. Averaging 120–150 cm (4–5 ft) in length—with some reaching nearly 2.4 meters (7.9 ft)—it is the largest member of its genus and a prominent species in its native region. The habu is characterized by its slender body, triangular head, and olive-brown coloration overlaid with greenish or brown blotches edged in yellow, often merging into wavy patterns. Nocturnal and primarily terrestrial, it frequently enters buildings in search of prey like rats and mice. Although its venom contains powerful cytotoxins and hemorrhagins, the fatality rate from bites is under 1%, though 6–8% of victims may suffer permanent disabilities if untreated. Unlike most vipers, P. flavoviridis is oviparous, laying up to 18 eggs in mid-summer. Hatchlings, born after about six weeks, look identical to adults and are already venomous. Due to the species\' abundance and danger to humans, efforts were made in the early 1900s to control populations by introducing the small Asian mongoose—a move that led to unintended ecological consequences for native wildlife. One of its more bizarre human associations is its role in making habushu, a traditional Okinawan liquor in which the snake is infused into rice wine. This practice has led to overcollection in some areas, though the species is currently listed as Least Concern by the IUCN.'),
(32, 'Boiga irregularis, commonly known as the Brown Tree Snake, is a nocturnal, arboreal, rear-fanged colubrid snake native to northern and eastern Australia, Papua New Guinea, eastern Indonesia, and parts of Melanesia. Reaching up to 2 meters (6.6 feet) in its native range—and up to 3 meters (9.8 feet) in introduced populations—this agile predator is notorious for its role as one of the most ecologically destructive invasive species on Guam, where it was accidentally introduced after World War II. Coloration varies widely across its range, from light brown to reddish or olive green, often patterned with darker crossbands or blotches. It possesses vertical pupils, a large head, and a long, slender body ideal for climbing and squeezing through tight spaces. Primarily feeding on birds, lizards, frogs, bats, and small mammals, the brown tree snake played a central role in the extinction of 12 native bird species on Guam, as well as major economic damage through power outages and poultry predation. Despite being mildly venomous, its venom is not considered dangerous to adult humans, though small children may be vulnerable. This snake lays 4–12 leathery eggs in protected crevices and can breed year-round in introduced environments like Guam. Its reproductive flexibility, generalist diet, and ability to stow away in cargo make it a major concern for biosecurity across the Pacific, especially in places like Hawaii. Extensive control efforts include canine detection units, aerial acetaminophen-laced mouse bait drops, manual trapping, and public awareness campaigns. Innovative behaviors like \"\"lasso locomotion\"\"—a unique climbing method—showcase the species’ adaptability, further emphasizing the ecological risks it poses when outside its native range.'),
(33, 'Hydrodynastes gigas, commonly known as the False Water Cobra, is a large, rear-fanged colubrid snake native to the wetlands and rainforests of South America, particularly Brazil, Paraguay, Bolivia, and Argentina. This species is renowned for its dramatic defensive behavior—when threatened, it flattens its neck to mimic a cobra’s hood, hence the name. Unlike true cobras, however, it does not rear up but instead maintains a horizontal position when hooding. This visually striking snake typically grows between 2 to 3 meters (6.5 to 9.8 feet) in length, with females often larger than males. Its olive to brown body is adorned with dark spots and bands, blending well into marshy and forested surroundings. The ventral side is yellowish to brown, marked with flecks forming distinctive dotted lines. An active and diurnal species, H. gigas is a proficient swimmer and climber, often seen burrowing or exploring its environment. It feeds on a variety of prey including fish, frogs, reptiles, small mammals, and birds. In captivity, it adapts well and is known for its inquisitive nature. Though not considered dangerous to humans, this snake produces a mild venom through enlarged rear fangs. Bites can result in localized swelling or bruising, especially if the snake holds on and chews, but systemic effects are rare. Despite this, it has become increasingly popular in the exotic pet trade due to its intelligence, bold appearance, and relatively docile nature when captive-bred. As a wetland specialist, Hydrodynastes gigas plays an important ecological role in controlling amphibian and small vertebrate populations in its native range. It is listed under CITES Appendix II to monitor international trade and ensure sustainable wild populations.'),
(34, 'Aipysurus laevis, commonly known as the Olive Sea Snake or Golden Sea Snake, is a fully marine elapid found throughout the tropical Indo-Pacific, especially around the coral reefs of Australia, Indonesia, Papua New Guinea, and New Caledonia. Named for its smooth, olive-colored scales, this species can grow up to two meters in length and features a laterally compressed, paddle-like tail that makes it an agile swimmer among reefs. The olive sea snake is diurnal and feeds on crustaceans, small fish, and fish eggs, which it captures using potent venom containing enzymes that begin digesting prey from the inside out. Despite its formidable defense, it is not aggressive towards humans unless provoked, though there have been instances of males mistakenly approaching divers during mating season. This species is viviparous, giving birth to up to five live young, though larger litters have occasionally been recorded. It reaches sexual maturity between three and five years, with a typical lifespan of around 15 years. Fascinatingly, A. laevis has photoreceptive skin on its tail, helping it stay completely hidden in coral crevices during the day. Although listed as Least Concern, it faces man-made threats, primarily from prawn trawling operations, which can result in accidental capture and high mortality. The implementation of bycatch reduction devices and turtle exclusion devices has improved survival rates, but continued monitoring is necessary to ensure long-term population stability.'),
(35, 'Boiga dendrophila, commonly known as the mangrove snake or gold-ringed cat snake, is a strikingly colored rear-fanged colubrid native to Southeast Asia. One of the largest species of cat snakes, it can reach lengths of 2.4 to 2.7 meters (8–9 feet). Though considered mildly venomous, it poses little threat to humans, with no confirmed fatalities recorded. Its vivid black body with bright yellow bands makes it visually impressive and often confused with more dangerous species like the banded krait. Primarily nocturnal and often aggressive when threatened, it preys on reptiles, birds, and small mammals. Like other colubrids, it uses a Duvernoy\'s gland to deliver venom via grooved rear fangs, typically requiring a chewing motion to envenomate. Despite its name, the mangrove snake is more frequently found in tropical rainforests than in mangrove swamps.'),
(36, 'Boiga cyanea, commonly known as the green cat snake, is a large, arboreal, rear-fanged colubrid found across parts of South and Southeast Asia. This mildly venomous snake reaches lengths of up to 190 cm and is characterized by its uniform green dorsal coloration, golden-brown eyes, and a long prehensile tail, making it well-adapted for life in trees. Hatchlings are reddish-brown with green heads, transitioning to adult coloration after several months. Nocturnal and primarily lizard-eating, this species is known for its calm demeanor but may display defensive posturing with an open mouth if provoked. While its venom is not dangerous to humans, minor local symptoms such as swelling and numbness may occur after a bite. It reproduces by laying 7–14 eggs with an incubation period of around 85 days.'),
(37, 'Trimorphodon lambda, commonly known as the Sonoran lyre snake, is a slender, mildly venomous colubrid native to arid regions of the southwestern United States and northwestern Mexico. It gets its common name from the distinctive lyre-shaped pattern on its head. This nocturnal, rear-fanged species uses mild venom to subdue small prey such as lizards, birds, and rodents, and is typically non-aggressive toward humans. With vertical pupils and a somewhat flattened head, it is well adapted for life among rocks and crevices. Though secretive and rarely seen, it plays an important role in controlling local prey populations. Its venom is not considered dangerous to humans, and it is listed as Least Concern due to its wide distribution and stable populations.'),
(38, 'Thamnophis elegans, commonly known as the Western terrestrial garter snake, is a widely distributed and variable colubrid species found throughout western North America. It is recognized for its adaptability to a range of ecosystems and dietary flexibility, including both aquatic and terrestrial prey. This medium-sized snake typically features a light dorsal stripe with additional lateral stripes, though coloration and patterning vary significantly by region. Some populations are known to constrict prey—a behavior uncommon among garter snakes—and others produce mildly myonecrotic venom, although its effects on humans are minor. The species is ovoviviparous and produces live young in late summer.'),
(39, 'Hypsiglena torquata, commonly known as the Sinaloan night snake, is a rear-fanged colubrid endemic to western Mexico. Despite being mildly venomous, it poses no threat to humans and uses its venom to subdue small lizards and other prey. It is a small, slender snake, typically measuring between 30–66 cm in length, and is most recognizable by its pale gray or beige body marked with darker blotches and a characteristic bar behind each eye. With vertical pupils and crepuscular to nocturnal habits, it is well-adapted to life in arid environments. Like others in its genus, H. torquata is elusive, often seen crossing roads at night or hiding under rocks during the day.'),
(40, 'Hypsiglena jani, commonly known as the Texas night snake or Chihuahuan night snake, is a small, mildly venomous dipsadine species native to the southwestern United States and northeastern Mexico. Typically measuring between 25–41 cm in length, this rear-fanged snake is nocturnal and secretive, easily identified by its light gray to tan coloration with dark dorsal blotches and vertically elliptical pupils. Although equipped with mild venom to subdue prey such as lizards and small snakes, it poses no danger to humans. Its reproductive season aligns with spring rains, with females laying 4–6 eggs that hatch in late summer. H. jani thrives in arid regions with rocky terrain and is often encountered at night, especially during warm months.'),
(41, 'Heterodon nasicus, commonly known as the Western hognose snake, is a stout-bodied, diurnal colubrid native to North America. Renowned for its upturned snout—used for burrowing—this species exhibits bluffing behaviors when threatened, including hissing, mock striking, neck flattening, and even playing dead. While rear-fanged and mildly venomous, it poses no significant threat to humans. Adults typically measure 40–50 cm (15–20 inches), with males smaller than females. It primarily feeds on amphibians, particularly toads, and is well adapted to arid and sandy environments. The species is oviparous, with females laying 4–23 eggs in summer that hatch after approximately two months. In captivity, over 50 color morphs have been selectively bred, contributing to its popularity in the pet trade.'),
(42, 'Amphiesma stolatum, commonly known as the Buff striped keelback, is a small, nonvenomous colubrid snake found across South and Southeast Asia. Often mistaken for a cobra due to its threat display posture, this harmless, diurnal species is recognized by its olive-brown to grey body with two distinctive yellow stripes running along its back. It thrives in wet lowland areas and feeds mainly on frogs and toads, occasionally consuming fish, earthworms, and geckos. Females lay clutches of 5–10 eggs, typically in underground holes, and often stay with the eggs until hatching. The species is common and widespread, frequently observed during monsoon seasons and often seen inflating its body to reveal striking interscale colors when disturbed.'),
(43, 'Heterodon kennerlyi, commonly known as the Mexican hognose snake or Kennerly\'s hog-nosed snake, is a rear-fanged, mildly venomous colubrid native to the arid and semi-arid landscapes of the southwestern United States and northeastern Mexico. Named in honor of naturalist Caleb Burwell Rowan Kennerly, this snake is notable for its upturned snout, which aids in burrowing, and its striking defensive behaviors, including bluff strikes and death-feigning. Adults typically range from 38–64 cm (15–25 in) in snout-to-vent length, with a maximum recorded length of nearly 76 cm (30 in). H. kennerlyi is oviparous, laying eggs during the warmer months. Though its venom is not dangerous to humans, it is specialized to subdue small prey like amphibians and lizards.'),
(44, 'Diadophis punctatus, commonly known as the Ring-necked Snake, is a small, secretive colubrid widely distributed across North America. Recognized by its characteristic yellow, orange, or red neck ring and brightly colored underside, this nocturnal species is most active at night or during cool, overcast days. When threatened, it coils its tail to expose its vivid ventral coloration—a classic bluff defense against predators. Though it possesses mild venom delivered via rear fangs, it is harmless to humans and uses this adaptation primarily to subdue soft-bodied prey such as earthworms, salamanders, and slugs. Ring-necked snakes typically reach lengths of 25–38 cm (10–15 in), although larger individuals can grow over 50 cm. Oviparous, females lay clutches of 3–10 eggs in rotting logs or loose soil in summer. This species thrives in a variety of habitats and may form communal dens or colonies in suitable conditions.'),
(45, 'Tantilla nigriceps, commonly known as the Plains Black-headed Snake, is a small, secretive species in the family Colubridae. Typically measuring between 18–38 cm (7–15 in), this slender snake displays a uniform tan to brownish-gray dorsal coloration with a distinctive black head, and a pale belly marked by a pink or orange midline. Unlike other closely related species, it lacks a light neck collar. This fossorial species is nocturnal and rarely seen, often spending its time under rocks, in loose soil, or hidden within leaf litter. It is considered non-venomous and poses no threat to humans. Little is known about its breeding behavior, but it is believed to lay a small clutch of eggs in late spring or early summer. Hatchlings typically emerge by mid to late summer.'),
(46, 'Salvadora grahamiae, commonly known as the Eastern Patch-nosed Snake or Mountain Patchnose Snake, is a slender, fast-moving colubrid native to arid and semi-arid regions of the southwestern United States and northeastern Mexico. It can grow up to 120 cm (47 in) long and is easily identified by the distinctive “patch” or enlarged rostral scale at the tip of its snout, used to help dig through sand and debris. This diurnal snake is oviparous, laying 5–10 eggs per clutch in spring to early summer. Its diet primarily includes lizards—particularly Aspidoscelis species—along with small snakes, reptile eggs, nestling birds, and small mammals. Despite its speed and agility, S. grahamiae is non-venomous and poses no threat to humans.'),
(47, '\"Vipera ursinii, commonly known as the Meadow Viper or Orsini’s Viper, is a small venomous viper species and the most threatened snake in Europe. Measuring 40–50 cm on average (with occasional reports of individuals reaching up to 80 cm), it is the smallest viper in Europe, characterized by a thick body, narrow head, and a gray, tan, or yellowish body with a dark zigzag dorsal stripe. It is non-aggressive and highly elusive, often found in alpine meadows, steppe grasslands, or other open habitats.The species is highly sensitive to changes in land use and climate, and faces threats from grazing, agriculture, illegal collection, and habitat destruction. Due to this, it is listed as Vulnerable on the IUCN Red List and protected under CITES Appendix I and the Berne Convention.\"');

-- --------------------------------------------------------

--
-- Table structure for table `distribution`
--

CREATE TABLE `distribution` (
  `dist_id` int(11) NOT NULL,
  `species_id` int(11) DEFAULT NULL,
  `region` varchar(255) DEFAULT NULL,
  `country` text DEFAULT NULL,
  `habitat` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `distribution`
--

INSERT INTO `distribution` (`dist_id`, `species_id`, `region`, `country`, `habitat`) VALUES
(1, 1, 'Eastern & Northeastern Africa', 'Kenya, Uganda, Ethiopia, Somalia', 'Dry lowlands, semi-arid savannas, scrublands'),
(2, 2, 'Northern & Eastern Australia, Southern New Guinea', 'Australia, Papua New Guinea', 'Monsoon forests, woodlands, sugarcane fields'),
(3, 3, 'West Africa', 'Guinea, Sierra Leone, Liberia, Ivory Coast, Ghana', 'Rainforests, forest edges, humid lowland areas'),
(4, 4, 'Eastern & Coastal Southern Australia; Papua', 'Australia, Papua (Indonesia/Papua New Guinea)', 'Forests, woodlands, grasslands, shrublands; camouflages in leaf litter and debris'),
(5, 5, 'Central America', 'Mexico, Guatemala, El Salvador, Honduras', 'Lowland forests, scrublands, rocky terrain near water, often in dry to semi-arid environments'),
(6, 6, 'Central & West Africa', 'Benin, Nigeria, Cameroon, Central African Republic, Equatorial Guinea, Gabon, Republic of Congo, Democratic Republic of Congo, Angola', 'Tropical & subtropical lowland forests, moist savannas, mangroves, riverbanks, highland grasslands, urban & agricultural areas'),
(7, 7, 'Australia', 'Northern Territory, Queensland, New South Wales, South Australia, Western Australia (Absent from Victoria & Tasmania)', 'Arid to semi-arid zones, woodlands, grasslands, deserts, chenopod scrublands, agricultural land, urban edges'),
(8, 8, 'Australia', 'South Australia, Western Australia, Victoria, New South Wales, Tasmania, coastal islands (e.g., King Island, Chappell Island)', 'Coastal regions, wetlands, creeks, marshes, dams, riverbanks, temperate woodlands, agricultural land'),
(9, 9, 'South Asia, Southeast Asia, East Asia, Maritime Asia', 'India, Bangladesh, Nepal, Bhutan, Thailand, Myanmar, Laos, Cambodia, Vietnam, Southern China, Malay Peninsula (Malaysia)', 'Paddy fields, grasslands, forests, urban areas, wetlands, rodent burrows, and agricultural land, Swamps, mangroves, rice fields, shrublands, urban outskirts, and forest edges, Agricultural land, rural human settlements, lowland tropical and subtropical re'),
(10, 10, 'Southern Africa, Southeastern Africa, Central Africa, Botswana', 'South Africa (KwaZulu-Natal, Mpumalanga), Namibia, Mozambique, Malawi, Zimbabwe, Tanzania (including Pemba Island), Zambia, Angola, Botswana', 'Savanna, lowveld, near rivers or water sources, including agricultural and rural zones, Moist savannas, wetlands, grasslands, and human settlements near water, Tropical and subtropical savanna, bushveld, and riparian zones near water,  Dry woodlands and g'),
(11, 11, 'Southeast Asia', 'Thailand, Cambodia, Vietnam, Laos', 'Lowlands, hills, plains, woodlands, jungle, agricultural zones, and urban areas with rodents, Forest edges, shrublands, villages near rice paddies or water sources, Mixed terrain—woodlands, jungles, farmlands, and outskirts of towns, Forested regions, agr'),
(12, 12, 'West Africa, Central Africa, East-Central Africa', 'Guinea, Sierra Leone, Liberia, Ghana, Cameroon, Gabon, Republic of the Congo, Democratic Republic of the Congo, Central African Republic, Angola, Rwanda, Uganda, South Sudan, western Kenya', 'Dense tropical rainforests, Rainforests, near rivers and forest floors, Moist forest regions, lowland jungles, Forested zones, often near wetlands'),
(13, 13, 'North Africa, East Africa, Southern Africa, West Africa, Central Africa, Arabian Peninsula', 'Morocco (southern), parts of Egypt (excluding Mediterranean coast), Ethiopia, Uganda, Kenya, Tanzania, South Africa (Western Cape, Eastern Cape), Namibia, Zimbabwe, Botswana, Senegal, Nigeria, Mali (excluding rainforest zones), DR Congo (edge zones, not rainforest), Angola, Southwestern Saudi Arabia, Dhofar region of Oman', 'Savannahs, rocky grasslands, Highlands, grasslands, rocky outcrops, bushland, Arid shrublands, savannahs, open woodlands, Dry savannahs, open scrub, Forest borders, dry woodlands, Rocky hillsides, dry riverbeds, grasslands'),
(14, 14, 'Eastern Australia, South Australia, Northern Australia, Capital Region', 'Australia', 'Swamplands, rivers, billabongs, bushlands, woodlands, urban forest edges, Fragmented bushland, water edges, Waterways and wetland regions, Urban woodlands, wetlands'),
(15, 15, 'Channel Country and Marree-Innamincka districts, southwestern Queensland and northeastern South Australia', 'Australia', 'Arid to semi-arid zones, black soil plains, gibber deserts, chenopod shrublands, claypans, grasslands, and abandoned animal burrows'),
(16, 16, 'Central western Queensland', 'Australia', 'Arid to semi-arid plains, dry-barren zones, grasslands, and sparsely vegetated areas'),
(17, 17, 'Southern Western Australia, remote coastal parts of western South Australia', 'Australia', 'Coastal dunes, heathlands, shrublands, woodlands, degraded farmland, golf courses, industrial zones, suburban areas, and abandoned termite mounds'),
(18, 18, 'Inland southeastern Queensland and northeastern New South Wales', 'Australia', 'Grasslands, shrublands, and savannas'),
(19, 19, 'Eastern and central Australia, southern New Guinea', 'Australia, Papua New Guinea (including southern West Papua, Indonesia)', 'Dry sclerophyll forests, savannas, grasslands, shrublands, farmland, open scrub, and urban fringes'),
(20, 20, 'Southeastern Australia, including Tasmania', 'Australia', 'Damp lowland areas, woodlands, wetlands, swamps, grasslands, riparian zones, sandstone ridgetop woodlands, and areas near freshwater sources'),
(21, 21, 'Southeastern Queensland to Central New South Wales', 'Australia', 'High-rainfall remnant forests, canopy tree hollows, rocky outcrops, and dense understory regions up to 950m elevation'),
(22, 22, 'Maturín Savannah, Monagas', 'Venezuela', 'Savannah'),
(23, 23, 'South Australia', 'Australia', 'Not specifically documented'),
(24, 24, 'Northern and Central Australia', 'Australia', 'Dry open habitats such as arid shrublands, savannas, grasslands, and semi-desert areas; also found in coastal eucalypt forests and woodlands. Commonly shelters under rocks, in crevices, or man-made debris like tin or rubbish piles in urban fringe areas. O'),
(25, 25, 'Eastern Australia (from mid-eastern New South Wales to far-north Queensland)', 'Australia', 'Rainforests, moist open forests, and areas near freshwater sources such as streams and rivers. Known to forage at ground level but also climbs trees in pursuit of prey.'),
(26, 26, 'Southeast Asia', 'Thailand, Cambodia, Vietnam, Laos, Malaysia, Indonesia (including Java and Bali)', 'Lowland forests, rice paddies, plantations, and rural residential areas; often found near water sources such as streams and ditches. It is nocturnal and frequently shelters under debris, in burrows, or under logs during the day.'),
(27, 27, 'Western Australia – Midwest and Goldfields regions', 'Australia', 'Acacia woodlands with stony or loamy soils, occasionally found among rocky outcrops. The species is endemic to the Murchison region of Western Australia, with recorded sightings from Mullewa in the north to Leonora and Laverton in the south and east.'),
(28, 28, 'Southwestern Europe and Northwestern Africa', 'Portugal, Spain, Morocco, Algeria', 'Moist rocky areas in dry scrublands, woodlands, hedgerows, stone walls, and coastal dunes. Often hides under rocks and is found in elevations from sea level to mountainous regions, especially in Mediterranean climates.'),
(29, 29, 'Middle East', 'Egypt (Sinai Peninsula), Israel, Palestine, Jordan, Saudi Arabia', 'Arid to semi-arid deserts, rocky and sandy soils, desert oases, stream banks, and springs rich in vegetation. This fossorial species is primarily underground, residing in burrows, under rocks, and occasionally venturing into human settlements. It is most '),
(30, 30, 'Northeastern Australia', 'Australia', 'Arid and semi-arid inland environments including Channel Country, Mitchell Grass Downs, and Mount Isa Inlier. Found in dry grasslands, rocky terrains, and open woodlands across the eastern Northern Territory, western Queensland, and far northern South Aus'),
(31, 31, 'East Asia – Ryukyu Archipelago', 'Japan', 'Subtropical forests, rocky areas, old tombs, and agricultural edges—especially where palm forest transitions into cultivated fields. Found on larger volcanic islands like Okinawa and the Amami Islands, but absent on smaller coral islands. Common near rock'),
(32, 32, 'Northern and Eastern Coastal Australasia, Eastern Indonesia, Melanesia', 'Australia (Northern Territory, Queensland), Papua New Guinea, Indonesia (Sulawesi to Papua), Solomon Islands, Guam, and formerly detected in Saipan, Okinawa, and Hawaii', 'Forests (both primary and secondary), coastal woodlands, caves, rock crevices, limestone cliffs, grasslands, and human-altered environments. On Guam, often found in buildings, tree canopies, and thatched roofs, especially near human settlements.'),
(33, 33, 'South America (Central to Southern)', 'Brazil (central and southern regions, including Pantanal), Paraguay, Bolivia, Argentina (northern regions)', 'Primarily found in wetlands, marshes, and humid tropical forests, but it may also venture into drier scrubland and flooded savannas. Frequently inhabits areas with dense vegetation and proximity to water, such as swamps and seasonal ponds.'),
(34, 34, 'Indo-Pacific', 'Australia (including the Great Barrier Reef), Indonesia, Papua New Guinea, New Caledonia', 'Coral reef ecosystems, lagoon edges, and sheltered reef slopes in tropical marine environments. Prefers warm, shallow coastal waters, where it hides in coral crevices and rocky outcrops during the day and emerges to hunt at night. It avoids open waters, i'),
(35, 35, 'Southeast Asia', 'Cambodia, Indonesia (including Java, Borneo, Sumatra, Sulawesi, Bangka, Belitung, Riau Archipelago, Nias, Babi, Batu Archipelago), Brunei, Malaysia (Peninsular and East), Myanmar, the Philippines (including Luzon, Mindanao, Palawan, Panay, Balabac, Polillo), Singapore, Thailand, and Vietnam.', 'Primarily found in lowland tropical rainforests, this species also occurs in secondary forests and occasionally in mangrove swamps. It is largely arboreal, often inhabiting tree canopies, but may also be found on the ground or near water. Boiga dendrophil'),
(36, 36, 'South Asia, Southeast Asia, East Asia', 'Bangladesh, Bhutan, India (Sikkim, Darjeeling, Jalpaiguri, West Bengal, Assam, Arunachal Pradesh, Andaman & Nicobar Islands), Nepal, China (Yunnan), Myanmar, Thailand (including Phuket), Laos, Cambodia, Vietnam, and Malaysia (Peninsular).', 'Boiga cyanea inhabits primary and secondary forests, both terrestrial and arboreal zones, ranging from coastal lowlands to montane forests. It is particularly common in humid forested areas where it can remain hidden during the day, coiled in tree branche'),
(37, 37, 'North America', 'United States (Arizona), Mexico (Sonora, Sinaloa, Baja California, Chihuahua)', 'Trimorphodon lambda inhabits rocky desert slopes, arid canyons, and foothills with scattered vegetation. It is frequently associated with limestone outcrops and rocky cliffs, where it shelters in crevices or under rocks. This nocturnal species prefers war'),
(38, 38, 'North America', 'United States (western and central states including California, Oregon, Washington, Colorado, and Nebraska), Canada (British Columbia, Alberta, Manitoba), Mexico (northern Baja California)', 'Thamnophis elegans occupies a diverse range of habitats, including grasslands, open woodlands, riparian corridors, coniferous forests, montane meadows, and coastal marshes. It can be found from sea level to alpine zones above 3,900 meters. Populations may'),
(39, 39, 'North America (Western Mexico)', 'Mexico (Sinaloa and surrounding western states)', 'Arid and semi-arid environments, including rocky hillsides, desert scrub, and canyonlands with scattered vegetation. This species is fossorial and secretive, often sheltering under rocks, logs, and surface debris during the day. It becomes active at dusk '),
(40, 40, 'North America', 'United States (southern Kansas, southern Colorado, New Mexico, western Texas), Mexico (Chihuahua, Coahuila, Nuevo León, Zacatecas, and neighboring northeastern states)', 'Semi-arid deserts, rocky outcrops, scrublands, and dry grasslands with well-drained, sandy or stony soils. Often found beneath rocks, logs, and surface debris during the day, this crepuscular to nocturnal species becomes active after dusk. It is adapted t'),
(41, 41, 'North America', 'United States (Texas, New Mexico, Oklahoma, Kansas, Nebraska, Colorado, Missouri, Minnesota, Illinois, Arizona), Canada (southern Saskatchewan, southwestern Manitoba), Mexico (Tamaulipas, San Luis Potosí, Chihuahua, Coahuila, Sonora)', 'Arid to semi-arid environments, including prairies, grasslands, sandy scrublands, desert fringes, and floodplain regions. Prefers sandy or gravelly soils suitable for burrowing. Commonly found near river basins and semi-agricultural fields. Diurnal and fo'),
(42, 42, 'South and Southeast Asia', 'Pakistan (Sindh), India (including Andaman Islands), Nepal, Bhutan, Bangladesh, Sri Lanka, Myanmar, Thailand, Laos, Cambodia, Vietnam, Indonesia (Borneo, Sabah), Taiwan, China (Hainan, Hong Kong, Fujian, Jiangxi)', 'Well-watered lowland plains, cultivated fields, gardens, and hilly areas up to 910 meters elevation. This terrestrial, diurnal snake is often found near water sources and can swim readily. It prefers moist environments and is especially active during the '),
(43, 43, 'Southwestern United States and Northeastern Mexico', 'United States (southern Arizona, southern New Mexico, southwestern Texas), Mexico (Sonora, Chihuahua, Coahuila, Nuevo León, Tamaulipas, Zacatecas, San Luis Potosí, Durango, Jalisco, Aguascalientes)', 'Arid and semi-arid deserts, rocky scrublands, grasslands, and dry valleys. Often associated with loose, sandy or gravelly soils that support its burrowing behavior. It prefers areas with low vegetation, such as mesquite scrub or desert thorn forest. Most '),
(44, 44, 'North America (North American Woodlands, Great Plains, and Central Mexico)', 'Canada (southern Quebec, Ontario, southwestern Manitoba), United States (from the Eastern Seaboard west through the Midwest, Pacific Northwest, and parts of the Southwest), Mexico (northeastern to central highland regions)', 'Moist woodlands, riparian zones, rocky hillsides, flatland forests, and occasionally arid habitats with sufficient cover. Prefers areas with loose, moist soil and abundant debris such as logs, rocks, or leaf litter for cover. Commonly found in urban green'),
(45, 45, 'Central North America (Great Plains and southwestern deserts)', 'United States (Colorado, Kansas, Nebraska, Oklahoma, Texas, New Mexico), Mexico (northern regions)', 'Moist soil environments within rocky hillsides, grassy prairies, semi-arid foothills, and mixed-grass plains. Frequently found in areas with ample ground cover such as leaf litter, rocks, or loose soil. Occasionally enters human structures like basements.'),
(46, 46, 'Southwestern United States and Northeastern Mexico', 'United States (Arizona, New Mexico, Texas), Mexico (Chihuahua, Coahuila, Querétaro, Tamaulipas, Veracruz)', 'Found in a wide range of environments including deserts, savannas, shrublands, grasslands, and forested areas. Occupies elevations from sea level up to 1,980 meters (6,500 ft), often preferring open or semi-open terrain with scattered vegetation, rocky ou'),
(47, 47, 'Central & Southeastern Europe', 'France, Italy, Hungary, Serbia, Croatia, Bosnia & Herzegovina, North Macedonia, Albania, Romania', 'Alpine meadows, grasslands, fields, montane steppe habitats');

-- --------------------------------------------------------

--
-- Table structure for table `families`
--

CREATE TABLE `families` (
  `family_id` int(11) NOT NULL,
  `family_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `families`
--

INSERT INTO `families` (`family_id`, `family_name`) VALUES
(3, 'Colubridae'),
(1, 'Elapidae'),
(2, 'Viperidae');

-- --------------------------------------------------------

--
-- Table structure for table `images`
--

CREATE TABLE `images` (
  `image_id` int(11) NOT NULL,
  `species_id` int(11) DEFAULT NULL,
  `image_url` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `images`
--

INSERT INTO `images` (`image_id`, `species_id`, `image_url`) VALUES
(1, 1, 'https://upload.wikimedia.org/wikipedia/commons/c/c1/N_ashei.jpg'),
(2, 2, 'https://upload.wikimedia.org/wikipedia/commons/9/97/Deadly_Taipan_Snake-04%2B_%28111863661%29.jpg'),
(3, 3, 'https://upload.wikimedia.org/wikipedia/commons/b/b4/Bitis_gabonica_fangs.jpg'),
(4, 4, 'https://upload.wikimedia.org/wikipedia/commons/5/5a/CSIRO_ScienceImage_3990_Death_Adder.jpg'),
(5, 5, 'https://upload.wikimedia.org/wikipedia/commons/5/5e/Agkistrodon_bilineatus.jpg'),
(6, 6, 'https://upload.wikimedia.org/wikipedia/commons/d/d8/Naja_melanoleuca_%28cropped_2%29.png'),
(7, 7, 'https://upload.wikimedia.org/wikipedia/commons/9/9c/Pseudechis_australis_358490951.jpg'),
(8, 8, 'https://upload.wikimedia.org/wikipedia/commons/2/29/Tiger_snake_%28Notechis_scutatus%29_at_Lake_Walyungup%2C_May_2023_02.jpg'),
(9, 9, 'https://upload.wikimedia.org/wikipedia/commons/a/af/Monocled_cobra_%28cropped%29.jpg'),
(10, 10, 'https://upload.wikimedia.org/wikipedia/commons/5/50/Mozambique_spitting_cobra_%28Naja_mossambica%29.jpg'),
(11, 11, 'https://upload.wikimedia.org/wikipedia/commons/b/b4/Naja_siamensis_by_Danny_S..jpg'),
(12, 12, 'https://upload.wikimedia.org/wikipedia/commons/a/ac/Bitis_nasicornis_Nashornviper.jpg'),
(13, 13, 'https://upload.wikimedia.org/wikipedia/commons/0/07/Bitis_arietans_locomotion.gif'),
(14, 14, 'https://upload.wikimedia.org/wikipedia/commons/b/bb/Red-bellied_Black_Snake_%28Pseudechis_porphyriacus%29_%288397137495%29.jpg'),
(15, 15, 'https://upload.wikimedia.org/wikipedia/commons/f/fe/Fierce_Snake-Oxyuranus_microlepidotus.jpg'),
(16, 16, 'https://upload.wikimedia.org/wikipedia/commons/c/cc/Serpent_de_collett_ou_pseudoechis_colletti.jpg'),
(17, 17, 'https://upload.wikimedia.org/wikipedia/commons/c/c0/Pseudonaja_affinis_30418354.jpg'),
(18, 18, 'https://upload.wikimedia.org/wikipedia/commons/c/c8/Pseudechis_guttatus_223922875.jpg'),
(19, 19, 'https://upload.wikimedia.org/wikipedia/commons/d/de/Eastern_Brown_Snake_eating_an_Eastern_Blue_tongue._%288235988337%29.jpg'),
(20, 20, 'https://upload.wikimedia.org/wikipedia/commons/4/4f/LowlandcopperheadMullawallah.jpg'),
(21, 21, 'https://upload.wikimedia.org/wikipedia/commons/2/26/Hoplocephalus_stephensii_270908250.jpg'),
(22, 22, 'https://upload.wikimedia.org/wikipedia/commons/f/fa/Crotalus_vegrandis_Gen%C3%A8ve_24102014_2.jpg'),
(23, 23, 'https://upload.wikimedia.org/wikipedia/commons/8/8c/Pseudonaja_inframacula_242318329.jpg'),
(24, 24, 'https://upload.wikimedia.org/wikipedia/commons/d/d3/Pseudonaja_nuchalis_287530599.jpg'),
(25, 25, 'https://upload.wikimedia.org/wikipedia/commons/5/51/Tropcarin3.jpg'),
(26, 26, 'https://upload.wikimedia.org/wikipedia/commons/e/e8/Bungarus_candidus%2C_Blue_krait_-_Khao_Chamao_-_Khao_Wong_National_Park_%2830019398583%29.jpg'),
(27, 27, 'https://static.inaturalist.org/photos/24752418/medium.jpg'),
(28, 28, 'https://upload.wikimedia.org/wikipedia/commons/d/d5/Lataste%27s_viper.jpg'),
(29, 29, 'https://upload.wikimedia.org/wikipedia/commons/7/74/Aswad_Khabith_Snake_%28%D8%A3%D9%81%D8%B9%D9%89_%D8%A3%D8%B3%D9%88%D8%AF_%D8%AE%D8%A8%D9%8A%D8%AB%29.png'),
(30, 30, 'https://upload.wikimedia.org/wikipedia/commons/0/05/Pseudonaja_guttata_%28cropped%29.jpg'),
(31, 31, 'https://upload.wikimedia.org/wikipedia/commons/f/fb/%E3%83%8F%E3%83%96_Protobothrops_flavoviridis_%E5%A5%84%E7%BE%8E%E5%A4%A7%E5%B3%B6%E4%BD%8F%E7%94%A8%E5%B7%9D.jpg'),
(32, 32, 'https://upload.wikimedia.org/wikipedia/commons/3/3d/Brown_treesnake_on_frangipangi_blossoms_in_Guam.jpg'),
(33, 33, 'https://upload.wikimedia.org/wikipedia/commons/0/00/Brazilian_False_Water_Cobra_%28Hydrodynastes_gigas%29_on_the_road_..._%2831641157382%29.jpg'),
(34, 34, 'https://upload.wikimedia.org/wikipedia/commons/f/f0/Aipysurus_laevis_66402036.jpg'),
(35, 35, 'https://upload.wikimedia.org/wikipedia/commons/1/1a/Boiga_dendrophila%2C_Mangrove_cat_snake.jpg'),
(36, 36, 'https://upload.wikimedia.org/wikipedia/commons/d/d5/Boiga_cyanea%2C_Green_cat_snake_-_Tha_Yang_District%2C_Phetchaburi_%2827400583774%29.jpg'),
(37, 37, 'https://upload.wikimedia.org/wikipedia/commons/3/35/Sonoran_lyre_snake_Trimorphodon_lambda.jpg'),
(38, 38, 'https://upload.wikimedia.org/wikipedia/commons/d/d4/Mountain_Garter_Snake%2C_Old_Station_Ln%2C_Shingle_Springs%2C_CA%2C_US_imported_from_iNaturalist_photo_361144907.jpg'),
(39, 39, 'https://upload.wikimedia.org/wikipedia/commons/5/5b/Night_snake_New_Mexico.jpg'),
(40, 40, 'https://upload.wikimedia.org/wikipedia/commons/9/97/Chihuahuan_nightsnake_%28Hypsiglena_jani%29.jpg'),
(41, 41, 'https://upload.wikimedia.org/wikipedia/commons/7/76/Plains_Hognose_Snake_%28Heterodon_nasicus%29_%2829833441881%29.jpg'),
(42, 42, 'https://upload.wikimedia.org/wikipedia/commons/1/17/Buff-striped_Keelback_Amphiesma_stolatum_by_Dr_Raju_Kasambe_DSCN0502_%286%29.jpg'),
(43, 43, 'https://upload.wikimedia.org/wikipedia/commons/3/34/Mexican_hognose_snake_%28Heterodon_kennerlyi%29.jpg'),
(44, 44, 'https://upload.wikimedia.org/wikipedia/commons/c/cf/Coral-belly_Ringneck_Snake_%28Diadophis_punctatus_ssp._pulchellus%29.jpg'),
(45, 45, 'https://upload.wikimedia.org/wikipedia/commons/c/c3/Plains_black_headed_snake.jpg'),
(46, 46, 'https://upload.wikimedia.org/wikipedia/commons/4/4d/SNAKE%2C_MOUNTAIN_PATCH-NOSED_%28Salvadora_grahamiae%29_%283-16-11%29_sonoita_creek_state_natural_area%2C_scc_az_-01_%285532540365%29.jpg'),
(47, 47, 'https://upload.wikimedia.org/wikipedia/commons/d/d6/Vipera_ursinii_macrops.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `species`
--

CREATE TABLE `species` (
  `species_id` int(11) NOT NULL,
  `binomial` varchar(255) DEFAULT NULL,
  `common_name` varchar(255) DEFAULT NULL,
  `family` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `species`
--

INSERT INTO `species` (`species_id`, `binomial`, `common_name`, `family`) VALUES
(1, 'Naja ashei', 'Ashe\'s Spitting Cobra', 'Elapidae'),
(2, 'Oxyuranus scutellatus', 'Coastal Taipan', 'Elapidae'),
(3, 'Bitis rhinoceros', 'West African Gaboon Viper', 'Viperidae'),
(4, 'Acanthophis antarcticus', 'Common Death Adder', 'Elapidae'),
(5, 'Agkistrodon bilineatus', 'Cantil', 'Viperidae'),
(6, 'Naja melanoleuca', 'Forest Cobra', 'Elapidae'),
(7, 'Pseudechis australis', 'King Brown Snake', 'Elapidae'),
(8, 'Notechis scutatus', 'Tiger Snake', 'Elapidae'),
(9, 'Naja kaouthia', 'Monocled Cobra', 'Elapidae'),
(10, 'Naja mossambica', 'Mozambique Spitting Cobra', 'Elapidae'),
(11, 'Naja siamensis', 'Siamese Spitting Cobra', 'Elapidae'),
(12, 'Bitis nasicornis', 'Butterfly Viper', 'Viperidae'),
(13, 'Bitis arietans', 'Puff Adder', 'Viperidae'),
(14, 'Pseudechis porphyriacus', 'Red-bellied Black Snake', 'Elapidae'),
(15, 'Oxyuranus microlepidotus', 'Inland Taipan', 'Elapidae'),
(16, 'Pseudechis colletti', 'Collett\'s Snake', 'Elapidae'),
(17, 'Pseudonaja affinis', 'Dugite', 'Elapidae'),
(18, 'Pseudechis guttatus', 'Blue-bellied Black Snake', 'Elapidae'),
(19, 'Pseudonaja textilis', 'Eastern Brown Snake', 'Elapidae'),
(20, 'Austrelaps superbus', 'Lowland Copperhead', 'Elapidae'),
(21, 'Hoplocephalus stephensii', 'Stephens\'s Banded Snake', 'Elapidae'),
(22, 'Crotalus vegrandis', 'Uracoan Rattlesnake', 'Viperidae'),
(23, 'Pseudonaja inframacula', 'Peninsula Brown Snake', 'Elapidae'),
(24, 'Pseudonaja nuchalis', 'Northern Brown Snake', 'Elapidae'),
(25, 'Tropidechis carinatus', 'Rough-scaled Snake', 'Elapidae'),
(26, 'Bungarus candidus', 'Malayan Krait', 'Elapidae'),
(27, 'Pseudechis butleri', 'Spotted Mulga Snake', 'Elapidae'),
(28, 'Vipera latastei', 'Lataste\'s Viper', 'Viperidae'),
(29, 'Atractaspis engaddensis', 'Israeli Mole Viper', 'Atractaspididae'),
(30, 'Pseudonaja guttata', 'Speckled Brown Snake', 'Elapidae'),
(31, 'Protobothrops flavoviridis', 'Habu', 'Viperidae'),
(32, 'Boiga irregularis', 'Brown Tree Snake', 'Colubridae'),
(33, 'Hydrodynastes gigas', 'False Water Cobra', 'Colubridae'),
(34, 'Aipysurus laevis', 'Olive Sea Snake', 'Elapidae'),
(35, 'Boiga dendrophila', 'Mangrove Snake', 'Colubridae'),
(36, 'Boiga cyanea', 'Green Cat Snake', 'Colubridae'),
(37, 'Trimorphodon lambda', 'Sonoran Lyre Snake', 'Colubridae'),
(38, 'Thamnophis elegans', 'Western Terrestrial Garter Snake', 'Colubridae'),
(39, 'Hypsiglena torquata', 'Sinaloan Night Snake', 'Colubridae'),
(40, 'Hypsiglena jani', 'Texas Night Snake', 'Colubridae'),
(41, 'Heterodon nasicus', 'Western Hognose Snake', 'Colubridae'),
(42, 'Amphiesma stolatum', 'Buff Striped Keelback', 'Colubridae'),
(43, 'Heterodon kennerlyi', 'Mexican Hognose Snake', 'Colubridae'),
(44, 'Diadophis punctatus', 'Ring-Necked Snake', 'Colubridae'),
(45, 'Tantilla nigriceps', 'Plains Black-Headed Snake', 'Colubridae'),
(46, 'Salvadora grahamiae', 'Eastern Patch-Nosed Snake', 'Colubridae'),
(47, 'Vipera ursinii', 'Meadow Viper', 'Viperidae'),
(48, 'Testus venomus', NULL, 'Testidae'),
(49, 'Testus venomus', 'Test Snake', 'Testidae');

--
-- Triggers `species`
--
DELIMITER $$
CREATE TRIGGER `PreventSnakeDeletion` BEFORE DELETE ON `species` FOR EACH ROW BEGIN
    DECLARE dependent_count INT;

    SELECT COUNT(*) INTO dependent_count FROM venom_yield WHERE species_id = OLD.species_id;

    IF dependent_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Cannot delete species with venom data.';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_species_delete` AFTER DELETE ON `species` FOR EACH ROW BEGIN
    INSERT INTO Species_Deletion_Log (species_id, binomial, deleted_at)
    VALUES (OLD.species_id, OLD.binomial, NOW());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `species_deletion_log`
--

CREATE TABLE `species_deletion_log` (
  `log_id` int(11) NOT NULL,
  `species_id` int(11) DEFAULT NULL,
  `binomial` varchar(255) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `toxicity`
--

CREATE TABLE `toxicity` (
  `toxicity_id` int(11) NOT NULL,
  `species_id` int(11) DEFAULT NULL,
  `toxicity_level` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `toxicity`
--

INSERT INTO `toxicity` (`toxicity_id`, `species_id`, `toxicity_level`) VALUES
(1, 1, 'venomous bite – very dangerous'),
(2, 2, 'venomous bite – extremely dangerous'),
(3, 3, 'venomous bite – very dangerous'),
(4, 4, 'venomous bite – very dangerous'),
(5, 5, 'venomous bite – very dangerous'),
(6, 6, 'venomous bite – very dangerous'),
(7, 7, 'venomous bite – very dangerous'),
(8, 8, 'venomous bite – very dangerous'),
(9, 9, 'venomous bite – very dangerous'),
(10, 10, 'venomous bite – very dangerous'),
(11, 11, 'venomous bite – very dangerous'),
(12, 12, 'venomous bite – very dangerous'),
(13, 13, 'venomous bite – very dangerous'),
(14, 14, 'venomous bite – very dangerous'),
(15, 15, 'venomous bite – extremely dangerous'),
(16, 16, 'venomous bite – dangerous'),
(17, 17, 'venomous bite – very dangerous'),
(18, 18, 'venomous bite – very dangerous'),
(19, 19, 'venomous bite – very dangerous'),
(20, 20, 'venomous bite – very dangerous'),
(21, 21, 'venomous bite – dangerous'),
(22, 22, 'venomous bite – very dangerous'),
(23, 23, 'venomous bite – very dangerous'),
(24, 24, 'venomous bite – very dangerous'),
(25, 25, 'venomous bite – very dangerous'),
(26, 26, 'venomous bite – very dangerous'),
(27, 27, 'venomous bite – very dangerous'),
(28, 28, 'venomous bite – dangerous'),
(29, 29, 'venomous bite – dangerous'),
(30, 30, 'venomous bite – very dangerous'),
(31, 31, 'venomous bite – very dangerous'),
(32, 32, 'venomous bite – dangerous'),
(33, 33, 'venomous bite – potentially dangerous'),
(34, 34, 'venomous bite – very dangerous'),
(35, 35, 'venomous bite – potentially dangerous'),
(36, 36, 'venomous bite – potentially dangerous'),
(37, 37, 'venomous bite – potentially dangerous'),
(38, 38, 'venomous bite – potentially dangerous'),
(39, 39, 'venomous bite – unknown dangerousness'),
(40, 40, 'venomous bite – unknown dangerousness'),
(41, 41, 'venomous bite – potentially dangerous'),
(42, 42, 'venomous bite – potentially dangerous'),
(43, 43, 'unclear toxicity'),
(44, 44, 'venomous bite – potentially dangerous'),
(45, 45, 'venomous bite – unknown dangerousness'),
(46, 46, 'unclear toxicity'),
(47, 47, 'venomous bite – dangerous');

-- --------------------------------------------------------

--
-- Table structure for table `venom_extractions`
--

CREATE TABLE `venom_extractions` (
  `extraction_id` int(11) NOT NULL,
  `species_id` int(11) DEFAULT NULL,
  `amount_extracted_ml` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `venom_extractions`
--

INSERT INTO `venom_extractions` (`extraction_id`, `species_id`, `amount_extracted_ml`) VALUES
(1, 1, 2.00);

--
-- Triggers `venom_extractions`
--
DELIMITER $$
CREATE TRIGGER `ReduceWetVolumeAfterExtraction` AFTER INSERT ON `venom_extractions` FOR EACH ROW BEGIN
    UPDATE venom_yield
    SET wetvolume_ml = wetvolume_ml - NEW.amount_extracted_ml
    WHERE species_id = NEW.species_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `venom_yield`
--

CREATE TABLE `venom_yield` (
  `yield_id` int(11) NOT NULL,
  `species_id` int(11) DEFAULT NULL,
  `wetweight_mg` decimal(10,2) DEFAULT NULL,
  `wetvolume_ml` decimal(10,2) DEFAULT NULL,
  `dryweight_mg` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `venom_yield`
--

INSERT INTO `venom_yield` (`yield_id`, `species_id`, `wetweight_mg`, `wetvolume_ml`, `dryweight_mg`) VALUES
(1, 1, 7100.00, 4.20, 2994.00),
(2, 2, 4900.00, NULL, 882.00),
(3, 3, 3611.00, NULL, 848.00),
(4, 4, 3180.80, NULL, 270.00),
(5, 5, 2862.00, NULL, 688.00),
(6, 6, 2766.00, NULL, 1102.00),
(7, 7, 2442.00, NULL, 1500.00),
(8, 8, 2257.00, NULL, 636.00),
(9, 9, 1897.00, NULL, 742.00),
(10, 10, 1806.00, NULL, 656.00),
(11, 11, 1690.00, NULL, 738.00),
(12, 12, 1475.00, NULL, 353.00),
(13, 13, 1140.00, NULL, 750.00),
(14, 14, 895.00, NULL, 298.00),
(15, 15, 883.00, NULL, 217.00),
(16, 16, 705.00, NULL, 226.00),
(17, 17, 588.00, NULL, 143.00),
(18, 18, 540.00, NULL, 213.00),
(19, 19, 536.00, NULL, 155.00),
(20, 20, 528.00, NULL, 155.00),
(21, 21, 514.00, NULL, 154.00),
(22, 22, 496.00, NULL, 129.00),
(23, 23, 298.00, NULL, 76.21),
(24, 24, 291.00, NULL, 74.00),
(25, 25, 287.00, NULL, 84.00),
(26, 26, 255.80, NULL, 67.70),
(27, 27, 220.00, NULL, 64.00),
(28, 28, 103.00, NULL, 26.00),
(29, 29, 39.00, NULL, 9.60),
(30, 30, 19.00, NULL, 6.00),
(31, 31, NULL, 1.16, 353.80),
(32, 32, NULL, 0.95, 25.00),
(33, 33, NULL, 0.84, 15.20),
(34, 34, NULL, 0.30, 150.00),
(35, 35, NULL, 0.27, 12.50),
(36, 36, NULL, 0.24, 13.16),
(37, 37, NULL, 0.15, 7.70),
(38, 38, NULL, 0.05, 0.46),
(39, 39, NULL, 0.03, 1.05),
(40, 40, NULL, 0.03, 1.05),
(41, 41, NULL, 0.03, NULL),
(42, 42, NULL, 0.02, 0.10),
(43, 43, NULL, 0.02, NULL),
(44, 44, NULL, 0.02, 2.88),
(45, 45, NULL, 0.02, 0.10),
(46, 46, NULL, 0.02, 0.60),
(47, 47, NULL, NULL, 4.00);

--
-- Triggers `venom_yield`
--
DELIMITER $$
CREATE TRIGGER `LogVenomYieldChange` AFTER UPDATE ON `venom_yield` FOR EACH ROW BEGIN
    IF OLD.dryweight_mg <> NEW.dryweight_mg THEN
        INSERT INTO Venom_Yield_Change_Log (species_id, old_dryweight_mg, new_dryweight_mg)
        VALUES (NEW.species_id, OLD.dryweight_mg, NEW.dryweight_mg);
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `SetDefaultDryweight` BEFORE INSERT ON `venom_yield` FOR EACH ROW BEGIN
    IF NEW.dryweight_mg IS NULL OR NEW.dryweight_mg <= 0 THEN
        SET NEW.dryweight_mg = 5.00; -- Default 5 mg
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `prevent_negative_dryweight` BEFORE UPDATE ON `venom_yield` FOR EACH ROW BEGIN
    IF NEW.dryweight_mg < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Dry venom yield cannot be negative.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `venom_yield_change_log`
--
-- Error reading structure for table what_the_snake.venom_yield_change_log: #1932 - Table &#039;what_the_snake.venom_yield_change_log&#039; doesn&#039;t exist in engine
-- Error reading data for table what_the_snake.venom_yield_change_log: #1064 - You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near &#039;FROM `what_the_snake`.`venom_yield_change_log`&#039; at line 1

--
-- Indexes for dumped tables
--

--
-- Indexes for table `descriptions`
--
ALTER TABLE `descriptions`
  ADD PRIMARY KEY (`species_id`);

--
-- Indexes for table `distribution`
--
ALTER TABLE `distribution`
  ADD PRIMARY KEY (`dist_id`),
  ADD KEY `species_id` (`species_id`),
  ADD KEY `idx_distribution_region_habitat` (`region`,`habitat`);

--
-- Indexes for table `families`
--
ALTER TABLE `families`
  ADD PRIMARY KEY (`family_id`),
  ADD UNIQUE KEY `family_name` (`family_name`);

--
-- Indexes for table `images`
--
ALTER TABLE `images`
  ADD PRIMARY KEY (`image_id`),
  ADD KEY `species_id` (`species_id`);

--
-- Indexes for table `species`
--
ALTER TABLE `species`
  ADD PRIMARY KEY (`species_id`),
  ADD KEY `idx_species_binomial` (`binomial`),
  ADD KEY `idx_species_commonname` (`common_name`);

--
-- Indexes for table `species_deletion_log`
--
ALTER TABLE `species_deletion_log`
  ADD PRIMARY KEY (`log_id`);

--
-- Indexes for table `toxicity`
--
ALTER TABLE `toxicity`
  ADD PRIMARY KEY (`toxicity_id`),
  ADD KEY `species_id` (`species_id`);

--
-- Indexes for table `venom_extractions`
--
ALTER TABLE `venom_extractions`
  ADD PRIMARY KEY (`extraction_id`);

--
-- Indexes for table `venom_yield`
--
ALTER TABLE `venom_yield`
  ADD PRIMARY KEY (`yield_id`),
  ADD KEY `species_id` (`species_id`),
  ADD KEY `idx_dryweight` (`dryweight_mg`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `distribution`
--
ALTER TABLE `distribution`
  MODIFY `dist_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `families`
--
ALTER TABLE `families`
  MODIFY `family_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `images`
--
ALTER TABLE `images`
  MODIFY `image_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `species`
--
ALTER TABLE `species`
  MODIFY `species_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT for table `species_deletion_log`
--
ALTER TABLE `species_deletion_log`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `toxicity`
--
ALTER TABLE `toxicity`
  MODIFY `toxicity_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `venom_extractions`
--
ALTER TABLE `venom_extractions`
  MODIFY `extraction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `venom_yield`
--
ALTER TABLE `venom_yield`
  MODIFY `yield_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `descriptions`
--
ALTER TABLE `descriptions`
  ADD CONSTRAINT `descriptions_ibfk_1` FOREIGN KEY (`species_id`) REFERENCES `species` (`species_id`);

--
-- Constraints for table `distribution`
--
ALTER TABLE `distribution`
  ADD CONSTRAINT `distribution_ibfk_1` FOREIGN KEY (`species_id`) REFERENCES `species` (`species_id`);

--
-- Constraints for table `images`
--
ALTER TABLE `images`
  ADD CONSTRAINT `images_ibfk_1` FOREIGN KEY (`species_id`) REFERENCES `species` (`species_id`);

--
-- Constraints for table `toxicity`
--
ALTER TABLE `toxicity`
  ADD CONSTRAINT `toxicity_ibfk_1` FOREIGN KEY (`species_id`) REFERENCES `species` (`species_id`);

--
-- Constraints for table `venom_yield`
--
ALTER TABLE `venom_yield`
  ADD CONSTRAINT `venom_yield_ibfk_1` FOREIGN KEY (`species_id`) REFERENCES `species` (`species_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
