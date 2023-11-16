package com.example.leavesmanagement.Controller;

import com.example.leavesmanagement.Repository.UserRepository;
import com.example.leavesmanagement.entity.RepositoryMessage;
import com.example.leavesmanagement.entity.SessionUser;
import com.example.leavesmanagement.entity.User;
import org.hibernate.Session;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class LoginController {
    private UserRepository userRepository;

    public LoginController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping("login")
    public String getLogin() {
        return "login";
    }

    @GetMapping("logout")
    public String getLogout(HttpServletRequest req) {
        HttpSession session = req.getSession();
        session.setAttribute("isLogin", false);
        session.setAttribute("isAdmin", false);

        return "redirect:/";
    }

    @PostMapping("login")
    public String postLogin(HttpServletRequest req) throws Exception {
        String id = req.getParameter("id");
        String password = req.getParameter("password");

        RepositoryMessage<User> msg = userRepository.Login(id, password);

        if (msg.isSuccess()) {
            HttpSession session = req.getSession();
            SessionUser user = SessionUser.builder()
                    .user_no(msg.getObj().getUser_no())
                    .sign(msg.getObj().getSign())
                    .role(msg.getObj().getRole())
                    .name(msg.getObj().getName())
                    .department(msg.getObj().getDepartment())
                    .leavesDays(msg.getObj().getLeavesDays())
                    .build();
            session.setAttribute("user", user);
            session.setAttribute("isLogin", true);

            if(msg.getObj().getAdmin_role().equals("USER")) {
                session.setAttribute("isAdmin", false);
            } else {
                session.setAttribute("isAdmin", true);
            }

            return "redirect:/";
        } else {
            req.setAttribute("message", msg.getMessage());
            return "login";
        }

    }
}