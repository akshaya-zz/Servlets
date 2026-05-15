
import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class SurvivalPercentage extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int coffee_number = Integer.parseInt(req.getParameter("coffee"));
        int sleepHours = Integer.parseInt(req.getParameter("sleep"));
        int assignment_backlog = Integer.parseInt(req.getParameter("assignment-backlog"));
        int totalAssignments = Integer.parseInt(req.getParameter("total-assignments"));
        int leetcodeCount = Integer.parseInt(req.getParameter("leetcode"));
        int assessment = Integer.parseInt(req.getParameter("assessment"));
        int totalAssessments = Integer.parseInt(req.getParameter("total-assessments"));

        double score = 0;

        // Assessment: 30% weight (cleared / total given)
        score += (assessment / (double) totalAssessments) * 30;

        // LeetCode: 30% weight (capped at 300)
        score += Math.min(leetcodeCount, 300) / 300.0 * 30;

        // Backlog: 20% weight (inverse — less backlog = more score)
        score += Math.max(0, 1 - assignment_backlog / (double) totalAssignments) * 20;

        // Sleep: 15% weight (optimal 8 hours)
        score += Math.min(sleepHours, 8) / 8.0 * 15;

        // Coffee: 1-3 = +5 (productive), 4-5 = +2.5 (okay), 6+ = -2.5 (burnout)
        if (coffee_number >= 1 && coffee_number <= 3)
            score += 5;
        else if (coffee_number <= 5)
            score += 2.5;
        else
            score -= 2.5;

        score = Math.max(0, Math.min(score, 100));

        int survivalPercentage = (int) Math.round(score);
        req.setAttribute("survivalPercentage", survivalPercentage);
        RequestDispatcher requestDispatcher = req.getRequestDispatcher("survival.jsp");
        requestDispatcher.forward(req, resp);
    }

}
