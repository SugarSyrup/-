package com.example.leavesmanagement.entity;

import lombok.*;

@Getter
@Setter
@ToString
@NoArgsConstructor()
@AllArgsConstructor()
@Builder()
public class RepositoryMessage<T> {
    private boolean isSuccess;
    private String message;
    private T obj;
}
