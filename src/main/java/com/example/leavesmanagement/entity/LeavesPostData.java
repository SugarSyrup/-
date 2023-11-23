package com.example.leavesmanagement.entity;


import lombok.*;

@Getter
@Setter
@ToString
@NoArgsConstructor()
@AllArgsConstructor()
@Builder()
public class LeavesPostData {
    private String name;
    private String before;
    private String current;
    private String total;
    private String addLeaves;
    private String enterDate;
}
