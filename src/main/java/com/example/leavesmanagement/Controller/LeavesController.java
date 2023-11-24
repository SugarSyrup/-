package com.example.leavesmanagement.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpServletRequest;

@Controller
public class LeavesController {
    @GetMapping("/totalLeaves")
    public String getTotalLeaves(HttpServletRequest req) {
        return "totalLeaves";
    }
}
