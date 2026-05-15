<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CodeSurvive - Check Your Survival</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            background: #f5f6fa;
            font-family: 'Segoe UI', system-ui, sans-serif;
            color: #1a1a2e;
            min-height: 100vh;
        }

        /* NAV */
        nav {
            background: #fff; border-bottom: 1px solid #ebebeb;
            padding: 0 2rem; height: 60px;
            display: flex; align-items: center; justify-content: space-between;
            position: sticky; top: 0; z-index: 100;
        }
        .nav-logo { font-size: 1.15rem; font-weight: 800; color: #1a1a2e; display: flex; align-items: center; gap: 0.5rem; }
        .nav-logo .logo-box {
            width: 30px; height: 30px; background: #4361ee; border-radius: 8px;
            display: flex; align-items: center; justify-content: center; color: #fff; font-size: 0.85rem;
        }
        .nav-links a {
            padding: 0.4rem 1rem; border-radius: 8px; font-size: 0.85rem;
            font-weight: 600; color: #4361ee; background: #e8f0fe; text-decoration: none;
        }
        .nav-right { display: flex; align-items: center; gap: 0.8rem; }
        .nav-avatar {
            width: 34px; height: 34px; background: linear-gradient(135deg, #4361ee, #a78bfa);
            border-radius: 50%; display: flex; align-items: center; justify-content: center;
            color: #fff; font-weight: 700; font-size: 0.85rem;
        }
        .nav-user strong { display: block; font-size: 0.85rem; }
        .nav-user span { font-size: 0.75rem; color: #aaa; }

        /* MAIN */
        .main {
            min-height: calc(100vh - 60px);
            display: flex; align-items: center; justify-content: center;
            padding: 2rem 1rem;
        }

        .container { width: 100%; max-width: 560px; }

        /* HEADER */
        .header { text-align: center; margin-bottom: 2rem; }
        .header .icon-wrap {
            width: 64px; height: 64px; background: #e8f0fe; border-radius: 18px;
            display: flex; align-items: center; justify-content: center;
            font-size: 2rem; margin: 0 auto 1rem;
        }
        .header h1 { font-size: 1.8rem; font-weight: 800; color: #1a1a2e; }
        .header p { color: #888; margin-top: 0.4rem; font-size: 0.88rem; }

        /* CARD */
        .card {
            background: #fff; border: 1px solid #ebebeb;
            border-radius: 20px; padding: 2rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
        }

        /* FORM FIELDS */
        .field { margin-bottom: 1.3rem; }
        .field label {
            display: flex; align-items: center; gap: 0.5rem;
            color: #555; font-size: 0.82rem; font-weight: 600;
            text-transform: uppercase; letter-spacing: 0.07em; margin-bottom: 0.5rem;
        }
        .field input {
            width: 100%; padding: 0.75rem 1rem;
            background: #f5f6fa; border: 1.5px solid #ebebeb;
            border-radius: 10px; color: #1a1a2e;
            font-size: 0.95rem; outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .field input::placeholder { color: #bbb; }
        .field input:focus {
            border-color: #4361ee;
            box-shadow: 0 0 0 3px rgba(67,97,238,0.12);
            background: #fff;
        }
        input[type="number"]::-webkit-inner-spin-button,
        input[type="number"]::-webkit-outer-spin-button { opacity: 0.3; }

        .divider { border: none; border-top: 1px solid #f0f1f5; margin: 1.4rem 0; }

        .submit-btn {
            width: 100%; padding: 0.9rem;
            background: #4361ee; border: none; border-radius: 12px;
            color: #fff; font-size: 0.95rem; font-weight: 700;
            cursor: pointer; transition: background 0.15s, transform 0.15s, box-shadow 0.15s;
            box-shadow: 0 4px 16px rgba(67,97,238,0.3);
        }
        .submit-btn:hover { background: #3451d1; transform: translateY(-1px); box-shadow: 0 6px 20px rgba(67,97,238,0.4); }
        .submit-btn:active { transform: translateY(0); }

        .footer-note { text-align: center; color: #bbb; font-size: 0.75rem; margin-top: 1.2rem; }
    </style>
</head>
<body>

<nav>
    <div class="nav-logo">
        <div class="logo-box">&#128200;</div>
        CodeSurvive.
    </div>
    <div class="nav-links">
        <a href="#">Dashboard</a>
    </div>
    <div class="nav-right">
        <div class="nav-user" style="text-align:right">
            <strong>You</strong>
            <span>Aspirant</span>
        </div>
        <div class="nav-avatar">A</div>
    </div>
</nav>

<div class="main">
    <div class="container">

        <div class="header">
            <div class="icon-wrap">&#129504;</div>
            <h1>Check Your Survival</h1>
            <p>Enter your stats honestly — the algorithm will do the rest.</p>
        </div>

        <form action="survival" method="post">
            <div class="card">

                <div class="field">
                    <label>&#9749; Caffeine intake per day</label>
                    <input type="number" name="coffee" placeholder="Cups of tea / coffee" min="0" required />
                </div>

                <div class="field">
                    <label>&#128564; Sleep hours per night</label>
                    <input type="number" name="sleep" placeholder="Average hours you sleep" min="0" max="24" required />
                </div>

                <div class="field">
                    <label>&#128218; Assignment backlogs</label>
                    <div style="display:flex;gap:0.7rem">
                        <input type="number" name="assignment-backlog" placeholder="Pending" min="0" required />
                        <input type="number" name="total-assignments" placeholder="Total given" min="1" required />
                    </div>
                </div>

                <div class="field">
                    <label>&#60;/&#62; LeetCode problems solved</label>
                    <input type="number" name="leetcode" placeholder="Total problems solved" min="0" required />
                </div>

                <div class="field">
                    <label>&#128196; Assessments cleared</label>
                    <div style="display:flex;gap:0.7rem">
                        <input type="number" name="assessment" placeholder="Cleared" min="0" required />
                        <input type="number" name="total-assessments" placeholder="Total given" min="1" required />
                    </div>
                </div>

                <hr class="divider" />

                <button type="submit" class="submit-btn">Calculate My Survival &#128200;</button>
            </div>
        </form>

        <p class="footer-note">No data is stored. Results are for fun and self-reflection.</p>
    </div>
</div>

</body>
</html>
