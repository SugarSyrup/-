package com.example.leavesmanagement.entity;

import lombok.*;

import java.util.Date;

@Getter
@Setter
@ToString
@NoArgsConstructor()
@AllArgsConstructor()
@Builder()
public class CalendarData {
    private String title;
    private Date start_date;
    private Date end_date;
    private String backgroundColor;
    private String department;
}
