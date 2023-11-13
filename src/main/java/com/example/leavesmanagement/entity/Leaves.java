package com.example.leavesmanagement.entity;

import lombok.*;

import java.time.LocalDate;
import java.util.Date;

@Getter
@Setter
@ToString
@NoArgsConstructor()
@AllArgsConstructor()
@Builder()
public class Leaves {
    private int user_no;
    private Date start_date;
    private Date end_date;

    private String type;
    private String desc;
    private int dates;
}
