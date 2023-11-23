package com.example.leavesmanagement.entity;


import lombok.*;

import java.util.Date;

@Getter
@Setter
@ToString
@NoArgsConstructor()
@AllArgsConstructor()
@Builder()
public class SessionUser {
    private int user_no;
    private String id;
    private String department;
    private String role;
    private String name;
    private String sign;
    private int leavesDays;
}
