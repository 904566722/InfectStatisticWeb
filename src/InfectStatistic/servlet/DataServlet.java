package InfectStatistic.servlet;

import InfectStatistic.dao.DataDAO;
import net.sf.json.JSONArray;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/DataServlet")
public class DataServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action != null && action.equals("getTotalData")) {
            this.getTotalData(request, response);
        } else if (action != null && action.equals("getDailyData")) {

        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    private void getTotalData(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        DataDAO dataDAO = new DataDAO();
        String endDate = request.getParameter("endDate");
        if (endDate != null) {
        } else {
            endDate = "2020-02-02";
        }
        JSONArray jsonArray = dataDAO.getTotalData(endDate);
        request.setAttribute("totalData", jsonArray);
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}
