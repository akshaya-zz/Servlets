<html>
<head>
<link rel = "stylesheet" href = "css/score.css"/>

</head>
<body>
    <!-- Form talks to Servlet via HTTP -->
    <form action="welcome" method="post">
        <input name="username"/>
        <button type="submit">Submit</button>
    </form>

    <!-- Button opens WebSocket directly via JS -->
    <button onclick="startScore()">Watch Live Score</button>
    <div class = "card">
    <h3 id="score-card">0</h3>
    </div>

    <script>
    function startScore() {
        let socket = new WebSocket("ws://localhost:8080/welcome/score");
        socket.onmessage = function(event) {
            document.getElementById("score-card").innerHTML = event.data;
        }
    }
    </script>

</body>
</html>
