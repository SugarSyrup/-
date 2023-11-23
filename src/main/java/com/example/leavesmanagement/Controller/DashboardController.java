package com.example.leavesmanagement.Controller;

import com.example.leavesmanagement.Repository.LeavesRepository;
import com.example.leavesmanagement.Repository.SwiftCodeRepository;
import com.example.leavesmanagement.Repository.UserRepository;
import com.example.leavesmanagement.entity.CalendarData;
import com.example.leavesmanagement.entity.Leaves;
import com.example.leavesmanagement.entity.SessionUser;
import com.example.leavesmanagement.entity.User;
import org.springframework.security.core.parameters.P;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

@Controller
public class DashboardController {
    private final SwiftCodeRepository swiftCodeRepository;
    private final LeavesRepository leavesRepository;
    private final UserRepository userRepository;

    public DashboardController(SwiftCodeRepository swiftCodeRepository, LeavesRepository leavesRepository, UserRepository userRepository) {
        this.swiftCodeRepository = swiftCodeRepository;
        this.leavesRepository = leavesRepository;
        this.userRepository = userRepository;
    }

    @GetMapping("/")
    public String getIndex(HttpServletRequest req) throws Exception {
        List<String> departments =  swiftCodeRepository.getDepartments();
        List<String> types =  swiftCodeRepository.getLeavesType();
        List<Leaves> leaves = leavesRepository.getLeaves();
        List<CalendarData> calendarData = new ArrayList<CalendarData>();

        req.setAttribute("departments", departments);
        req.setAttribute("types", types);
        req.setAttribute("isDashboard", true);

        for(int i = 0; i < leaves.size(); i++) {
            User user = userRepository.findUser(leaves.get(i).getUser_no());
            Calendar c = Calendar.getInstance();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            c.setTime(sdf.parse(leaves.get(i).getEnd_date()));
            c.add(Calendar.DATE, 1);
            String end_date = sdf.format(c.getTime());


            CalendarData data = new CalendarData().builder()
                    .title(user.getName())
                    .start_date(leaves.get(i).getStart_date())
                    .end_date(end_date)
                    .backgroundColor(swiftCodeRepository.getColor(user.getDepartment()))
                    .department(user.getDepartment())
                    .build();

            calendarData.add(data);
        }

        req.setAttribute("departments", departments);
        req.setAttribute("calendarData", calendarData);

        return "dashboard";
    }

    @PostMapping("/registLeaves")
    public String postRegistLeaves(HttpServletRequest req, HttpSession session) throws ParseException {
        String start_date = req.getParameter("start_date");
        String end_date = req.getParameter("end_date");
        String type = req.getParameter("type");
        String type_text = req.getParameter("type_text");
        String desc = req.getParameter("desc");

        SessionUser user = (SessionUser) session.getAttribute("user");


        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        long diff = sdf.parse(end_date).getTime() - sdf.parse(start_date).getTime();
        long days = (diff / (24 * 60 * 60 * 1000L)) % 365;
        System.out.println(days);

        if(type.equals("else")) {
            type = type + "/" + type_text;
        }

        Leaves leaves = Leaves.builder()
                .start_date(start_date)
                .end_date(end_date)
                .type(type)
                .desc(desc)
                .dates(2)
                .dates(Long.valueOf(days).intValue() + 1)
                .build();

        try {
            leavesRepository.create(leaves, user.getUser_no());
        } catch (Exception e) {
            System.out.println(e);
        }

        return "redirect:/";
    }
}
