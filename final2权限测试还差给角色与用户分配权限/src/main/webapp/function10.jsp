<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="entity.Permission" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.stream.Collectors" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="entity.Role" %>
<%@ page import="entity.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>权限管理 - 账务管理系统</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
        body { font-family: 'Inter', sans-serif; }
        .role-section { margin-bottom: 2rem; }
        .role-title { 
            font-size: 1.25rem; 
            font-weight: 600; 
            margin-bottom: 0.5rem; 
            display: flex; 
            align-items: center; 
            padding: 0.5rem 1rem;
            border-radius: 0.375rem;
        }
        .admin-role { background-color: #EEF2FF; color: #4338CA; }
        .user-role { background-color: #ECFDF5; color: #065F46; }
        .finance-role { background-color: #FEF3C7; color: #92400E; }
        .checkr-role { background-color: #E0F2FE; color: #0369A1; } 
        .permission-table { width: 100%; }
        .btn-primary {
            background-color: #6366F1;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 0.375rem;
            transition: all 0.2s ease;
        }
        .btn-primary:hover {
            background-color: #4F46E5;
        }
        .btn-secondary {
            background-color: #F3F4F6;
            color: #4B5563;
            padding: 0.5rem 1rem;
            border-radius: 0.375rem;
            transition: all 0.2s ease;
        }
        .btn-secondary:hover {
            background-color: #E5E7EB;
        }
        .role-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 500;
        }
        .permission-badge {
            display: inline-block;
            padding: 0.2rem 0.6rem;
            border-radius: 9999px;
            font-size: 0.7rem;
            margin: 0.1rem;
            background-color: #f3f4f6;
            color: #4b5563;
        }
        .form-card {
            border-radius: 0.75rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            border: 1px solid #E5E7EB;
        }
        .empty-select {
            color: #9CA3AF;
        }
        .error-highlight {
            border-color: #EF4444 !important;
            background-color: #FEE2E2 !important;
        }
        .animate-shake {
            animation: shake 0.5s;
        }
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
            20%, 40%, 60%, 80% { transform: translateX(5px); }
        }
    </style>
</head>
<body class="bg-gray-50 min-h-screen">
    <div class="container mx-auto px-4 mt-4">
        <% if (request.getAttribute("successMessage") != null) { %>
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative" role="alert">
                <strong class="font-bold">成功!</strong>
                <span class="block sm:inline"><%= request.getAttribute("successMessage") %></span>
            </div>
        <% } %>
        
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative" role="alert">
                <strong class="font-bold">错误!</strong>
                <span class="block sm:inline"><%= request.getAttribute("errorMessage") %></span>
            </div>
        <% } %>
    </div>
    <!-- 顶部导航栏 -->
    <header class="w-full bg-white shadow-md fixed top-0 z-30">
        <div class="container mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center py-3">
                <div class="flex items-center space-x-3">
                    <div class="w-14 h-14 rounded-xl flex items-center justify-center mr-5 bg-blue-100 text-blue-600">
                        <i class="fa-solid fa-shield-alt text-2xl"></i>
                    </div>
                    <h1 class="text-xl sm:text-2xl font-bold text-gray-800">权限管理</h1>
                </div>
                <div class="flex items-center space-x-4">
                    <a href="content.jsp" class="btn-secondary flex items-center space-x-1">
                        <i class="fa-solid fa-arrow-left"></i>
                        <span class="hidden sm:inline">返回主页</span>
                    </a>
                    <a href="LogoutServlet" class="btn-primary flex items-center space-x-1">
                        <i class="fa-solid fa-sign-out-alt"></i>
                        <span class="hidden sm:inline">退出登录</span>
                    </a>
                </div>
            </div>
        </div>
    </header>

    <main class="max-w-6xl mx-auto pt-28 pb-16 px-4">
        <div class="text-center mb-10">
            <h2 class="text-[clamp(1.8rem,4vw,2.5rem)] font-bold text-gray-800 mb-3">权限管理系统</h2>
            <p class="text-gray-600 max-w-2xl mx-auto">管理角色、权限和用户角色分配</p>
        </div>

        <!-- 角色管理部分 -->
        <div class="bg-white form-card p-6">
            <h3 class="text-xl font-semibold text-gray-800 mb-4 flex items-center">
                <i class="fa-solid fa-users-gear text-purple-600 mr-2"></i>
                角色管理
            </h3>
            
            <!-- 添加角色表单 -->
            <form action="RoleServlet" method="post" class="mb-6 p-4 border border-gray-200 rounded-lg">
                <input type="hidden" name="action" value="add">
                <div class="flex items-end gap-4">
                    <div class="flex-1">
                        <label class="block text-sm font-medium text-gray-700 mb-1">角色名称</label>
                        <input type="text" name="role_name" required 
                            class="w-full px-4 py-2 border border-gray-300 rounded-md">
                    </div>
                    <div class="flex-1">
                        <label class="block text-sm font-medium text-gray-700 mb-1">角色描述</label>
                        <input type="text" name="description" 
                            class="w-full px-4 py-2 border border-gray-300 rounded-md">
                    </div>
                    <button type="submit" class="btn-primary h-fit">
                        <i class="fa-solid fa-plus mr-1"></i>添加角色
                    </button>
                </div>
            </form>
            
            <!-- 角色列表 -->
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">角色ID</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">角色名称</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">描述</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">操作</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <% 
                        List<Role> allRoles = (List<Role>) request.getAttribute("allRoles");
                        if (allRoles == null) {
                            // 尝试从会话中获取角色数据
                            allRoles = (List<Role>) session.getAttribute("allRoles");
                            if (allRoles == null) {
                                allRoles = new ArrayList<>();
                            }
                        }
                        
                        if (allRoles.isEmpty()) { %>
                            <tr>
                                <td colspan="4" class="px-6 py-4 text-center text-gray-500">
                                    <div class="flex flex-col items-center py-4">
                                        <i class="fa-solid fa-users text-gray-300 text-3xl mb-2"></i>
                                        <span>暂无角色数据</span>
                                    </div>
                                </td>
                            </tr>
                        <% } else { 
                            for (Role role : allRoles) {
                                String roleClass = "";
                                if ("admin".equalsIgnoreCase(role.getRoleName())) {
                                    roleClass = "admin-role";
                                } else if ("user".equalsIgnoreCase(role.getRoleName())) {
                                    roleClass = "user-role";
                                } else if ("checkr".equalsIgnoreCase(role.getRoleName())) {
                                    roleClass = "checkr-role";
                                }
                        %>
                        <tr>
                            <td class="px-6 py-4 whitespace-nowrap"><%= role.getRoleId() %></td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <span class="role-badge <%= roleClass %>">
                                    <%= role.getRoleName() %>
                                </span>
                            </td>
                            <td class="px-6 py-4"><%= role.getDescription() %></td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <% if (role.getRoleId() > 2) { // 系统角色不可删除 %>
                                <a href="RoleServlet?action=delete&role_id=<%= role.getRoleId() %>" 
                                   class="text-red-600 hover:text-red-800 text-sm"
                                   onclick="return confirm('确定删除此角色吗？')">
                                    <i class="fa-solid fa-trash mr-1"></i>删除
                                </a>
                                <% } else { %>
                                <span class="text-gray-400 text-sm">系统角色</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- 权限分配部分 -->
        <div class="bg-white form-card p-6 mt-8">
            <h3 class="text-xl font-semibold text-gray-800 mb-4 flex items-center">
                <i class="fa-solid fa-key text-purple-600 mr-2"></i>
                权限分配
            </h3>
            
            <form action="PermissionServlet" method="post" class="space-y-6">
                <input type="hidden" name="action" value="assignPermissions">
                
                <div class="flex gap-4">
                    <div class="flex-1">
                        <label class="block text-sm font-medium text-gray-700 mb-1">选择角色</label>
                        <select name="role_id" id="roleSelector" required
                            class="w-full px-4 py-2 border border-gray-300 rounded-md">
                            <option value="">-- 选择角色 --</option>
                            <% if (allRoles.isEmpty()) { %>
                                <option value="" class="empty-select" disabled>无角色数据</option>
                            <% } else { 
                                for (Role role : allRoles) { %>
                                <option value="<%= role.getRoleId() %>"><%= role.getRoleName() %></option>
                            <% } } %>
                        </select>
                    </div>
                </div>
                
                <!-- 权限选择区域 -->
                <div class="border border-gray-200 rounded-lg p-4">
                    <h4 class="font-medium text-gray-700 mb-3">权限设置</h4>
                    <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
                        <% 
                        List<Permission> allPermissions = (List<Permission>) request.getAttribute("allPermissions");
                        if (allPermissions == null) allPermissions = new ArrayList<>();
                        
                        if (allPermissions.isEmpty()) { %>
                            <div class="col-span-full text-center text-gray-500 py-4">
                                <div class="flex flex-col items-center">
                                    <i class="fa-solid fa-ban text-gray-300 text-3xl mb-2"></i>
                                    <span>暂无权限数据</span>
                                </div>
                            </div>
                        <% } else { 
                            for (Permission perm : allPermissions) { 
                        %>
                        <label class="flex items-start">
                            <input type="checkbox" name="permissions" value="<%= perm.getPermissionId() %>"
                                class="mt-1 h-4 w-4 text-purple-600 rounded border-gray-300 focus:ring-purple-500"
                                id="perm_<%= perm.getPermissionId() %>">
                            <span class="ml-2 text-sm text-gray-700">
                                <%= perm.getPermissionName() %><br>
                                <span class="text-xs text-gray-500"><%= perm.getDescription() %></span>
                            </span>
                        </label>
                        <% } } %>
                    </div>
                </div>
                
                <div class="flex justify-end mt-4">
                    <button type="submit" class="btn-primary">
                        <i class="fa-solid fa-floppy-disk mr-2"></i>保存权限配置
                    </button>
                </div>
            </form>
        </div>

        <!-- 用户角色分配部分 -->
        <div class="bg-white form-card p-6 mt-8">
            <h3 class="text-xl font-semibold text-gray-800 mb-4 flex items-center">
                <i class="fa-solid fa-user-plus text-purple-600 mr-2"></i>
                用户角色分配
            </h3>
            
            <form action="PermissionServlet" method="post" class="space-y-4">
                <input type="hidden" name="action" value="assignRoleToUser">
                
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <!-- 用户选择 -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">选择用户</label>
                        <select name="user_id" id="userSelector" required
                            class="w-full px-4 py-2 border border-gray-300 rounded-md">
                            <option value="">-- 选择用户 --</option>
                            <% 
                            List<User> allUsers = (List<User>) request.getAttribute("allUsers");
                            if (allUsers == null) {
                                // 尝试从会话中获取用户数据
                                allUsers = (List<User>) session.getAttribute("allUsers");
                                if (allUsers == null) {
                                    allUsers = new ArrayList<>();
                                }
                            }
                            
                            if (allUsers.isEmpty()) { %>
                                <option value="" class="empty-select" disabled>无用户数据</option>
                            <% } else { 
                                for (User user : allUsers) { 
                            %>
                            <option value="<%= user.getUserId() %>"><%= user.getUsername() %> (ID: <%= user.getUserId() %>)</option>
                            <% } } %>
                        </select>
                    </div>
                    
                    <!-- 角色选择 -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">分配角色</label>
                        <select name="role_id" id="roleAssignSelector" required
                            class="w-full px-4 py-2 border border-gray-300 rounded-md">
                            <option value="">-- 选择角色 --</option>
                            <% if (allRoles.isEmpty()) { %>
                                <option value="" class="empty-select" disabled>无角色数据</option>
                            <% } else { 
                                for (Role role : allRoles) { %>
                                <option value="<%= role.getRoleId() %>"><%= role.getRoleName() %></option>
                            <% } } %>
                        </select>
                    </div>
                    
                    <!-- 提交按钮 -->
                    <div class="flex items-end">
                        <button type="submit" class="btn-primary w-full">
                            <i class="fa-solid fa-user-plus mr-2"></i>分配角色
                        </button>
                    </div>
                </div>
            </form>

        <!-- 用户与角色对应显示框 -->
        <div id="user-role-display" class="mt-8 bg-white form-card p-6">
            <h3 class="text-lg font-semibold text-gray-800 mb-3 flex items-center">
                <i class="fa-solid fa-user-tag text-purple-600 mr-2"></i>
                用户与角色对应关系
            </h3>
            
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">用户ID</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">用户名</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">角色</th>
                    </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                    <% 
                    Map<Integer, Map<String, String>> userRoles = (Map<Integer, Map<String, String>>) request.getAttribute("userRoles");
                    if (userRoles == null) userRoles = new HashMap<>();
                    
                    if (userRoles.isEmpty()) { %>
                        <tr>
                            <td colspan="3" class="px-6 py-4 text-center text-gray-500">
                                <div class="flex flex-col items-center py-4">
                                    <i class="fa-solid fa-user-circle text-gray-300 text-3xl mb-2"></i>
                                    <span>暂无用户角色分配数据</span>
                                </div>
                            </td>
                        </tr>
                    <% } else { 
                        for (Map.Entry<Integer, Map<String, String>> entry : userRoles.entrySet()) {
                            int userId = entry.getKey();
                            String userName = entry.getValue().get("userName");
                            String roleName = entry.getValue().get("roleName");
                            String displayRoleName = getDisplayRoleName(roleName);
                    %>
                    <tr>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><%= userId %></td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><%= userName %></td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <span class="role-badge <%= getRoleClass(roleName) %>">
                                <%= displayRoleName %>
                            </span>
                        </td>
                    </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>

        <!-- 权限列表：按角色分组展示 -->
        <div class="bg-white form-card p-6 mt-8">
            <h3 class="text-xl font-semibold text-gray-800 mb-4 flex items-center">
                <i class="fa-solid fa-sliders text-purple-600 mr-2"></i>
                系统权限配置
            </h3>
            
            <div class="bg-white rounded-xl shadow-md p-6">
                <% 
                List<Permission> userPerms = (List<Permission>) request.getAttribute("userPerms");
                if (userPerms == null) {
                    userPerms = new ArrayList<>();
                }

                // 按角色名称分组权限
                Map<String, List<Permission>> permsByRole = userPerms.stream()
                    .collect(Collectors.groupingBy(Permission::getRoleName));
                %>

                <% if (!permsByRole.isEmpty()) { %>
                    <% for (Map.Entry<String, List<Permission>> entry : permsByRole.entrySet()) { 
                        String roleName = entry.getKey();
                        List<Permission> perms = entry.getValue();
                        
                        // 正确匹配角色名称
                        String displayRoleName = roleName;
                        if ("admin".equalsIgnoreCase(roleName)) {
                            displayRoleName = "管理员";
                        } else if ("user".equalsIgnoreCase(roleName)) {
                            displayRoleName = "普通用户";
                        } else if ("finance".equalsIgnoreCase(roleName)) {
                            displayRoleName = "财务人员";
                        } else if ("checkr".equalsIgnoreCase(roleName)) {
                            displayRoleName = "审核财务人员";
                        }
                        
                        // 修复权限过滤逻辑
                        List<Permission> uniquePerms = new ArrayList<>();
                        Set<Integer> seenIds = new HashSet<>();
                        for (Permission perm : perms) {
                            if (!seenIds.contains(perm.getPermissionId())) {
                                uniquePerms.add(perm);
                                seenIds.add(perm.getPermissionId());
                            }
                        }
                        
                        // 根据角色名称设置不同的样式类
                        String roleClass = "user-role";
                        if ("admin".equalsIgnoreCase(roleName)) {
                            roleClass = "admin-role";
                        } else if ("finance".equalsIgnoreCase(roleName)) {
                            roleClass = "finance-role";
                        } else if ("checkr".equalsIgnoreCase(roleName)) {
                            roleClass = "checkr-role";
                        }
                    %>
                    <div class="role-section">
                        <!-- 角色标题 -->
                        <div class="role-title <%= roleClass %>">
                            <i class="fa-solid fa-user-shield mr-2"></i>
                            <span><%= displayRoleName.toUpperCase() %> 角色权限</span>
                            <span class="ml-auto text-sm font-normal text-gray-600">
                                <i class="fa-solid fa-users mr-1"></i>
                                共 <%= uniquePerms.size() %> 项权限
                            </span>
                        </div>

                        <!-- 权限表格 -->
                        <div class="overflow-x-auto">
                            <table class="permission-table min-w-full divide-y divide-gray-200">
                                <thead class="bg-gray-50">
                                    <tr>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">权限ID</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">权限名称</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">描述</th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">操作</th>
                                    </tr>
                                </thead>
                                <tbody class="bg-white divide-y divide-gray-200">
                                    <% for (Permission perm : uniquePerms) { %>
                                    <tr class="hover:bg-gray-50 transition-colors">
                                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900"><%= perm.getPermissionId() %></td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><%= perm.getPermissionName() %></td>
                                        <td class="px-6 py-4 text-sm text-gray-500"><%= perm.getDescription() %></td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <!-- 只保留删除功能 -->
                                            <a href="DeletePermissionServlet?permission_id=<%= perm.getPermissionId() %>" 
                                               class="text-red-600 hover:text-red-800 text-sm"
                                               onclick="return confirm('确定要删除此权限吗？')">
                                                <i class="fa-solid fa-trash mr-1"></i>删除
                                            </a>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <% } %>
                <% } else { %>
                    <div class="text-center text-gray-500 py-8">
                        <div class="flex flex-col items-center">
                            <i class="fa-solid fa-shield-alt text-gray-300 text-5xl mb-4"></i>
                            <p class="text-lg">暂无权限数据</p>
                            <p class="text-sm mt-1">请联系系统管理员分配权限</p>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    </main>

    <!-- 页脚 -->
    <footer class="w-full bg-white py-6 border-t border-gray-200 mt-16">
        <div class="container mx-auto px-4 sm:px-6 lg:px-8 text-center text-gray-500 text-sm">
            <p>账务管理系统 &copy; 2025 | 权限管理模块</p>
        </div>
    </footer>

    <!-- 辅助方法声明 -->
    <%!
    // 辅助方法：获取角色显示名称
    private String getDisplayRoleName(String roleName) {
        if (roleName == null) return "未知角色";
        switch (roleName.toLowerCase()) {
            case "admin": return "管理员";
            case "user": return "普通用户";
            case "finance": return "财务人员";
            case "checkr": return "审核财务人员";
            default: return roleName;
        }
    }

    // 辅助方法：获取角色对应的CSS类
    private String getRoleClass(String roleName) {
        if (roleName == null) return "";
        switch (roleName.toLowerCase()) {
            case "admin": return "admin-role";
            case "user": return "user-role";
            case "finance": return "finance-role";
            case "checkr": return "checkr-role";
            default: return "";
        }
    }
    %>

    <script>
        // 角色选择器变更时加载权限配置
        document.getElementById('roleSelector').addEventListener('change', function() {
            const roleId = this.value;
            if (!roleId) return;
            
            // AJAX请求获取角色的权限配置
            fetch('GetRolePermissions?role_id=' + roleId)
                .then(response => response.json())
                .then(permissions => {
                    // 重置所有复选框
                    document.querySelectorAll('input[name="permissions"]').forEach(checkbox => {
                        checkbox.checked = false;
                    });
                    
                    // 选中该角色拥有的权限
                    permissions.forEach(permId => {
                        const checkbox = document.querySelector('input[name="permissions"][value="' + permId + '"]');
                        if (checkbox) checkbox.checked = true;
                    });
                })
                .catch(error => console.error('Error fetching role permissions:', error));
        });

        // 初始化：如果有角色被选中，加载其权限
        const initialRoleId = document.getElementById('roleSelector').value;
        if (initialRoleId) {
            document.getElementById('roleSelector').dispatchEvent(new Event('change'));
        }

        // 检查下拉框是否有数据
        function checkSelectOptions() {
            const selects = ['roleSelector', 'userSelector', 'roleAssignSelector'];
            
            selects.forEach(id => {
                const select = document.getElementById(id);
                if (!select) return;
                
                // 如果除了第一个选项外没有其他选项，显示空数据提示
                if (select.options.length <= 1) {
                    select.classList.add('error-highlight');
                    
                    // 添加抖动动画
                    select.classList.add('animate-shake');
                    setTimeout(() => {
                        select.classList.remove('animate-shake');
                    }, 1000);
                    
                    // 显示错误消息
                    const errorMsg = document.createElement('div');
                    errorMsg.className = 'text-red-500 text-xs mt-1';
                    errorMsg.textContent = '无可用数据，请刷新页面或联系管理员';
                    
                    // 确保不重复添加错误消息
                    const parent = select.parentElement;
                    if (!parent.querySelector('.text-red-500')) {
                        parent.appendChild(errorMsg);
                    }
                } else {
                    // 有数据时移除错误样式
                    select.classList.remove('error-highlight');
                    const errorMsg = select.parentElement.querySelector('.text-red-500');
                    if (errorMsg) {
                        errorMsg.remove();
                    }
                }
            });
        }
        
        // 页面加载完成后检查
        document.addEventListener('DOMContentLoaded', checkSelectOptions);
        
        // 页面加载完成后自动刷新数据
        window.addEventListener('load', function() {
            // 尝试从服务器重新获取角色和用户数据
            fetch('RefreshDataServlet')
                .then(response => {
                    if (response.ok) {
                        // 刷新成功，重新检查下拉框
                        setTimeout(checkSelectOptions, 500);
                    }
                })
                .catch(error => console.error('Error refreshing data:', error));
        });
    </script>
</body>
</html>