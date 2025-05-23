<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>What The Snake: Database Dashboard</title>
    <link rel="stylesheet" href="style.css">
    <link href="https://fonts.googleapis.com/css2?family=Linden+Hill&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Linden Hill', serif;
            text-align: center;
            background-image: url("what_the_snake_background.png");
            background-size: cover;
            background-attachment: fixed;
            background-position: center;
            background-repeat: no-repeat;
            margin: 0;
            padding: 0;
        }

        header {
            font-size: 3em;
            padding: 20px;
            color: white;
            background-color: #841617;
            border-bottom: 5px solid #c2b8bb;
            box-shadow: 0px 4px 6px rgba(0,0,0,0.4);
        }

        #dashboard {
            background-color: rgba(53, 77, 32, 0.8);
            padding: 30px;
            margin: 60px auto;
            width: 70%;
            border-radius: 20px;
            box-shadow: 0 0 15px rgba(0,0,0,0.6);
            color: white;
        }

        h2 {
            color: #c2b8bb;
            font-size: 2em;
            margin-bottom: 10px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            color: white;
        }

        th, td {
            padding: 15px;
            border-bottom: 1px solid #c2b8bb;
        }

        button {
            background-color: #354d20;
            color: white;
            border: 2px solid #c2b8bb;
            padding: 10px 16px;
            border-radius: 8px;
            font-size: 1em;
            cursor: pointer;
        }

        button:hover {
            background-color: #6a9441;
        }

        a {
            text-decoration: none;
        }
    </style>
</head>
<body>

    <header>
        What The Snake Database
    </header>

    <section id="dashboard">
        <h2>Main Menu</h2>
        <p>Welcome! Use the options below to manage and explore snake data.</p>

        <table>
            <thead>
                <tr>
                    <th>Action</th>
                    <th>Description</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><a href="snake_view.php"><button>View Snakes</button></a></td>
                    <td>Browse the full list of snake species</td>
                </tr>
                <tr>
                    <td><a href="snake_add.html"><button>Add New Snake</button></a></td>
                    <td>Insert a new snake and its biological data</td>
                </tr>
                <tr>
                    <td><a href="ajax_snake.php"><button>Manage Snakes</button></a></td>
                    <td>Update or delete snake records (AJAX)</td>
                </tr>
                <tr>
                    <td><a href="statisicis_windows_.php"><button>Snake Statistics</button></a></td>
                    <td>View advanced stats (window functions)</td>
                </tr>
            </tbody>
        </table>
    </section>

</body>
</html>
