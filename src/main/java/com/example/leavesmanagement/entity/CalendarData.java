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
    private String start_date;
    private String end_date;
    private String backgroundColor;
    private String department;
}
