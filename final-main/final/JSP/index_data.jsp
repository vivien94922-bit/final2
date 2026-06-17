<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbutil.jsp" %>
<%
    // 1. 訪客計數器
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    int count = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = getConnection();

        if (session.getAttribute("visitor_counted") == null) {
            ps = con.prepareStatement("UPDATE counter SET count = count + 1 WHERE id = 1");
            ps.executeUpdate();
            ps.close();
            session.setAttribute("visitor_counted", Boolean.TRUE);
        }

        ps = con.prepareStatement("SELECT count FROM counter WHERE id = 1");
        rs = ps.executeQuery();
        if (rs.next()) {
            count = rs.getInt("count");
        }
        rs.close();
        ps.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    // 2. 手動拼接 JSON 字串 (不用外掛 JAR，最安全)
    StringBuilder json = new StringBuilder();
    json.append("{");
    json.append("\"visitorCount\":").append(count).append(",");

    // --- 熱門商品 ---
    json.append("\"hot\":[");
    try {
        ps = con.prepareStatement("SELECT * FROM product LIMIT 3");
        rs = ps.executeQuery();
        boolean first = true;
        while(rs.next()) {
            if(!first) json.append(",");
            json.append("{")
                .append("\"id\":").append(rs.getInt("id")).append(",")
                .append("\"name\":\"").append(rs.getString("name").replace("\"", "\\\"")).append("\",")
                .append("\"price\":").append(rs.getInt("price")).append(",")
                .append("\"image\":\"").append(rs.getString("image")).append("\"")
                .append("}");
            first = false;
        }
        rs.close(); ps.close();
    } catch(Exception e) {}
    json.append("],");

    // --- 登機系列 ---
    json.append("\"boarding\":[");
    try {
        ps = con.prepareStatement("SELECT * FROM product WHERE category = 'boarding' LIMIT 3");
        rs = ps.executeQuery();
        boolean first = true;
        while(rs.next()) {
            if(!first) json.append(",");
            json.append("{")
                .append("\"id\":").append(rs.getInt("id")).append(",")
                .append("\"name\":\"").append(rs.getString("name").replace("\"", "\\\"")).append("\",")
                .append("\"price\":").append(rs.getInt("price")).append(",")
                .append("\"image\":\"").append(rs.getString("image")).append("\"")
                .append("}");
            first = false;
        }
        rs.close(); ps.close();
    } catch(Exception e) {}
    json.append("],");

    // --- 旅行系列 ---
    json.append("\"travel\":[");
    try {
        ps = con.prepareStatement("SELECT * FROM product WHERE category = 'travel' LIMIT 3");
        rs = ps.executeQuery();
        boolean first = true;
        while(rs.next()) {
            if(!first) json.append(",");
            json.append("{")
                .append("\"id\":").append(rs.getInt("id")).append(",")
                .append("\"name\":\"").append(rs.getString("name").replace("\"", "\\\"")).append("\",")
                .append("\"price\":").append(rs.getInt("price")).append(",")
                .append("\"image\":\"").append(rs.getString("image")).append("\"")
                .append("}");
            first = false;
        }
        rs.close(); ps.close();
    } catch(Exception e) {}
    json.append("]");

    json.append("}");

    if(con != null) { try { con.close(); } catch(Exception e){} }

    out.print(json.toString());
%>
