package com.example.leavesmanagement.Controller;

import com.example.leavesmanagement.Repository.UserRepository;
import com.example.leavesmanagement.entity.UserData;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class RestAPIController {
    private UserRepository userRepository;

    public RestAPIController( UserRepository userRepository ) {
        this.userRepository = userRepository;
    }

    @PostMapping("/getUserDateData")
    public UserData postGetUserDateData(@RequestBody UserData userData) throws Exception{
        UserData getUserData = userRepository.getUserDateData(userData.getUser_no());

        return getUserData;
    }

    @PostMapping("/userDelete")
    public void postUserDelete(@RequestBody UserData userData) throws Exception {
        userRepository.setUserDelete(userData.getUser_no());
    }

    @PostMapping("/userRestore")
    public void postUserRestore(@RequestBody UserData userData) throws Exception {
        userRepository.setUserRestore(userData.getUser_no());
    }
}
