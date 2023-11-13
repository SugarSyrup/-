package com.example.leavesmanagement.Controller;

import com.example.leavesmanagement.Repository.LeavesRepository;
import com.example.leavesmanagement.Repository.SwiftCodeRepository;
import com.example.leavesmanagement.Repository.UserRepository;
import com.example.leavesmanagement.entity.CalendarData;
import com.example.leavesmanagement.entity.Leaves;
import com.example.leavesmanagement.entity.User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
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
        List<Leaves> leaves = leavesRepository.getLeaves();
        List<CalendarData> calendarData = new ArrayList<CalendarData>();

        for(int i = 0; i < leaves.size(); i++) {
            User user = userRepository.findUser(leaves.get(i).getUser_no());

            CalendarData data = new CalendarData().builder()
                    .title(user.getName())
                    .start_date(leaves.get(i).getStart_date())
                    .end_date(leaves.get(i).getEnd_date())
                    .backgroundColor(swiftCodeRepository.getColor(user.getDepartment()))
                    .build();

            calendarData.add(data);
        }

        req.setAttribute("departments", departments);
        req.setAttribute("calendarData", calendarData);

        return "dashboard";
    }
}
