# what_the_snake

A relational database and web interface for managing venomous snake data.

---

## Overview

**What The Snake** is a themed database-backed web application designed to manage biological data on venomous snakes. It integrates a MySQL backend with PHP, AJAX, and custom HTML/CSS to provide:

- Full CRUD functionality  
- Real-time AJAX updates  
- Secure login control  
- Statistical analysis using SQL window functions

---

## Features

- Add new snakes with full biological and venom data  
- Upload and display images per species  
- View snakes in a formatted, read-only card layout  
- Edit and delete snakes using a live AJAX interface  
- Analyze data using SQL Window Functions and transactions  
- Login/logout with role-based access control  
- Custom aesthetic with background art and typography

---

## Tech Stack

- PHP 8+  
- MySQL  
- HTML5 and CSS3  
- JavaScript (AJAX)  
- Google Fonts: Linden Hill  
- Hosted via XAMPP on localhost

---

## File Structure
/what_the_snake/
├── index.php # Dashboard landing page
├── login.php # Manager login form
├── logout.php # Ends session and clears login
├── snake_add.html # Web form to submit new snake
├── snake_view.php # Public read-only view of snakes
├── ajax_snake.php # Editable AJAX interface (manager only)
├── snake_crud.php # PHP logic for insert, update, delete
├── statisicis_windows_.php # SQL statistics and window function display
├── ajax_snake.js # AJAX request handlers
├── style.css # Project styling (Art Nouveau inspired)
├── /images/ # Uploaded snake images
└── README.md # Project documentation


---

## Login Credentials

| Role       | Username     | Password     | Permissions       |
|------------|--------------|--------------|-------------------|
| Manager    | `ccommander` | `hailcobra!` | Full CRUD access  |
| Read-Only  | `duke`       | `yojoe!`     | Select-only       |

---

## SQL Features Demonstrated

### Transaction Safety

```sql
START TRANSACTION;
UPDATE venom_yield SET dryweight_mg = dryweight_mg - 5 WHERE species_id = 1;
ROLLBACK;
```
### Window Functions
```
SELECT s.binomial, v.dryweight_mg,
       LAG(v.dryweight_mg) OVER (ORDER BY s.binomial) AS prev,
       LEAD(v.dryweight_mg) OVER (ORDER BY s.binomial) AS next
FROM species s
JOIN venom_yield v ON s.species_id = v.species_id;
```
### Running Totals by Family
```
SELECT s.family, s.binomial, v.dryweight_mg,
       SUM(v.dryweight_mg) OVER (PARTITION BY s.family ORDER BY s.binomial) AS running_total
FROM species s
JOIN venom_yield v ON s.species_id = v.species_id;
```

## How to Run Locally
1.Start Apache and MySQL using XAMPP
2.Place the project folder inside your htdocs directory
3.Open a browser and go to http://localhost/what_the_snake/
4.Use the login form at login.php to access the manager interface or continue as a viewer

##Image Upload Details

- Images are uploaded via snake_add.html

- Files are stored in the /images/ directory

- Paths are saved into the images table and displayed in snake_view.php

## Description
This project was developed as a themed exercise in database design, SQL analytics, web-based interfaces, and secure user management. It combines multiple tables linked by foreign keys and includes features commonly used in scientific data systems, such as image handling, real-time editing, and windowed analytics.

## References

###Venom and biological data:
- SnakeDB.org
- Data hosted and maintained by Sascha Steinhoff. Used for species names, venom yield metrics (dry/wet), and binomial classifications.

### Descriptions, habitats, and ecology:
- Wikipedia
- Used for general species background, regional distribution, and environmental descriptions.

### Snake images:
- Wikimedia Commons – Public domain and Creative Commons licensed images
- iNaturalist – Supplemental regional photo references

## Development Notes

This project was built using knowledge and assignments from the Database Fundamentals course, including concepts and example code provided during lectures, labs, and in-class exercises. All core logic was adapted and extended to fit the scope and theme of the final project.

Some code troubleshooting, formatting, and integration guidance was supported using ChatGPT as a learning assistant during development. All implementation decisions and customizations were made by the project author.

# Acknowledgments

Inspired by the fictional COBRA organization from G.I. Joe and the conservation legacy of Steve Irwin.
Created for academic purposes at University of Oklahoma Polytechnic Institute.



