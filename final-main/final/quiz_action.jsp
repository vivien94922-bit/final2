<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.json.JSONObject" %>
<%
    String q1 = request.getParameter("q1");
    String q2 = request.getParameter("q2");
    String q3 = request.getParameter("q3");
    String q4 = request.getParameter("q4");
    String q5 = request.getParameter("q5");

    JSONObject result = new JSONObject();

    if (q1 != null && q2 != null && q3 != null && q4 != null && q5 != null) {
        int totalScore = Integer.parseInt(q1) + Integer.parseInt(q2) + 
                         Integer.parseInt(q3) + Integer.parseInt(q4) + 
                         Integer.parseInt(q5);
        
        String resultType = "";
        String resultMsg = "";

        if (totalScore <= 7) {
            resultType = "極致輕便登機箱";
            resultMsg = "你是一位追求效率的精簡實用派！20吋的輕量登機箱最適合你，說走就走毫無負擔。";
        } else if (totalScore <= 11) {
            resultType = "時尚萬用商務/全能箱";
            resultMsg = "你的旅行頻率與天數非常標準，推薦 24-26 吋的中型行李箱，容量與機動性完美平衡。";
        } else {
            resultType = "豪華大容量奢華深箱";
            resultMsg = "看來你熱愛長途旅行或是一位購物狂！29吋以上的大容量巨無霸行李箱絕對是你的神隊友。";
        }

        result.put("success", true);
        result.put("resultType", resultType);
        result.put("resultMsg", resultMsg);
    } else {
        result.put("success", false);
    }

    out.print(result.toString());
%>