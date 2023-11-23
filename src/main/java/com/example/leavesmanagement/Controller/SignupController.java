package com.example.leavesmanagement.Controller;

import com.example.leavesmanagement.Repository.SwiftCodeRepository;
import com.example.leavesmanagement.Repository.UserRepository;
import com.example.leavesmanagement.entity.RepositoryMessage;
import com.example.leavesmanagement.entity.SessionUser;
import com.example.leavesmanagement.entity.User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.List;


@MultipartConfig(
        location = "/img",
        fileSizeThreshold=1024*1024,
        maxFileSize=1024*1024*10,
        maxRequestSize=1024*1024*10*10
)
@Controller
public class SignupController {
    private UserRepository userRepository;
    private SwiftCodeRepository swiftCodeRepository;

    public SignupController(UserRepository userRepository, SwiftCodeRepository swiftCodeRepository) {
        this.userRepository = userRepository;
        this.swiftCodeRepository = swiftCodeRepository;
    }

    @GetMapping("signup")
    public String getSignup(HttpServletRequest req) throws Exception {

        List<String> departments = swiftCodeRepository.getDepartments();
        req.setAttribute("departments", departments);

        return "signup";
    }

    @PostMapping("signup")
    public String postSignup(HttpServletRequest req, HttpServletResponse res) throws Exception {
        String id = req.getParameter("id");
        String password = req.getParameter("password");
        String passwordcheck = req.getParameter("passwordcheck");
        String name = req.getParameter("name");
        String department = req.getParameter("department");
        String role = req.getParameter("role");

        String realPath = req.getServletContext().getRealPath("/upload");
        Part filePart = req.getPart("sign");
        String filename = filePart.getSubmittedFileName();
        InputStream fis = filePart.getInputStream();
        String filePath = realPath + File.separator + filename;
        System.out.println(filePath);
        FileOutputStream fos = new FileOutputStream(filePath);

        byte[] buf = new byte[1024];
        int size = 0;
        while((size = fis.read(buf)) != -1) {
            fos.write(buf, 0, size);
        }

        fos.close();
        fis.close();

        List<String> departments = swiftCodeRepository.getDepartments();
        req.setAttribute("departments", departments);

        if(password.equals(passwordcheck)) {
            User user = User.builder()
                    .id(id)
                    .password(password)
                    .name(name)
                    .department(department)
                    .role(role)
                    .sign(filename)
                    .build();

            try {
                userRepository.signup(user);
            } catch (Exception e) {
                System.out.println(e);
                req.setAttribute("message", "id가 중복입니다.");
                return "signup";
            }
            return "redirect:/";
        } else {
            req.setAttribute("message", "비밀번호가 일치하지 않습니다");
            return "signup";
        }
    }


    @GetMapping("/user-edit")
    public String getUserEdit(HttpServletRequest req) throws Exception {
        List<String> departments = swiftCodeRepository.getDepartments();
        req.setAttribute("departments", departments);
        return "user-edit";
    }

    @PostMapping("/user-edit")
    public String postUserEdit(HttpServletRequest req, HttpSession session) throws Exception {
        int userno = Integer.parseInt(req.getParameter("userno"));
        String password = req.getParameter("password");
        String passwordcheck = req.getParameter("passwordcheck");
        String name = req.getParameter("name");
        String department = req.getParameter("department");
        String role = req.getParameter("role");

        SessionUser sessionUser = (SessionUser) session.getAttribute("user");
        String realPath = req.getServletContext().getRealPath("/upload");
        Part filePart = req.getPart("sign");
        String filename = filePart.getSubmittedFileName();


        if(!sessionUser.getSign().equals(filename)) {
            InputStream fis = filePart.getInputStream();
            String filePath = realPath + File.separator + filename;
            FileOutputStream fos = new FileOutputStream(filePath);

            byte[] buf = new byte[1024];
            int size = 0;
            while((size = fis.read(buf)) != -1) {
                fos.write(buf, 0, size);
            }

            fos.close();
            fis.close();
        }

        List<String> departments = swiftCodeRepository.getDepartments();
        req.setAttribute("departments", departments);

        if(password.equals(passwordcheck)) {
            User user = User.builder()
                    .user_no(userno)
                    .password(password)
                    .name(name)
                    .department(department)
                    .role(role)
                    .sign(filename)
                    .build();

            try {
                userRepository.userEdit(user);
            } catch (Exception e) {

                return "user-edit";
            }
            return "redirect:/";
        } else {
            req.setAttribute("message", "비밀번호가 일치하지 않습니다");
            return "user-edit";
        }
    }
}
