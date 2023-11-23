package com.example.leavesmanagement.Controller;

import com.example.leavesmanagement.Repository.SwiftCodeRepository;
import com.example.leavesmanagement.Repository.UserRepository;
import com.example.leavesmanagement.entity.UserData;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
public class UsersController {
    private UserRepository userRepository;
    private SwiftCodeRepository swiftCodeRepository;

    public UsersController(UserRepository userRepository, SwiftCodeRepository swiftCodeRepository) {
        this.userRepository = userRepository;
        this.swiftCodeRepository = swiftCodeRepository;
    }

    @GetMapping("/users")
    public String getUsers(HttpServletRequest req) throws Exception{
        List<String> departments =  swiftCodeRepository.getDepartments();
        List<UserData> users = userRepository.getUsers(0);

        req.setAttribute("departments", departments);
        req.setAttribute("isDashboard", false);
        req.setAttribute("users", users);
        return "users";
    }

    @PostMapping("calcLeaves")
    public String postUsers(HttpServletRequest req) throws Exception {
        String before = req.getParameter("month") + "/" + req.getParameter("year");
        String enter_date = req.getParameter("enter_date");
        int user_no = Integer.parseInt(req.getParameter("user_no"));

        userRepository.setUserTimeData(user_no, before, enter_date);

        return "redirect:/users";
    }

}
