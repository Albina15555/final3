package servlet;

import java.io.IOException;

import Dao.RoleDao;
import entity.Role;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/RoleServlet")
public class RoleServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        RoleDao roleDao = new RoleDao();
        
        if ("delete".equals(action)) {
            int roleId = Integer.parseInt(request.getParameter("role_id"));
            if (roleDao.deleteRole(roleId)) {
                response.sendRedirect("PermissionServlet?success=角色删除成功");
            } else {
                response.sendRedirect("PermissionServlet?error=角色删除失败");
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            String roleName = request.getParameter("role_name");
            String description = request.getParameter("description");
            
            if (roleName == null || roleName.trim().isEmpty()) {
                response.sendRedirect("PermissionServlet?error=角色名称不能为空");
                return;
            }
            
            RoleDao roleDao = new RoleDao();
            Role role = new Role();
            role.setRoleName(roleName);
            role.setDescription(description);
            
            if (roleDao.addRole(role)) {
                response.sendRedirect("PermissionServlet?success=角色添加成功");
            } else {
                response.sendRedirect("PermissionServlet?error=角色添加失败");
            }
        }
    }
}