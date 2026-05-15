<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
    String barColor(String tag) {
        switch (tag) {
            case "Excellent": case "Perfect": case "Good": case "Optimal": case "Clear": return "#1a9e5c";
            case "Great": case "Fair": case "Manageable": return "#4361ee";
            case "Okay": case "High": return "#e07b00";
            default: return "#d32f2f";
        }
    }
    String tagStyle(String tag) {
        String c = barColor(tag);
        if (c.equals("#1a9e5c")) return "background:#e6f9f0;color:#1a9e5c";
        if (c.equals("#4361ee")) return "background:#e8f0fe;color:#4361ee";
        if (c.equals("#e07b00")) return "background:#fff4e5;color:#e07b00";
        return "background:#fdecea;color:#d32f2f";
    }
%>
<%
    int survival        = (Integer) request.getAttribute("survivalPercentage");
    int coffee          = Integer.parseInt(request.getParameter("coffee"));
    int sleep           = Integer.parseInt(request.getParameter("sleep"));
    int backlog         = Integer.parseInt(request.getParameter("assignment-backlog"));
    int totalAssign     = Integer.parseInt(request.getParameter("total-assignments"));
    int leetcode        = Integer.parseInt(request.getParameter("leetcode"));
    int assessment      = Integer.parseInt(request.getParameter("assessment"));
    int totalAssess     = Integer.parseInt(request.getParameter("total-assessments"));

    double leetcodeScore   = Math.min(leetcode, 300) / 300.0 * 30;
    double assessmentScore = (assessment / (double) totalAssess) * 30;
    double sleepScore      = Math.min(sleep, 8) / 8.0 * 15;
    double coffeeScore     = (coffee >= 1 && coffee <= 3) ? 5.0 : (coffee > 3 && coffee <= 5) ? 2.5 : (coffee > 5) ? -2.5 : 0.0;
    double backlogScore    = Math.max(0, 1 - backlog / (double) totalAssign) * 20;

    String status, message, recommendation;
    if (survival >= 80) {
        status = "Strong Survivor!"; message = "You're built different. Keep it up.";
        recommendation = "Outstanding performance! Keep maintaining this consistency to ace your placements.";
    } else if (survival >= 60) {
        status = "Good Chance!"; message = "Keep pushing! You're on the right track.";
        recommendation = "Focus on reducing your assignment backlog and solving more LeetCode problems to improve your score.";
    } else if (survival >= 40) {
        status = "Risky Zone"; message = "You're on thin ice. Take action now.";
        recommendation = "Prioritize clearing your assignment backlog and getting more sleep to boost your score.";
    } else {
        status = "Critical!"; message = "Barely surviving. Intervention needed.";
        recommendation = "Urgent action needed. Address your backlogs immediately and practice more LeetCode.";
    }

    String leetcodeTag   = leetcode >= 200 ? "Excellent" : leetcode >= 100 ? "Good" : leetcode >= 50 ? "Fair" : "Low";
    double assessRatio = assessment / (double) totalAssess;
    String assessmentTag = assessRatio >= 0.9 ? "Perfect" : assessRatio >= 0.6 ? "Great" : assessRatio >= 0.3 ? "Fair" : "None";
    String sleepTag      = sleep >= 7 ? "Good" : sleep >= 5 ? "Fair" : "Poor";
    String coffeeTag     = (coffee >= 1 && coffee <= 3) ? "Optimal" : coffee == 0 ? "No Breaks" : coffee <= 5 ? "Okay" : "Burnout Risk";
    double backlogRatio  = backlog / (double) totalAssign;
    String backlogTag    = backlogRatio == 0 ? "Clear" : backlogRatio <= 0.3 ? "Manageable" : backlogRatio <= 0.7 ? "High" : "Critical";

    int leetcodeBar   = Math.min(100, (int)(leetcode / 300.0 * 100));
    int assessmentBar = (int)(assessRatio * 100);
    int sleepBar      = (int)(Math.min(sleep, 8) / 8.0 * 100);
    int coffeeBar     = coffee == 0 ? 0 : Math.min(100, (int)(Math.min(coffee, 3) / 3.0 * 100));
    int backlogBar    = (int)(Math.max(0, 1 - backlogRatio) * 100);

    double gaugeR = 70, circumference = 2 * Math.PI * gaugeR;
    double dashOffset = circumference * (1 - survival / 100.0);

    double needleSVGAngle = survival * 1.8 - 180;

    String statusColor = survival >= 80 ? "#1a9e5c" : survival >= 60 ? "#4361ee" : survival >= 40 ? "#e07b00" : "#d32f2f";
    String coffeeScoreStr = coffeeScore > 0 ? "+" + String.format("%.1f", coffeeScore) : String.format("%.1f", coffeeScore);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CodeSurvive - Result</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background: #f5f6fa; font-family: 'Segoe UI', system-ui, sans-serif; color: #1a1a2e; min-height: 100vh; }

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
        .nav-links { display: flex; gap: 0.3rem; }
        .nav-links a {
            padding: 0.4rem 1rem; border-radius: 8px; font-size: 0.85rem;
            font-weight: 500; color: #888; text-decoration: none; transition: all 0.15s;
        }
        .nav-links a.active { background: #e8f0fe; color: #4361ee; font-weight: 600; }
        .nav-links a:hover { background: #f5f6fa; color: #555; }
        .nav-right { display: flex; align-items: center; gap: 0.8rem; }
        .nav-avatar {
            width: 34px; height: 34px; background: linear-gradient(135deg,#4361ee,#a78bfa);
            border-radius: 50%; display: flex; align-items: center; justify-content: center;
            color: #fff; font-weight: 700; font-size: 0.85rem;
        }
        .nav-user strong { display: block; font-size: 0.85rem; }
        .nav-user span { font-size: 0.75rem; color: #aaa; }

        /* LAYOUT */
        .main { padding: 1.5rem 2rem; max-width: 1280px; margin: 0 auto; }
        .page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 1.4rem; }
        .page-header h1 { font-size: 1.7rem; font-weight: 800; }
        .page-header p { color: #888; font-size: 0.85rem; margin-top: 0.2rem; }
        .back-btn {
            padding: 0.45rem 1.1rem; background: #fff; border: 1.5px solid #e0e0e0;
            border-radius: 10px; color: #555; font-size: 0.82rem; font-weight: 600;
            text-decoration: none; transition: all 0.2s;
        }
        .back-btn:hover { border-color: #4361ee; color: #4361ee; }

        .grid { display: grid; grid-template-columns: 270px 1fr 330px; gap: 1.2rem; align-items: start; }

        /* CARDS */
        .card {
            background: #fff; border-radius: 18px; border: 1px solid #ebebeb;
            box-shadow: 0 2px 12px rgba(0,0,0,0.05); padding: 1.3rem; margin-bottom: 1.2rem;
        }
        .card:last-child { margin-bottom: 0; }
        .card-title {
            font-size: 0.8rem; font-weight: 700; color: #888; text-transform: uppercase;
            letter-spacing: 0.08em; margin-bottom: 1.1rem; display: flex; align-items: center; gap: 0.4rem;
        }
        .info-i {
            width: 15px; height: 15px; border: 1.5px solid #ddd; border-radius: 50%;
            display: inline-flex; align-items: center; justify-content: center;
            font-size: 0.6rem; color: #bbb; font-style: italic; font-weight: 700;
        }

        /* CIRCULAR GAUGE */
        .gauge-wrap { position: relative; width: 190px; height: 190px; margin: 0 auto 0.8rem; }
        .gauge-wrap svg { width: 190px; height: 190px; }
        .gauge-center {
            position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); text-align: center;
        }
        .gauge-number { font-size: 2.4rem; font-weight: 800; color: #1a1a2e; line-height: 1; }
        .gauge-status { font-size: 0.8rem; font-weight: 700; margin-top: 0.25rem; color: <%= statusColor %>; }
        .gauge-message { text-align: center; font-size: 0.78rem; color: #888; line-height: 1.4; }

        /* TROPHY & QUOTE */
        .trophy-card {
            background: #fffbeb; border: 1px solid #fde68a; border-radius: 14px;
            padding: 0.9rem 1.1rem; display: flex; gap: 0.75rem; align-items: flex-start; margin-bottom: 1rem;
        }
        .trophy-card .t-icon { font-size: 1.6rem; flex-shrink: 0; }
        .trophy-card strong { display: block; font-size: 0.85rem; margin-bottom: 0.15rem; }
        .trophy-card span { font-size: 0.75rem; color: #888; }
        .quote-card { background: #fff; border: 1px solid #ebebeb; border-radius: 14px; padding: 1rem 1.1rem; }
        .quote-mark { color: #4361ee; font-size: 1.3rem; margin-bottom: 0.25rem; }
        .quote-text { font-size: 0.9rem; font-weight: 600; line-height: 1.5; }
        .quote-sub { font-size: 0.75rem; color: #aaa; margin-top: 0.4rem; }

        /* BRAIN SECTION */
        .brain-section {
            position: relative; height: 250px;
            display: flex; align-items: center; justify-content: center;
        }
        .brain-emoji { font-size: 9rem; filter: drop-shadow(0 8px 24px rgba(0,0,0,0.1)); user-select: none; }
        .float-icon {
            position: absolute; width: 44px; height: 44px; background: #fff;
            border: 1px solid #ebebeb; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.1rem; box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            font-family: monospace; font-weight: 700; color: #4361ee;
        }
        .fi-code   { top: 16px; left: 36px; }
        .fi-sleep  { top: 50px; right: 28px; font-family: 'Segoe UI', sans-serif; }
        .fi-coffee { bottom: 56px; left: 16px; }
        .fi-books  { bottom: 24px; right: 44px; }
        .fi-target { top: 110px; right: 10px; }

        /* INPUT OVERVIEW */
        .ov-row { display: flex; align-items: center; gap: 0.7rem; margin-bottom: 0.85rem; }
        .ov-row:last-child { margin-bottom: 0; }
        .ov-icon {
            width: 30px; height: 30px; border-radius: 8px; background: #f5f6fa;
            display: flex; align-items: center; justify-content: center; font-size: 0.95rem; flex-shrink: 0;
        }
        .ov-label { font-size: 0.8rem; color: #888; width: 115px; flex-shrink: 0; }
        .ov-val { font-size: 0.85rem; font-weight: 700; width: 48px; flex-shrink: 0; }
        .bar-wrap { flex: 1; background: #f0f1f5; border-radius: 99px; height: 6px; overflow: hidden; }
        .bar-fill { height: 100%; border-radius: 99px; }
        .ov-max { font-size: 0.72rem; color: #bbb; width: 36px; flex-shrink: 0; text-align: right; }
        .tag {
            font-size: 0.68rem; font-weight: 700; padding: 0.18rem 0.55rem;
            border-radius: 99px; flex-shrink: 0;
        }

        /* SCORE BREAKDOWN */
        .br-row {
            display: flex; align-items: center; justify-content: space-between;
            padding: 0.55rem 0; border-bottom: 1px solid #f5f6fa;
        }
        .br-row:last-of-type { border-bottom: none; }
        .br-label { display: flex; align-items: center; gap: 0.55rem; font-size: 0.82rem; color: #555; }
        .br-icon {
            width: 26px; height: 26px; background: #f5f6fa; border-radius: 7px;
            display: flex; align-items: center; justify-content: center; font-size: 0.8rem;
            font-family: monospace; font-weight: 700; color: #555;
        }
        .br-score { font-size: 0.85rem; font-weight: 700; }
        .br-max { font-size: 0.75rem; color: #bbb; font-weight: 400; }
        .br-total {
            display: flex; justify-content: space-between; align-items: center;
            margin-top: 0.8rem; padding-top: 0.8rem; border-top: 2px solid #ebebeb;
        }
        .br-total span { font-size: 0.88rem; font-weight: 700; }
        .br-total .total-val { font-size: 1.05rem; font-weight: 800; color: #4361ee; }

        /* SPEEDOMETER */
        .speedo-pct { font-size: 1.3rem; font-weight: 800; color: #1a1a2e; line-height: 1; }
        .speedo-lbl { font-size: 0.7rem; font-weight: 600; color: <%= statusColor %>; }
        .speedo-layout { display: flex; gap: 1rem; align-items: center; }
        .legend { display: flex; flex-direction: column; gap: 0.35rem; }
        .legend-item { display: flex; align-items: center; gap: 0.4rem; font-size: 0.72rem; color: #888; white-space: nowrap; }
        .leg-dot { width: 9px; height: 9px; border-radius: 50%; flex-shrink: 0; }

        /* RECOMMENDATION */
        .rec-card {
            background: #4361ee; border-radius: 14px; padding: 1.1rem 1.2rem;
            display: flex; align-items: center; justify-content: space-between; gap: 1rem;
        }
        .rec-inner { display: flex; align-items: flex-start; gap: 0.75rem; }
        .rec-icon { font-size: 1.3rem; flex-shrink: 0; }
        .rec-text { font-size: 0.8rem; color: rgba(255,255,255,0.92); line-height: 1.5; }
        .rec-arrow {
            width: 34px; height: 34px; background: rgba(255,255,255,0.15); border-radius: 9px;
            display: flex; align-items: center; justify-content: center; color: #fff;
            font-size: 0.9rem; flex-shrink: 0;
        }

        /* BOTTOM BANNER */
        .banner {
            margin-top: 1.4rem; background: #fff; border: 1px solid #ebebeb;
            border-radius: 18px; padding: 1.3rem 2rem;
            display: flex; align-items: center; justify-content: space-between;
        }
        .banner-left { display: flex; align-items: center; gap: 1rem; }
        .banner-icon { font-size: 1.8rem; }
        .banner-left h3 { font-size: 0.95rem; font-weight: 700; }
        .banner-left p { font-size: 0.78rem; color: #888; margin-top: 0.2rem; }
        .banner-right { font-size: 2.5rem; }
    </style>
</head>
<body>

<!-- NAV -->
<nav>
    <div class="nav-logo">
        <div class="logo-box">&#128200;</div>
        CodeSurvive.
    </div>
    <div class="nav-links">
        <a href="index.jsp" class="active">Dashboard</a>
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

    <div class="page-header">
        <div>
            <h1>Good Job! &#128640;</h1>
            <p>Here is your survival analysis</p>
        </div>
        <a href="index.jsp" class="back-btn">&#8592; Recalculate</a>
    </div>

    <div class="grid">

        <!-- LEFT COLUMN -->
        <div>
            <div class="card" style="text-align:center">
                <div class="card-title" style="justify-content:center">
                    Survival Percentage <span class="info-i">i</span>
                </div>
                <div class="gauge-wrap">
                    <svg viewBox="0 0 180 180">
                        <defs>
                            <linearGradient id="gGrad" x1="0%" y1="0%" x2="100%" y2="0%">
                                <stop offset="0%" stop-color="#a78bfa"/>
                                <stop offset="100%" stop-color="#4361ee"/>
                            </linearGradient>
                        </defs>
                        <circle cx="90" cy="90" r="70" fill="none" stroke="#f0f1f5" stroke-width="13"/>
                        <circle cx="90" cy="90" r="70" fill="none" stroke="url(#gGrad)" stroke-width="13"
                            stroke-dasharray="<%= String.format("%.2f", circumference) %>"
                            stroke-dashoffset="<%= String.format("%.2f", dashOffset) %>"
                            stroke-linecap="round" transform="rotate(-90 90 90)"/>
                    </svg>
                    <div class="gauge-center">
                        <div style="font-size:1.3rem">&#128150;</div>
                        <div class="gauge-number"><%= survival %>%</div>
                        <div class="gauge-status"><%= status %></div>
                    </div>
                </div>
                <div class="gauge-message"><%= message %></div>
            </div>

            <div class="trophy-card">
                <div class="t-icon">&#127942;</div>
                <div>
                    <strong><%= survival >= 60 ? "You can Survive the Interview!" : "Keep Fighting!" %></strong>
                    <span><%= survival >= 60 ? "Stay consistent and you'll make it." : "Every point counts. Don't give up." %></span>
                </div>
            </div>

            <div class="quote-card">
                <div class="quote-mark">&#10077;</div>
                <div class="quote-text">Discipline today,<br>Placement tomorrow.</div>
                <div class="quote-sub">Keep grinding! &#128072;</div>
            </div>
        </div>

        <!-- CENTER COLUMN -->
        <div>
            <div class="card" style="padding:0;overflow:hidden;margin-bottom:1.2rem">
                <div class="brain-section">
                    <div class="brain-emoji">&#129504;</div>
                    <div class="float-icon fi-code">&lt;/&gt;</div>
                    <div class="float-icon fi-sleep">&#128564;</div>
                    <div class="float-icon fi-coffee">&#9749;</div>
                    <div class="float-icon fi-books">&#128218;</div>
                    <div class="float-icon fi-target">&#127919;</div>
                </div>
            </div>

            <div class="card">
                <div class="card-title">&#128202; Input Overview <span class="info-i">i</span></div>

                <div class="ov-row">
                    <div class="ov-icon">&lt;/&gt;</div>
                    <div class="ov-label">LeetCode Solved</div>
                    <div class="ov-val"><%= leetcode %></div>
                    <div class="bar-wrap"><div class="bar-fill" style="width:<%= leetcodeBar %>%;background:<%= barColor(leetcodeTag) %>"></div></div>
                    <div class="ov-max">/300</div>
                    <span class="tag" style="<%= tagStyle(leetcodeTag) %>"><%= leetcodeTag %></span>
                </div>
                <div class="ov-row">
                    <div class="ov-icon">&#128196;</div>
                    <div class="ov-label">Assessment Score</div>
                    <div class="ov-val"><%= assessment %></div>
                    <div class="bar-wrap"><div class="bar-fill" style="width:<%= assessmentBar %>%;background:<%= barColor(assessmentTag) %>"></div></div>
                    <div class="ov-max">/<%= totalAssess %></div>
                    <span class="tag" style="<%= tagStyle(assessmentTag) %>"><%= assessmentTag %></span>
                </div>
                <div class="ov-row">
                    <div class="ov-icon">&#128564;</div>
                    <div class="ov-label">Sleep Hours</div>
                    <div class="ov-val"><%= sleep %>.0</div>
                    <div class="bar-wrap"><div class="bar-fill" style="width:<%= sleepBar %>%;background:<%= barColor(sleepTag) %>"></div></div>
                    <div class="ov-max">/8</div>
                    <span class="tag" style="<%= tagStyle(sleepTag) %>"><%= sleepTag %></span>
                </div>
                <div class="ov-row">
                    <div class="ov-icon">&#9749;</div>
                    <div class="ov-label">Coffee (Breaks)</div>
                    <div class="ov-val"><%= coffee %></div>
                    <div class="bar-wrap"><div class="bar-fill" style="width:<%= coffeeBar %>%;background:<%= barColor(coffeeTag) %>"></div></div>
                    <div class="ov-max">cups</div>
                    <span class="tag" style="<%= tagStyle(coffeeTag) %>"><%= coffeeTag %></span>
                </div>
                <div class="ov-row">
                    <div class="ov-icon">&#128218;</div>
                    <div class="ov-label">Assignment Backlog</div>
                    <div class="ov-val"><%= backlog %></div>
                    <div class="bar-wrap"><div class="bar-fill" style="width:<%= backlogBar %>%;background:<%= barColor(backlogTag) %>"></div></div>
                    <div class="ov-max">/<%= totalAssign %></div>
                    <span class="tag" style="<%= tagStyle(backlogTag) %>"><%= backlogTag %></span>
                </div>
            </div>
        </div>

        <!-- RIGHT COLUMN -->
        <div>
            <div class="card" style="margin-bottom:1.2rem">
                <div class="card-title">Score Breakdown <span class="info-i">i</span></div>

                <div class="br-row">
                    <div class="br-label"><div class="br-icon">&lt;/&gt;</div>LeetCode Contribution</div>
                    <div class="br-score" style="color:#4361ee"><%= String.format("%.1f", leetcodeScore) %><span class="br-max"> / 30</span></div>
                </div>
                <div class="br-row">
                    <div class="br-label"><div class="br-icon">&#128196;</div>Assessment Contribution</div>
                    <div class="br-score" style="color:#4361ee"><%= String.format("%.1f", assessmentScore) %><span class="br-max"> / 30</span></div>
                </div>
                <div class="br-row">
                    <div class="br-label"><div class="br-icon">&#128564;</div>Sleep Contribution</div>
                    <div class="br-score" style="color:#4361ee"><%= String.format("%.1f", sleepScore) %><span class="br-max"> / 15</span></div>
                </div>
                <div class="br-row">
                    <div class="br-label"><div class="br-icon">&#9749;</div>Coffee (Breaks)</div>
                    <div class="br-score" style="color:<%= coffeeScore >= 0 ? "#1a9e5c" : "#d32f2f" %>"><%= coffeeScoreStr %><span class="br-max"> / 5</span></div>
                </div>
                <div class="br-row">
                    <div class="br-label"><div class="br-icon">&#128218;</div>Backlog Score</div>
                    <div class="br-score" style="color:#4361ee"><%= String.format("%.1f", backlogScore) %><span class="br-max"> / 20</span></div>
                </div>

                <div class="br-total">
                    <span>Total Score</span>
                    <span class="total-val"><%= survival %> / 100</span>
                </div>
            </div>

            <!-- Speedometer -->
            <div class="card" style="margin-bottom:1.2rem">
                <div class="card-title">Survival Prediction <span class="info-i">i</span></div>
                <div class="speedo-layout">
                    <div>
                        <svg viewBox="0 0 200 110" style="width:200px;height:110px;display:block">
                            <!-- Red 0-40% -->
                            <path d="M 15 100 A 85 85 0 0 1 73.7 19.2 L 79.9 38.2 A 65 65 0 0 0 35 100 Z" fill="#fca5a5"/>
                            <!-- Orange 40-60% -->
                            <path d="M 73.7 19.2 A 85 85 0 0 1 126.3 19.2 L 120.1 38.2 A 65 65 0 0 0 79.9 38.2 Z" fill="#fdba74"/>
                            <!-- Yellow 60-80% -->
                            <path d="M 126.3 19.2 A 85 85 0 0 1 168.8 50.0 L 152.6 61.8 A 65 65 0 0 0 120.1 38.2 Z" fill="#fde047"/>
                            <!-- Green 80-100% -->
                            <path d="M 168.8 50.0 A 85 85 0 0 1 185 100 L 165 100 A 65 65 0 0 0 152.6 61.8 Z" fill="#86efac"/>
                            <!-- Needle (triangle rotated to survival %) -->
                            <polygon points="100,98 168,100 100,102"
                                     transform="rotate(<%= String.format("%.1f", needleSVGAngle) %>, 100, 100)"
                                     fill="#1a1a2e"/>
                            <circle cx="100" cy="100" r="6" fill="#fff" stroke="#1a1a2e" stroke-width="2"/>
                        </svg>
                        <div style="text-align:center;margin-top:0.4rem">
                            <div class="speedo-pct"><%= survival %>%</div>
                            <div class="speedo-lbl"><%= status %></div>
                        </div>
                    </div>
                    <div class="legend">
                        <div class="legend-item"><div class="leg-dot" style="background:#86efac"></div>80–100% &nbsp;Strong</div>
                        <div class="legend-item"><div class="leg-dot" style="background:#fde047"></div>60–79% &nbsp;&nbsp;Good</div>
                        <div class="legend-item"><div class="leg-dot" style="background:#fdba74"></div>40–59% &nbsp;&nbsp;Risky</div>
                        <div class="legend-item"><div class="leg-dot" style="background:#fca5a5"></div>0–39% &nbsp;&nbsp;&nbsp;Low</div>
                    </div>
                </div>
            </div>

            <!-- Recommendation -->
            <div class="rec-card">
                <div class="rec-inner">
                    <div class="rec-icon">&#127919;</div>
                    <div class="rec-text"><%= recommendation %></div>
                </div>
                <div class="rec-arrow">&#8594;</div>
            </div>
        </div>

    </div><!-- /grid -->

    <!-- BOTTOM BANNER -->
    <div class="banner">
        <div class="banner-left">
            <div class="banner-icon">&#9889;</div>
            <div>
                <h3>Consistency + Focus + Smart Breaks = Success</h3>
                <p>You're capable of great things. Keep going!</p>
            </div>
        </div>
        <div class="banner-right">&#128187;</div>
    </div>

</div>
</body>
</html>
