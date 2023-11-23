package com.example.leavesmanagement.entity;


import lombok.*;

@Getter
@Setter
@ToString
@NoArgsConstructor()
@AllArgsConstructor()
@Builder()
public class UserData {
    private int user_no;
    private String department;
    private String role;
    private String name;
    private String sign;
    private String admin_role;
    private String regist_date;
    private String before_date;
    private String enter_date;
    private int isdelete;
    private int totalLeaves;
}
