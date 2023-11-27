package com.example.leavesmanagement.Controller;

import com.example.leavesmanagement.Repository.LeavesRepository;
import com.example.leavesmanagement.entity.Leaves;
import com.example.leavesmanagement.entity.SessionUser;
import com.example.leavesmanagement.entity.SingleValue;
import org.hibernate.Session;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.util.Date;
import java.util.List;

@Controller
public class LeavesController {
    private LeavesRepository leavesRepository;
    private int year;
    public LeavesController(LeavesRepository leavesRepository) {
        this.leavesRepository = leavesRepository;
        LocalDate now = LocalDate.now();
        this.year = now.getYear();
    }
    @GetMapping("/totalLeaves")
    public String getTotalLeaves(HttpServletRequest req, HttpSession session) throws Exception {
        SessionUser user = (SessionUser) session.getAttribute("user");
        List<Leaves> leaves = leavesRepository.getUserLeaves(user.getUser_no(), year);
        int totalUseLeaves = leavesRepository.getUserUseLeaves(user.getUser_no(), year);
        req.setAttribute("leaves", leaves);
        req.setAttribute("year", this.year);
        req.setAttribute("useDays", totalUseLeaves);

        return "totalLeaves";
    }

    @PostMapping("/setLeavesYear")
    public String postLeavesYear(@RequestBody SingleValue singleValue) {
        this.year = Integer.parseInt(singleValue.getValue());
        System.out.println(this.year);
        return "redirect:/totalLeaves";
    }
}
