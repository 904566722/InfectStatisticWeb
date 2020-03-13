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
        } else if (action != null && action.equals("getProvinceData")) {
            this.getProvinceData(request, response);
        } else {
            this.getTotalData(request, response);
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
        JSONArray totalData = dataDAO.getTotalData(endDate, "全国");
        JSONArray dailyData = dataDAO.getDailyData(endDate, "全国");
        request.setAttribute("totalData", totalData);
        request.setAttribute("dailyData", dailyData);
        request.setAttribute("flag", 1);
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    private void getProvinceData(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        DataDAO dataDAO = new DataDAO();
        String endDate = request.getParameter("endDate");
        String province = request.getParameter("province");
        if (endDate != null) {
        } else {
            endDate = "2020-02-02";
        }
        if (province != null) {
        } else {
            province = "全国";
        }
        JSONArray totalData = dataDAO.getTotalData(endDate, province);
        JSONArray dailyData = dataDAO.getDailyData(endDate, province);
        request.setAttribute("totalData", totalData);
        request.setAttribute("dailyData", dailyData);
        request.setAttribute("province", province);
        request.getRequestDispatcher("jsp/province.jsp").forward(request, response);
    }
}
