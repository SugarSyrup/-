package com.example.leavesmanagement.Controller;

import com.example.leavesmanagement.Repository.UserRepository;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

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
}
