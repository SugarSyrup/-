package com.example.leavesmanagement.entity;


import lombok.*;

import java.util.Date;

@Getter
@Setter
@ToString
@NoArgsConstructor()
@AllArgsConstructor()
@Builder()
public class User {
    private int user_no;
    private String email;
    private String password;
    private String department;
    private String role;
    private String name;
    private String sign;
    private int rest_leaves;
    private int admin_role;
    private Date enter_date;
    private Date regist_date;
    private Date up_date;
    private int isdelete;
}
